


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

#define PRTOBJ  0xA0    /* Keep reference to Eiffel object on stack */
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

rt_private int cr_object_count ()
{
	EIF_GET_CONTEXT
	int count = 0;
	struct stcrchunk *chunk = cr_top_object;

	while (chunk != NULL) {
		chunk = chunk->sk_prev;
		count++;
	}

	return count;
}

rt_private uint32 cr_id_of_object (EIF_POINTER p, size_t size)
{

	/*
		size == 0 will return any reference that matches...
	*/

	EIF_GET_CONTEXT

	struct stcrchunk *chunk = cr_top_object;
	

	uint32 id = 1;
	while (chunk != NULL) {
		int same_ref = 0;
		if (chunk->object.size > 0)
			same_ref = chunk->object.ref.p == p;
		else
			same_ref = eif_access(chunk->object.ref.o) == (EIF_REFERENCE) p;

		if (same_ref && (size == 0 || chunk->object.size == size))
			return id;

		chunk = chunk->sk_prev;
		id++;
	}

	 /* No object for that pointer */
	return 0;

}


rt_private struct cr_object *cr_object_of_id (uint32 id)
{

	REQUIRE("valid_id", id > 0);

	EIF_GET_CONTEXT

	uint32 curr_id = id;
	struct stcrchunk *chunk = cr_top_object;

	while (curr_id-- > 1) {
		chunk = chunk->sk_prev;
		if (chunk == NULL)
			return NULL;
	}

	return &(chunk->object);
}

rt_private void cr_push_object (EIF_VALUE val, size_t size, int is_current)
{

	EIF_GET_CONTEXT

	struct stcrchunk *chunk;
	void *src = NULL;
	size_t src_size = 0;
	uint32 id;

	EIF_CR_REFERENCE ref;

		/* Get id if `ref' has already been pushed to stack  */
	if (size > 0) {
		ref.p = val.p;
		id = cr_id_of_object (ref.p, size);
	}
	else {
		cr_suppress_event = 1;
		ref.o = eif_protect(val.r);
		cr_suppress_event = 0;
		id = cr_id_of_object (val.r, (size_t) 0);
	}

	chunk = (struct stcrchunk *) cmalloc(sizeof(struct stcrchunk));
	if (chunk == NULL)
		enomem();

	chunk->sk_prev = cr_top_object;
	cr_top_object = chunk;

	chunk->object.is_current = is_current;
	chunk->object.ref = ref;
	chunk->object.size = size;
	chunk->object.is_protected = 0;
	chunk->object.copy = NULL;

		/* when replaying we do not observe objects */
	if (is_replaying)
		return;

		/* return if ref is already being observed by a different area */
	if (id > 0)
		return;

		/* check if we need to do any observation */
	if (size == 0) {
		EIF_REFERENCE r = eif_access(ref.o);
		union overhead *zone = HEADER(r);
			// FIXME: make sure r is a basic typed SPECIAL!
		if ((zone->ov_flags & (EO_SPEC | EO_TUPLE)) == EO_SPEC) {
			src = (void *) r;
			src_size = RT_SPECIAL_CAPACITY(r)*RT_SPECIAL_ELEM_SIZE(r);
		}
	}
	else {
		src = (void *) ref.p;
		src_size = size;
	}

	if (src_size > 0 && src != NULL) {
		chunk->object.copy = cmalloc(src_size);

		if (chunk->object.copy == NULL)
			enomem();
		memcpy(chunk->object.copy, src, src_size);
	}

	return;

}


rt_private void cr_capture_mutations ()
{

	EIF_GET_CONTEXT

	REQUIRE("capturing", is_capturing);

	struct stcrchunk *chunk;
	uint32 id = 1;

	chunk = cr_top_object;
	while (chunk != NULL) {

		void *src;
		size_t src_size = chunk->object.size;
		if (src_size == 0) {
			EIF_REFERENCE r = eif_access(chunk->object.ref.o);
			union overhead *zone = HEADER(r);
			if ((zone->ov_flags & (EO_SPEC | EO_TUPLE)) == EO_SPEC) {
				src = (void *) r;
				src_size = RT_SPECIAL_CAPACITY(r)*RT_SPECIAL_ELEM_SIZE(r);
			}
		}
		else {
			src = chunk->object.ref.p;
		}

		void *copy = chunk->object.copy;

		if (src_size > 0 && copy != NULL) {
			if (memcmp(src, copy, src_size)) {

				char type = (char) MEMMUT;
				bwrite(&type, 1);
				bwrite((char *) &id, sizeof(uint32));

				size_t start, end;

					// TODO: optimize start/end values
				start = 0;
				end = src_size-1;

				bwrite((char *) &start, sizeof(size_t));
				bwrite((char *) &end, sizeof(size_t));
				bwrite((char *) src, src_size);

				memcpy(chunk->object.copy, src, src_size);
			}
		}
		chunk = chunk->sk_prev;
		id++;
	}

}

rt_private void cr_pop_objects ()
{

	EIF_GET_CONTEXT

	REQUIRE("top_not_null", cr_top_object != NULL);

	struct stcrchunk *chunk = cr_top_object;
	struct stcrchunk **tail = &cr_top_object;

	int count = cr_object_count ();
	int id = 1;

	while (chunk != NULL) {

		struct stcrchunk *old = chunk;
		if (old->object.is_current) {
			chunk = NULL;
		}
		else {
			chunk = old->sk_prev;
			CHECK ("not_null", chunk != NULL);
		}
		if (old->object.is_protected) {
				/* chunk will remain in stack */
			*tail = old;
			tail = &(old->sk_prev);
				/* If chunk was bottom of stack but remains, it no longer represents a `Current' */
			old->object.is_current = 0;
		}
		else {
				 /* chunk is removed from stack */
			*tail = old->sk_prev;

			if (old->object.size == 0) {
				cr_suppress_event = 1;
				eif_wean (old->object.ref.o);
				cr_suppress_event = 0;
			}
			if (old->object.copy != NULL)
				eif_rt_xfree (old->object.copy);
			eif_rt_xfree (old);
		}
		id++;
	}

}




/*
 * Capture/Replay helper routines
 */


/* Special EIF_VALUE for storing the size and id of an EIF_CR_REFERENCE */
typedef union EIF_CR_VALUE_tag {
	EIF_NATURAL_64 n8;
	struct {
		uint32 size;
		uint32 id;
	} n4;
} EIF_CR_VALUE;

rt_private void cr_store_value (EIF_TYPED_VALUE value);
rt_private void cr_read_value (EIF_TYPED_VALUE *value);

rt_private void cr_capture_object (EIF_VALUE value, EIF_TYPE_INDEX dtype, size_t size, char flag);
rt_private void cr_capture_value (EIF_TYPED_VALUE value, char flag);

rt_private void cr_retrieve_value (EIF_TYPED_VALUE *value);
rt_private struct cr_object * cr_retrieve_object ();


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
#define CV_CURRENT	0x04


rt_private void cr_capture_object (EIF_VALUE val, EIF_TYPE_INDEX dtype, size_t size, char flag)
{

	REQUIRE("capturing_or_replaying", is_capturing || is_replaying);
	REQUIRE("replaying_implies_pushing", !is_replaying || (flag & CV_PUSH));
	REQUIRE("size_or_dtype", size == 0 || dtype == 0);
	
	EIF_TYPED_VALUE tvalue, rtvalue;
	EIF_CR_VALUE item;
	uint32 id = 0;

	item.n4.size = size;

	if (flag & CV_PUSH) {
		id = 0;
		// TODO: recursively push TUPLE [..] objects and store subitems in `id'

		cr_push_object (val, size, flag & CV_CURRENT);
	}
	else {
		id = cr_id_of_object (val.p, size);

		if (id == 0) {
				/* FIXME: generalize the access to once variables in run-time, such as the exception manager ... */
			if (val.r == except_mnger)
				id = 0xFFFFFFFF;
		}

		if (id == 0) {
			printf("Unknown reference %lx\n", (long unsigned int) val.p);
			cr_raise ("Passing unknown reference to Eiffel");
		}

	}

	item.n4.size = size;
	item.n4.id = id;

	tvalue.type = SK_REF | dtype;
	tvalue.it_n8 = item.n8;

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

	if ((flag & (CV_PUSH | CV_RECURSIVE)) && size == 0) {
		if (HEADER(val.r)->ov_flags & EO_TUPLE) {
			EIF_TYPED_VALUE *titem = (EIF_TYPED_VALUE *) val.r;
			uint32 count = RT_SPECIAL_COUNT (val.r);
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
	REQUIRE("not_current", !(flag & CV_CURRENT));

	EIF_TYPED_VALUE rvalue;

	if ((value.type & SK_HEAD) == SK_REF && (value.it_r != (EIF_REFERENCE) NULL)) {
		cr_capture_object (value.item, (EIF_TYPE_INDEX) value.type & SK_DTYPE, (size_t) 0, flag);
	}
	else if ((value.type & SK_POINTER) && value.it_p != NULL && is_instance (value.it_p)) {
		cr_capture_object (value.item, HEADER(value.it_r)->ov_dftype, (size_t) 0, flag);
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

	EIF_CR_VALUE item;
	struct cr_object *object;

	cr_read_value (value);

	if ((value->type & SK_HEAD) == SK_REF) {

		item.n8 = value->it_n8;
		if (item.n4.id > 0) {
				/* FIXME: generalize once references... */
			if (item.n4.id == 0xFFFFFFFF) {
				value->it_r = except_mnger;
				value->type = SK_REF;
			}
			else {
				object = cr_object_of_id (item.n4.id);
				if (object == NULL)
					cr_raise ("Replay mismatch: requested reference for unknown ID");
			
				if (object->size > 0) {
					value->type = SK_POINTER;
					value->it_p = object->ref.p;
				}
				else {
					value->it_r = eif_access (object->ref.o);
					value->type = SK_REF | (EIF_TYPE_INDEX) HEADER(value->it_r)->ov_dftype;
				}
			}
		}
		else {
			value->it_p = NULL;
		}

	}

}

rt_private struct cr_object * cr_retrieve_object ()
{

	REQUIRE("replaying", is_replaying);

	uint32 id;

	bread((char *) &id, sizeof(id));
	
	if (id == 0)
		cr_raise("Replay mismatch: read invalid id from log");

	return cr_object_of_id (id);
}


/*
 * Public capture/replay routines
 */


rt_public void cr_init (struct ex_vect* vect, int num_args)
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
	EIF_VALUE v;
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

	v.r = vect->ex_id;

	if (is_capturing) {


			/* We only capture changes done during external OUTCALL */
		if (RTCRI)
			cr_capture_mutations();

		bwrite(&type, sizeof(char));
		bwrite((char *) &(vect->ex_bodyid), sizeof(BODY_INDEX));

	}
	else {
			// If we are not capturing, it must be an outcall
		bread(&rtype, sizeof(char));

		if (rtype != type) {
			cr_raise ("Expected OUTCALL but read different event from log");
		}

		bread((char *) &bid, sizeof(BODY_INDEX));
		
		if (bid != (vect->ex_bodyid)) {
			cr_raise("Expected OUTCALL to different routine");
		}
	}

	cr_capture_object (v, HEADER(v.r)->ov_dftype, (size_t) 0, RTCRI ? (char) 0 : CV_CURRENT | CV_PUSH | CV_RECURSIVE);

}


rt_public void cr_register_argument (EIF_TYPED_VALUE arg, size_t size)
{
	EIF_GET_CONTEXT

	REQUIRE("valid_context", is_capturing || (is_replaying && !RTCRI));
	REQUIRE("valid_size", size == 0 || arg.type == SK_POINTER);

	char flags;
	if (RTCRI) {
			/* We must be capturing the arguments of an incall */
		flags = (char) 0;
	}
	else {
		flags = CV_PUSH | CV_PUSH;
	}

	if (size > 0) {
		cr_capture_object (arg.item, (EIF_TYPE_INDEX) 0, size, flags);
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
	EIF_VALUE v;

	if ((zone->ov_flags) & EO_NEW)
		type |= 0x1;

	EIF_TYPE_INDEX dftype = zone->ov_dftype;

	bwrite (&type, 1);
	bwrite ((char *) &dftype, sizeof(EIF_TYPE_INDEX));

	v.r = obj;
	cr_push_object (v, (size_t) 0, 0);

}

rt_public void cr_register_result (struct ex_vect* vect, EIF_TYPED_VALUE Result, size_t size) {

	EIF_GET_CONTEXT

	REQUIRE("valid_context", is_capturing || (is_replaying && RTCRI));
	REQUIRE("size_implies_pointer", size == 0 || (Result.type == SK_POINTER));

	char type, rtype, flags;

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
		if (size > 0)
			cr_capture_object (Result.item, (EIF_TYPE_INDEX) 0, size, flags);
		else
			cr_capture_value (Result, flags);
	}

	if (!RTCRI)
		cr_pop_objects();
}

rt_public void cr_register_protect (EIF_REFERENCE obj)
{
	EIF_GET_CONTEXT

	REQUIRE("capturing", is_capturing);

	if (!cr_suppress_event) {

		REQUIRE("not_inside", !RTCRI);

		uint32 id = cr_id_of_object (obj, (size_t) 0);

		if (id == 0)
			cr_raise ("Trying to protect unknown reference");

		char type = (char) PRTOBJ;
		bwrite(&type, (size_t) 1);
		bwrite((char *) &id, sizeof(uint32));
	
		struct cr_object * cr_obj = cr_object_of_id (id);
		CHECK("not_null", cr_obj != NULL);

		cr_obj->is_protected++;

	}
}


rt_public void cr_register_wean (EIF_REFERENCE obj)
{

	EIF_GET_CONTEXT

	REQUIRE("capturing", is_capturing);

	if (!cr_suppress_event) {

		REQUIRE("not_inside", !RTCRI);

		printf ("wean %lx\n", (long unsigned int) obj);
	}
}






rt_private EIF_REFERENCE_FUNCTION featref (BODY_INDEX body_id)
{
	EIF_GET_CONTEXT

	if (egc_frozen[body_id])
		return egc_frozen[body_id];
	else {
		IC = melt[body_id];
		return pattern[MPatId(body_id)].toi;
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
	EIF_VALUE v;
	struct cr_object *object;


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
					v.r = emalloc(dftype);
				else
					v.r = emalloc_as_old(dftype);

				cr_push_object (v, (size_t) 0, 0);

				break;

			case PRTOBJ:

				object = cr_retrieve_object();

				if (object == NULL)
					cr_raise("Invalid ID for PRTOBJ");

				object->is_protected++;

				break;

			case MEMMUT:

				object = cr_retrieve_object();

				if (object == NULL)
					cr_raise("Invalid ID for MEMMUT");

				size_t start, end, size;
				bread((char *) &start, sizeof(size_t));
				bread((char *) &end, sizeof(size_t));
				size = end - start + 1;

				if (object->size > 0) {
					CHECK("valid_size", size <= object->size);
					bread((char *) object->ref.p, size);
				}
				else {
					Current = eif_access(object->ref.o);

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




/* RT_CAPTURE_REPLAY implementations */


rt_public void eif_printf (EIF_REFERENCE string)
{

	printf("%s", (char *) *(EIF_REFERENCE *)string);

}




