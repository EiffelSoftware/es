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

create
	default_create

feature -- Access

	fault_signature: EPA_TEST_CASE_SIGNATURE
			-- Signature of the fault to fix.
		do
			if fault_signature_cache = Void then
				if not shared_test_case_collector.failing_test_cases.is_empty then
					fault_signature_cache := shared_test_case_collector.failing_test_cases.keys.first
				end
			end
			Result := fault_signature_cache
		end

	failing_test_case_files: DS_ARRAYED_LIST [PATH]
			-- Failing test case files related with `fault_signature'.
		require
			fault_signature_attached: fault_signature /= Void
		do
			if failing_test_case_files_cache = Void then
				check shared_test_case_collector.failing_test_cases.has (fault_signature) end
				failing_test_case_files_cache := shared_test_case_collector.failing_test_cases.item (fault_signature)
				failing_test_case_files_cache := test_case_file_selection_from_list (failing_test_case_files_cache, max_failing_test_case_number)
			end
			Result := failing_test_case_files_cache
		ensure
			result_attached: Result /= Void
			max_number: max_failing_test_case_number = 0 or else (Result.count <= max_failing_test_case_number)
		end

	passing_test_case_files: DS_ARRAYED_LIST [PATH]
			-- Passing test case files testing the same feature as `fault_signature' does.
		require
			fault_signature_attached: fault_signature /= Void
		local
			l_passing_test_cases_by_feature_under_test: DS_HASH_TABLE [DS_ARRAYED_LIST [PATH], STRING_8]
			l_class_and_feature_under_test: STRING
		do
			if passing_test_case_files_cache = Void then
				l_passing_test_cases_by_feature_under_test := shared_test_case_collector.passing_test_cases_by_feature_under_test
				l_class_and_feature_under_test := fault_signature.class_and_feature_under_test
				if l_passing_test_cases_by_feature_under_test.has (l_class_and_feature_under_test) then
					passing_test_case_files_cache := l_passing_test_cases_by_feature_under_test.item (l_class_and_feature_under_test)
					passing_test_case_files_cache := test_case_file_selection_from_list (passing_test_case_files_cache, max_passing_test_case_number)
				else
					create passing_test_case_files_cache.make_equal (1)
				end
			end
			Result := passing_test_case_files_cache
		ensure
			result_attached: Result /= Void
			max_number: max_passing_test_case_number = 0 or else (Result.count <= max_passing_test_case_number)
		end

feature -- Basic operation

	select_fault_and_test_cases
			-- Select the first fault and the related test cases, as specified by `config'.
		local
			l_file_names: LINKED_LIST [PATH]
			l_file_name: PATH
			l_file: PLAIN_TEXT_FILE
			l_line: STRING
		do
			reset

			create l_file_names.make
				-- Collect file names into `l_file_names'.
			if config.test_case_file_list /= Void and then not config.test_case_file_list.is_empty then
				create l_file_name.make_from_string (config.test_case_file_list)
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
			elseif config.test_case_path /= Void and then not config.test_case_path.is_empty then
				l_file_names.extend (create {PATH}.make_from_string (config.test_case_path))
			end

			shared_test_case_collector.collect_all (l_file_names, True)
		end

feature{NONE} -- Implementation

	reset
			-- Reset the selector by wiping out all collected test case files.
		do
			fault_signature_cache := Void
			failing_test_case_files_cache := Void
			passing_test_case_files_cache := Void
		end

	max_passing_test_case_number: INTEGER
			-- Maximum number of passing test cases that will be used for fixing.
		do
			Result := config.max_passing_test_case_number
		end

	max_failing_test_case_number: INTEGER
			-- Maximum number of failing test cases that will be used for fixing.
		do
			Result := config.max_failing_test_case_number
		end

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

	test_case_file_selection_from_list (a_file_list: DS_ARRAYED_LIST [PATH]; a_max_number: INTEGER): DS_ARRAYED_LIST [PATH]
			-- A selection, of at most `a_max_number' number of test case files, from `a_file_list'.
			-- No size constraint for the result list, if `a_max_number' is 0.
			-- Note: all the test cases would not necessarily be selected even if `a_max_number' is 0, if `is_using_state_based_test_case_selection' is enabled.
		require
			file_list_attached: a_file_list /= Void
			max_number_not_negative: a_max_number >= 0
		local
			l_cursor: DS_ARRAYED_LIST_CURSOR [PATH]
			l_file: PATH
			l_count: INTEGER
			l_object_states: HASH_TABLE [NATURAL_8, STRING]
			l_reg: RX_PCRE_REGULAR_EXPRESSION
		do
				-- Maximum number of files to select.
			if a_max_number = 0 then
				l_count := a_file_list.count
			else
				l_count := a_max_number
			end
			create Result.make (l_count)

				-- Wipe out observed states for state based test case selection.
			observed_states.wipe_out

				-- Add files to the result list, if appropriate.
			l_cursor := a_file_list.new_cursor
			from l_cursor.start
			until l_cursor.after or else Result.count = l_count
			loop
				l_file := l_cursor.item

				if config.is_using_state_based_test_case_selection then
					l_object_states := object_states_from_test_case_file (l_file)
					if is_object_states_new (l_object_states) then
						register_new_object_states (l_object_states)
						Result.force_last (l_file)
					end
				else
					Result.force_last (l_file)
				end

				l_cursor.forth
			end
		ensure
			result_attached: Result /= Void
			max_number: a_max_number = 0 or else (Result.count <= a_max_number)
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

	fault_signature_cache: like fault_signature
			-- Cache for `fault_signature'.

	failing_test_case_files_cache: like failing_test_case_files
			-- Cache for `failing_test_case_files'.

	passing_test_case_files_cache: like passing_test_case_files
			-- Cache for `passing_test_case_files'.

	observed_states_cache: like observed_states
			-- Cache for `observed_states'.


end
