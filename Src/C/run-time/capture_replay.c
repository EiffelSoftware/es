

#include "eif_main.h"
#include "eif_types.h"
#include "eif_globals.h"
#include "rt_struct.h"
#include "rt_wbench.h"
#include "eif_except.h"
#include "eif_file.h"
#include "rt_assert.h"
#include "rt_err_msg.h"
#include "rt_malloc.h"
#include "eif_malloc.h"
#include "eif_project.h"
#include "eif_traverse.h"
#include "rt_garcol.h"
#include "eif_store.h"
#include "eif_misc.h"
#include "eif_macros.h"


#ifdef EIF_THREADS
#include "eif_threads.h"
#endif



#include <stdio.h>
#include <string.h>

/* Constants for describing the type of event, using the first 4 bits of a byte */

#define TYPE_MASK 0xF0

#define CR_CALL 0x00	/* A C routine is called from Eiffel */
#define CR_RET  0x10
#define CR_EXC  0x20	/* An exception occured in C and gets propagated back to Eiffel */

#define NEWOBJ	0x30	/* A Eiffel object is created in C */
/*

 Add type of object to argument

#define NEWSPL	0x60
#define NEWTPL	0x70
#define NEWBIT	0x80
*/

#define MEMMUT  0x40    /* Memory area mutation */

#define PROTOBJ 0x50    /* Keep reference to Eiffel object on stack */
#define WEANOBJ 0x60    /* Remove reference to Eiffel object from stack */

#define CR_RTV  0x70	/* Retrieve object */
#define CR_VAL	0x80	/* Register value (object or basic type) */

#define CR_NEWTHR 0x90	/* Initialize new thread */
#define CR_ENDTHR 0xA0	/* Cleanup thread */


/* The other 4 bits can be used for argument count etc. */

#define ARG_MASK 0x0F



/* Exception handling */

rt_private void cr_raise (char *msg) {
	//eraise (msg, EN_CR);
	print_err_msg(stderr, "%s\n", msg);
	exit(1);
}




/* Read/write capture log */

rt_private void bwrite (char *buffer, size_t nbytes)
{


	REQUIRE("cr_file_not_null", cr_file != NULL);
	REQUIRE("is_capturing", is_capturing);

	if (nbytes != fwrite(buffer, sizeof(char), nbytes, cr_file))
		cr_raise("Unable to write to capture log");

	RTCRDBG((stderr, "r/w %d %x bytes\n", nbytes, nbytes == 1 ? (int) * (char *) buffer : 0));

}

rt_private void bread (char *buffer, size_t nbytes)
{


	REQUIRE("cr_file_not_null", cr_file != NULL);
	REQUIRE("is_replaying", is_replaying);

	if (nbytes != fread(buffer, sizeof(char), nbytes, cr_file))
		cr_raise("Unable to read from capture log");

	RTCRDBG((stderr, "r/w %d %x bytes\n", nbytes, nbytes == 1 ? (int) * (char *) buffer : 0));

}

rt_private int cr_bread_wrapper (char *buffer, int nbytes)
{
	bread (buffer, (size_t) nbytes);
	return nbytes;
}



/*
 * Thread synchronization
 */

#ifdef EIF_THREADS

rt_private EIF_CS_TYPE *cr_event_mutex = NULL;

//#define CR_EVENT_MUTEX_LOCK(where)	RT_TRACE(eif_pthread_cs_lock(cr_event_mutex)); printf("lock %ld %s\n", (long unsigned int) cr_thread_id, where)
//#define CR_EVENT_MUTEX_UNLOCK(where)	printf("unlock %ld %s\n", (long unsigned int) cr_thread_id, where); RT_TRACE(eif_pthread_cs_unlock(cr_event_mutex))

#define CR_EVENT_MUTEX_LOCK(where)      EIF_ENTER_C; RT_TRACE(eif_pthread_cs_lock(cr_event_mutex)); EIF_EXIT_C; RTGC
#define CR_EVENT_MUTEX_UNLOCK(where)	RT_TRACE(eif_pthread_cs_unlock(cr_event_mutex))

#else
#define CR_EVENT_MUTEX_LOCK(where)
#define CR_EVENT_MUTEX_UNLOCK(where)
#endif

/*
 * Object/Memory observing
 */


#define CR_GLOBAL_REF 0xFFFFFFFF           /* Special size value indicating that the reference is an Eiffel object on the global stack */
#define CR_OBJECT_REF 0x00000000           /* Special size value indicating that reference points to an Eiffel object on the local stack */


#define CR_IS_REFERENCE(r) ((r).size == CR_GLOBAL_REF || (r).size == CR_OBJECT_REF)
#define CR_ACCESS(ref) ((ref).size == CR_GLOBAL_REF ? *((ref).item.o) : ((ref).item.r))




#define CR_INVALID_ID 0x00000000         /* Flag for indicating an id for the global stack */

typedef union tag_EIF_CR_ID {
	EIF_NATURAL_64 value;           /* 8 word representation of the id which can be stored to the log */
	struct {
		uint32 size;            /* size information of the corresponding object/pointer */
		uint32 id;              /* the actual id, possibly flagged with CR_GLOBAL_ID */
	} item;
} EIF_CR_ID;

#define cr_is_valid_id(cr_id) ((cr_id).item.id != CR_INVALID_ID)

rt_private EIF_CR_ID cr_id_of_object (EIF_CR_REFERENCE ref)
{

	EIF_GET_CONTEXT

	EIF_CR_ID cr_id;
	cr_id.item.id = 0;
	cr_id.item.size = ref.size;
	uint32 id = 1;

	struct cr_object *object = cr_local_objects;
	if (object == (struct cr_object *) NULL || ref.size == CR_GLOBAL_REF) {
		object = cr_global_objects;
		cr_id.item.size = CR_GLOBAL_REF;
	}

	while (object != NULL) {
		int same_ref = 0;
		if (ref.size == CR_GLOBAL_REF) {
			same_ref = object->ref.item.o == ref.item.o;
		}
		else if (ref.size > 0) {
			same_ref = object->ref.item.p == ref.item.p;
		}
		else {
			same_ref = CR_ACCESS(object->ref) == ref.item.r;
		}

		if (same_ref && object->ref.size == cr_id.item.size) {
			cr_id.item.id = id;
			break;
		}

		object = object->next;
		if (object == NULL && cr_id.item.size == CR_OBJECT_REF) {
			/* Check global objects */
			cr_id.item.size = CR_GLOBAL_REF;
			object = cr_global_objects;
			id = 1;
		}
		else {
			id++;
		}
	}

	return cr_id;

}


rt_private EIF_CR_REFERENCE cr_object_of_id (EIF_CR_ID cr_id)
{

	EIF_GET_CONTEXT

	REQUIRE("valid_id", cr_is_valid_id(cr_id));

	struct cr_object *object;
	EIF_CR_REFERENCE ref;
	uint32 id = cr_id.item.id;

	ref.size = cr_id.item.size;
	if (ref.size == CR_GLOBAL_REF) {
		object = cr_global_objects;
		ref.item.o = (EIF_REFERENCE *) NULL; /* FIXME: this should be a valid pointer to a null pointer! */
	}
	else {
		object = cr_local_objects;
		ref.item.p = (EIF_POINTER) NULL;
	}

	while (object != NULL) {
		id--;
		if (id == 0) {
			if (ref.size == object->ref.size)
				ref.item = object->ref.item;
			break;
		}
		object = object->next;
	}

	ENSURE("valid_size", ref.size == cr_id.item.size);

	return ref;
}

rt_private void cr_push_object (EIF_CR_REFERENCE ref)
{

	EIF_GET_CONTEXT

	struct cr_object *object;
	void *src = NULL;
	size_t src_size = 0;
	EIF_REFERENCE r;

	object = (struct cr_object *) cmalloc(sizeof(struct cr_object));
	if (object == NULL)
		enomem();

	/* Insert new object into observed list */
	if (ref.size == CR_GLOBAL_REF) {
		object->next = cr_global_objects;
		cr_global_objects = object;
	}
	else {
		object->next = cr_local_objects;
		cr_local_objects = object;
	}

	object->ref = ref;
	object->copy = NULL;

	RTCRDBG((stderr, "push object %s\n", ref.size == CR_GLOBAL_REF ? "gobal" : "local"));

		/* when replaying we do not observe objects */
	if (is_replaying)
		return;

		/* check if we need to do any observation */
	if (CR_IS_REFERENCE(ref)) {
		r = CR_ACCESS(ref);
		union overhead *zone = HEADER(r);
			// FIXME: make sure r is a basic typed SPECIAL!
		if (zone->ov_dftype == egc_str_dtype) {
			/* We are pushing a string which has an initialized area, make r point to the area
			 * so it will be treated as a special object */
			if (* (EIF_REFERENCE *) r != NULL) {
				r = * (EIF_REFERENCE *) r;
				zone = HEADER(r);
			}
		}
		if ((zone->ov_flags & (EO_SPEC | EO_TUPLE)) == EO_SPEC) {
			src = (void *) r;
			src_size = (size_t) RT_SPECIAL_CAPACITY(r)*RT_SPECIAL_ELEM_SIZE(r);
		}
	}
	else {
		src = (void *) ref.item.p;
		src_size = (size_t) ref.size;
	}

	if (src_size > 0 && src != NULL) {
		object->copy = cmalloc(src_size);

		if (object->copy == NULL)
			enomem();
		memcpy(object->copy, src, src_size);
	}

	return;

}

rt_private void cr_capture_mutations (int register_mutations)
{

	EIF_GET_CONTEXT

	REQUIRE("capturing", is_capturing);

	struct cr_object *object;
	uint32 id = 1;
	EIF_CR_ID cr_id;

	object = cr_local_objects;
	if (object == (struct cr_object *) NULL) {
		object = cr_global_objects;
	}

	while (object != NULL) {

		void *src;
		size_t src_size;
		if (CR_IS_REFERENCE(object->ref)) {
			src_size = 0;
			EIF_REFERENCE r = CR_ACCESS(object->ref);
			if (r != (EIF_REFERENCE) NULL) {
				union overhead *zone = HEADER(r);
				if (zone->ov_dftype == egc_str_dtype) {
					if (* (EIF_REFERENCE *) r != NULL) {
						r = * (EIF_REFERENCE *) r;
						zone = HEADER(r);
					}
				}
				if ((zone->ov_flags & (EO_SPEC | EO_TUPLE)) == EO_SPEC) {
					src = (void *) r;
					src_size = RT_SPECIAL_CAPACITY(r)*RT_SPECIAL_ELEM_SIZE(r);
				}
			}
		}
		else {
			src = object->ref.item.p;
			src_size = object->ref.size;
		}

		void *copy = object->copy;
		cr_id.item.id = id;
		cr_id.item.size = object->ref.size;

		if (src_size > 0) {
			/* If no copy has been made yet, we create it now */
			if (copy == NULL) {
				object->copy = cmalloc(src_size);
				if (object->copy == NULL)
					enomem();
			}

			if (register_mutations && (copy == NULL || memcmp(src, copy, src_size))) {

				char type = (char) MEMMUT;
				bwrite(&type, 1);
#ifdef EIF_THREADS
				bwrite((char *) &cr_thread_id, sizeof(EIF_NATURAL_64));
#endif
				bwrite((char *) &cr_id, sizeof(EIF_CR_ID));

				uint32 start, end;

					// TODO: optimize start/end values
				start = 0;
				end = src_size-1;

				bwrite((char *) &start, sizeof(uint32));
				bwrite((char *) &end, sizeof(uint32));
				bwrite((char *) src, src_size);

			}

			/* In any case we copy the current content to the copy */
			memcpy(object->copy, src, src_size);
		}
		object = object->next;
		if (object == NULL && cr_id.item.size != CR_GLOBAL_REF) {
			object = cr_global_objects;
			id = 1;
		}
		else {
			id++;
		}
	}

}

rt_private void cr_pop_objects ()
{

	EIF_GET_CONTEXT

	struct cr_object *object = cr_local_objects;
	cr_local_objects = (struct cr_object *) NULL;
	struct cr_object *old;

	while (object != NULL) {

		old = object;
		object = object->next;

		RTCRDBG((stderr, "pop object\n"));

		if (old->copy != NULL)
			eif_rt_xfree (old->copy);

		eif_rt_xfree (old);
	}

}

rt_private void cr_remove_object (EIF_CR_ID cr_id)
{

	EIF_GET_CONTEXT

	REQUIRE("valid_id", cr_is_valid_id(cr_id));

	struct cr_object **object, *old;
	uint32 id = cr_id.item.id;

	if (cr_id.item.size == CR_GLOBAL_REF) {
		object = &cr_global_objects;
	}
	else {
		object = &cr_local_objects;
	}

	while (object != NULL) {
		id--;
		if (id == 0) {
			old = *object;
			*object = old->next;
			if (old->copy != NULL)
				eif_rt_xfree (old->copy);

			RTCRDBG((stderr, "remove object\n"));

			eif_rt_xfree (old);
			
			return;
		}
		object = &((*object)->next);
		
	}

	cr_raise("tried to remove object for invalid id");

}


/*
 * Capture/Replay helper routines
 */


rt_private size_t cr_value_size (uint32 type) {

	switch (type & SK_HEAD) {
		case SK_BOOL:    return sizeof (EIF_BOOLEAN);
		case SK_CHAR8:   return sizeof (EIF_CHARACTER_8);
		case SK_CHAR32:  return sizeof (EIF_CHARACTER_32);
		case SK_INT8:    return sizeof (EIF_INTEGER_8);
		case SK_INT16:   return sizeof (EIF_INTEGER_16);
		case SK_INT32:   return sizeof (EIF_INTEGER_32);
		case SK_INT64:   return sizeof (EIF_INTEGER_64);
		case SK_UINT8:   return sizeof (EIF_NATURAL_8);
		case SK_UINT16:  return sizeof (EIF_NATURAL_16);
		case SK_UINT32:  return sizeof (EIF_NATURAL_32);
		case SK_UINT64:  return sizeof (EIF_NATURAL_64);
		case SK_REAL32:  return sizeof (EIF_REAL_32);
		case SK_REAL64:  return sizeof (EIF_REAL_64);
		case SK_POINTER: return sizeof (EIF_POINTER);
		case SK_REF:     return sizeof (EIF_REFERENCE);
		default: break;
	}
	return (size_t) 0;
}


rt_private EIF_CR_REFERENCE cr_retrieve_object ()
{

	REQUIRE("replaying", is_replaying);

	EIF_CR_ID id;

	bread((char *) &id, sizeof(EIF_CR_ID));
	
	if (cr_is_valid_id(id) == 0)
		cr_raise("Replay mismatch: read invalid id from log");

	return cr_object_of_id (id);
}



/*
 * Private capture/replay routines
 */

#ifdef EIF_THREADS

/*
rt_private void cr_log_event (unsigned char type, EIF_NATURAL_64 tid)
{
	char *types = NULL;

	switch (type & TYPE_MASK) {
		case CR_CALL: types = "CR_CALL"; break;
		case CR_RET: types = "CR_RET"; break;
		case CR_EXC: types = "CR_EXC"; break;
		case NEWOBJ: types = "NEWOBJ"; break;
		case MEMMUT: types = "MEMMUT"; break;
		case PROTOBJ: types = "PROTOBJ"; break;
		case WEANOBJ: types = "WEANOBJ"; break;
		case CR_RTV: types = "CR_RTV"; break;
		case CR_VAL: types = "CR_VAL"; break;
		case CR_NEWTHR: types = "CR_NEWTHR"; break;
		case CR_ENDTHR: types = "CR_ENDTHR"; break;
		default: types =  "?";
	}


	fprintf(stderr, "%s %ld\n", types, (long int) tid);
}
*/

rt_private void cr_start_thread(EIF_REFERENCE Current)
{

	EIF_GET_CONTEXT

	REQUIRE("thread_id_not_initialized", cr_thread_id == 0);

	CR_EVENT_MUTEX_LOCK("start_thread");

	cr_thread_id = ++cr_thread_count;

	CR_EVENT_MUTEX_UNLOCK("start_thread");

	cr_cross_depth = 1;
	cr_replay();
	cr_cross_depth = 0;

	/* TODO: cleanup thread... */
}

#endif


rt_private char cr_schedule()
{

	EIF_GET_CONTEXT

#ifdef EIF_THREADS
	REQUIRE("valid_thread_id", cr_thread_id != 0);

/*	EIF_THR_ATTR_TYPE attr;*/
#endif

	EIF_CR_ID id;
	EIF_CR_REFERENCE ref, newref;
	char next_action;

	while (1) {

#ifdef EIF_THREADS

		if (cr_next_thread_id == 0) {
			/* Event has not been read yet */
			bread(&cr_next_event, sizeof(char));
			bread((char *) &cr_next_thread_id, sizeof(EIF_NATURAL_64));
		}

		if (cr_next_thread_id == cr_thread_id || (cr_next_event & TYPE_MASK) == CR_NEWTHR) {
			next_action = cr_next_event;
		}
		else {

			CR_EVENT_MUTEX_UNLOCK("yield");

			RTGC;
			/* TODO: use proper condition variables for scheduling, currently only spinning */
			eif_sleep (100);

			CR_EVENT_MUTEX_LOCK("yield");

			continue;

		}

		/* Reset event variables to indicate that this event has been worked off */
		cr_next_thread_id = 0;
		cr_next_event = (char) 0;
#else

		/* In single thread mode we simply read the event type and move on */

		bread(&next_action, sizeof(char));
#endif


		if ((next_action & TYPE_MASK) == WEANOBJ) {

			/* WEANOBJ events must be performed here as they can also occur outside of a cr_replay().
			 * The reason for this is that cr_register_wean records the event even if cr_suppress is
			 * true (usually during disposal. However it is still important we perform the wean in
			 * the correct thread as the reference is put back on the local object stack. */

			bread((char *) &id, sizeof(EIF_CR_ID));

			if (!cr_is_valid_id(id))
				cr_raise("Trying to wean unknown object");

			ref = cr_object_of_id (id);

			if (ref.size != CR_GLOBAL_REF)
				cr_raise("Trying to wean non global object");

			RTCRDBG((stderr, "wean %lx\n", (unsigned long) ref.item.o));
			newref.item.r = eif_wean((EIF_OBJECT) ref.item.o);

			cr_remove_object (id);

			if (!CR_IS_REFERENCE(ref))
				cr_raise("Trying to wean pointer reference");

			newref.size = CR_OBJECT_REF;

			cr_push_object (newref);

		}
#ifdef EIF_THREADS
		else if ((next_action & TYPE_MASK) == CR_NEWTHR) {

			/* CR_NEWTHR also have to be executed here as they can be replayed by any thread id */

			bread((char *) &id, sizeof(EIF_CR_ID));
			
			if (!cr_is_valid_id(id))
				cr_raise("Invalid THREAD object ID");

			ref = cr_object_of_id (id);
			if (ref.size != CR_GLOBAL_REF)
				cr_raise("Invalid THREAD object");

			/*
			bread((char *) &attr.priority, sizeof(rt_uint_ptr));
			bread((char *) &attr.stack_size, sizeof(rt_uint_ptr));
			*/

			eif_thr_create_with_attr((EIF_OBJECT) ref.item.o, (EIF_PROCEDURE) cr_start_thread, NULL);
		}
#endif
		else {
			break;
		}
	}

	return next_action;

}

rt_private void cr_write_event_type (char type)
{

	bwrite(&type, sizeof(char));

#ifdef EIF_THREADS

	EIF_GET_CONTEXT

	if (cr_thread_id == 0)
		cr_raise ("Current thread has not been initialized");
	bwrite((char *) &cr_thread_id, sizeof(EIF_NATURAL_64));
#endif


}






/*
 * Public capture/replay routines
 */


rt_public void cr_init ()
{

	EIF_GET_CONTEXT

	if (is_capturing)
		cr_file = fopen("./capture.log", "w");
	else if (is_replaying)
		cr_file = fopen("./capture.log", "r");

#ifdef EIF_THREADS
	if (is_capturing || is_replaying) {
		RT_TRACE(eif_pthread_cs_create(&cr_event_mutex, 4000)); /* TODO: possibly choose a better spin count */
		cr_thread_id = ++cr_thread_count;
	}
#endif

}


rt_public void cr_register_call (int num_args, BODY_INDEX bodyid)
{
	EIF_GET_CONTEXT

	REQUIRE("valid_context", is_capturing || is_replaying);

	if (cr_suppress)
		return;

	char type, rtype;
	BODY_INDEX bid;

	if (num_args > 15)
		cr_raise ("Too many arguments for call");

		/* Initialize descriptor */
	type = (char) CR_CALL | (char) num_args;


	/* TODO: clear stack */

	if (!RTCRI)
		cr_pop_objects();


	if (is_capturing) {

		CR_EVENT_MUTEX_LOCK("call");

		/* We only capture changes done during external OUTCALL */
		cr_capture_mutations(RTCRI);
		
		cr_write_event_type (type);
		bwrite((char *) &bodyid, sizeof(BODY_INDEX));

	}
	else if (!RTCRI) {

		CR_EVENT_MUTEX_LOCK("call");

			// If we are not capturing, it must only read from the log in case of an outcall
		rtype = cr_schedule();
		bread((char *) &bid, sizeof(BODY_INDEX));

		if ((rtype & TYPE_MASK) != (type & TYPE_MASK))
			cr_raise ("Expected CR_CALL but read different event from log");

		if ((rtype & ARG_MASK) != (type & ARG_MASK))
			cr_raise ("Expected CR_CALL with different number of arguments");
		
		if (bid != bodyid)
			cr_raise("Expected CR_CALL to different routine");
	}
	else {
		/* No need to lock the mutex, as it is an incall and cr_replay already locked it */
	}

	CR_EVENT_MUTEX_UNLOCK("call");

}

rt_public void cr_register_return (int num_args)
{

	EIF_GET_CONTEXT

	REQUIRE("valid_context", is_capturing || (is_replaying && !RTCRI));

	char type, log_type;

	if (cr_suppress)
		return;

	if (num_args > 15)
		cr_raise ("Too many return values");

	type = (char) CR_RET | (char) num_args;

	if (!RTCRI)
		cr_pop_objects();

	CR_EVENT_MUTEX_LOCK("ret");

	if (is_capturing) {

		cr_capture_mutations(RTCRI);

		cr_write_event_type (type);

	}
	else {
		log_type = cr_schedule();

		if ((log_type & TYPE_MASK) != (type & TYPE_MASK))
			cr_raise ("Expected CR_RET but read different event from log");

		if ((log_type & ARG_MASK) != (type & ARG_MASK))
			cr_raise ("Expected CR_RET with different number of arguments");

	}

	CR_EVENT_MUTEX_UNLOCK("ret");

}

rt_private void cr_register_value_recursive (void *value, uint32 *type, uint32 pointed_type, int recursive)
{

	EIF_GET_CONTEXT

	/* `use_value' indicates whether value and type point to live memory locations and whether their
	* should be used by the capture/replay mechanism or restored
	*/
	int use_value = (is_capturing || (is_replaying && !RTCRI));

	REQUIRE("value_pointer_not_null", value != NULL);
	REQUIRE("type_pointer_not_null", type != NULL);
	REQUIRE("valid_context", is_capturing || is_replaying);
	REQUIRE("valid_type_and_size", !use_value || (*type == SK_POINTER || pointed_type == SK_INVALID));

	if (cr_suppress)
		return;

	char event_type = (char) CR_VAL;
	char rtype;
	uint32 log_type;
	char log_value[8];
	EIF_CR_REFERENCE ref, log_ref;
	EIF_CR_ID cr_id;

	/* Initialize ref to NULL */
	ref.item.p = (EIF_POINTER) NULL;
	ref.size = CR_OBJECT_REF;

	/* Check if value points to a reference */
	if (use_value) {

		/* Check if value represents a reference */
		/* FIXME: what do we do with NULL references/pointers? */
		if ((*type & SK_HEAD) == SK_REF) {
			ref.item.r = * (EIF_REFERENCE *) value;
		}
		else if (*type == SK_POINTER) {
			if ((pointed_type & SK_HEAD) == SK_REF) {
				ref.item.r = * (EIF_REFERENCE *) value;
			}
			else if (pointed_type != SK_INVALID) {
				ref.item.p = * (EIF_POINTER *) value;
				ref.size = cr_value_size (pointed_type);
			}
		}

	}

	if (recursive) {
		CR_EVENT_MUTEX_LOCK("value");
	}

	if (is_replaying) {

		rtype = cr_schedule();

		if (event_type != rtype)
			cr_raise ("Expected value event but retrieved different event from log");

		/* We need to read type and value from the log */
		bread((char *) &log_type, sizeof(uint32));

		if (use_value) {
			/* Lets see if we got the same type as originally */
			if (*type != log_type) {
				if (((*type) & SK_HEAD) == SK_REF && (log_type & SK_HEAD) == SK_REF) {
					/* FIXME: not sure to what extend we should check the dynamic type here */
				}
				else if (*type == SK_POINTER && log_type == SK_REF && ref.item.r != NULL) {
					/* This is the special case where a regular pointer points to an Eiffel object */
				}
				else {
					/* Otherwise we throw an exception */

					/* TODO: try to be more flexible and if possible only provide a warning */

					cr_raise ("Type mismatch");
				}
			}
		}
		else {
			/* Restore type information */
			*type = log_type;
		}

		bread(log_value, cr_value_size(log_type));

		if (use_value) {
			/* We also check whether we got the same value */
			if (ref.item.p != NULL && !memcmp(value, log_value, cr_value_size(log_type))) {
				cr_raise ("Different value");
			}

			/* If it is a reference type it will later be pushed to the stack */
		}
		else {
			if ((log_type & SK_HEAD) == SK_REF) {
				/* We are restoring a reference type */
				cr_id.value = * (EIF_INTEGER_64 *) log_value;
				if (cr_is_valid_id (cr_id)) {
					if (cr_id.item.id == 0xFFFFFFFF) {
						*(EIF_REFERENCE *) value = except_mnger;
					}
					else {
						log_ref = cr_object_of_id (cr_id);
						if (CR_IS_REFERENCE(log_ref)) {
							* (EIF_REFERENCE *) value = CR_ACCESS(log_ref);
							*type = SK_REF;
						}
						else {
							* (EIF_POINTER *) value = log_ref.item.p;
							*type = SK_POINTER;
						}
					}
				}
				else {
					* (EIF_REFERENCE *) value = (EIF_REFERENCE) NULL;
				}
			}
			else {
				/* We are restoring a basic type which we can simply copy */
				memcpy(value, log_value, cr_value_size(log_type));
			}
		}
	}
	else {
		if (ref.item.r != NULL) {
			/* FIXME: same as above, we might want to store the dynamic type along... */
			log_type = SK_REF;
			if (RTCRI) {
				cr_id = cr_id_of_object (ref);
				if (!cr_is_valid_id(cr_id)) {
					if (CR_IS_REFERENCE(ref) && (CR_ACCESS(ref) == except_mnger)) {
						cr_id.item.id = 0xFFFFFFFF;
						cr_id.item.size = CR_GLOBAL_REF;
					}
					else {
						if (CR_IS_REFERENCE(ref)) {
							printf("Unknown reference %lx\n", (long unsigned int) CR_ACCESS(ref));
						}
						else {
							printf("Unknown reference %lx\n", (long unsigned int) ref.item.p);
						}
						cr_raise ("Passing unknown reference to Eiffel");
					}
				}
				* (EIF_INTEGER_64 *) log_value = cr_id.value;
			}
			else {
				/* In this case an ID does not make sense as we will simply push the reference. As an
				 * optimization the log_value could be completely ommitted in order to reduce the log
				 * size by a few bytes */
				* (EIF_INTEGER_64 *) log_value = (EIF_INTEGER_64) 0;
			}
		}
		else {
			log_type = *type;
			memcpy(log_value, value, cr_value_size(log_type));
		}

		cr_write_event_type (event_type);

		bwrite((char *) &log_type, sizeof(uint32));
		bwrite(log_value, cr_value_size(log_type));
	}

	/* FIXME: the following can be problematic if we receive a different tuple from the one
	 *        registered when capturing. Possibly the dynamic type could be used to detect
	 *        such a difference and at least raise an exception. Best would be to continue
	 *        with the same local object stack even if it contains null pointers.
	 */

	if (ref.item.r != NULL && !RTCRI) {
		/* this implies use_value */
		cr_push_object (ref);

		/* Finally, if value points to a tuple we want to register its items */
		if (recursive && CR_IS_REFERENCE(ref)) {
			EIF_REFERENCE tup = CR_ACCESS(ref);
			if ((tup != (EIF_REFERENCE) NULL) && HEADER(tup)->ov_flags & EO_TUPLE) {
				uint32 count = RT_SPECIAL_COUNT (tup);
				EIF_TYPED_VALUE *tup_item = (EIF_TYPED_VALUE *) tup;
				int i;
				tup_item++;
				for (i = 1; i < count; i++) {
					cr_register_value_recursive (&(tup_item->item), &(tup_item->type), SK_INVALID, 0);
					tup_item++;
				}
			}
		}
	}

	if (recursive) {
		CR_EVENT_MUTEX_UNLOCK("value");
	}

}

rt_public void cr_register_value (void *value, uint32 *type, uint32 pointed_type)
{

	cr_register_value_recursive (value, type, pointed_type, 1);
}

rt_public void cr_register_emalloc (EIF_REFERENCE obj)
{

	EIF_GET_CONTEXT

	REQUIRE("valid_context", is_capturing && !RTCRI);

	if (cr_suppress)
		return;

	union overhead *zone = HEADER(obj);
	char type = NEWOBJ;
	EIF_CR_REFERENCE ref;
	ref.size = CR_OBJECT_REF;
	ref.item.p = obj;

	if ((zone->ov_flags) & EO_NEW)
		type |= 0x1;

	EIF_TYPE_INDEX dftype = zone->ov_dftype;

	CR_EVENT_MUTEX_LOCK("malloc");

	cr_write_event_type (type);
	bwrite ((char *) &dftype, sizeof(EIF_TYPE_INDEX));

	CR_EVENT_MUTEX_UNLOCK("malloc");

	cr_push_object (ref);

}


rt_public void cr_register_protect (EIF_REFERENCE *obj)
{

	EIF_GET_CONTEXT

	REQUIRE("valid_object", obj != NULL);
	REQUIRE("capturing", is_capturing);
	REQUIRE("not_inside", !RTCRI);

	if (cr_suppress)
		return;

	EIF_CR_REFERENCE ref, newref;
	ref.item.r = *obj;
	ref.size = CR_OBJECT_REF;

	CR_EVENT_MUTEX_LOCK("protect");

	EIF_CR_ID id = cr_id_of_object (ref);

	if (!cr_is_valid_id(id)) {
		/* Instead of rising an exception we just ignore this protect. */
		CR_EVENT_MUTEX_UNLOCK("protect");
		return;
	}

	char type = (char) PROTOBJ;
	cr_write_event_type (type);
	bwrite((char *) &id, sizeof(EIF_CR_ID));

	cr_remove_object (id);

	RTCRDBG((stderr, "protect %lx\n", (unsigned long) obj));

	newref.item.o = obj;
	newref.size = CR_GLOBAL_REF;

	cr_push_object (newref);

	CR_EVENT_MUTEX_UNLOCK("protect");

}

rt_public void cr_register_wean (EIF_REFERENCE *obj)
{
#ifdef EIF_ASSERTIONS
	EIF_GET_CONTEXT
#endif

	/* Note: we register a wean event even if cr_suppress is true, otherwise we miss freeing an object which
	 * causes a memory leak during replay.
	 */

	REQUIRE("capturing", is_capturing);
	REQUIRE("not_inside", !RTCRI);

	EIF_CR_REFERENCE ref, newref;
	EIF_CR_ID id;

	ref.item.o = obj;
	ref.size = CR_GLOBAL_REF;

	CR_EVENT_MUTEX_LOCK("wean");

	id = cr_id_of_object (ref);

	if (!cr_is_valid_id(id)) {
		/* Instead of rising an exception we just ignore this wean */
		CR_EVENT_MUTEX_UNLOCK("wean");
		return;
	}

	char type = (char) WEANOBJ;
	cr_write_event_type (type);
	bwrite((char *) &id, sizeof(EIF_CR_ID));

	RTCRDBG((stderr, "wean %lx\n", (unsigned long) obj));

	cr_remove_object (id);

	CR_EVENT_MUTEX_UNLOCK("wean");

	newref.item.p = *(obj);
	newref.size = CR_OBJECT_REF;

	cr_push_object (newref);

}

rt_public void cr_register_exception (char *tag, long code)
{

	EIF_GET_CONTEXT

	REQUIRE("capturing", is_capturing);
	REQUIRE("not_inside", !RTCRI);

	/* Note: exception in a call to dispose? Not sure what to do here */
	if (cr_suppress)
		return;

	char type = (char) CR_EXC;
	uint32 length = strlen(tag);

	CR_EVENT_MUTEX_LOCK("exception");

	cr_capture_mutations(1);

	cr_write_event_type (type);
	bwrite((char *) &code, sizeof(long));

	bwrite((char *) &length, sizeof(uint32));
	bwrite(tag, length);

	CR_EVENT_MUTEX_UNLOCK("exception");

}

rt_public void cr_register_retrieve (EIF_REFERENCE obj)
{

	/* For now we simply store `obj' to a temporary file and then copy
	 * the contents of the file to the log. */

#ifdef EIF_ASSERTIONS
	EIF_GET_CONTEXT
#endif

	REQUIRE("capturing", is_capturing);
	REQUIRE("not_inside", !RTCRI);
	REQUIRE("not_inside_dispose", !cr_suppress);

	char type = (char) CR_RTV;

	FILE *file = tmpfile();
	sstore (file_fd(file), obj);
	
	CR_EVENT_MUTEX_LOCK("retrieve");

	/* Write event type to log */
	cr_write_event_type (type);

	/* Write stored object to buffer */
	char buffer[1024];
	rewind(file);
	do {
		size_t nbytes = fread (buffer, 1, 1024, file);

		if (ferror(file) != 0)
			cr_raise ("Could not write retrieved object to log");

		bwrite(buffer, nbytes);

	} while (!feof(file));

	CR_EVENT_MUTEX_UNLOCK("retrieve");

	fclose(file);

	EIF_CR_REFERENCE ref;
	ref.size = CR_OBJECT_REF;
	ref.item.r = obj;
	cr_push_object (ref);

}

#ifdef EIF_THREADS

rt_public void cr_register_thread_start (EIF_REFERENCE thr_root_obj, EIF_THR_ATTR_TYPE *attr)
{

	EIF_CR_REFERENCE ref;
	EIF_CR_ID id;

	EIF_GET_CONTEXT

	if (cr_thread_id != 0)
		cr_raise("Current thread has already been initialized");

	CR_EVENT_MUTEX_LOCK("thread_start");

	cr_thread_id = ++cr_thread_count;
	cr_cross_depth = 1;

	ref.item.r = thr_root_obj;
	ref.size = CR_OBJECT_REF;

	id = cr_id_of_object (ref);

	if (!cr_is_valid_id(id))
		cr_raise("Unknown thread object");

	if (id.item.size != CR_GLOBAL_REF)
		cr_raise("Invalid thread object");

	cr_write_event_type ((char) CR_NEWTHR);

	bwrite((char *) &id.value, sizeof(EIF_NATURAL_64));
/*	bwrite((char *) &(attr->priority), sizeof(rt_uint_ptr));
	bwrite((char *) &(attr->stack_size), sizeof(rt_uint_ptr)); */

	CR_EVENT_MUTEX_UNLOCK("thread_start");

}

rt_public void cr_register_thread_end ()
{

	EIF_GET_CONTEXT

	CR_EVENT_MUTEX_LOCK("thread_end");

	cr_write_event_type ((char) CR_ENDTHR);

	CR_EVENT_MUTEX_UNLOCK("thread_end");

	cr_thread_id = 0;
	cr_cross_depth = 0;

}

#endif


rt_public int cr_epush(register struct stack *stk, EIF_REFERENCE *obj)
{
	EIF_GET_CONTEXT

	if (is_capturing && !RTCRI) {
		cr_register_protect (obj);
	}
	return epush(stk, (EIF_REFERENCE) obj);
}


rt_public void cr_epop(struct stack *stk, EIF_REFERENCE *obj)
{
	EIF_GET_CONTEXT

	if (is_capturing && !RTCRI) {
		cr_register_wean (obj);
	}
	epop(stk, 1);
}


rt_private EIF_REFERENCE_FUNCTION featref (BODY_INDEX body_id)
{

	if (egc_frozen[body_id]) {
		return egc_frozen[body_id];
	}
	else {
		cr_raise("Trying to replay melted routine");

			/* Not reached */
		return (EIF_REFERENCE_FUNCTION) NULL;
	}
}


rt_public void cr_replay ()
{

	EIF_GET_CONTEXT

	REQUIRE("valid_context", is_replaying && !RTCRI);

	char type;

	BODY_INDEX body_id;
	EIF_TYPED_VALUE arg1, arg2, arg3 ,arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12;
	EIF_REFERENCE Current;
	EIF_TYPE_INDEX dftype;
	EIF_CR_REFERENCE ref, newref;
	EIF_CR_ID id;
	long excpt_code;
	uint32 excpt_length;
	char *excpt_tag;

	if (cr_suppress)
		return;

	while (1) {

		CR_EVENT_MUTEX_LOCK("replay");

		type = cr_schedule();

		switch (type & TYPE_MASK) {
			case CR_RET:
			case CR_ENDTHR:

				CR_EVENT_MUTEX_UNLOCK("ret");

				return;

			case CR_CALL:

				bread((char *) &body_id, sizeof(BODY_INDEX));

				switch (type & ARG_MASK) {
					case 0:
						cr_raise("INCALL requires Current as an argument");
						break;
					case 1:
						(FUNCTION_CAST(void, (EIF_REFERENCE)) featref(body_id))(Current);
						break;
					case 2:
						(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE))
							featref(body_id))(Current, arg1);
						break;
					case 3:
						(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE))
							featref(body_id))(Current, arg1, arg2);
						break;
					case 4:
						(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE))
							featref(body_id))(Current, arg1, arg2, arg3);
						break;
					case 5:
						(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE))
							featref(body_id))(Current, arg1, arg2, arg3, arg4);
						break;
					case 6:
						(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
								EIF_TYPED_VALUE, EIF_TYPED_VALUE))
							featref(body_id))(Current, arg1, arg2, arg3, arg4, arg5);
						break;
					case 7:
						(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
								EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE))
							featref(body_id))(Current, arg1, arg2, arg3, arg4, arg5, arg6);
						break;
					case 8:
						(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
								EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE))
							featref(body_id))(Current, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
						break;
					case 9:
						(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
								EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
								EIF_TYPED_VALUE))
							featref(body_id))(Current, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
						break;
					case 10:
						(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
								EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
								EIF_TYPED_VALUE, EIF_TYPED_VALUE))
							featref(body_id))(Current, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
						break;
					case 11:
						(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
								EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
								EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE))
							featref(body_id))(Current, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
						break;
					case 12:
						(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
								EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
								EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE))
							featref(body_id))(Current, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11);
						break;
					case 13:
						(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
								EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
								EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
								EIF_TYPED_VALUE))
							featref(body_id))(Current, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12);
						break;
					default:
						cr_raise("Too many args for INCALL");
				}

				/* Note: MUTEX is unlocked by the called routine */

				break;

			case NEWOBJ:

				bread ((char *) &dftype, sizeof(EIF_TYPE_INDEX));

				CR_EVENT_MUTEX_UNLOCK("malloc");

				if ((type & ARG_MASK) == 1)
					ref.item.r = emalloc(dftype);
				else
					ref.item.r = emalloc_as_old(dftype);

				ref.size = CR_OBJECT_REF;

				cr_push_object (ref);

				break;

			case PROTOBJ:


 				bread((char *) &id, sizeof(EIF_CR_ID));

				if (cr_is_valid_id(id) == 0)
					cr_raise("Replay mismatch: read invalid id from log");

				ref = cr_object_of_id(id);

				if (!CR_IS_REFERENCE(ref))
					cr_raise("Trying to protect pointer");

				Current = CR_ACCESS(ref);

				if (Current == (EIF_REFERENCE) NULL)
					cr_raise("Invalid ID for PROTOBJ");

				cr_remove_object(id);

				newref.item.o = (EIF_REFERENCE *) eif_protect(CR_ACCESS(ref));

				RTCRDBG((stderr, "protect %lx\n", (unsigned long) newref.item.o));

				newref.size = CR_GLOBAL_REF;

				cr_push_object (newref);

				CR_EVENT_MUTEX_UNLOCK("protect");

				break;

			case MEMMUT:

				ref = cr_retrieve_object();

				uint32 start, end;
				size_t size;
				bread((char *) &start, sizeof(uint32));
				bread((char *) &end, sizeof(uint32));
				size = (size_t) (end - start + 1);

				if (!CR_IS_REFERENCE(ref)) {
					if (ref.item.p == NULL)
						cr_raise("Invalid pointer ID for MEMMUT");

					CHECK("valid_size", size <= ref.size);
					bread((char *) ref.item.p, size);
				}
				else {
					Current = CR_ACCESS(ref);
					if (Current == (EIF_REFERENCE) NULL)
						cr_raise("Invalid object ID for MEMMUT");

					if (HEADER(Current)->ov_dftype == egc_str_dtype) {
                                	        if (* (EIF_REFERENCE *) Current != NULL) {
                        	                        Current = * (EIF_REFERENCE *) Current;
        	                                }
	                                }

					if (((HEADER(Current)->ov_flags) & (EO_SPEC | EO_TUPLE)) != EO_SPEC) {
						cr_raise("Invalid object type for MEMMUT");
					}

					if (size != RT_SPECIAL_CAPACITY(Current)*RT_SPECIAL_ELEM_SIZE(Current)) {
						cr_raise("Invalid special size for MEMMUT");
					}

					bread((char *) Current, size);
				}

				CR_EVENT_MUTEX_UNLOCK("memmut");

				break;

			case CR_RTV:

				Current = portable_retrieve(cr_bread_wrapper);

				CR_EVENT_MUTEX_UNLOCK("retrieve");

				ref.size = CR_OBJECT_REF;
				ref.item.r = Current;

				cr_push_object (ref);

				break;

			case CR_EXC:

				bread((char *) &excpt_code, sizeof(long));
				bread((char *) &excpt_length, sizeof(uint32));
				
				excpt_tag = cmalloc((size_t) excpt_length + 1);
				if (excpt_tag == (char *) NULL)
					enomem();

				bread(excpt_tag, excpt_length);

				CR_EVENT_MUTEX_UNLOCK("exception");

				excpt_tag[excpt_length] = '\0';

				eraise(excpt_tag, excpt_code);

				/* NOT REACHED */
				break;

			default:
				cr_raise("Corrupted log");
		}

	}

}


/* Special feature body id */
#define SF_BODY_ID 0xFFFFFFFF

rt_public void cr_memcpy(struct ex_vect *exvect, void *dest, uint32 dest_type, const void *source, size_t count)
{

	EIF_GET_CONTEXT

	char *l_feature_name;
	l_feature_name = "cr_memcpy";

	EIF_TYPED_VALUE arg1, arg2, arg3;
	
	arg1.type = SK_POINTER;
	arg1.it_p = (EIF_POINTER) dest;
	arg2.type = SK_POINTER;
	arg2.it_p = (EIF_POINTER) source;
	arg3.type = SK_INT32;
	arg3.it_i4 = (EIF_INTEGER) count;

	RTCRCSO(3,SF_BODY_ID,l_feature_name);
	RTCRRV(arg1,dest_type);
	RTCRRV(arg2,0);
	RTCRRV(arg3,0);
	RTCRES;
	RTCRCEO(l_feature_name);

	memcpy (dest, source, count);

	RTCREE;
	RTCRRSO(0);
	RTCRRE;

}

rt_public void cr_memmove(struct ex_vect *exvect, void *dest, uint32 dest_type, const void *source, size_t count)
{

	EIF_GET_CONTEXT
	
	char *l_feature_name;
	l_feature_name = "cr_memmove";

	EIF_TYPED_VALUE arg1, arg2, arg3;
	
	arg1.type = SK_POINTER;
	arg1.it_p = (EIF_POINTER) dest;
	arg2.type = SK_POINTER;
	arg2.it_p = (EIF_POINTER) source;
	arg3.type = SK_INT32;
	arg3.it_i4 = (EIF_INTEGER) count;

	RTCRCSO(3,SF_BODY_ID,l_feature_name);
	RTCRRV(arg1,dest_type);
	RTCRRV(arg2,0);
	RTCRRV(arg3,0);
	RTCRES;
	RTCRCEO(l_feature_name);
	
	memmove(dest, source, count);

	RTCREE;
	RTCRRSO(0);
	RTCRRE;

}

rt_public void cr_memset(struct ex_vect *exvect, void *dest, uint32 dest_type, int value, size_t count)
{

	EIF_GET_CONTEXT

	char *l_feature_name;
	l_feature_name = "cr_memset";

	EIF_TYPED_VALUE arg1, arg2, arg3;
	
	arg1.type = SK_POINTER;
	arg1.it_p = (EIF_POINTER) dest;
	arg2.type = SK_INT32;
	arg2.it_i4 = (EIF_INTEGER) value;
	arg3.type = SK_INT32;
	arg3.it_i4 = (EIF_INTEGER) count;

	RTCRCSO(3,SF_BODY_ID,l_feature_name);
	RTCRRV(arg1,dest_type);
	RTCRRV(arg2,0);
	RTCRRV(arg3,0);
	RTCRES;
	RTCRCEO(l_feature_name);

	memset(dest, value, count);

	RTCREE;
	RTCRRSO(0);
	RTCRRE;

}

rt_public int cr_memcmp(struct ex_vect *exvect, void *dest, void *other, size_t count)
{

	EIF_GET_CONTEXT

	char *l_feature_name;
	l_feature_name = "cr_memcmp";

	EIF_TYPED_VALUE arg1, arg2, arg3;
	EIF_INTEGER Result;
	
	arg1.type = SK_POINTER;
	arg1.it_p = (EIF_POINTER) dest;
	arg2.type = SK_POINTER;
	arg2.it_p = (EIF_POINTER) other;
	arg3.type = SK_INT32;
	arg3.it_i4 = (EIF_INTEGER) count;

	RTCRCSO(3,SF_BODY_ID,l_feature_name);
	RTCRRV(arg1,0);
	RTCRRV(arg2,0);
	RTCRRV(arg3,0);
	RTCRES;
	RTCRCEO(l_feature_name);

	Result = (EIF_INTEGER) memcmp(dest, other, count);

	RTCREE;
	RTCRRSO(1);
	RTCRRR(SK_INT32,0);
	RTCRRE;

	return (int) Result;
}

rt_public void *cr_malloc(struct ex_vect *exvect, size_t size)
{

	EIF_GET_CONTEXT

	char *l_feature_name;
	l_feature_name = "cr_malloc";

	EIF_TYPED_VALUE arg1;
	EIF_POINTER Result;
	
	arg1.type = SK_INT32;
	arg1.it_i4 = (EIF_INTEGER) size;

	RTCRCSO(1,SF_BODY_ID,l_feature_name);
	RTCRRV(arg1,0);
	RTCREE;
	RTCRCEO(l_feature_name);

	Result = (EIF_POINTER) malloc(size);

	RTCRES;
	RTCRRSO(1);
	RTCRRR(SK_POINTER,0);
	RTCRRE;

	return (void *) Result;
	
}


rt_public void *cr_calloc(struct ex_vect *exvect, size_t nmemb, size_t size)
{

	EIF_GET_CONTEXT

	char *l_feature_name;
	l_feature_name = "cr_calloc";

	EIF_TYPED_VALUE arg1, arg2;
	EIF_POINTER Result;
	
	arg1.type = SK_INT32;
	arg1.it_i4 = (EIF_INTEGER) nmemb;
	arg2.type = SK_INT32;
	arg2.it_i4 = (EIF_INTEGER) size;

	RTCRCSO(2,SF_BODY_ID,l_feature_name);
	RTCRRV(arg1,0);
	RTCRRV(arg2,0);
	RTCRES;
	RTCRCEO(l_feature_name);

	Result = (EIF_POINTER) calloc(nmemb, size);
	
	RTCREE;
	RTCRRSO(1);
	RTCRRR(SK_POINTER,0);
	RTCRRE;

	return (void *) Result;
}


rt_public void *cr_realloc(struct ex_vect *exvect, void *source, size_t size)
{

	EIF_GET_CONTEXT

	char *l_feature_name;
	l_feature_name = "cr_realloc";

	EIF_TYPED_VALUE arg1, arg2;
	EIF_POINTER Result;
	
	arg1.type = SK_POINTER;
	arg1.it_p = (EIF_POINTER) source;
	arg2.type = SK_INT32;
	arg2.it_i4 = (EIF_INTEGER) size;

	RTCRCSO(2,SF_BODY_ID,l_feature_name);
	RTCRRV(arg1,0);
	RTCRRV(arg2,0);
	RTCRES;
	RTCRCEO(l_feature_name);

	Result = (EIF_POINTER) realloc(source, size);
	
	RTCREE;
	RTCRRSO(1);
	RTCRRR(SK_POINTER,0);
	RTCRRE;
	return (void *) Result;
}


rt_public void cr_free (struct ex_vect *exvect, void *dest)
{

	EIF_GET_CONTEXT

	char *l_feature_name;
	l_feature_name = "cr_free";

	EIF_TYPED_VALUE arg1;
	
	arg1.type = SK_POINTER;
	arg1.it_p = (EIF_POINTER) dest;

	RTCRCSO(1,SF_BODY_ID,l_feature_name);
	RTCRRV(arg1,0);
	RTCRES;
	RTCRCEO(l_feature_name);

	free(dest);

	RTCREE;
	RTCRRSO(0);
	RTCRRE;

}




/* RT_CAPTURE_REPLAY implementations */


rt_public void eif_printf (EIF_REFERENCE string)
{

	printf("%s", (char *) *(EIF_REFERENCE *)string);

}

#ifdef EIF_THREADS
rt_public EIF_NATURAL_64 eif_cr_thread_id ()
{
	EIF_GET_CONTEXT

	return cr_thread_id;

}
#endif
