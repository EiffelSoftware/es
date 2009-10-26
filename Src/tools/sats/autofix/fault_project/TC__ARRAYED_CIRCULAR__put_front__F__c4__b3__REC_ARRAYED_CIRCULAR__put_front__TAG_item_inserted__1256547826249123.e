
class
    TC__ARRAYED_CIRCULAR__put_front__F__c4__b3__REC_ARRAYED_CIRCULAR__put_front__TAG_item_inserted__1256547826249123
    
inherit
    EQA_SERIALIZED_TEST_SET

feature -- Test routines

    generated_test_1
        note
            testing: "AutoTest test case serialization"
            testing: "ARRAYED_CIRCULAR.put_front"
        local
            data: STRING
            operands: SPECIAL [detachable ANY]
            v_32: ARRAYED_CIRCULAR [?ANY]
v_436: ?ANY

        do
            data := serialized_data
            operands ?= deserialized_object (data)
            	v_32 ?= operands.item (0)
	v_436 ?= operands.item (1)
			-- Test case
		v_32.put_front (v_436)

        end
        
-- Object states

-- v_436: [[ANY]], [[]]

-- v_32: [[ARRAYED_CIRCULAR [ANY]]], [[bbbibbbbibbbbbbbb]]
--|after = False
--|before = False
--|changeable_comparison_criterion = True
--|count = 6
--|empty = False
--|exhausted = True
--|extendible = True
--|full = False
--|index = 1
--|is_empty = False
--|isfirst = True
--|islast = False
--|object_comparison = False
--|off = False
--|prunable = True
--|readable = True
--|writable = True



-- Exception trace
--
--<![CDATA[
--4
--put_front
--ARRAYED_CIRCULAR
--item_inserted
--False
---------------------------------------------------------------------------------
--Class / Object      Routine                Nature of exception           Effect
---------------------------------------------------------------------------------
--ARRAYED_CIRCULAR    put_front @3           item_inserted:               
--<00000000B6FFC6F8>                         Postcondition violated.       Fail
---------------------------------------------------------------------------------
--ARRAYED_CIRCULAR    put_front @3                                        
--<00000000B6FFC6F8>                         Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    execute_byte_code @4   
--<00000000B6FFBBE8>                         Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    execute_protected @3   
--<00000000B6FFBBE8>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    report_execute_request @10
--<00000000B6FFBBE8>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    parse @6               
--<00000000B6FFBBE8>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    main_loop @5           
--<00000000B6FFBBE8>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    start @6               
--<00000000B6FFBBE8>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    execute @32            
--<00000000B6FFBBE8>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    root's creation        
--<00000000B6FFBBE8>                         Routine failure.              Exit
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
16, 0, 0, 2, 103, 0, 12, 3, 248, 0, 6, 0, 3, 65, 78, 89, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 66, 79, 
79, 76, 69, 65, 78, 0, 0, 3, 1, 0, 212, 0, 0, 0, 1, 0, 4, 105, 116, 101, 109, 4, 0, 1, 0, 212, 0, 10, 73, 78, 
84, 69, 71, 69, 82, 95, 51, 50, 0, 0, 3, 8, 0, 215, 0, 0, 0, 1, 0, 4, 105, 116, 101, 109, 16, 0, 1, 0, 215, 0, 
7, 83, 80, 69, 67, 73, 65, 76, 0, 0, 0, 0, 1, 119, 0, 1, 248, 0, 0, 0, 0, 0, 0, 12, 65, 82, 82, 65, 89, 69, 
68, 95, 76, 73, 83, 84, 0, 0, 0, 0, 1, 137, 0, 1, 248, 0, 0, 0, 0, 6, 0, 4, 97, 114, 101, 97, 248, 0, 3, 1, 
119, 255, 248, 0, 1, 0, 17, 111, 98, 106, 101, 99, 116, 95, 99, 111, 109, 112, 97, 114, 105, 115, 111, 110, 4, 0, 1, 0, 212, 0, 
5, 108, 111, 119, 101, 114, 16, 0, 1, 0, 215, 0, 5, 117, 112, 112, 101, 114, 16, 0, 1, 0, 215, 0, 5, 99, 111, 117, 110, 116, 
16, 0, 1, 0, 215, 0, 5, 105, 110, 100, 101, 120, 16, 0, 1, 0, 215, 0, 16, 65, 82, 82, 65, 89, 69, 68, 95, 67, 73, 82, 
67, 85, 76, 65, 82, 0, 0, 0, 0, 2, 37, 0, 1, 248, 0, 0, 0, 0, 4, 0, 4, 108, 105, 115, 116, 248, 0, 3, 1, 137, 
255, 248, 0, 1, 0, 17, 111, 98, 106, 101, 99, 116, 95, 99, 111, 109, 112, 97, 114, 105, 115, 111, 110, 4, 0, 1, 0, 212, 0, 18, 
105, 110, 116, 101, 114, 110, 97, 108, 95, 101, 120, 104, 97, 117, 115, 116, 101, 100, 4, 0, 1, 0, 212, 0, 7, 115, 116, 97, 114, 116, 
101, 114, 16, 0, 1, 0, 215, 0, 0, 0, 11, 4, 183, 122, 169, 56, 22, 0, 0, 0, 0, 0, 0, 1, 4, 183, 122, 192, 192, 8, 
0, 0, 0, 0, 0, 0, 1, 4, 183, 122, 206, 220, 2, 130, 0, 215, 0, 0, 0, 1, 0, 0, 0, 100, 4, 183, 122, 170, 124, 14, 
0, 0, 0, 0, 0, 0, 1, 4, 183, 122, 206, 244, 2, 130, 0, 215, 0, 0, 0, 1, 255, 255, 255, 254, 4, 183, 122, 207, 12, 2, 
130, 0, 212, 0, 0, 0, 1, 1, 4, 182, 255, 199, 52, 1, 176, 1, 119, 0, 0, 0, 2, 0, 0, 1, 119, 0, 0, 0, 0, 0, 
0, 0, 9, 0, 0, 0, 4, 4, 183, 122, 169, 56, 183, 122, 192, 192, 183, 122, 206, 220, 183, 122, 170, 124, 183, 122, 206, 244, 183, 122, 
207, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 182, 255, 199, 16, 0, 32, 1, 137, 0, 0, 0, 2, 0, 0, 1, 
137, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 6, 0, 0, 0, 9, 0, 0, 0, 1, 0, 4, 182, 255, 199, 52, 4, 182, 255, 
198, 248, 0, 32, 2, 37, 0, 0, 0, 2, 0, 0, 2, 37, 0, 0, 0, 0, 0, 0, 0, 2, 1, 0, 4, 182, 255, 199, 16, 4, 
183, 165, 194, 192, 0, 0, 0, 0, 0, 0, 0, 1, 4, 183, 167, 198, 96, 1, 128, 1, 119, 0, 0, 0, 2, 0, 0, 1, 119, 0, 
0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 4, 4, 182, 255, 198, 248, 183, 165, 194, 192>>
            
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

