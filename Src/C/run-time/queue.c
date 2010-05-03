


#include "eif_queue.h"
#include "rt_malloc.h"

#include <string.h>



int lfq_init (struct lfqueue *q, uint32 size) {

	/* require (size & (size - 1) == 0) */
	
	q->buffer = cmalloc(size);
	if (!q->buffer)
		return -1;

	q->in = 0;
	q->out = q->last = size-1;
	q->read_func = NULL;

	return 0;

}

void lfq_recycle (struct lfqueue *q) {

	eif_rt_xfree (q->buffer);

}


uint32 lfq_write (struct lfqueue *q, char *data, uint32 length) {

 	uint32 remaining = length;
	uint32 last = q->last;

	while (remaining > 0) {

		uint32 in = q->in;
		uint32 out = q->out;

		if (in != out) {

				// number of free cells
			uint32 free = out - in;
				// if end of buffer is between, we only write into cells up to the buffer
				// and write the rest in a next step
			if (free < 0)
				free = last - in + 1;
				// number of cells we are going to write
			uint32 write = free < remaining ? free : remaining;
//			printf ("writing %d bytes\n", write);
			memcpy (q->buffer + in, data + length - remaining, write);
			remaining -= write;
			q->in = (in + write) & last;

		}
		else {
			// Buffer full
			if (q->read_func == NULL) {
					// No read function so we return the effective number of bytes written to buffer
				return length - remaining;
			}
			else {
				// Call read function to empty buffer again
				(*(q->read_func))(q);
			}

		}

	}

	return length;

}

uint32 lfq_read (struct lfqueue *q, char *data, uint32 length) {

	uint32 remaining = length;
	uint32 last = q->last;

	while (remaining > 0) {

		uint32 in = q->in;
		uint32 out = (q->out + 1) & last;
		
		if (in != out) {
			uint32 avail = in - out;
			if (avail < 0)
				avail = last - out + 1;
			uint32 read = avail < remaining ? avail : remaining;
//			printf ("reading %d bytes\n", read);
			memcpy (data + length - remaining, q->buffer + out, read);
			remaining -= read;
			q->out = (out + read - 1) & last;
		}
		else {
			return length - remaining;
		}

	}
	return length;
}


char lfq_read_char (struct lfqueue *q) {

	char c = 0;
	lfq_read (q, &c, 1);
	return c;
}
