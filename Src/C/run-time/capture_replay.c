


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

/* FIXME: remove */
#include "eif_macros.h"


#include <stdio.h>
#include <string.h>

/* Constants for describing the type of event, using the first 4 bits of a byte */

#define TYPE_MASK 0xF0

#define OUTCALL 0x00	/* A C routine is called from Eiffel */
#define OUTRET  0x10	/* A C routine returns to Eiffel */
#define OUTEXC  0x20	/* An exception occured in C and gets propagated back to Eiffel */

#define INCALL  0x30	/* An Eiffel routine is called from the C side */
#define INRET   0x40	/* An Eiffel routine returns to C */

#define NEWOBJ	0x50	/* A Eiffel object is created in C */
#define NEWSPL	0x60
#define NEWTPL	0x70
#define NEWBIT	0x80

#define MEMMUT  0x90    /* Memory area mutation */

#define PROTOBJ  0xA0    /* Keep reference to Eiffel object on stack */
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

}

rt_private void bread (char *buffer, size_t nbytes)
{

	EIF_GET_CONTEXT

	REQUIRE("cr_file_not_null", cr_file != NULL);
	REQUIRE("is_replaying", is_replaying);

	if (nbytes != fread(buffer, sizeof(char), nbytes, cr_file))
		cr_raise("Unable to read from capture log");

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

	REQUIRE("has_stack_frame", cr_top_object != NULL);

	EIF_CR_ID cr_id;
	cr_id.item.id = 0;
	cr_id.item.size = ref.size;
	uint32 id = 1;

	struct cr_object *object = cr_top_object->first;
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

	 /* No object for that pointer */
	return cr_id;

}


rt_private EIF_CR_REFERENCE cr_object_of_id (EIF_CR_ID cr_id)
{

	EIF_GET_CONTEXT

	REQUIRE("valid_id", cr_is_valid_id(cr_id));
	REQUIRE("has_stack_frame", cr_top_object != NULL);

	struct cr_object *object;
	EIF_CR_REFERENCE ref;
	uint32 id = cr_id.item.id;

	ref.size = cr_id.item.size;
	if (ref.size == CR_GLOBAL_REF) {
		object = cr_global_objects;
		ref.item.o = (EIF_REFERENCE *) NULL; /* FIXME: this should be a valid pointer to a null pointer! */
	}
	else {
		object = cr_top_object->first;
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

	struct stcrchunk *chunk = cr_top_object;

	REQUIRE("chunk_not_null", chunk != (struct stcrchunk *) NULL);

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
		object->next = chunk->first;
		chunk->first = object;
	}

	object->ref = ref;
	object->copy = NULL;

		/* when replaying we do not observe objects */
	if (is_replaying)
		return;

		/* check if we need to do any observation */
	if (CR_IS_REFERENCE(ref)) {
		r = CR_ACCESS(ref);
		union overhead *zone = HEADER(r);
			// FIXME: make sure r is a basic typed SPECIAL!
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

rt_private void cr_capture_mutations ()
{

	EIF_GET_CONTEXT

	REQUIRE("capturing", is_capturing);
	REQUIRE("has_chunk", cr_top_object != (struct stcrchunk *) NULL);

	struct cr_object *object;
	uint32 id = 1;
	EIF_CR_ID cr_id;

	object = cr_top_object->first;
	if (object == (struct cr_object *) NULL) {
		object = cr_global_objects;
	}

	while (object != NULL) {

		void *src;
		size_t src_size = (size_t) object->ref.size;
		if (CR_IS_REFERENCE(object->ref)) {
			EIF_REFERENCE r = CR_ACCESS(object->ref);
			if (r != (EIF_REFERENCE) NULL) {
				union overhead *zone = HEADER(r);
				if ((zone->ov_flags & (EO_SPEC | EO_TUPLE)) == EO_SPEC) {
					src = (void *) r;
					src_size = RT_SPECIAL_CAPACITY(r)*RT_SPECIAL_ELEM_SIZE(r);
				}
			}
		}
		else {
			src = object->ref.item.p;
		}

		void *copy = object->copy;

		if (src_size > 0 && copy != NULL) {
			if (memcmp(src, copy, src_size)) {

				char type = (char) MEMMUT;
				bwrite(&type, 1);
				cr_id.item.id = id;
				cr_id.item.size = (uint32) src_size;
				bwrite((char *) &cr_id, sizeof(EIF_CR_ID));

				uint32 start, end;

					// TODO: optimize start/end values
				start = 0;
				end = src_size-1;

				bwrite((char *) &start, sizeof(uint32));
				bwrite((char *) &end, sizeof(uint32));
				bwrite((char *) src, src_size);

				memcpy(object->copy, src, src_size);
			}
		}
		object = object->next;
		if (object == NULL && src_size != CR_GLOBAL_REF) {
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

	REQUIRE("top_not_null", cr_top_object != NULL);

	struct stcrchunk *top = cr_top_object;
	struct cr_object *object = top->first;
	struct cr_object *old;

	while (object != NULL) {

		old = object;
		object = object->next;

		if (old->copy != NULL)
			eif_rt_xfree (old->copy);

		eif_rt_xfree (old);
	}

	cr_top_object = top->sk_prev;
	eif_rt_xfree (top);

}

rt_private void cr_remove_object (EIF_CR_ID cr_id)
{

	EIF_GET_CONTEXT

	REQUIRE("valid_id", cr_is_valid_id(cr_id));
	REQUIRE("has_stack_frame", cr_top_object != NULL);

	struct cr_object **object, *old;
	uint32 id = cr_id.item.id;

	if (cr_id.item.size == CR_GLOBAL_REF) {
		object = &cr_global_objects;
	}
	else {
		object = &(cr_top_object->first);
	}

	while (object != NULL) {
		id--;
		if (id == 0) {
			old = *object;
			*object = old->next;
			if (old->copy != NULL)
				eif_rt_xfree (old->copy);
				
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


rt_private void cr_store_value (EIF_TYPED_VALUE value);
rt_private void cr_read_value (EIF_TYPED_VALUE *value);

rt_private void cr_capture_object (EIF_CR_REFERENCE ref, char flag);
rt_private void cr_capture_value (EIF_TYPED_VALUE value, char flag);

rt_private void cr_retrieve_value (EIF_TYPED_VALUE *value);
rt_private EIF_CR_REFERENCE cr_retrieve_object ();


rt_private void cr_store_value (EIF_TYPED_VALUE value)
{
	bwrite((char *) &value, sizeof(EIF_TYPED_VALUE));
}

rt_private void cr_read_value (EIF_TYPED_VALUE *value)
{
	bread((char *) value, sizeof(EIF_TYPED_VALUE));
}


#define CV_PUSH		0x01
#define CV_RECURSIVE	0x02


rt_private void cr_capture_object (EIF_CR_REFERENCE ref, char flag)
{

	REQUIRE("capturing_or_replaying", is_capturing || is_replaying);
	REQUIRE("replaying_implies_pushing", !is_replaying || (flag & CV_PUSH));
	
	EIF_TYPED_VALUE tvalue, rtvalue;
	EIF_CR_ID cr_id;
	EIF_REFERENCE r = CR_IS_REFERENCE(ref) ? CR_ACCESS(ref) : (EIF_REFERENCE) NULL;

	if (flag & CV_PUSH) {
		cr_id.item.size = ref.size;
		cr_id.item.id = CR_INVALID_ID;
		cr_push_object (ref);
	}
	else {

		cr_id = cr_id_of_object (ref);

		if (!cr_is_valid_id(cr_id)) {
				/* FIXME: generalize the access to once variables in run-time, such as the exception manager ... */
			if (r == except_mnger) {
				cr_id.item.id = 0xFFFFFFFF;
				cr_id.item.size = CR_GLOBAL_REF;
			}
		}

		if (!cr_is_valid_id(cr_id)) {
			printf("Unknown reference %lx\n", (long unsigned int) r);
			cr_raise ("Passing unknown reference to Eiffel");
		}

	}

	tvalue.type = SK_REF;
	if (r != (EIF_REFERENCE) NULL) {
		tvalue.type |= HEADER(r)->ov_dftype;
	}
	tvalue.it_n8 = cr_id.value;

	if (is_capturing) {
		cr_store_value (tvalue);
	}
	else {
		cr_read_value (&rtvalue);
		if (tvalue.type != rtvalue.type)
			cr_raise("Replay mismatch: passed type differs from one when capturing");

		if (tvalue.it_n8 != rtvalue.it_n8)
			cr_raise("Replay mismatch: passed reference size differs from one when capturing");
	}

	if ((flag & (CV_PUSH | CV_RECURSIVE)) && r != (EIF_REFERENCE) NULL) {
		if (HEADER(r)->ov_flags & EO_TUPLE) {
			EIF_TYPED_VALUE *titem = (EIF_TYPED_VALUE *) r;
			uint32 count = RT_SPECIAL_COUNT (r);
			unsigned int i;
			titem++;
			for (i = 1; i < count; i++) {
				cr_capture_value (*titem, CV_PUSH);
				titem++;
			}
		}
	}

}

rt_private void cr_capture_value (EIF_TYPED_VALUE value, char flag)
{

	REQUIRE("capturing_or_replaying", is_capturing || is_replaying);
	REQUIRE("replaying_implies_pushing", !is_replaying || (flag & CV_PUSH));

	EIF_TYPED_VALUE rvalue;
	EIF_CR_REFERENCE ref;

	if ((value.type & SK_HEAD) == SK_REF && (value.it_r != (EIF_REFERENCE) NULL)) {
		ref.item.r = value.it_r;
		ref.size = CR_OBJECT_REF;
		cr_capture_object (ref, flag);
	}
	else if ((value.type & SK_POINTER) && value.it_p != NULL && is_instance (value.it_p)) {
		ref.item.p = value.it_p;
		ref.size = CR_OBJECT_REF;
		cr_capture_object (ref, flag);
	}
	else {
		if (is_capturing)
			cr_store_value (value);
		else {
			cr_read_value (&rvalue);

			if (value.type != rvalue.type)
				cr_raise("Replay mismatch: passed basic type differs from one when capturing");

			// FIXME: compare the basic values and at least provide warning

			// FIXME: if previous captured object was a reference type/tuple, provide warning and push dummy reference to stack
			
		}
	}
}


rt_private void cr_retrieve_value (EIF_TYPED_VALUE *value)
{

	REQUIRE("replaying", is_replaying);

	EIF_CR_ID cr_id;
	EIF_CR_REFERENCE ref;

	cr_read_value (value);

	if ((value->type & SK_HEAD) == SK_REF) {

		cr_id.value = value->it_n8;
		if (cr_id.item.id > 0) {
				/* FIXME: generalize once references... */
			if (cr_id.item.id == 0xFFFFFFFF) {
				value->it_r = except_mnger;
				value->type = SK_REF;
			}
			else if (cr_is_valid_id(cr_id)) {
				ref = cr_object_of_id (cr_id);
				if (CR_IS_REFERENCE(ref)) {
					value->it_r = CR_ACCESS(ref);
					value->type = SK_REF | ((EIF_TYPE_INDEX) HEADER(value->it_r)->ov_dftype);
				}
				else {
					value->type = SK_POINTER;
					value->it_p = ref.item.p;
				}
			}
		}
		else {
			value->it_p = NULL;
		}

	}

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
 * Public capture/replay routines
 */


rt_public void cr_init (EIF_TYPED_VALUE Current, uint32 size, BODY_INDEX bodyid, int num_args)
{

	EIF_GET_CONTEXT

	REQUIRE("valid_context", is_capturing || (is_replaying && !RTCRI));

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
		cr_raise ("To many arguments");

		/* Initialize descriptor */
	if (RTCRI) {
		type = (char) INCALL;
	}
	else {
		type = (char) OUTCALL;
	}
	type |= (char) num_args;

	if (is_capturing) {


			/* We only capture changes done during external OUTCALL */
		if (RTCRI)
			cr_capture_mutations();

		bwrite(&type, sizeof(char));
		bwrite((char *) &(bodyid), sizeof(BODY_INDEX));

	}
	else {
			// If we are not capturing, it must be an outcall
		bread(&rtype, sizeof(char));

		if (rtype != type) {
			cr_raise ("Expected OUTCALL but read different event from log");
		}

		bread((char *) &bid, sizeof(BODY_INDEX));
		
		if (bid != bodyid) {
			cr_raise("Expected OUTCALL to different routine");
		}
	}

	if (!RTCRI) {
		/* Add new object list to stack */
		struct stcrchunk *chunk = (struct stcrchunk *) cmalloc(sizeof(struct stcrchunk));
		if (chunk == NULL)
			enomem();
		chunk->sk_prev = cr_top_object;
		chunk->first = (struct cr_object *) NULL;
		cr_top_object = chunk;
	}

	cr_register_argument (Current, size);

}


rt_public void cr_register_argument (EIF_TYPED_VALUE arg, uint32 size)
{
	EIF_GET_CONTEXT

	REQUIRE("valid_context", is_capturing || (is_replaying && !RTCRI));
	REQUIRE("valid_size", size == 0 || (arg.type == SK_POINTER && size < CR_GLOBAL_REF));

	EIF_CR_REFERENCE ref;
	char flags;
	if (RTCRI) {
			/* We must be capturing the arguments of an incall */
		flags = (char) 0;
	}
	else {
		flags = CV_PUSH | CV_PUSH;
	}

	if (size > 0) {
		ref.size = size;
		ref.item.p = arg.it_p;
		cr_capture_object (ref, flags);
	}
	else {
		cr_capture_value (arg, flags);
	}

}

rt_public void cr_register_emalloc (EIF_REFERENCE obj)
{

	EIF_GET_CONTEXT

	REQUIRE("valid_context", is_capturing && !RTCRI);

	union overhead *zone = HEADER(obj);
	char type = NEWOBJ;
	EIF_CR_REFERENCE ref;
	ref.size = CR_OBJECT_REF;
	ref.item.r = obj;

	if ((zone->ov_flags) & EO_NEW)
		type |= 0x1;

	EIF_TYPE_INDEX dftype = zone->ov_dftype;

	bwrite (&type, 1);
	bwrite ((char *) &dftype, sizeof(EIF_TYPE_INDEX));

	cr_push_object (ref);

}

rt_public void cr_register_result (EIF_TYPED_VALUE Result, uint32 size) {

	EIF_GET_CONTEXT

	REQUIRE("valid_context", is_capturing || (is_replaying && RTCRI));
	REQUIRE("size_implies_pointer", size == 0 || (Result.type == SK_POINTER));

	char type, rtype, flags;
	EIF_CR_REFERENCE ref;

	if (RTCRI) {
		type = (char) INRET;
		flags = CV_PUSH | CV_RECURSIVE;
	}
	else {
		type = (char) OUTRET;
		flags = (char) 0;

			/* We only capture changes done during OUTCALL */
		if (is_capturing)
			cr_capture_mutations();
	}

	if (Result.type != SK_INVALID) {
		type |= 0x1;
	}

	if (is_capturing) {
		bwrite (&type, 1);
	}
	else {
			// We must be returning an Eiffel in-call
		bread(&rtype, 1);
		if (rtype != type) {
			cr_raise("Replay mismatch");
		}
	}

	if (Result.type != SK_INVALID) {
		if (size > 0) {
			ref.size = size;
			ref.item.p = Result.it_p;
			cr_capture_object (ref, flags);
		}
		else
			cr_capture_value (Result, flags);
	}

	if (!RTCRI)
		cr_pop_objects();
}

rt_public void cr_register_protect (EIF_REFERENCE *obj)
{
	EIF_GET_CONTEXT

	REQUIRE("valid_object", obj != NULL);
	REQUIRE("capturing", is_capturing);
	REQUIRE("not_inside", !RTCRI);

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

	newref.item.o = obj;
	newref.size = CR_GLOBAL_REF;

	cr_push_object (newref);

}

rt_public void cr_register_wean (EIF_REFERENCE *obj)
{

	EIF_GET_CONTEXT

	REQUIRE("capturing", is_capturing);
	REQUIRE("not_inside", !RTCRI);

	EIF_CR_REFERENCE ref, newref;
	EIF_CR_ID id = cr_id_of_object (ref);

	ref.item.o = obj;
	ref.size = CR_GLOBAL_REF;

	id = cr_id_of_object (ref);

	if (!cr_is_valid_id(id))
		cr_raise ("Trying to wean unknown reference");

	char type = (char) WEANOBJ;
	bwrite(&type, (size_t) 1);
	bwrite((char *) &id, sizeof(EIF_CR_ID));

	cr_remove_object (id);

	newref.item.p = *(obj);
	newref.size = CR_OBJECT_REF;

	cr_push_object (newref);

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


rt_public void cr_replay (EIF_TYPED_VALUE *Result)
{

		// FIXME: remove once printf is no longer done
	EIF_GET_CONTEXT

	REQUIRE("valid_context", is_replaying && !RTCRI);

	char type;

	BODY_INDEX body_id;
	EIF_TYPED_VALUE target, arg1, arg2, arg3 ,arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12;
	EIF_REFERENCE Current;
	EIF_TYPE_INDEX dftype;
	EIF_CR_REFERENCE ref, newref;
	EIF_CR_ID id;

	while (1) {
		bread (&type, 1);

		switch (type & TYPE_MASK) {
			case OUTRET:

				if ((type & ARG_MASK) > 0)
					cr_retrieve_value (Result);

				cr_pop_objects();

				return;

			case INCALL:

				bread((char *) &body_id, sizeof(BODY_INDEX));

				cr_retrieve_value (&target);
				if ((target.type & SK_HEAD) != SK_REF)
					cr_raise ("Replay mismatch: retrieved target not valid for incall");

				Current = target.it_r;

				if ((type & ARG_MASK) == 0) {
					(FUNCTION_CAST(void, (EIF_REFERENCE)) featref(body_id))(Current);
					continue;
				}

				cr_retrieve_value(&arg1);
				if ((type & ARG_MASK) == 1) {
					(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE))
						featref(body_id))(Current, arg1);
					continue;
				}

				cr_retrieve_value(&arg2);
				if ((type & ARG_MASK) == 2) {
					(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE))
						featref(body_id))(Current, arg1, arg2);
					continue;
				}

				cr_retrieve_value(&arg3);
				if ((type & ARG_MASK) == 3) {
					(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE))
						featref(body_id))(Current, arg1, arg2, arg3);
					continue;
				}

				cr_retrieve_value(&arg4);
				if ((type & ARG_MASK) == 4) {
					(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE))
						featref(body_id))(Current, arg1, arg2, arg3, arg4);
					continue;
				}
				
				cr_retrieve_value(&arg5);
				if ((type & ARG_MASK) == 5) {
					(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
							EIF_TYPED_VALUE, EIF_TYPED_VALUE))
						featref(body_id))(Current, arg1, arg2, arg3, arg4, arg5);
					continue;
				}

				cr_retrieve_value(&arg6);
				if ((type & ARG_MASK) == 6) {
					(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
							EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE))
						featref(body_id))(Current, arg1, arg2, arg3, arg4, arg5, arg6);
					continue;
				}

				cr_retrieve_value(&arg7);
				if ((type & ARG_MASK) == 7) {
					(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
							EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE))
						featref(body_id))(Current, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
					continue;
				}
				
				cr_retrieve_value(&arg8);
				if ((type & ARG_MASK) == 8) {
					(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
							EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
							EIF_TYPED_VALUE))
						featref(body_id))(Current, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
					continue;
				}
				
				cr_retrieve_value(&arg9);
				if ((type & ARG_MASK) == 9) {
					(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
							EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
							EIF_TYPED_VALUE, EIF_TYPED_VALUE))
						featref(body_id))(Current, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
					continue;
				}
				
				cr_retrieve_value(&arg10);
				if ((type & ARG_MASK) == 10) {
					(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
							EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
							EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE))
						featref(body_id))(Current, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
					continue;
				}

				cr_retrieve_value(&arg11);
				if ((type & ARG_MASK) == 11) {
					(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
							EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
							EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE))
						featref(body_id))(Current, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11);
					continue;
				}
				
				cr_retrieve_value(&arg12);
				if ((type & ARG_MASK) == 12) {
					(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
							EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
							EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE,
							EIF_TYPED_VALUE))
						featref(body_id))(Current, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12);
					continue;
				}
				else {
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

				ref = cr_retrieve_object();

				if (!CR_IS_REFERENCE(ref))
					cr_raise("Trying to protect pointer");

				Current = CR_ACCESS(ref);

				if (Current == (EIF_REFERENCE) NULL)
					cr_raise("Invalid ID for PROTOBJ");

				newref.item.p = eif_protect(CR_ACCESS(ref));
				newref.size = CR_GLOBAL_REF;

				cr_push_object (newref);

				/* 
					FIXME: insert object into global list...
				object->is_protected++;

				*/

				break;

			case WEANOBJ:

				bread((char *) &id, sizeof(EIF_CR_ID));

				if (!cr_is_valid_id(id))
					cr_raise("Trying to wean unknown object");

				ref = cr_object_of_id (id);
				cr_remove_object (id);

				if (!CR_IS_REFERENCE(ref))
					cr_raise("Trying to wean pointer reference");

				newref.item.r = CR_ACCESS(ref);
				newref.size = CR_OBJECT_REF;

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

					CHECK("is_special", ((HEADER(Current)->ov_flags) & (EO_SPEC | EO_TUPLE)) == EO_SPEC);
					CHECK("valid_size", size <= RT_SPECIAL_CAPACITY(Current)*RT_SPECIAL_ELEM_SIZE(Current));

					bread((char *) Current, size);
				}

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

	char *l_feature_name = "cr_memcpy";
	EIF_POINTER Current = (EIF_POINTER) dest;

	RTCRAFS(0, l_feature_name, SF_BODY_ID);
	RTCRABS1(SK_POINTER, it_p, dest_size, SF_BODY_ID, 0);
	RTCRBS2;

	memcpy (dest, source, count);

	RTCRABEV(l_feature_name);
	RTCRFE;

}

rt_public void cr_memmove(struct ex_vect *exvect, void *dest, size_t dest_size, const void *source, size_t count)
{

	EIF_GET_CONTEXT
	
	char *l_feature_name = "cr_memmove";
	EIF_POINTER Current = (EIF_POINTER) dest;
	
	RTCRAFS(0, l_feature_name, SF_BODY_ID);
	RTCRABS1(SK_POINTER, it_p, dest_size, SF_BODY_ID, 0);
	RTCRBS2;
	
	memmove(dest, source, count);

	RTCRABEV(l_feature_name);
	RTCRFE;	

}

rt_public void cr_memset(struct ex_vect *exvect, void *dest, size_t dest_size, int value, size_t count)
{

	EIF_GET_CONTEXT

	char *l_feature_name = "cr_memset";

	EIF_POINTER Current = (EIF_POINTER) dest;

	RTCRAFS(0, l_feature_name, SF_BODY_ID);
	RTCRABS1(SK_POINTER, it_p, dest_size, SF_BODY_ID, 0);
	RTCRBS2;

	memset(dest, value, count);

	RTCRABEV(l_feature_name);
	RTCRFE;

}

rt_public int cr_memcmp(struct ex_vect *exvect, void *dest, void *other, size_t count)
{

	EIF_GET_CONTEXT

	char *l_feature_name = "cr_memcmp";
	EIF_POINTER Current = (EIF_POINTER) NULL;
	EIF_INTEGER Result;

	RTCRAFS(0, l_feature_name, SF_BODY_ID);
	RTCRABS1(SK_POINTER, it_p, 0, SF_BODY_ID, 0);
	RTCRBS2;

	Result = (EIF_INTEGER) memcmp(dest, other, count);

	RTCRABER(SK_INT32, it_i4, 0, l_feature_name);
	RTCRFE;

	return (int) Result;
}

rt_public void *cr_malloc(struct ex_vect *exvect, size_t size)
{

	EIF_GET_CONTEXT

	char *l_feature_name = "cr_malloc";
	EIF_POINTER Current = (EIF_POINTER) NULL;
	EIF_POINTER Result;

	RTCRAFS(0, l_feature_name, SF_BODY_ID);
	RTCRABS1(SK_POINTER, it_p, 0, SF_BODY_ID, 0);
	RTCRBS2;

	Result = (EIF_POINTER) malloc(size);

	RTCRABER(SK_POINTER, it_p, 0, l_feature_name);
	RTCRFE;

	return (void *) Result;
}


rt_public void *cr_calloc(struct ex_vect *exvect, size_t nmemb, size_t size)
{

	EIF_GET_CONTEXT

	char *l_feature_name = "cr_calloc";
	EIF_POINTER Current = (EIF_POINTER) NULL;
	EIF_POINTER Result;

	RTCRAFS(0, l_feature_name, SF_BODY_ID);
	RTCRABS1(SK_POINTER, it_p, 0, SF_BODY_ID, 0);
	RTCRBS2;

	Result = (EIF_POINTER) calloc(nmemb, size);
	
	RTCRABER(SK_POINTER, it_p, 0, l_feature_name);
	RTCRFE;

	return (void *) Result;
}


rt_public void *cr_realloc(struct ex_vect *exvect, void *source, size_t size)
{

	EIF_GET_CONTEXT

	char *l_feature_name = "cr_realloc";
	EIF_POINTER Current = (EIF_POINTER) NULL;
	EIF_POINTER Result;

	RTCRAFS(0, l_feature_name, SF_BODY_ID);
	RTCRABS1(SK_POINTER, it_p, 0, SF_BODY_ID, 0);
	RTCRBS2;

	Result = (EIF_POINTER) realloc(source, size);
	
	RTCRABER(SK_POINTER, it_p, 0, l_feature_name);
	RTCRFE;

	return (void *) Result;
}


rt_public void cr_free (struct ex_vect *exvect, void *dest)
{

	EIF_GET_CONTEXT

	char *l_feature_name = "cr_free";

	EIF_POINTER Current = (EIF_POINTER) NULL;

	RTCRAFS(0, l_feature_name, SF_BODY_ID);
	RTCRABS1(SK_POINTER, it_p, (size_t) 0, SF_BODY_ID, 0);
	RTCRBS2;

	free(dest);

	RTCRABEV(l_feature_name);
	RTCRFE;

}




/* RT_CAPTURE_REPLAY implementations */


rt_public void eif_printf (EIF_REFERENCE string)
{

	printf("%s", (char *) *(EIF_REFERENCE *)string);

}




