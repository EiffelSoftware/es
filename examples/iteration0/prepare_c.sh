#!/bin/bash
pushd .
cd EIFGENs/iteration0_example/W_code/C1
sed -i 's/\([[:space:]]*(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_REFERENCE, EIF_POINTER, EIF_INTEGER_32)) RTVF([[:digit:]]*, [[:digit:]]*, "methodbodystart", [[:alnum:]]*))([[:alnum:]]*, [[:alnum:]]*, \)Current\(, ((EIF_INTEGER_32).*\)/\1c_oitem(0+0 + cargnum + clocnum -1)\2/' *.c
popd
