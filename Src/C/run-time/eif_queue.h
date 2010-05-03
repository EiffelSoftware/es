
#ifndef _eif_queue_h_
#define _eif_queue_h_

#include "eif_portable.h"

#ifdef __cplusplus
extern "C" {
#endif


struct lfqueue {

	char *buffer;			// data buffer
	uint32 in, out;			// current position of writer/reader
	uint32 last;			// actual size of buffer-1

	void (*read_func)(struct lfqueue *q);	// routine which reads from the buffer (single threaded version)

};


int lfq_init (struct lfqueue *q, uint32 size);

void lfq_recycle (struct lfqueue *q);

uint32 lfq_write (struct lfqueue *q, char *data, uint32 length);
uint32 lfq_read (struct lfqueue *q, char *data, uint32 length);

char lfq_read_char (struct lfqueue *q);


#ifdef __cplusplus
}
#endif


#endif // _eif_queue_h_
