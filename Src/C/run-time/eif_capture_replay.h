
#ifndef _eif_capture_replay_h_
#define _eif_capture_replay_h_

#include "eif_portable.h"
#include "eif_types.h"

#ifdef __cplusplus
extern "C" {
#endif


/* Capture routines */

void cr_init (struct ex_vect*, int num_args);
void cr_register_argument (EIF_TYPED_VALUE arg, size_t size);
void cr_register_result (struct ex_vect* vect, EIF_TYPED_VALUE Result, size_t size);
void cr_register_emalloc (EIF_REFERENCE obj);

void cr_register_protect (EIF_REFERENCE obj);
void cr_register_wean (EIF_REFERENCE obj);

/* Replay routines */

void cr_replay (EIF_TYPED_VALUE *Result);


/* RT_CAPTURE_REPLAY routines */

RT_LNK void eif_printf (EIF_REFERENCE string);

#ifdef __cplusplus
}
#endif


#endif // _eif_capture_replay_h_
