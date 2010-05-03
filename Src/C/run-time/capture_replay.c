


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


#include <stdio.h>
#include <string.h>

/* Constants for describing the type of event, using the first 3 bits of a byte */

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

/* The other 5 bits can be used for argument count etc. */

#define ARG_MASK 0x0F


#if 0
#define PRINTFDBG(x) \
	{ \
		int i;for(i=0;i<cr_cross_depth;i++)printf("  "); \
		printf x; \
	}
#else
#define PRINTFDBG(x)
#endif


/* Exception handling */

rt_private void cr_raise (char *msg) {
	//eraise (msg, EN_CR);
	print_err_msg(stderr, msg);
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






#define MAX_OBJ 1000

rt_private int cr_object_count;
rt_private EIF_REFERENCE cr_objects[MAX_OBJ];

rt_private void set_object_id (int id, EIF_REFERENCE obj)
{
	REQUIRE("valid_id", id < 1000);
	cr_objects[id] = obj;
	cr_object_count = id+1 > cr_object_count ? id+1 : cr_object_count;
}

rt_private int object_id (EIF_REFERENCE obj)
{
	int i;
	for (i = 0; i < cr_object_count; i++) {
		if (cr_objects[i] == obj) {
			return i;
		}
	}

	return -1;

}

rt_private int new_object_id (EIF_REFERENCE obj)
{
	REQUIRE("no_id_yet", object_id(obj) < 0);
	
	if (cr_object_count < MAX_OBJ) {
		cr_objects[cr_object_count] = obj;
		cr_object_count++;
	}
	else
		cr_raise ("Too many objects");
	return cr_object_count - 1;
}

rt_private int id_for_object (EIF_REFERENCE obj)
{
	int id = object_id(obj);
	if (id < 0) {
		id = new_object_id (obj);	
	}
	return id;
}

rt_private EIF_REFERENCE object_of_id (int id)
{
	if (1000 <= id)
		cr_raise ("Invalid object id");
	return cr_objects[id];
}









rt_private void cr_capture_value (EIF_TYPED_VALUE value)
{

	if ((value.type & SK_HEAD) == SK_REF) {
		value.it_i4 = id_for_object (value.it_r);
	}
	bwrite((char *) &value, sizeof(EIF_TYPED_VALUE));

}

rt_private void cr_capture_id (EIF_REFERENCE obj)
{

	uint32 id = id_for_object(obj);

	bwrite((char *) &id, sizeof(uint32));

}

rt_private void cr_retrieve_value (EIF_TYPED_VALUE *Result)
{

	bread((char *) Result, sizeof(EIF_TYPED_VALUE));

	if (((*Result).type & SK_HEAD) == SK_REF) {
		Result->it_r = object_of_id (Result->it_i4);
	}

}

#ifdef WORKBENCH

rt_private EIF_REFERENCE cr_retrieve_object ()
{
	uint32 id;
	bread((char *) &id, sizeof (uint32));
	return object_of_id (id);
}

#endif

rt_private void cr_retrieve_id (EIF_REFERENCE obj)
{
	uint32 id;
	bread((char *) &id, sizeof(uint32));

	set_object_id(id, obj);
}






/*
 * SPECIAL observing
 */

rt_private void cr_observe_object (EIF_REFERENCE sp)
{

	EIF_GET_CONTEXT

	REQUIRE("capturing", is_capturing);
	REQUIRE("has_id", object_id(sp) > -1);

	union overhead *zone = HEADER(sp);

	REQUIRE("is_special", (zone->ov_flags & (EO_SPEC | EO_TUPLE)) == EO_SPEC);


	struct stcrchunk *chunk;

	chunk = cr_top_area;
	while (chunk != NULL) {
		if (chunk->area.obj == sp)
			return;
		chunk = chunk->sk_prev;
	}

	chunk = (struct stcrchunk *) cmalloc(sizeof(struct stcrchunk));
	if (chunk == NULL)
		enomem();

	chunk->sk_prev = cr_top_area;
	cr_top_area = chunk;
	chunk->area.cross_depth = cr_cross_depth;
	chunk->area.obj = sp;

	size_t size = RT_SPECIAL_CAPACITY(sp)*RT_SPECIAL_ELEM_SIZE(sp);
	chunk->area.copy = cmalloc(size);
	if (chunk->area.copy == NULL)
		enomem();
	memcpy(chunk->area.copy, (void *) sp, size);

	PRINTFDBG(("Added observed obj (%d)\n", (int) size));

}

rt_private void cr_observe_changes ()
{

	EIF_GET_CONTEXT

	REQUIRE("capturing", is_capturing);

	struct stcrchunk *chunk;

	chunk = cr_top_area;
	while (chunk != NULL) {
		EIF_REFERENCE sp = chunk->area.obj;
		void *copy = chunk->area.copy;
		size_t size = RT_SPECIAL_CAPACITY(sp)*RT_SPECIAL_ELEM_SIZE(sp);
		if (memcmp(sp, copy, size)) {
			char type = (char) MEMMUT;
			bwrite(&type, 1);
			cr_capture_id(sp);
			size_t start, end;

				// TODO: optimize start/end values
			start = 0;
			end = size-1;

			bwrite((char *) &start, sizeof(size_t));
			bwrite((char *) &end, sizeof(size_t));
			bwrite((char *) sp, size);

			PRINTFDBG(("MEMMUT (%d, %d, %d)\n", (int) size, (int) start, (int) end));
		}
		chunk = chunk->sk_prev;
	}

}

rt_private void cr_remove_observed ()
{
	
	EIF_GET_CONTEXT

	REQUIRE("capturing", is_capturing);

	struct stcrchunk *chunk;

	chunk = cr_top_area;
	while (cr_top_area != NULL && cr_top_area->area.cross_depth >= cr_cross_depth) {
		struct stcrchunk *chunk = cr_top_area;

		cr_top_area = chunk->sk_prev;

		eif_rt_xfree (chunk->area.copy);
		eif_rt_xfree (chunk);
		PRINTFDBG(("Removed observed obj\n"));
	}


}

rt_private void cr_check_observation (EIF_REFERENCE obj)
{

	REQUIRE("has_id", object_id(obj) > -1);

	union overhead *zone = HEADER(obj);
	EIF_REFERENCE sp;

	if ((zone->ov_flags & (EO_SPEC | EO_TUPLE)) == EO_SPEC) {
		sp = obj;
	}
	else if (zone->ov_dftype == egc_str_dtype) {
		// TODO: observe special inside of STRING_8 object
		return;
	}
	else {
		return;
	}

	if (is_capturing)
		cr_observe_object (sp);

}


/*
 * Public Capture/Replay routines
 */


rt_public void cr_init (struct ex_vect* vect, int num_args, int num_ref_args)
{

	EIF_GET_CONTEXT

	REQUIRE("valid_context", is_capturing || (is_replaying && !RTCRI));

	// To be done during some (thread) initialization
	if (cr_file == (FILE *) NULL) {
		cr_object_count = 0;
		if (is_capturing)
			cr_file = fopen("./capture.log", "w");
		else
			cr_file = fopen("./capture.log", "r");
	}

	char type;
	if (RTCRI) {
		type = INCALL | num_args;
#ifdef WORKBENCH
		PRINTFDBG(("INCALL to %s (%d)\n", vect->ex_rout, vect->ex_bodyid));
#endif

	}
	else {
		type = OUTCALL | num_ref_args;
#ifdef WORKBENCH
		PRINTFDBG(("OUTCALL to %s (%d)\n", vect->ex_rout, vect->ex_bodyid));
#endif
	}

	if (is_capturing) {


		cr_observe_changes();


		if (num_args > 15)
			cr_raise ("to many arguments");

		bwrite(&type, sizeof(char));
#ifdef WORKBENCH
		bwrite((char *) &(vect->ex_bodyid), sizeof(BODY_INDEX));
#endif
		cr_capture_id(vect->ex_id);

		cr_check_observation(vect->ex_id);
	}
	else {
			// If we are not capturing, it must be an outcall
		char rtype;
		bread(&rtype, sizeof(char));
#ifdef WORKBENCH
		BODY_INDEX bid;
		bread((char *) &bid, sizeof(BODY_INDEX));
		
		if (rtype != type || bid != (vect->ex_bodyid)) {
			PRINTFDBG(("%x <> %x and %d != %d\n", rtype, type, bid, vect->ex_bodyid));
			cr_raise("Replay missmatch");
		}
#endif

		cr_retrieve_id (vect->ex_id);
	}
}


rt_public void cr_register_argument (EIF_TYPED_VALUE argx) {

	EIF_GET_CONTEXT

	REQUIRE("cr_file_not_null", cr_file != NULL);
	REQUIRE("valid_context", is_capturing || (is_replaying && !RTCRI));

	if (RTCRI) {
		// We must be capturing an INCALL
		cr_capture_value (argx);
	}
	else {
		if ((argx.type & SK_HEAD) == SK_POINTER && argx.it_r != NULL) {
			if ((HEADER(argx.it_r)->ov_flags & (EO_SPEC | EO_TUPLE)) == EO_SPEC) {
				argx.type = SK_REF;
				PRINTFDBG(("Pointer -> Special Ref\n"));
			}
			else {
				PRINTFDBG(("Pointer -> Nothing\n"));
			}
		}

		// We are either capturing or replaying an outcall
		if ((argx.type & SK_HEAD) == SK_REF) {
			if (is_capturing)
				cr_capture_id (argx.it_r);
			else
				cr_retrieve_id (argx.it_r);
			cr_check_observation(argx.it_r);
		}
	}

}

rt_public void cr_register_emalloc (EIF_REFERENCE obj)
{

	EIF_GET_CONTEXT

	REQUIRE("valid_context", is_capturing && !RTCRI);

	union overhead *zone = HEADER(obj);

	char type = NEWOBJ;
	if ((zone->ov_flags) & EO_NEW)
		type |= 0x1;

	EIF_TYPE_INDEX dftype = zone->ov_dftype;

	bwrite (&type, 1);
	bwrite ((char *) &dftype, sizeof(EIF_TYPE_INDEX));

	cr_capture_id (obj);

	cr_check_observation(obj);
	
	PRINTFDBG(("NEWOBJ %s\n", System(dftype).cn_generator));

}

rt_public void cr_register_result (struct ex_vect* vect, EIF_TYPED_VALUE Result) {

	EIF_GET_CONTEXT

	REQUIRE("valid_context", is_capturing || (is_replaying && RTCRI));

	char type;
	int returns_value = 0;
	int returns_id = 0;

	if (RTCRI) {
		type = (char) INRET;
#ifdef WORKBENCH
		PRINTFDBG(("INRET %s (%d)\n", vect->ex_rout, vect->ex_bodyid));
#endif
	}
	else {
		type = (char) OUTRET;
#ifdef WORKBENCH
		PRINTFDBG(("OUTRET %s (%d)\n", vect->ex_rout, vect->ex_bodyid));
#endif
	}

	if (Result.type != SK_INVALID) {
		if (type == OUTRET) {
			returns_value = 1;
			type |= 0x1;
		}
		else if ((Result.type & SK_HEAD) == SK_REF) {
			returns_id = 1;
			type |= 0x1;
		}
	}

	if (is_capturing) {

		cr_observe_changes();

		bwrite (&type, 1);

		if (returns_value) {
			cr_capture_value (Result);
		}
		else if (returns_id) {
			cr_capture_id (Result.it_r);
		}

		cr_remove_observed();
	}
	else {
		// We must be returning an Eiffel in-call

		char rtype;
		bread(&rtype, 1);
		if (rtype != type) {
			PRINTFDBG(("%x <> %x\n", rtype, type));
			cr_raise("Replay missmatch");
		}

		if (returns_id)
			cr_retrieve_id (Result.it_r);
		
	}
}

#ifdef WORKBENCH

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

#endif

rt_public void cr_replay (EIF_TYPED_VALUE *Result)
{

		// FIXME: remove once printf is no longer done
	EIF_GET_CONTEXT

	char type;

#ifdef WORKBENCH
	BODY_INDEX body_id;
	EIF_REFERENCE Current;
	EIF_TYPED_VALUE arg1, arg2;
#endif
	EIF_TYPE_INDEX dftype;
	EIF_REFERENCE obj = NULL;

	while (1) {
		bread (&type, 1);

		switch (type & TYPE_MASK) {
			case OUTRET:
				if ((type & ARG_MASK) > 0) {
					cr_retrieve_value(Result);
				}

				if (Result)
					if (Result->type == SK_POINTER)
						Result->it_p = (EIF_POINTER) NULL;

				PRINTFDBG(("OUTRET (?)\n"));

				return;

			case INCALL:
#ifdef WORKBENCH

				bread((char *) &body_id, sizeof(BODY_INDEX));
				Current = cr_retrieve_object();

				PRINTFDBG(("INCALL to (%d): %lx\n", body_id, (long unsigned int) Current));

				if ((type & ARG_MASK) == 0) {
					(FUNCTION_CAST(void, (EIF_REFERENCE)) featref(body_id))(Current);
					continue;
				}

				cr_retrieve_value(&arg1);
				if ((type & ARG_MASK) == 1) {
					(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE)) featref(body_id))(Current, arg1);
					continue;
				}

				cr_retrieve_value(&arg2);
				if ((type & ARG_MASK) == 2) {
					(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE)) featref(body_id))(Current, arg1, arg2);
					continue;
				}
				else {
					PRINTFDBG(("\n%d args for INCALL\n\n", (type&ARG_MASK)));
					cr_raise("Too many args for INCALL");
				}

#endif
				break;

			case NEWOBJ:

				bread ((char *) &dftype, sizeof(EIF_TYPE_INDEX));

				if ((type & ARG_MASK) == 1)
					obj = emalloc(dftype);
				else
					obj = emalloc_as_old(dftype);

				cr_retrieve_id(obj);
				PRINTFDBG(("NEWOBJ %s\n", System(dftype).cn_generator));
				break;

			case MEMMUT:
#ifdef WORKBENCH
				Current = cr_retrieve_object();

				CHECK("is_special", ((HEADER(Current)->ov_flags) & (EO_SPEC | EO_TUPLE)) == EO_SPEC);

				size_t start, end, size;
				bread((char *) &start, sizeof(size_t));
				bread((char *) &end, sizeof(size_t));
				size = end - start + 1;
				CHECK("valid_size", size <= RT_SPECIAL_CAPACITY(Current)*RT_SPECIAL_ELEM_SIZE(Current));

				bread((char *) Current, size);
				PRINTFDBG(("MEMMUT (%d)\n", (int) size));
#endif
				break;
			default:
				cr_raise("Corrupted log");
		}

	}

}









