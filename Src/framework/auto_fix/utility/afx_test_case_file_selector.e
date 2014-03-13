note
	description:
	"[
		A selector to select test cases for use in the fixing process.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_TEST_CASE_FILE_SELECTOR

inherit

	AFX_SHARED_SESSION

	EPA_FILE_UTILITY

	REFACTORING_HELPER

feature -- Access

	failing_test_signatures: DS_LINKED_LIST [EPA_TEST_CASE_SIGNATURE]
			-- All failing test signatures from last collection.

feature -- Test selection

	selected_tests (a_is_from_passings: BOOLEAN; a_criterion: PREDICATE[ANY, TUPLE[EPA_TEST_CASE_SIGNATURE]]): DS_ARRAYED_LIST [PATH]
			--
		require
			a_criterion /= Void
		local
			l_test_cases: DS_HASH_TABLE [DS_ARRAYED_LIST[PATH], EPA_TEST_CASE_SIGNATURE]
			l_test_case_cursor: DS_HASH_TABLE_CURSOR [DS_ARRAYED_LIST[PATH], EPA_TEST_CASE_SIGNATURE]
			l_path_list: DS_ARRAYED_LIST[PATH]
		do
			create Result.make_equal (50)

				-- All test cases satisfying the criterion.
			if a_is_from_passings then
				l_test_cases := shared_test_case_collector.passing_test_cases
			else
				l_test_cases := shared_test_case_collector.failing_test_cases
			end
			from
				l_test_case_cursor := l_test_cases.new_cursor
				l_test_case_cursor.start
			until
				l_test_case_cursor.after
			loop
				if a_criterion.item ([l_test_case_cursor.key]) then
					Result.append_last (l_test_case_cursor.item)
				end
				l_test_case_cursor.forth
			end

				-- Selection
			if a_is_from_passings then
				Result := test_case_file_selection_from_list (Result, max_passing_test_case_number)
			else
				Result := test_case_file_selection_from_list (Result, max_failing_test_case_number)
			end
		end

feature -- Status report

	should_select_randomly: BOOLEAN assign use_random_selection
			-- Test case files should be randomly selected from all the available ones.

	should_select_based_on_states: BOOLEAN assign use_state_based_selection
			-- Test case files should be selected if their object states are unique.

	max_passing_test_case_number: NATURAL assign set_max_passing_test_case_number
			-- Maximum number of passing test cases that will be selected.

	max_failing_test_case_number: NATURAL assign set_max_failing_test_case_number
			-- Maximum number of failing test cases that will be selected.

feature -- Status set

	use_state_based_selection (a_flag: BOOLEAN)
		do
			should_select_based_on_states := a_flag
		end

	use_random_selection (a_flag: BOOLEAN)
		do
			should_select_randomly := a_flag
		end

	set_max_passing_test_case_number (a_number: NATURAL)
		do
			max_passing_test_case_number := a_number
		end

	set_max_failing_test_case_number (a_number: NATURAL)
		do
			max_failing_test_case_number := a_number
		end

feature -- Basic operation

	collect_test_cases (a_test_case_dir, a_test_case_file_list: STRING)
			-- Collect test cases from 'a_test_case_dir' or listed in 'a_test_case_file_list'.
		local
			l_file_names: LINKED_LIST [PATH]
			l_file_name: PATH
			l_file: PLAIN_TEXT_FILE
			l_line: STRING
		do
			create failing_test_signatures.make_equal

			create l_file_names.make
			if a_test_case_file_list /= Void and then not a_test_case_file_list.is_empty then
				create l_file_name.make_from_string (a_test_case_file_list)
				create l_file.make_with_path (l_file_name)
				l_file.open_read
				if l_file.is_open_read then
					from l_file.read_line
					until l_file.after
					loop
						l_line := l_file.last_string.twin
						if not l_line.starts_with_general ("--") and l_line.ends_with_general (".e") then
							l_file_names.extend (create {PATH}.make_from_string (l_line))
						end
						l_file.read_line
					end
					l_file.close
				end
			end

			if a_test_case_dir /= Void and then not a_test_case_dir.is_empty then
				l_file_names.extend (create {PATH}.make_from_string (a_test_case_dir))
			end

			shared_test_case_collector.collect_all (l_file_names, True)

			failing_test_signatures.append_first (shared_test_case_collector.failing_test_cases.keys)
		end

	test_case_file_selection_from_list (a_file_list: DS_ARRAYED_LIST [PATH]; a_max_number: NATURAL): DS_ARRAYED_LIST [PATH]
			-- A selection, of at most `a_max_number' number of test case files, from `a_file_list'.
			-- No size constraint for the result list, if `a_max_number' is 0.
			-- Note: all the test cases would not necessarily be selected even if `a_max_number' is 0, if `is_using_state_based_test_case_selection' is enabled.
		require
			file_list_attached: a_file_list /= Void
			max_number_not_negative: a_max_number >= 0
		local
			l_index, l_count, l_max_count, l_pos, l_value: INTEGER
			l_random: RANDOM
			l_check_order, l_original_order: DS_ARRAYED_LIST [INTEGER]
			l_cursor: DS_ARRAYED_LIST_CURSOR [PATH]
			l_file: PATH
			l_object_states: HASH_TABLE [NATURAL_8, STRING]
			l_reg: RX_PCRE_REGULAR_EXPRESSION
		do
				-- Maximum number of files to select.
			if a_max_number <= 0 then
				l_count := a_file_list.count
			else
				l_count := a_max_number.to_integer_32.min (a_file_list.count)
			end
			l_max_count := a_file_list.count
			create Result.make (l_count)

				-- The natural order in which test cases will be examined.
			create l_check_order.make (a_file_list.count)
			from l_index := 1
			until l_index > a_file_list.count
			loop
				l_check_order.force_last (l_index)
				l_index := l_index + 1
			end

				-- Randomize the order
			if should_select_randomly then
				from
					l_original_order := l_check_order
					create l_check_order.make (l_count)
					create l_random.set_seed ((create {TIME}.make_now).seconds)
					l_random.start
				until
					l_original_order.is_empty
				loop
					l_random.forth
						-- Randomly select a test from `l_original_order', which contains only unselected tests.
					l_pos := (l_random.real_item * 10000).truncated_to_integer \\ l_original_order.count + 1
					l_check_order.force_last (l_original_order.item (l_pos))	-- Take the selected test
					l_original_order.replace (l_original_order.last, l_pos)		-- Replace the selected test with the last
					l_original_order.remove (l_pos)								-- Remove the last
				end
			end

				-- Wipe out observed states for state based test case selection.
			observed_states.wipe_out

				-- Add files to the result list, if appropriate.
			from
				l_index := 1
			until
				l_index > l_check_order.count or else Result.count = l_count
			loop
				l_file := a_file_list.item (l_check_order.item (l_index))

				if config.is_using_state_based_test_case_selection then
					l_object_states := object_states_from_test_case_file (l_file)
					if is_object_states_new (l_object_states) then
						register_new_object_states (l_object_states)
						Result.force_last (l_file)
					end
				else
					Result.force_last (l_file)
				end

				l_index := l_index + 1
			end
		ensure
			result_attached: Result /= Void
			max_number: a_max_number = 0 or else (Result.count <= a_max_number.to_integer_32)
		end

feature{NONE} -- Implementation

	observed_states: DS_HASH_TABLE [NATURAL_8, STRING]
			-- Object states that have been observed.
			-- Key is predicate name,
			-- Value is the value of that predicate.
			-- The predicate name is prefixed with the object index. For example,
			-- a predicate `is_empty' in the first object is renamed as "v1_is_empty".
		do
			if observed_states_cache = Void then
				create observed_states_cache.make_equal (30)
			end
			Result := observed_states_cache
		ensure
			result_attached: Result /= Void
		end

	object_states_from_test_case_file (a_test_case_file: PATH): HASH_TABLE [NATURAL_8, STRING]
			-- Object states observed in `a_test_case_file'.
		local
			l_state_extractor: AFX_TEST_CASE_STATE_EXTRACTOR
		do
			create l_state_extractor.make (a_test_case_file)
			Result := l_state_extractor.states
		end

	is_object_states_new (a_states: HASH_TABLE [NATURAL_8, STRING]): BOOLEAN
			-- Is `a_states' containing new information?
		local
			l_expr: STRING
			l_value: NATURAL_8
			l_found_value: NATURAL_8
			l_observed_states: like observed_states
		do
			from
				l_observed_states := observed_states
				a_states.start
			until
				a_states.after or else Result
			loop
				l_expr := a_states.key_for_iteration
				l_value := a_states.item_for_iteration

				l_observed_states.search (l_expr)
				if l_observed_states.found then
					l_found_value := l_observed_states.found_item
					if l_found_value.bit_or (l_value) /= l_found_value then
						Result := True
					end
				else
					Result := True
				end

				a_states.forth
			end
		end

	register_new_object_states (a_states: HASH_TABLE [NATURAL_8, STRING])
			-- Register `a_states' at `observed_states'.
		require
			is_new_states: is_object_states_new (a_states)
		local
			l_expr: STRING
			l_value: NATURAL_8
			l_found_value: NATURAL_8
			l_observed_states: like observed_states
		do
			from
				l_observed_states := observed_states
				a_states.start
			until
				a_states.after
			loop
				l_expr := a_states.key_for_iteration
				l_value := a_states.item_for_iteration

				l_observed_states.search (l_expr)
				if l_observed_states.found then
					l_found_value := l_observed_states.found_item
					if l_found_value.bit_or (l_value) /= l_found_value then
						l_observed_states.force (l_found_value.bit_or (l_value), l_expr)
					end
				else
					l_observed_states.force (l_value, l_expr)
				end

				a_states.forth
			end
		end

feature -- Shared object

	shared_test_case_collector: AUT_TEST_CASE_COLLECTOR
			-- Shared test case collecotr.
		once
			create Result.make
		end

feature{NONE} -- Cache

	observed_states_cache: like observed_states
			-- Cache for `observed_states'.


end
