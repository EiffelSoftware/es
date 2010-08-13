
#ifndef _eif_capture_replay_h_
#define _eif_capture_replay_h_

#include "eif_portable.h"
#include "eif_types.h"

#ifdef __cplusplus
extern "C" {
#endif



RT_LNK void cr_init ();
RT_LNK void cr_exit ();

/* Capture routines */

RT_LNK void cr_register_call (int num_args, BODY_INDEX bodyid);
RT_LNK void cr_register_return (int num_args);
RT_LNK void cr_register_value (void *value, uint32 *type, uint32 pointed_type);

RT_LNK void cr_register_emalloc (EIF_REFERENCE obj);
RT_LNK void cr_register_protect (EIF_REFERENCE *obj);
RT_LNK void cr_register_wean (EIF_REFERENCE *obj);
RT_LNK void cr_register_exception (char *tag, long code);
RT_LNK void cr_register_retrieve (EIF_REFERENCE ref);

#ifdef EIF_THREADS
RT_LNK void cr_register_thread_start (EIF_REFERENCE thr_root_obj, EIF_THR_ATTR_TYPE *attr);
RT_LNK void cr_register_thread_end ();
#endif

RT_LNK int cr_epush(register struct stack *stk, EIF_REFERENCE *obj);
RT_LNK void cr_epop(struct stack *stk, EIF_REFERENCE *obj);

/* Replay routines */

RT_LNK void cr_replay ();

/* RT_CAPTURE_REPLAY routines */

RT_LNK void eif_printf (EIF_REFERENCE string);
#ifdef EIF_THREADS
RT_LNK EIF_NATURAL_64 eif_cr_thread_id ();
#endif

RT_LNK void cr_memcpy(struct ex_vect *exvect, void *dest, uint32 dest_type, const void *source, size_t count);
RT_LNK void cr_memmove(struct ex_vect *exvect, void *dest, uint32 dest_type, const void *source, size_t count);
RT_LNK void cr_memset(struct ex_vect *exvect, void *dest, uint32 dest_type, int value, size_t count);
RT_LNK int cr_memcmp(struct ex_vect *exvect, void *dest, void *other, size_t count);
RT_LNK void *cr_malloc(struct ex_vect *exvect, size_t size);
RT_LNK void *cr_calloc(struct ex_vect *exvect, size_t nmemb, size_t size);
RT_LNK void *cr_realloc(struct ex_vect *exvect, void *source, size_t size);
RT_LNK void cr_free (struct ex_vect *exvect, void *dest);


/* Operand extraction */

RT_LNK void cr_prepare_extraction (int num_operands);
RT_LNK void cr_add_operand (EIF_VALUE value, uint32 type);
RT_LNK void cr_extract_operands ();


#ifdef __cplusplus
}
#endif


#endif // _eif_capture_replay_h_
