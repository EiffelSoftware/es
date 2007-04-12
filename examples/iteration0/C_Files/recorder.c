#include <stdio.h>
#include "recorder.h"
//#include "/home/stefan/ETH/Masterarbeit/capture_replay/Src/C/run-time/include/rt_interp.h"
#include "/home/stefan/ETH/Masterarbeit/capture_replay/Src/C/ipc/shared/stack.h"
//#include "/home/stefan/estudio/EiffelXX/studio/spec/linux-x86/include/eif_cecil.h"
//#include "/home/stefan/estudio/EiffelXX/studio/spec/linux-x86/include/eif_debug.h"
//#include "/home/stefan/estudio/EiffelXX/studio/spec/linux-x86/include/eif_eiffel.h"

//#include "/home/stefan/ETH/Masterarbeit/capture_replay/Src/C/run-time/eif_struct.h"

char * type_name(uint32 type);

EIF_OBJECT getCaller(){
	printf( "Hello World\n" );
}


EIF_REFERENCE c_arguments_test(EIF_REFERENCE arg1, float arg2){
/*	printf("HELLO WORLD, c_arguments_test\n");
	struct item * stack_item;
	printf("exvect: %p",exvect);

	int method_start = go_ith_stack_level(0);
//	stack_item = c_oitem(0+0 + 2 +1 -1); //XXX this is most probably wrong. It should point at arg1.
	
	if (method_start != EIF_NO_ITEM) {
		dp = get_next_variable (method_start);
		while (dp) {	// While still some data to send 
			if (dp != (struct dump *) EIF_IGNORE)
				send_dump(s, dp);
			dp = get_next_variable (start);
		}

	}


	printf("type: %p", stack_item->type);
	if(stack_item->type == SK_REF){
		printf("HAHA, REFERENCE detected!");
	}
	printf("Address:%p",stack_item);

//	printf("starting extraction\n");
//	c_extract_args(2,stack_item);
//	printf("extraction finished.\n");
*/
return 0; //XXX
}

/*
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
*/

EIF_REFERENCE c_extract_argument(int stack_level, uint32 n){
	struct item *stack_item;
	stack_item = get_argument(stack_level,n);

	printf("before if. type =%s\n", type_name(stack_item->type));
	if(stack_item->type == SK_REF){
		printf("if");
		return (EIF_REFERENCE) * (EIF_REFERENCE*)stack_item->it_addr;
	}else{
		printf("else");
		return (EIF_REFERENCE) 0;
	}
	//TODO: handle expanded types correctly (find a way to pass them/dump them)
}


char * type_name(uint32 type_id){
	
	char * res;

	switch (type_id){
		case SK_EXP: res="SK_EXP"; break;
		case SK_MASK: res="SK_MASK"; break;
		case SK_BOOL: res="SK_BOOL"; break;
		case SK_CHAR: res="SK_CHAR"; break;
		case SK_INT8: res="SK_INT8"; break;
		case SK_INT32: res="SK_INT32"; break;
		case SK_INT16: res="SK_INT16"; break;
		case SK_REAL32: res="SK_REAL32"; break;
		case SK_WCHAR: res="SK_WCHAR"; break;
		case SK_REAL64: res="SK_REAL64"; break;
		case SK_INT64: res="SK_INT64"; break;
		case SK_BIT: res="SK_BIT"; break;
		case SK_STRING: res="SK_STRING"; break;
		case SK_UINT8: res="SK_UINT8"; break;
		case SK_UINT16: res="SK_UINT16"; break;
		case SK_UINT32: res="SK_UINT32"; break;
		case SK_UINT64: res="SK_UINT64"; break;
		case SK_POINTER: res="SK_POINTER"; break;
		case SK_CHAR32: res="SK_CHAR32"; break;
		case SK_BMASK: res="SK_BMASK"; break;
		case SK_SIMPLE: res="SK_SIMPLESK_SIMPLE"; break;
		case SK_REF: res="SK_REF"; break;
		case SK_VOID: res="SK_VOID"; break;
		case SK_DTYPE: res="SK_DTYPE"; break;
		case SK_INVALID: res="SK_INVALID"; break;
		
	}
	return res;
}
/*
#define_SK_BOOL		0x04000000			/*_Simple_boolean_type_
#define SK_CHAR		0x08000000			/*_Simple_character_type_
#define SK_INT8		0x0c000000			/*_Simple_integer_8_type_
#define SK_INT32	0x10000000			/*_Simple_integer_32_typ
#define SK_INT16	0x14000000			/*_Simple_integer_16_type_
#define SK_REAL32	0x18000000			/*_Simple_real_type_
#define SK_WCHAR	0x1c000000			/*_Simple_unicode_character_type_
#define SK_REAL64	0x20000000			/*_Simple_double_type_
#define SK_INT64	0x24000000			/*_Simple_integer_64_types_
#define SK_BIT		0x28000000			/*_Signals_bits_type_
#define SK_STRING	0x2c000000			/*_String_type_/_Use_for_debugging_only_
#define SK_UINT8	0x30000000			/*_Simple_unsigned_integer_8_type_
#define SK_UINT16	0x34000000			/*_Simple_unsigned_integer_16_type_
#define SK_UINT32	0x38000000			/*_Simple_unsigned_integer_32_type_
#define SK_UINT64	0x3c000000			/*_Simple_unsigned_integer_64_type_
#define SK_POINTER	0x40000000			/*_Simple_pointer_type_
#define SK_CHAR32	0x44000000			/*_Simple_32_bits_character_type_
#define SK_BMASK	0x00007fff			/*_Bits_number_(coded_on_15_bits)_
#define SK_SIMPLE	0x7c000000			/*_Mask_to_test_for_simple_type
#define SK_REF		0xf8000000			/*_Mask_to_test_for_reference_type_
#define SK_VOID		0x00000000			/*_Mask_for_void_type_
#define SK_DTYPE	0x0000ffff			/*_Value_of_reference_type_
#define SK_HEAD		0xff000000			/*_Mask_for_header_value_
#define SK_INVALID	0xffffffff			/*_Invalid_value,_may_be_used_as_flag_
*/

