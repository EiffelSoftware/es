C = gcc
CFLAGS = -O0 -g -pipe  -DWORKBENCH -I"/home/stefan/estudio/EiffelXX/studio/spec/linux-x86/include" -I.
.c.o:
	$(CC) $(CFLAGS) -c $<
all: recorder.o
	(cd ../EIFGENs/iteration0_example/W_code/; make  all)
clean:
	rm  *.o
	(cd ../EIFGENs/iteration0_example/W_code/; make clean)
