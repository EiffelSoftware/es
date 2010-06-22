


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

#include "eif_macros.h"


#include <stdio.h>
#include <string.h>

/* Constants for describing the type of event, using the first 4 bits of a byte */

#define TYPE_MASK 0xF0

#define CR_CALL 0x00	/* A C routine is called from Eiffel */
#define CR_RET  0x10
#define CR_EXC  0x20	/* An exception occured in C and gets propagated back to Eiffel */

#define NEWOBJ	0x50	/* A Eiffel object is created in C */
#define NEWSPL	0x60
#define NEWTPL	0x70
#define NEWBIT	0x80

#define MEMMUT  0x90    /* Memory area mutation */

#define PROTOBJ 0xA0    /* Keep reference to Eiffel object on stack */
#define WEANOBJ 0xB0    /* Remove reference to Eiffel object from stack */

/* The other 4 bits can be used for argument count etc. */

#define ARG_MASK 0x0F

/*
 * Type definitions
 */




/* Exception handling */

rt_private void cr_raise (char *msg) {
	//eraise (msg, EN_CR);
	print_err_msg(stderr, "%s\n", msg);
	exit(1);
}




/* Read/write capture log */

rt_private void bwrite (char *buffer, size_t nbytes)
{

	EIF_GET_CONTEXT

	REQUIRE("cr_file_not_null", cr_file != NULL);
	REQUIRE("is_capturing", is_capturing);

	if (nbytes != fwrite(buffer, sizeof(char), nbytes, cr_file))
		cr_raise("Unable to write to capture log");

	RTCRDBG((stderr, "r/w %d %x bytes\n", nbytes, nbytes == 1 ? (int) * (char *) buffer : 0));

}

rt_private void bread (char *buffer, size_t nbytes)
{

	EIF_GET_CONTEXT

	REQUIRE("cr_file_not_null", cr_file != NULL);
	REQUIRE("is_replaying", is_replaying);

	if (nbytes != fread(buffer, sizeof(char), nbytes, cr_file))
		cr_raise("Unable to read from capture log");

	RTCRDBG((stderr, "r/w %d %x bytes\n", nbytes, nbytes == 1 ? (int) * (char *) buffer : 0));

}




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



rt_private char cr_schedule()
{

	EIF_GET_CONTEXT

	EIF_CR_ID id;
	EIF_CR_REFERENCE ref, newref;
	char next_action;

	while (1) {

		bread(&next_action, sizeof(char));

		if ((next_action & TYPE_MASK) == WEANOBJ) {

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
		else {
			break;
		}
	}

	return next_action;

}







/*
 * Public capture/replay routines
 */

rt_public void cr_register_call (int num_args, BODY_INDEX bodyid)
{
	EIF_GET_CONTEXT

	REQUIRE("valid_context", is_capturing || is_replaying);

	if (cr_suppress)
		return;

	// FIXME: To be done during some (thread) initialization
	if (cr_file == (FILE *) NULL) {
		if (is_capturing)
			cr_file = fopen("./capture.log", "w");
		else
			cr_file = fopen("./capture.log", "r");
	}

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

		if (!RTCRI) {
			cr_pop_objects();
		}
		/* We only capture changes done during external OUTCALL */
		cr_capture_mutations(RTCRI);
		
		bwrite(&type, sizeof(char));
		bwrite((char *) &(bodyid), sizeof(BODY_INDEX));

	}
	else if (!RTCRI) {

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

	if (is_capturing) {

		cr_capture_mutations(RTCRI);

		bwrite(&type, sizeof(char));
	}
	else {
		log_type = cr_schedule();

		if ((log_type & TYPE_MASK) != (type & TYPE_MASK))
			cr_raise ("Expected CR_RET but read different event from log");

		if ((log_type & ARG_MASK) != (type & ARG_MASK))
			cr_raise ("Expected CR_RET with different number of arguments");

	}
}

rt_private void cr_register_value_recursive (void *value, uint32 *type, size_t pointed_size, int recursive)
{

	EIF_GET_CONTEXT

	REQUIRE("value_pointer_not_null", value != NULL);
	REQUIRE("type_pointer_not_null", type != NULL);
	REQUIRE("valid_context", is_capturing || is_replaying);
	REQUIRE("valid_type_and_size", type == SK_POINTER || area_size == 0);

	if (cr_suppress)
		return;

	uint32 log_type;
	char log_value[8];
	EIF_CR_REFERENCE ref, log_ref;
	EIF_CR_ID cr_id;

	/* `use_value' indicates whether value and type point to live memory locations and whether their
	 * should be used by the capture/replay mechanism or restored
	 */
	int use_value = (is_capturing || (is_replaying && !RTCRI));

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
		else if (pointed_size > 0) {
			ref.item.p = * (EIF_POINTER *) value;
			ref.size = pointed_size;
		}
		else if (*type == SK_POINTER && is_instance (*(EIF_POINTER *) value)) {
			ref.item.r = * (EIF_REFERENCE *) value;
		}

	}

	if (is_replaying) {

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

		bwrite((char *) &log_type, sizeof(uint32));
		bwrite(log_value, cr_value_size(log_type));
	}

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
					cr_register_value_recursive (&(tup_item->item), &(tup_item->type), 0, 0);
					tup_item++;
				}
			}
		}
	}

}

rt_public void cr_register_value (void *value, uint32 *type, size_t pointed_size)
{
	cr_register_value_recursive (value, type, pointed_size, 1);
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

	bwrite (&type, 1);
	bwrite ((char *) &dftype, sizeof(EIF_TYPE_INDEX));

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

	EIF_CR_ID id = cr_id_of_object (ref);

	if (!cr_is_valid_id(id))
		cr_raise ("Trying to protect unknown reference");

	char type = (char) PROTOBJ;
	bwrite(&type, (size_t) 1);
	bwrite((char *) &id, sizeof(EIF_CR_ID));

	cr_remove_object (id);

	RTCRDBG((stderr, "protect %lx\n", (unsigned long) obj));

	newref.item.o = obj;
	newref.size = CR_GLOBAL_REF;

	cr_push_object (newref);

}

rt_public void cr_register_wean (EIF_REFERENCE *obj)
{

	EIF_GET_CONTEXT

	/* Note: here we might still want to register the event as currently this
	 * causes a memory leak because the corresponding object is not removed
	 * from the global stack.
	 */
	//if (cr_suppress)
	//	return;

	REQUIRE("capturing", is_capturing);
	REQUIRE("not_inside", !RTCRI);

	EIF_CR_REFERENCE ref, newref;
	EIF_CR_ID id;

	ref.item.o = obj;
	ref.size = CR_GLOBAL_REF;

	id = cr_id_of_object (ref);

	if (!cr_is_valid_id(id))
		cr_raise ("Trying to wean unknown reference");

	char type = (char) WEANOBJ;
	bwrite(&type, (size_t) 1);
	bwrite((char *) &id, sizeof(EIF_CR_ID));

	RTCRDBG((stderr, "wean %lx\n", (unsigned long) obj));

	cr_remove_object (id);

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

	cr_capture_mutations(1);

	bwrite(&type, sizeof(char));
	bwrite((char *) &code, sizeof(long));

	bwrite((char *) &length, sizeof(uint32));
	bwrite(tag, length);

}


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

		type = cr_schedule();

		switch (type & TYPE_MASK) {
			case CR_RET:

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

				break;

			case NEWOBJ:

				bread ((char *) &dftype, sizeof(EIF_TYPE_INDEX));

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

				break;

			case CR_EXC:

				bread((char *) &excpt_code, sizeof(long));
				bread((char *) &excpt_length, sizeof(uint32));
				
				excpt_tag = cmalloc((size_t) excpt_length + 1);
				if (excpt_tag == (char *) NULL)
					enomem();

				bread(excpt_tag, excpt_length);
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

rt_public void cr_memcpy(struct ex_vect *exvect, void *dest, size_t dest_size, const void *source, size_t count)
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
	RTCRRV(arg1,dest_size);
	RTCRRV(arg2,0);
	RTCRRV(arg3,0);
	RTCRES;
	RTCRCEO(l_feature_name);

	memcpy (dest, source, count);

	RTCREE;
	RTCRRSO(0);
	RTCRRE;

}

rt_public void cr_memmove(struct ex_vect *exvect, void *dest, size_t dest_size, const void *source, size_t count)
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
	RTCRRV(arg1,dest_size);
	RTCRRV(arg2,0);
	RTCRRV(arg3,0);
	RTCRES;
	RTCRCEO(l_feature_name);
	
	memmove(dest, source, count);

	RTCREE;
	RTCRRSO(0);
	RTCRRE;

}

rt_public void cr_memset(struct ex_vect *exvect, void *dest, size_t dest_size, int value, size_t count)
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
	RTCRRV(arg1,dest_size);
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




