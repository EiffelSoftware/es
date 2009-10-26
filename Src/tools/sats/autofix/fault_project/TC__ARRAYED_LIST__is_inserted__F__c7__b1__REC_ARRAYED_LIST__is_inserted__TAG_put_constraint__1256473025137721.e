
class
    TC__ARRAYED_LIST__is_inserted__F__c7__b1__REC_ARRAYED_LIST__is_inserted__TAG_put_constraint__1256473025137721
    
inherit
    EQA_SERIALIZED_TEST_SET

feature -- Test routines

    generated_test_1
        note
            testing: "AutoTest test case serialization"
            testing: "ARRAYED_LIST.is_inserted"
        local
            data: STRING
            operands: SPECIAL [detachable ANY]
            v_500: ARRAYED_LIST [ANY]
v_507: ANY
v_508: BOOLEAN

        do
            data := serialized_data
            operands ?= deserialized_object (data)
            	v_500 ?= operands.item (0)
	v_507 ?= operands.item (1)
			-- Test case
		v_508 := v_500.is_inserted (v_507)

        end
        
-- Object states

-- v_507: [[ANY]], [[]]

-- v_500: [[ARRAYED_LIST [ANY]]], [[bbbibibbbbibbbbbbbb]]
--|after = False
--|all_default = False
--|before = True
--|capacity = 6
--|changeable_comparison_criterion = True
--|count = 6
--|empty = False
--|exhausted = True
--|extendible = True
--|full = True
--|index = 0
--|is_empty = False
--|isfirst = False
--|islast = False
--|object_comparison = False
--|off = True
--|prunable = True
--|readable = False
--|writable = False



-- Exception trace
--
--<![CDATA[
--7
--is_inserted
--ARRAYED_LIST
--put_constraint
--False
---------------------------------------------------------------------------------
--Class / Object      Routine                Nature of exception           Effect
---------------------------------------------------------------------------------
--ARRAYED_LIST        is_inserted @1         put_constraint:              
--<00000000B7DA27C0>                         Assertion violated.           Fail
---------------------------------------------------------------------------------
--ARRAYED_LIST        is_inserted @1                                      
--<00000000B7DA27C0>                         Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    execute_byte_code @5   
--<00000000B6F4C850>                         Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    execute_protected @3   
--<00000000B6F4C850>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    report_execute_request @10
--<00000000B6F4C850>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    parse @6               
--<00000000B6F4C850>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    main_loop @5           
--<00000000B6F4C850>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    start @6               
--<00000000B6F4C850>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    execute @32            
--<00000000B6F4C850>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    root's creation        
--<00000000B6F4C850>                         Routine failure.              Exit
---------------------------------------------------------------------------------
--
--]]>
--


feature{NONE} -- Implementation
    
    serialized_data: STRING
            -- Serialized test case
        local
            l_array: ARRAY [NATURAL_8]
        do
            l_array := <<
16, 0, 0, 1, 131, 0, 12, 3, 248, 0, 5, 0, 3, 65, 78, 89, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 66, 79, 
79, 76, 69, 65, 78, 0, 0, 3, 1, 0, 212, 0, 0, 0, 1, 0, 4, 105, 116, 101, 109, 4, 0, 1, 0, 212, 0, 10, 73, 78, 
84, 69, 71, 69, 82, 95, 51, 50, 0, 0, 3, 8, 0, 215, 0, 0, 0, 1, 0, 4, 105, 116, 101, 109, 16, 0, 1, 0, 215, 0, 
7, 83, 80, 69, 67, 73, 65, 76, 0, 0, 0, 0, 1, 119, 0, 1, 248, 0, 0, 0, 0, 0, 0, 12, 65, 82, 82, 65, 89, 69, 
68, 95, 76, 73, 83, 84, 0, 0, 0, 0, 1, 137, 0, 1, 248, 0, 0, 0, 0, 6, 0, 4, 97, 114, 101, 97, 248, 0, 3, 1, 
119, 255, 248, 0, 1, 0, 17, 111, 98, 106, 101, 99, 116, 95, 99, 111, 109, 112, 97, 114, 105, 115, 111, 110, 4, 0, 1, 0, 212, 0, 
5, 108, 111, 119, 101, 114, 16, 0, 1, 0, 215, 0, 5, 117, 112, 112, 101, 114, 16, 0, 1, 0, 215, 0, 5, 99, 111, 117, 110, 116, 
16, 0, 1, 0, 215, 0, 5, 105, 110, 100, 101, 120, 16, 0, 1, 0, 215, 0, 0, 0, 5, 4, 183, 175, 106, 144, 10, 0, 0, 0, 
0, 0, 0, 1, 4, 183, 218, 39, 228, 1, 128, 1, 119, 0, 0, 0, 2, 0, 0, 1, 119, 0, 0, 0, 0, 0, 0, 0, 6, 0, 
0, 0, 4, 4, 183, 175, 106, 144, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 183, 
218, 39, 192, 0, 0, 1, 137, 0, 0, 0, 2, 0, 0, 1, 137, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 
6, 0, 0, 0, 1, 0, 4, 183, 218, 39, 228, 4, 183, 231, 84, 92, 0, 0, 0, 0, 0, 0, 0, 1, 4, 183, 233, 83, 4, 1, 
128, 1, 119, 0, 0, 0, 2, 0, 0, 1, 119, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 4, 4, 183, 218, 39, 192, 183, 231, 
84, 92>>
            
            Result := string_from_array (l_array)
        end
        
    string_from_array (a_array: ARRAY [NATURAL_8]): STRING is
            -- String from `a_array'.
        local
            l_lower, l_upper: INTEGER
            i: INTEGER
            j: INTEGER
        do
            l_lower := a_array.lower
            l_upper := a_array.upper
            create Result.make_filled (' ', l_upper - l_lower + 1)
            from
                j := 1
                i := l_lower
            until
                i > l_upper
            loop
                Result.put (a_array.item (i).to_character_8, j)
                i := i + 1
                j := j + 1
            end
        end
        
end

