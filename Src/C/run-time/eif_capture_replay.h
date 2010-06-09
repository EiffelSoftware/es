
#ifndef _eif_capture_replay_h_
#define _eif_capture_replay_h_

#include "eif_portable.h"
#include "eif_types.h"

#ifdef __cplusplus
extern "C" {
#endif


/* Capture routines */

void cr_init (EIF_TYPED_VALUE Current, uint32 size, BODY_INDEX bodyid, int num_args);
void cr_register_argument (EIF_TYPED_VALUE value, uint32 size);
void cr_register_result (EIF_TYPED_VALUE Result, uint32 size);
void cr_register_emalloc (EIF_REFERENCE obj);

void cr_register_protect (EIF_REFERENCE *obj);
void cr_register_wean (EIF_REFERENCE *obj);

/* Replay routines */

void cr_replay (EIF_TYPED_VALUE *Result);


/* RT_CAPTURE_REPLAY routines */

RT_LNK void eif_printf (EIF_REFERENCE string);


RT_LNK void cr_memcpy(struct ex_vect *exvect, void *dest, size_t dest_size, const void *source, size_t count);
RT_LNK void cr_memmove(struct ex_vect *exvect, void *dest, size_t dest_size, const void *source, size_t count);
RT_LNK void cr_memset(struct ex_vect *exvect, void *dest, size_t dest_size, int value, size_t count);
RT_LNK int cr_memcmp(struct ex_vect *exvect, void *dest, void *other, size_t count);
RT_LNK void *cr_malloc(struct ex_vect *exvect, size_t size);
RT_LNK void *cr_calloc(struct ex_vect *exvect, size_t nmemb, size_t size);
RT_LNK void *cr_realloc(struct ex_vect *exvect, void *source, size_t size);
RT_LNK void cr_free (struct ex_vect *exvect, void *dest);



#ifdef __cplusplus
}
#endif


#endif // _eif_capture_replay_h_
