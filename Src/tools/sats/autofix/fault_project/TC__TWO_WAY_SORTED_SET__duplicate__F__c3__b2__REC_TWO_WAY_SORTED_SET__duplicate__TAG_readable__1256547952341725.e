
class
    TC__TWO_WAY_SORTED_SET__duplicate__F__c3__b2__REC_TWO_WAY_SORTED_SET__duplicate__TAG_readable__1256547952341725
    
inherit
    EQA_SERIALIZED_TEST_SET

feature -- Test routines

    generated_test_1
        note
            testing: "AutoTest test case serialization"
            testing: "TWO_WAY_SORTED_SET.duplicate"
        local
            data: STRING
            operands: SPECIAL [detachable ANY]
            v_119: TWO_WAY_SORTED_SET [COMPARABLE]
v_178: INTEGER_32
v_179: TWO_WAY_SORTED_SET [COMPARABLE]

        do
            data := serialized_data
            operands ?= deserialized_object (data)
            	v_119 ?= operands.item (0)
	v_178 ?= operands.item (1)
			-- Test case
		v_179 := v_119.duplicate (v_178)

        end
        
-- Object states

-- v_178: [[INTEGER_32]], [[i]]
--|item = 3

-- v_119: [[TWO_WAY_SORTED_SET [COMPARABLE]]], [[bbbibbbbibbbbbbbbb]]
--|after = False
--|before = True
--|changeable_comparison_criterion = True
--|count = 0
--|empty = True
--|exhausted = True
--|extendible = True
--|full = False
--|index = 0
--|is_empty = True
--|isfirst = False
--|islast = False
--|object_comparison = False
--|off = True
--|prunable = True
--|readable = False
--|sorted = True
--|writable = False



-- Exception trace
--
--<![CDATA[
--3
--duplicate
--TWO_WAY_SORTED_SET
--readable
--False
---------------------------------------------------------------------------------
--Class / Object      Routine                Nature of exception           Effect
---------------------------------------------------------------------------------
--TWO_WAY_SORTED_SET  item @2                readable:                    
--<00000000B7B10D84>  (From LINKED_LIST)     Precondition violated.        Fail
---------------------------------------------------------------------------------
--TWO_WAY_SORTED_SET  duplicate @9                                        
--<00000000B7B10D84>                         Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    execute_byte_code @4   
--<00000000B6F5A8EC>                         Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    execute_protected @3   
--<00000000B6F5A8EC>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    report_execute_request @10
--<00000000B6F5A8EC>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    parse @6               
--<00000000B6F5A8EC>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    main_loop @5           
--<00000000B6F5A8EC>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    start @6               
--<00000000B6F5A8EC>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    execute @32            
--<00000000B6F5A8EC>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    root's creation        
--<00000000B6F5A8EC>                         Routine failure.              Exit
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
16, 0, 0, 1, 234, 0, 12, 3, 248, 0, 7, 0, 3, 65, 78, 89, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 67, 79, 
77, 80, 65, 82, 65, 66, 76, 69, 0, 0, 16, 0, 0, 156, 0, 0, 0, 0, 0, 7, 66, 79, 79, 76, 69, 65, 78, 0, 0, 3, 
1, 0, 212, 0, 0, 0, 1, 0, 4, 105, 116, 101, 109, 4, 0, 1, 0, 212, 0, 10, 73, 78, 84, 69, 71, 69, 82, 95, 51, 50, 
0, 0, 3, 8, 0, 215, 0, 0, 0, 1, 0, 4, 105, 116, 101, 109, 16, 0, 1, 0, 215, 0, 7, 83, 80, 69, 67, 73, 65, 76, 
0, 0, 0, 0, 1, 119, 0, 1, 248, 0, 0, 0, 0, 0, 0, 11, 66, 73, 95, 76, 73, 78, 75, 65, 66, 76, 69, 0, 0, 0, 
0, 1, 249, 0, 1, 248, 0, 0, 0, 0, 3, 0, 4, 105, 116, 101, 109, 248, 0, 2, 255, 248, 0, 1, 0, 5, 114, 105, 103, 104, 
116, 248, 0, 4, 255, 18, 1, 249, 255, 248, 0, 1, 0, 4, 108, 101, 102, 116, 248, 0, 4, 255, 18, 1, 249, 255, 248, 0, 1, 0, 
18, 84, 87, 79, 95, 87, 65, 89, 95, 83, 79, 82, 84, 69, 68, 95, 83, 69, 84, 0, 0, 0, 0, 1, 254, 0, 1, 248, 0, 0, 
0, 0, 8, 0, 6, 97, 99, 116, 105, 118, 101, 248, 0, 3, 1, 249, 255, 248, 0, 1, 0, 13, 102, 105, 114, 115, 116, 95, 101, 108, 
101, 109, 101, 110, 116, 248, 0, 3, 1, 249, 255, 248, 0, 1, 0, 7, 115, 117, 98, 108, 105, 115, 116, 248, 0, 4, 255, 18, 1, 254, 
255, 248, 0, 1, 0, 12, 108, 97, 115, 116, 95, 101, 108, 101, 109, 101, 110, 116, 248, 0, 3, 1, 249, 255, 248, 0, 1, 0, 17, 111, 
98, 106, 101, 99, 116, 95, 99, 111, 109, 112, 97, 114, 105, 115, 111, 110, 4, 0, 1, 0, 212, 0, 6, 98, 101, 102, 111, 114, 101, 4, 
0, 1, 0, 212, 0, 5, 97, 102, 116, 101, 114, 4, 0, 1, 0, 212, 0, 5, 99, 111, 117, 110, 116, 16, 0, 1, 0, 215, 0, 0, 
0, 3, 4, 183, 177, 13, 132, 4, 0, 1, 254, 0, 0, 0, 2, 0, 0, 1, 254, 0, 0, 0, 156, 0, 0, 0, 0, 0, 1, 0, 
4, 0, 0, 0, 0, 4, 0, 0, 0, 0, 4, 0, 0, 0, 0, 4, 0, 0, 0, 0, 4, 183, 202, 144, 108, 0, 130, 0, 215, 0, 
0, 0, 1, 0, 0, 0, 3, 4, 183, 202, 130, 176, 1, 128, 1, 119, 0, 0, 0, 2, 0, 0, 1, 119, 0, 0, 0, 0, 0, 0, 
0, 2, 0, 0, 0, 4, 4, 183, 177, 13, 132, 183, 202, 144, 108>>
            
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

