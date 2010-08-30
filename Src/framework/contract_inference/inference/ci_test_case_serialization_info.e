note
	description: "Class to store serialization data for a test case"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_TEST_CASE_SERIALIZATION_INFO

inherit
	EPA_TYPE_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_tc_info: like test_case_info; a_pre_serialization: STRING; a_post_serialization: STRING; a_operand_table: STRING; a_pre_objects: STRING; a_post_objects: STRING)
			-- Initialize Current.
		do
			test_case_info := a_tc_info
			pre_serialization := array_from_string (a_pre_serialization)
			post_serialization := array_from_string (a_post_serialization)
			operand_table := operand_table_from_string (a_operand_table)
			pre_object_type_table := type_table_from_string (a_pre_objects)
			post_object_type_table := type_table_from_string (a_post_objects)
		end

feature -- Access

	test_case_info: CI_TEST_CASE_INFO
			-- Test case information

	pre_serialization: ARRAY [NATURAL_8]
			-- Serialized objects in prestate

	post_serialization: ARRAY [NATURAL_8]
			-- Serialized objects in poststate

	operand_table: HASH_TABLE [INTEGER, INTEGER]
			-- Operand table
			-- key is operand position index (0 means target, 1 means the first argument,
			-- and argument_count + 1 means the result, if any), value is the variable
			-- index of that operand.

	pre_object_type_table: HASH_TABLE [TYPE_A, INTEGER]
			-- Table from object id to the type of that object, in pre-state
			-- Key is object id, value is the type of that object.

	post_object_type_table: HASH_TABLE [TYPE_A, INTEGER]
			-- Table from object id to the type of that object, in post-state
			-- Key is object id, value is the type of that object.			

feature{NONE} -- Implementation

	array_from_string (a_string: STRING): ARRAY [NATURAL_8]
			-- Array from `a_string'
			-- Format of `a_string': comma separated numbers (0~255).
		local
			l_index1, l_index2: INTEGER
			l_done: BOOLEAN
			l_list: LINKED_LIST [NATURAL_8]
		do
			create l_list.make
			from
				l_index1 := 1
			until
				l_done
			loop
				l_index2 := a_string.index_of (',', l_index1 + 1)
				if l_index2 = 0 then
					l_index2 := a_string.count + 1
					l_done := True
				end
				l_list.extend (a_string.substring (l_index1, l_index2 - 1).to_natural_8)
				l_index1 := l_index2 + 1
			end

			create Result.make_filled (0, 1, l_list.count)
			l_index1 := 1
			across l_list as l_numbers loop
				Result.put (l_numbers.item, l_index1)
				l_index1 := l_index1 + 1
			end
		end

	operand_table_from_string (a_string: STRING): like operand_table
			-- Operand table from `a_string'
		local
			l_parts: LIST [STRING]
			l_key, l_value: INTEGER
		do
			l_parts := a_string.split (',')
			create operand_table.make (l_parts.count // 2)
			from
				l_parts.start
			until
				l_parts.after
			loop
				l_key := l_parts.item_for_iteration.to_integer
				l_parts.forth
				l_value := l_parts.item_for_iteration.to_integer
				l_parts.forth
				operand_table.force (l_value, l_key)
			end
		end

	type_table_from_string (a_string: STRING): HASH_TABLE [TYPE_A, INTEGER]
			-- Type table from `a_string'
		local
			l_parts: LIST [STRING]
			l_context_class: CLASS_C
			l_type_name: STRING
			l_object_id: INTEGER
		do
			l_context_class := test_case_info.test_case_class
			l_parts := a_string.split (',')
			create Result.make (l_parts.count // 2)

			from
				l_parts.start
			until
				l_parts.after
			loop
				l_type_name := l_parts.item_for_iteration
				l_parts.forth
				l_object_id := l_parts.item_for_iteration.to_integer
				l_parts.forth
				Result.force (type_a_from_string (l_type_name, l_context_class), l_object_id)
			end
		end

end
