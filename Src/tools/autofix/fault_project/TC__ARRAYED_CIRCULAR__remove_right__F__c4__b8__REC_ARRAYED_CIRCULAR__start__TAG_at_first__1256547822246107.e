
class
    TC__ARRAYED_CIRCULAR__remove_right__F__c4__b8__REC_ARRAYED_CIRCULAR__start__TAG_at_first__1256547822246107
    
inherit
    EQA_SERIALIZED_TEST_SET

feature -- Test routines

    generated_test_1
        note
            testing: "AutoTest test case serialization"
            testing: "ARRAYED_CIRCULAR.remove_right"
        local
            data: STRING
            operands: SPECIAL [detachable ANY]
            v_388: ARRAYED_CIRCULAR [?ANY]

        do
            data := serialized_data
            operands ?= deserialized_object (data)
            	v_388 ?= operands.item (0)
			-- Test case
		v_388.remove_right

        end
        
-- Object states

-- v_388: [[ARRAYED_CIRCULAR [ANY]]], [[bbbibbbbibbbbbbbb]]
--|after = False
--|before = False
--|changeable_comparison_criterion = True
--|count = 2
--|empty = False
--|exhausted = False
--|extendible = True
--|full = True
--|index = 2
--|is_empty = False
--|isfirst = False
--|islast = True
--|object_comparison = False
--|off = False
--|prunable = True
--|readable = True
--|writable = True



-- Exception trace
--
--<![CDATA[
--4
--start
--ARRAYED_CIRCULAR
--at_first
--False
---------------------------------------------------------------------------------
--Class / Object      Routine                Nature of exception           Effect
---------------------------------------------------------------------------------
--ARRAYED_CIRCULAR    start @8               at_first:                    
--<00000000B7BB19E8>                         Postcondition violated.       Fail
---------------------------------------------------------------------------------
--ARRAYED_CIRCULAR    start @8                                            
--<00000000B7BB19E8>                         Routine failure.              Fail
---------------------------------------------------------------------------------
--ARRAYED_CIRCULAR    go_i_th @4                                          
--<00000000B7BB19E8>  (From CIRCULAR)        Routine failure.              Fail
---------------------------------------------------------------------------------
--ARRAYED_CIRCULAR    finish @2                                           
--<00000000B7BB19E8>  (From CHAIN)           Routine failure.              Fail
---------------------------------------------------------------------------------
--ARRAYED_CIRCULAR    remove_right @6                                     
--<00000000B7BB19E8>                         Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    execute_byte_code @2   
--<00000000B70014B4>                         Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    execute_protected @3   
--<00000000B70014B4>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    report_execute_request @10
--<00000000B70014B4>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    parse @6               
--<00000000B70014B4>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    main_loop @5           
--<00000000B70014B4>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    start @6               
--<00000000B70014B4>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    execute @32            
--<00000000B70014B4>  (From ITP_INTERPRETER) Routine failure.              Fail
---------------------------------------------------------------------------------
--ITP_INTERPRETER_ROOT
--                    root's creation        
--<00000000B70014B4>                         Routine failure.              Exit
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
16, 0, 0, 2, 18, 0, 12, 3, 248, 0, 6, 0, 3, 65, 78, 89, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 66, 79, 
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
101, 114, 16, 0, 1, 0, 215, 0, 0, 0, 6, 4, 183, 187, 26, 84, 20, 130, 0, 215, 0, 0, 0, 1, 0, 0, 0, 5, 4, 183, 
187, 26, 108, 20, 130, 0, 212, 0, 0, 0, 1, 0, 4, 183, 187, 26, 36, 21, 128, 1, 119, 0, 0, 0, 2, 0, 0, 1, 119, 0, 
0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 4, 4, 183, 187, 26, 84, 183, 187, 26, 108, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 4, 183, 187, 26, 0, 22, 0, 1, 137, 0, 0, 0, 2, 0, 0, 1, 137, 0, 0, 0, 0, 0, 0, 0, 
2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 1, 0, 4, 183, 187, 26, 36, 4, 183, 187, 25, 232, 22, 0, 2, 37, 0, 0, 
0, 2, 0, 0, 2, 37, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 4, 183, 187, 26, 0, 4, 183, 207, 127, 188, 1, 128, 1, 119, 
0, 0, 0, 2, 0, 0, 1, 119, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 4, 4, 183, 187, 25, 232>>
            
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

