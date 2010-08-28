note
	description: "Summary description for {EQA_SERIALIZED_TEST_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EQA_SERIALIZED_TEST_SET

inherit
	EQA_TEST_SET
		redefine
			default_create
		end

	EQA_TEST_CASE_SERIALIZATION_UTILITY
		undefine

			default_create
		end

feature{NONE} -- Initialization

	default_create
			-- Initialize Current.
		do
			create environment
		end

feature -- Access

	pre_serialization: ARRAY [NATURAL_8]
			-- Serialization data for objects before the test case execution.
		deferred
		end

	pre_serialization_as_string: STRING
			-- String representation of `pre_serialization'
			-- Format: comma separated ASCII numbers
		do
			if attached {ARRAY [NATURAL_8]} pre_serialization as l_data then
				Result := array_as_string (l_data)
			else
				create Result.make_empty
			end
		end

	post_serialization: ARRAY [NATURAL_8]
			-- Serialization data for objects after the test case execution.
		deferred
		end

	post_serialization_as_string: STRING
			-- String representation of `post_serialization'
			-- Format: comma separated ASCII numbers
		do
			if attached {ARRAY [NATURAL_8]} post_serialization as l_data then
				Result := array_as_string (l_data)
			else
				create Result.make_empty
			end
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

feature -- Status report

	is_post_state_information_enabled: BOOLEAN
			-- Is information about objects in post-state enabled?

feature -- Basic operation

	setup_before_test
			-- Setup before executing the test case.
		do
		end

	cleanup_after_test
			-- Cleanup after executing the test case.
		do
		end

	finish_post_state_calculation
			-- Finish post state calculation
		do
		end

	set_is_post_state_information_enabled (b: BOOLEAN)
			-- Set `is_post_state_information_enabled' with `b'.
		do
			is_post_state_information_enabled := b
		ensure
			is_post_state_information_enabled_set: is_post_state_information_enabled = b
		end

feature{NONE} -- Implementation

	pre_variable_table_cache: detachable like pre_variable_table
			-- Internal cache for `pre_variable_table'.

	post_variable_table_cache: detachable like post_variable_table
			-- Internal cache for `post_variable_table'.

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

	tci_operand_table: HASH_TABLE [INTEGER, INTEGER]
			-- key is operand position index (0 means target, 1 means the first argument,
			-- and argument_count + 1 means the result, if any), value is the variable
			-- index of that operand.
		deferred
		end

	tci_operand_table_as_string: STRING
			-- String representation of `tci_operand_table'
			-- Format: Comma separated numbers.
			-- For every number pair, the first number is key, the second number is value.
		local
			l_cursor: CURSOR
		do
			create Result.make (128)
			l_cursor := tci_operand_table.cursor
			from
				tci_operand_table.start
			until
				tci_operand_table.after
			loop
				if not Result.is_empty then
					Result.append_character (',')
				end
				Result.append (tci_operand_table.key_for_iteration.out)
				Result.append_character (',')
				Result.append (tci_operand_table.item_for_iteration.out)
				tci_operand_table.forth
			end
			tci_operand_table.go_to (l_cursor)
		end

	tci_operand_variable_indexes: STRING
			-- Comma separated indexes of operands of the feature under test
		local
			l_tbl: HASH_TABLE [INTEGER, INTEGER]
			l_otbl: like tci_operand_table
			i: INTEGER
			c: INTEGER
		do
			l_otbl := tci_operand_table
			create l_tbl.make (tci_operand_table.count)
			create Result.make (32)

			c := tci_argument_count
			if tci_is_query then
				c := c + 1
			end

			from
				i := 0
			until
				i > c
			loop
				Result.append (l_otbl.item (i).out)
				if i < c then
					Result.append_character (',')
				end
				i := i + 1
			end
		end

    tci_exception_trace: STRING
		deferred
		end

feature{NONE} -- Implementation

	ascii_string_as_array (a_string: STRING): ARRAY [NATURAL_8]
			-- Array storing the ascii code for each character in `a_string'
		local
			l_count: INTEGER
			i: INTEGER
		do
			l_count := a_string.count
			create Result.make (1, l_count)
			from
				i := 1
			until
				i > l_count
			loop
				Result.put (a_string.item (i).code.to_natural_8, i)
				i := i + 1
			end
		end

	array_as_string (a_array: ARRAY [NATURAL_8]): STRING
			-- String representation of `a_array'
			-- Format: comma separated numbers
		local
			i: INTEGER
			u: INTEGER
		do
			create Result.make (a_array.count * 4 + 1)
			from
				i := a_array.lower
				u := a_array.upper
			until
				i > u
			loop
				Result.append (a_array.item (i).out)
				if i < u then
					Result.append_character (',')
				end
				i := i + 1
			end
		end

	special_from_tuple (a_tuple: TUPLE): SPECIAL [detachable ANY]
			-- Special from `a_tuple'
		local
			l_count: INTEGER
			i: INTEGER
		do
			l_count := a_tuple.count
			create Result.make_filled (Void, l_count)
			from
				i := 1
			until
				i > l_count
			loop
				Result.put (a_tuple.item (i), i - 1)
				i := i + 1
			end
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
