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
	make

feature{NONE} -- Initialization

	make
			-- Initialization.
		do
		end

feature -- Access

	fault_signature: EPA_TEST_CASE_SIGNATURE
			-- Signature of the fault.
		require
			has_more_fault_signature: has_more_fault_signature
		do
			Result := all_failing_test_case_files_by_signature.key_for_iteration
		end

	failing_test_case_files: DS_ARRAYED_LIST [STRING]
			-- Test case files revealing the fault with `fault_signature'.
		require
			fault_signature_attached: fault_signature /= Void
		local
			l_all_failing: DS_ARRAYED_LIST [STRING]
		do
			l_all_failing := all_failing_test_case_files_by_signature.item_for_iteration
			Result := test_case_file_selection_from_list (l_all_failing, max_failing_test_case_number)
		ensure
			result_attached: Result /= Void
			max_number: max_failing_test_case_number = 0 or else (Result.count <= max_failing_test_case_number)
		end

	passing_test_case_files: DS_ARRAYED_LIST [STRING]
			-- Test case files for passing runs.
		require
			fault_signature_attached: fault_signature /= Void
		do
			Result := test_case_file_selection_from_list (all_passing_test_case_files, max_passing_test_case_number)
		ensure
			result_attached: Result /= Void
			max_number: max_passing_test_case_number = 0 or else (Result.count <= max_passing_test_case_number)
		end

feature -- Status report

	is_using_state_based_test_case_selection: BOOLEAN
			-- Is AutoFix selecting test cases based on the states of objects?
		do
			Result := config.is_using_state_based_test_case_selection
		end

	has_more_fault_signature: BOOLEAN
			-- Has the selector a next fault signature?
		do
			Result := not all_failing_test_case_files_by_signature.off
		end

feature -- Basic operation

	start_with_first_fault
			-- Prepare the result for iteration.
		do
				-- The order may not be the same as the text order.
			all_failing_test_case_files_by_signature.start
		end

	collect_all_test_case_files
			-- Collect all test case files in `test_case_folder'.
			-- Put test case files into `all_passing_test_case_files' and `all_failing_test_case_files_by_signature'.
		local
			l_dir: DIRECTORY
			l_file_name: STRING
		do
			reset

			if config.test_case_file_list /= Void and then not config.test_case_file_list.is_empty then
				collect_all_test_case_files_from_list
			elseif config.test_case_path /= Void and then not config.test_case_path.is_empty then
				collect_all_test_case_files_from_directory
			end
		end

	collect_all_test_case_files_from_directory
			-- Collect all the test case files from `config.test_case_path'.
		local
			l_dir: DIRECTORY
			l_file_name: STRING
			l_full_path: FILE_NAME
		do
			create l_dir.make_open_read (test_case_folder)
			from l_dir.readentry
			until l_dir.lastentry = Void
			loop
				l_file_name := l_dir.lastentry.twin
				if not l_file_name.is_equal (once ".") and then
						not l_file_name.is_equal (once "..") and then
						l_file_name.ends_with (once ".e")
				then
					create l_full_path.make
					l_full_path.set_directory (test_case_folder)
					l_full_path.set_file_name (l_file_name)

					collect_test_case_file (l_full_path)
				end
				l_dir.readentry
			end
		end

	collect_all_test_case_files_from_list
			-- Collect all the test case files from `config.test_case_file_list'.
		require
			test_case_file_list_not_empty: config.test_case_file_list /= Void and then not config.test_case_file_list.is_empty
		local
			l_file_name: FILE_NAME
			l_file: PLAIN_TEXT_FILE
			l_line: STRING
			l_tc_path: STRING
		do
			create l_file_name.make_from_string (config.test_case_file_list)
			check l_file_name.is_valid end
			create l_file.make_open_read (l_file_name)
			if l_file.is_open_read then

				from l_file.read_line
				until l_file.after
				loop
					l_line := l_file.last_string.twin

					if not l_line.starts_with ("--") and l_line.ends_with (".e") then
						collect_test_case_file (l_line)
					end

					l_file.read_line
				end
				l_file.close
			end
		end

	reset
			-- Reset the selector by wiping out all collected test case files.
		do
			all_failing_test_case_files_by_signature.wipe_out
			all_passing_test_case_files.wipe_out
		end

	proceed_to_next_fault_signaure
			-- Proceed the selector to the next fault signature.
		require
			has_more_fault_signature: has_more_fault_signature
		do
			all_failing_test_case_files_by_signature.forth
		end

feature{NONE} -- Access

	all_failing_test_case_files_by_signature: DS_HASH_TABLE [DS_ARRAYED_LIST[STRING], EPA_TEST_CASE_SIGNATURE]
			-- Table of failing test cases, classified by their signatures.
			-- Key: test case signature.
			-- Val: list of test cases with the same signature.
		do
			if all_failing_test_case_files_by_signature_cache = Void then
				create all_failing_test_case_files_by_signature_cache.make (5)
			end
			Result := all_failing_test_case_files_by_signature_cache
		ensure
			result_attached: Result /= Void
		end

	all_passing_test_case_files: DS_ARRAYED_LIST [STRING]
			-- List of passing test case files.
		do
			if all_passing_test_case_files_cache = Void then
				create all_passing_test_case_files_cache.make (30)
			end
			Result := all_passing_test_case_files_cache
		ensure
			result_attached: Result /= Void
		end

	test_case_folder: STRING
			-- Folder storing test cases.
		do
			Result := config.test_case_path
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

	max_passing_test_case_number: INTEGER
			-- Maximum number of passing test cases that will be used for fixing.
			-- A value greater than 0 means no more than this number of passing
			-- 		test cases would be (randomly) selected to build the
			--		fixing project.
			-- A value of 0 means ALL passing test cases would be used for fixing.
			-- Default: 0
		do
			Result := config.max_passing_test_case_number
		end

	max_failing_test_case_number: INTEGER
			-- Maximum number of failing test cases that will be used for fixing.
			-- A value greater than 0 means no more than this number of failing
			-- 		test cases would be (randomly) selected to build the
			--		fixing project.
			-- A value of 0 means ALL failing test cases would be used for fixing.
			-- Default: 0
		do
			Result := config.max_failing_test_case_number
		end


feature{NONE} -- Implementation

	collect_test_case_file (a_file_name: STRING)
			-- Collect a test case file with the name 'a_file_name'.
		local
			l_base_name: STRING
			l_signature: EPA_TEST_CASE_SIGNATURE
			l_list: like all_passing_test_case_files
			l_max_tc_number: INTEGER
		do
			l_base_name := base_eiffel_file_name_from_full_path (a_file_name)
			create l_signature.make_with_string (l_base_name)
			if l_signature.is_failing then
				if all_failing_test_case_files_by_signature.has (l_signature) then
					l_list := all_failing_test_case_files_by_signature.item (l_signature)
				else
					create l_list.make (20)
					all_failing_test_case_files_by_signature.force (l_list, l_signature)
				end
			else
				l_list := all_passing_test_case_files
			end
			l_list.force_last (a_file_name)
		end

	test_case_file_selection_from_list (a_file_list: DS_ARRAYED_LIST [STRING]; a_max_number: INTEGER): DS_ARRAYED_LIST [STRING]
			-- A selection, of at most `a_max_number' number of test case files, from `a_file_list'.
			-- No size constraint for the result list, if `a_max_number' is 0.
			-- Note: all the test cases would not necessarily be selected even if `a_max_number' is 0, if `is_using_state_based_test_case_selection' is enabled.
		require
			file_list_attached: a_file_list /= Void
			max_number_not_negative: a_max_number >= 0
		local
			l_cursor: DS_ARRAYED_LIST_CURSOR [STRING]
			l_file: STRING
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

				if not is_using_state_based_test_case_selection then
					Result.force_last (l_file)
				else
					l_object_states := object_states_from_test_case_file (l_file)
					if is_object_states_new (l_object_states) then
						register_new_object_states (l_object_states)
						Result.force_last (l_file)
					end
				end

				l_cursor.forth
			end
		ensure
			result_attached: Result /= Void
			max_number: a_max_number = 0 or else (Result.count <= a_max_number)
		end

	object_states_from_test_case_file (a_test_case_file: STRING): HASH_TABLE [NATURAL_8, STRING]
			-- Object states observed in `a_test_case_file'.
		local
			l_state_extractor: AFX_TEST_CASE_STATE_EXTRACTOR
			l_file_name: FILE_NAME
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

feature{NONE} -- Cache

	all_failing_test_case_files_by_signature_cache: like all_failing_test_case_files_by_signature
			-- Cache for `all_failing_test_case_files_by_signature'.

	all_passing_test_case_files_cache: like all_passing_test_case_files
			-- Cache for `all_passing_test_case_files'.

	observed_states_cache: like observed_states
			-- Cache for `observed_states'.

invariant

	all_failing_test_case_files_by_signature_attached: all_failing_test_case_files_by_signature /= Void

	all_passing_test_case_files_attached: all_passing_test_case_files /= Void

end
