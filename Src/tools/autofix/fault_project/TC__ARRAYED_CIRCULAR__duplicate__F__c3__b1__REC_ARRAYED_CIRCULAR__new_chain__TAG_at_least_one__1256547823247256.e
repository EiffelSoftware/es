
class
    TC__ARRAYED_CIRCULAR__duplicate__F__c3__b1__REC_ARRAYED_CIRCULAR__new_chain__TAG_at_least_one__1256547823247256
    
inherit
    EQA_SERIALIZED_TEST_SET

feature -- Test routines

    generated_test_1
        note
            testing: "AutoTest test case serialization"
            testing: "ARRAYED_CIRCULAR.duplicate"
        local
            data: STRING
            operands: SPECIAL [detachable ANY]
            v_636: ARRAYED_CIRCULAR [?ANY]
v_790: INTEGER_32
v_791: ARRAYED_CIRCULAR [?ANY]

        do
            data := serialized_data
            operands ?= deserialized_object (data)
            	v_636 ?= operands.item (0)
	v_790 ?= operands.item (1)
			-- Test case
		v_791 := v_636.duplicate (v_790)

        end
        
-- Object states

-- v_790: [[INTEGER_32]], [[i]]
--|item = 10

-- v_636: [[ARRAYED_CIRCULAR [ANY]]], [[bbbibbbbibbbbbbbb]]
--|after = True
--|before = False
--|changeable_comparison_criterion = True
--|count = 0
--|empty = True
--|exhausted = True
--|extendible = True
--|full = False
--|index = 1
--|is_empty = True
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
--3
--new_chain
--ARRAYED_CIRCULAR
--at_least_one
--False
---------------------------------------------------------------------------------
--Class / Object      Routine                Nature of exception           Effect
---------------------------------------------------------------------------------
--ARRAYED_CIRCULAR    make @1                at_least_one:                
--<00000000B7A94C78>                         Precondition violated.        Fail
---------------------------------------------------------------------------------
--ARRAYED_CIRCULAR    new_chain @1                                        
--<00000000B76ED4C4>                         Routine failure.              Fail
---------------------------------------------------------------------------------
--ARRAYED_CIRCULAR    duplicate @3                                        
--<00000000B76ED4C4>  (From DYNAMIC_CIRCULAR)
--                                           Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    execute_byte_code @4   
--<00000000B6F3E000>                         Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    execute_protected @3   
--<00000000B6F3E000>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    report_execute_request @10
--<00000000B6F3E000>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    parse @6               
--<00000000B6F3E000>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    main_loop @5           
--<00000000B6F3E000>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    start @6               
--<00000000B6F3E000>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    execute @32            
--<00000000B6F3E000>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    root's creation        
--<00000000B6F3E000>                         Routine failure.              Exit
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
16, 0, 0, 2, 20, 0, 12, 3, 248, 0, 6, 0, 3, 65, 78, 89, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 66, 79, 
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
101, 114, 16, 0, 1, 0, 215, 0, 0, 0, 5, 4, 183, 110, 213, 0, 9, 128, 1, 119, 0, 0, 0, 2, 0, 0, 1, 119, 0, 0, 
0, 0, 0, 0, 0, 9, 0, 0, 0, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 183, 110, 212, 220, 8, 0, 1, 137, 0, 0, 0, 2, 
0, 0, 1, 137, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 1, 0, 4, 183, 110, 213, 0, 
4, 183, 110, 212, 196, 8, 0, 2, 37, 0, 0, 0, 2, 0, 0, 2, 37, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 183, 110, 
212, 220, 4, 183, 168, 225, 32, 0, 130, 0, 215, 0, 0, 0, 1, 0, 0, 0, 10, 4, 183, 168, 211, 100, 1, 128, 1, 119, 0, 0, 
0, 2, 0, 0, 1, 119, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 4, 4, 183, 110, 212, 196, 183, 168, 225, 32>>
            
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

