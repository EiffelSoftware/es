note
	description: "Summary description for {EQA_SERIALIZED_TEST_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EQA_SERIALIZED_TEST_SET

inherit
	EQA_TEST_SET

	EQA_TEST_CASE_SERIALIZATION_UTILITY

feature -- Access

	pre_serialization: ARRAY [NATURAL_8]
			-- Serialization data for objects before the test case execution.
		deferred
		end

	post_serialization: ARRAY [NATURAL_8]
			-- Serialization data for objects after the test case execution.
		deferred
		end

    pre_variable_table: HASH_TABLE [detachable ANY, INTEGER]
    		-- Table of the feature variable and the variables reachable from these variable.
    		-- Key: variable index.
    		-- Value: object.
    	do
    		if pre_variable_table_cache = Void then
    			pre_variable_table_cache := deserialized_variable_table (pre_serialization)
    		end
    		Result := pre_variable_table_cache
    	end

    pre_variable_indexes: STRING
    		-- A string containing comma separated indexes of pre-state variables.
		do
			Result := keys_from_table (pre_variable_table)
    	end

    post_variable_table: HASH_TABLE [detachable ANY, INTEGER]
    		-- Table of the feature variable and the variables reachable from these variable.
    		-- Key: variable index.
    		-- Value: object.
    	do
    		if post_variable_table_cache = Void then
    			post_variable_table_cache := deserialized_variable_table (post_serialization)
    		end
    		Result := post_variable_table_cache
    	end

    post_variable_indexes: STRING
    		-- A string containing comma separated indexes of post-state variables.
		do
			Result := keys_from_table (post_variable_table)
    	end

feature{NONE} -- Implementation

	pre_variable_table_cache: detachable like pre_variable_table
			-- Internal cache for `pre_variable_table'.

	post_variable_table_cache: detachable like post_variable_table
			-- Internal cache for `post_variable_table'.

    deserialized_variable_table (a_serialization: ARRAY [NATURAL_8]): HASH_TABLE [detachable ANY, INTEGER]
            -- Deserialize the objects from 'a_serialization'
            -- (as object of type {SPECIAL [TUPLE [INTEGER, detachable ANY]]})
            -- and store the objects into the Result hashtable.
        local
            l_data: STRING
            l_index: INTEGER
            l_variable_table: HASH_TABLE [detachable ANY, INTEGER]
        do
            l_data := string_from_array (a_serialization)
            if attached {SPECIAL [TUPLE [index: INTEGER; var: detachable ANY]]}deserialized_object (l_data) as lt_variable then
                from
                    create l_variable_table.make (lt_variable.count + 1)
                    l_variable_table.compare_objects
                    l_index := lt_variable.lower
                until
                    l_index > lt_variable.upper
                loop
                    l_variable_table.put (lt_variable[l_index].var, lt_variable[l_index].index)
                    l_index := l_index + 1
                end
            else
                create l_variable_table.make (0)
            end
            Result := l_variable_table
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

feature -- Test case

	generated_test_1
			-- Test routine
		deferred
		end

feature -- Test case information

	tci_class_name: STRING
			-- Name of current class
		deferred
		end

	tci_class_under_test: STRING
			-- Name of the class under test.
		deferred
		end

	tci_feature_under_test: STRING
			-- Name of the feature under test.
		deferred
		end

	tci_is_creation: BOOLEAN
			-- Is the feature under test a creation feature?
		deferred
		end

	tci_is_query: BOOLEAN
			-- Is the feature under test a query?
		deferred
		end

	tci_is_passing: BOOLEAN
			-- Is the test case passing?
		deferred
		end

	tci_exception_code: INTEGER
			-- Exception code. 0 for passing test cases.
		deferred
		end

	tci_assertion_tag: STRING
			-- Tag of the violated assertion, if any.
			-- Empty string for passing test cases.
		deferred
		end

	tci_exception_recipient: STRING
			-- Feature of the exception recipient, same as `tci_feature_under_test' in passing test cases.
		deferred
		end

	tci_exception_recipient_class: STRING
			-- Class of the recipient feature of the exception, same as `tci_class_under_test' in passing test cases.
		deferred
		end

	tci_argument_count: INTEGER
			-- Number of arguments of the feature under test.
		deferred
		end

	tci_operand_table: HASH_TABLE[INTEGER, INTEGER]
			-- key is operand position index (0 means target, 1 means the first argument,
			-- and argument_count + 1 means the result, if any), value is the variable
			-- index of that operand.
		deferred
		end

    tci_exception_trace: STRING
		deferred
		end

feature{NONE} -- Implementation

    keys_from_table (a_tbl: HASH_TABLE [detachable ANY, INTEGER]): STRING
    		-- A string containing comma separated indexes of keys in `a_tbl'
    	local
    		l_tbl: like pre_variable_table
    		l_cursor: CURSOR
    		i: INTEGER
    		l_count: INTEGER
    	do
    		l_tbl := pre_variable_table
    		l_cursor := l_tbl.cursor
    		create Result.make (64)
    		from
    			i := 1
    			l_count := l_tbl.count
    			l_tbl.start
    		until
    			l_tbl.after
    		loop
    			Result.append (l_tbl.key_for_iteration.out)
    			if i < l_count then
    				Result.append_character (',')
    			end
    			l_tbl.forth
    		end
    		l_tbl.go_to (l_cursor)
    	end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
