CC = gcc
DELIVERY=/home/stefan/estudio/EiffelXX_wkbench_orig/
SRC=/home/stefan/ETH/Masterarbeit/capture_replay/
CFLAGS = -O0 -g -pipe  -DWORKBENCH -I"$(DELIVERY)/studio/spec/linux-x86/include" -I. -I$(DELIVERY)/studio/spec/linux-x86/include -I$(SRC)Src/C/run-time/include/ $(DELIVERY)studio/spec/linux-x86/lib/libwkbench.so
.c.o:
	$(CC) $(CFLAGS) -c $<
all: recorder.o
	(cd ../EIFGENs/iteration0_example/W_code/; make  all)
clean:
	rm  *.o
	(cd ../EIFGENs/iteration0_example/W_code/; make clean)


test:
	$(CC) $(CFLAGS) test.c
