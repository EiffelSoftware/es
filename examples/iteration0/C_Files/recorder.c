#include <stdio.h>
#include "recorder.h"
#include "/home/stefan/estudio/EiffelXX/studio/spec/linux-x86/include/eif_cecil.h"
#include "/home/stefan/estudio/EiffelXX/studio/spec/linux-x86/include/eif_debug.h"
#include "/home/stefan/estudio/EiffelXX/studio/spec/linux-x86/include/eif_eiffel.h"
#include "/home/stefan/ETH/Masterarbeit/capture_replay/Src/C/ipc/shared/stack.h"
#include "/home/stefan/ETH/Masterarbeit/build/es_trunk/Src/C/run-time/eif_struct.h"


EIF_OBJECT getCaller(){
	printf( "Hello World\n" );
}

EIF_REFERENCE c_arguments_test(EIF_REFERENCE arg1, float arg2){
	printf("HELLO WORLD, c_arguments_test\n");
	struct item * stack_item;
	printf("exvect: %p",exvect);

	int method_start = go_ith_stack_level(0);
//	stack_item = c_oitem(0+0 + 2 +1 -1); //XXX this is most probably wrong. It should point at arg1.
	
	printf("type: %p", stack_item->type);
	if(stack_item->type == SK_REF){
		printf("HAHA, REFERENCE detected!");
	}
	printf("Address:%p",stack_item);

//	printf("starting extraction\n");
//	c_extract_args(2,stack_item);
//	printf("extraction finished.\n");
}

void c_extract_argument(EIF_POINTER p_item, int ith){
	int i;
	struct item * stack_item = (struct item *) p_item;
	stack_item = stack_item + ith;
	printf("before if. type =%p", stack_item->type);
	if(stack_item->type == SK_REF){
		printf("if");
		return (EIF_REFERENCE) stack_item->it_addr;
	}else{
		printf("else");
		return (EIF_REFERENCE) 0;
	}
}

