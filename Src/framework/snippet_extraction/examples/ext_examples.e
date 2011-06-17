note
	description : "Basic mining examples."
	date        : "$Date$"
	revision    : "$Revision$"

class
	EXT_EXAMPLES

create
	make

feature {NONE} -- Initialization

	make
			-- Default initialization
		do
		end

feature -- Loop Iteration Samples

	loop_iteratation_simple_001 (a_sample_list: LINKED_LIST [STRING]): STRING
		require
			a_sample_list_attached: attached a_sample_list
		do
			from
				create Result.make_empty
				a_sample_list.start
			until
				a_sample_list.after
			loop
				Result.append (a_sample_list.item)
				Result.append (";")

				a_sample_list.forth
			end
		end

	process_loop_iteration_simple_002 (a_item: STRING): STRING
			-- Dummy feature that takes any string and return it concatenated with a semi-colon.
		do
			create Result.make_from_string (a_item)
			Result.append (";")
		end

	loop_iteratation_simple_002 (a_sample_list: LINKED_LIST [STRING]): STRING
		require
			a_sample_list_attached: attached a_sample_list
		do
			from
				create Result.make_empty
				a_sample_list.start
			until
				a_sample_list.after
			loop
				Result.append (process_loop_iteration_simple_002 (a_sample_list.item))
				a_sample_list.forth
			end
		end

	process_loop_iteration_simple_003 (a_item: STRING)
			-- Dummy feature that takes any argument and does nothing.
		do
		end

	loop_iteratation_simple_003 (a_sample_list: LINKED_LIST [STRING])
		require
			a_sample_list_attached: attached a_sample_list
		do
			from
				a_sample_list.start
			until
				a_sample_list.after
			loop
				process_loop_iteration_simple_003 (a_sample_list.item)
				a_sample_list.forth
			end
		end

	loop_iteratation_simple_004 (a_sample_list: LINKED_LIST [STRING])
		require
			a_sample_list_attached: attached a_sample_list
		do
			from
				a_sample_list.start
			until
				a_sample_list.after
			loop
				Current.process_loop_iteration_simple_003 (a_sample_list.item)
				a_sample_list.forth
			end
		end

	loop_iteration_stop_variable_001
			-- Interface variable example: loop with stop variable from type {BOOLEAN}
			-- Interface variables: l_done
		local
			l_sample_list: LINKED_LIST [STRING]
			l_done: BOOLEAN
			l_string: STRING
		do
			from
				l_done := False
				l_sample_list.start
			until
				l_sample_list.after or l_done
			loop
				create l_string.make_from_string ("REMOVE ME")

				if process_loop_iteration_stop (l_sample_list.item) then
					l_done := True
				else
					l_string.append (", NOW!")
				end

				io.put_string (l_string)

				l_sample_list.forth
			end
		end

	loop_iteration_stop_variable_002 (a_sample_list: LINKED_LIST [STRING])
			-- Example: loop with stop variable from type {BOOLEAN}
			-- Interface variables: l_done
		local
			l_done: BOOLEAN
		do
			from
				l_done := False
				a_sample_list.start
			until
				a_sample_list.after or l_done
			loop
				if process_loop_iteration_stop (a_sample_list.item) then
					l_done := True
				end
				a_sample_list.forth
			end
		end

	process_loop_iteration_stop (a_item: STRING): BOOLEAN
			-- Dummy feature that takes any argument and does nothing.
		do
		end

	loop_iteration_stop_variable_003 (a_sample_list: LINKED_LIST [STRING])
			-- Example: loop with stop variable from type {BOOLEAN}
			-- Interface variables: l_done
		local
			l_done: BOOLEAN
		do
			from
				l_done := False
				a_sample_list.start
			until
				a_sample_list.after or l_done
			loop
				l_done := process_loop_iteration_stop (a_sample_list.item)
				a_sample_list.forth
			end
		end

	loop_iteration_stop_variable_004
			-- Interface variable example: loop with stop variable from type {BOOLEAN}
			-- Interface variables: l_done
		local
			l_sample_list: LINKED_LIST [STRING]
			l_done: BOOLEAN
		do
			from
				l_done := False
				l_sample_list.start
			until
				l_sample_list.after or l_done
			loop
				if process_loop_iteration_stop (l_sample_list.item) then
					l_done := True
				end
				l_sample_list.forth
			end
		end

	loop_iteration_stop_variable_005: STRING
			-- Interface variable example: loop with stop variable from type {ANY}
			-- Interface variables: Result
		local
			l_sample_list: LINKED_LIST [STRING]
		do
			from
				l_sample_list.start
			until
				l_sample_list.after or Result /= Void
			loop
				if not l_sample_list.item.is_empty then
					Result := l_sample_list.item
				end
				l_sample_list.forth
			end
		end

	loop_iteration_stop_variable_006: STRING
			-- Interface variable example: loop with stop variable from type {ANY}
			-- Interface variables: Result
		local
			l_sample_list: LINKED_LIST [STRING]
		do
			from
				l_sample_list.start
			until
				l_sample_list.after or Result /= Void
			loop
				if not process_loop_iteration_stop (l_sample_list.item) then
					Result := l_sample_list.item
				end
				l_sample_list.forth
			end
		end

feature -- Conditional Examples

	conditional_object_test_interface_variable_001 (a_string: STRING)
			-- Interface variable example: if statement with string interface variable (valid)
			-- Interface variables: a_string
		local
			l_sample_list: LINKED_LIST [STRING]
		do
			create l_sample_list.make

			if attached a_string then
				l_sample_list.extend (a_string)
			end
		end

	conditional_object_test_interface_variable_002 (a_string: STRING)
			-- Interface variable example: if statement with string interface variable (valid)
			-- Interface variables: a_string
		local
			l_sample_list: LINKED_LIST [STRING]
		do
			create l_sample_list.make

			if attached a_string as l_string then
				l_sample_list.extend (l_string)
			end
		end


	conditional_neg_feature_call_001 (a_string: STRING)
			-- Interface variable example: if statement with string interface variable (invalid)
		require
			a_string_not_void: a_string /= Void
		local
			l_sample_list: LINKED_LIST [STRING]
		do
			create l_sample_list.make

			if not a_string.is_empty then
				l_sample_list.extend (a_string)
			end
		end

	conditional_object_test_chaining_001 (a_string: STRING)
			-- Interface variable example: if statement with string interface variable (invalid)
		local
			l_sample_list: LINKED_LIST [STRING]
		do
			create l_sample_list.make

			if attached a_string and then a_string.is_empty then
				l_sample_list.extend (a_string)
			end
		end

feature -- Inspect Examples

	inspect_single_interface_variable_001
			-- Interface variable example: inspect statement
			-- Interface variables: l_option
		local
			l_sample_list: LINKED_LIST [STRING]
			l_option: INTEGER
		do
			create l_sample_list.make

			l_option := 1

			inspect
				l_option
			when 1 then
				l_sample_list.force ("one")
			when 2 then
				l_sample_list.force ("two")
			else
				l_sample_list.force ("...")
			end
		end

	inspect_without_variable_of_interest
			-- Inspect statement without mentioning a target variable.
		local
			l_sample_list: LINKED_LIST [STRING]
			l_option: INTEGER
		do
			create l_sample_list.make
			l_sample_list.wipe_out

			l_option := 1

			inspect
				l_option
			when 1 then
				io.put_integer (1)
			when 2 then
				io.put_integer (2)
			else
				io.put_character ('?')
			end
		end

	inspect_with_target_in_when_branch
			-- Inspect statement mentioning a target variable in only one 'when' path.
		local
			l_sample_list: LINKED_LIST [STRING]
			l_option: INTEGER
		do
			create l_sample_list.make
			l_sample_list.wipe_out

			l_option := 1

			inspect
				l_option
			when 1 then
				l_sample_list.force ("1")
			when 2 then
				io.put_integer (2)
			else
				io.put_character ('?')
			end
		end

	inspect_with_target_in_else_branch
			-- Inspect statement mentioning a target variable in only the 'else' path.
		local
			l_sample_list: LINKED_LIST [STRING]
			l_option: INTEGER
		do
			create l_sample_list.make
			l_sample_list.wipe_out

			l_option := 1

			inspect
				l_option
			when 1 then
				io.put_integer (1)
			when 2 then
				io.put_integer (2)
			else
				l_sample_list.force ("?")
			end
		end

	inspect_with_target_in_condition
			-- Inspect statement mentioning a target variable in only the 'else' path.
		local
			l_sample_list: LINKED_LIST [STRING]
			l_option: INTEGER
		do
			create l_sample_list.make
			l_sample_list.wipe_out

			l_option := 1

			inspect
				l_sample_list.count
			when 1 then
				io.put_integer (1)
			when 2 then
				io.put_integer (2)
			else
				io.put_character('?')
			end
		end

feature -- Object Test Examples

	object_test_as_different_as1 (a_sample_list1, a_sample_list2: LINKED_LIST [ANY])
		do
			if attached {STRING} a_sample_list1.item_for_iteration as l_sample_string1 then
				io.put_string (l_sample_string1)
			end

			if attached {STRING} a_sample_list2.item_for_iteration as l_sample_string2 then
				io.put_string (l_sample_string2)
			end
		end

	object_test_as_different_as2 (a_sample_list: LINKED_LIST [ANY])
		do
			if attached {STRING} a_sample_list.item_for_iteration as l_sample_string1 then
				io.put_string (l_sample_string1)
			end

			if attached {STRING} a_sample_list.item_for_iteration as l_sample_string2 then
				io.put_string (l_sample_string2)
			end
		end

	object_test_as_identical_as1 (a_sample_list1, a_sample_list2: LINKED_LIST [ANY])
		do
			if attached {STRING} a_sample_list1.item_for_iteration as l_sample_string then
				io.put_string (l_sample_string)
			end

			if attached {STRING} a_sample_list2.item_for_iteration as l_sample_string then
				io.put_string (l_sample_string)
			end
		end

	object_test_as_identical_as2 (a_sample_list: LINKED_LIST [ANY])
		do
			if attached {STRING} a_sample_list.item_for_iteration as l_sample_string then
				io.put_string (l_sample_string)
			end

			if attached {STRING} a_sample_list.item_for_iteration as l_sample_string then
				io.put_string (l_sample_string)
			end
		end

--	object_test_as_indentical_nested (a_sample_list: LINKED_LIST [ANY])
--		do
--			if attached {STRING} a_sample_list.item_for_iteration as l_sample_string then
--				if attached {STRING} a_sample_list.item_for_iteration as l_sample_string then
--					io.put_string (l_sample_string)
--				end
--			end
--		end

	object_test_as_complex (a_sample_list: LINKED_LIST [STRING]; a_sample_table: HASH_TABLE [ANY, STRING])
		do
			if attached {STRING} a_sample_table.at (a_sample_list.item_for_iteration) as l_sample_string then
				io.put_string (l_sample_string)
			end
		end

	object_test_as_strange (a_sample_list: LINKED_LIST [STRING]): BOOLEAN
		do
			check attached a_sample_list as l_sample_list and then not l_sample_list.is_empty end

			if attached a_sample_list as l_sample_list1 and attached a_sample_list as l_sample_list2 then
				l_sample_list1.start
				l_sample_list2.start
			end

			Result := attached a_sample_list as l_sample_list
		end

feature {NONE} -- Feature Chaining

	feature_chaining_target_item (a_sample_list: LINKED_LIST [STRING]): BOOLEAN
		do
			a_sample_list.item.append ("one")
			a_sample_list.item.append ("two")
		end

	feature_chaining_class_feature: LINKED_SET [STRING]

	feature_chaining_class_feature_item (a_sample_list: LINKED_LIST [STRING]): BOOLEAN
		do
			feature_chaining_class_feature.item.append (a_sample_list.item)
			feature_chaining_class_feature.item.append (a_sample_list.item)
		end

feature {NONE} -- Data Types

	different_data_types (a_sample_list1: LINKED_LIST [STRING]; a_sample_list2: LINKED_LIST [INTEGER]): BOOLEAN
		do
			a_sample_list1.force ("one")
			a_sample_list1.force ("two")

			a_sample_list2.force (1)
			a_sample_list2.force (2)
		end

end
