note
	description: "Summary description for {AFX_FIXING_PROJECT_ROOT_BUILDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIXING_PROJECT_ROOT_BUILDER

inherit
	AFX_UTILITY
		undefine
			system
		end

	AFX_SHARED_PROJECT_ROOT_INFO

	AFX_SHARED_SESSION

	EPA_ARGUMENTLESS_PRIMITIVE_FEATURE_FINDER
		undefine
			system
		end

	EPA_FILE_UTILITY

	EQA_TEST_EXECUTION_MODE

	REFACTORING_HELPER

create
	make_with_test_cases

feature{NONE} -- Initialization

	make_with_test_cases (a_system: like system; a_failing_test_cases, a_passing_test_cases: DS_ARRAYED_LIST [STRING];
					a_fault_signature: EPA_TEST_CASE_SIGNATURE)
			-- Initialization.
		do
			system := a_system
			current_failing_test_cases := a_failing_test_cases
			current_passing_test_cases := a_passing_test_cases
			current_fault_signature := a_fault_signature
		end

feature -- Access

	system: SYSTEM_I
			-- System under which test cases are analyzed

	current_fault_signature: EPA_TEST_CASE_SIGNATURE
			-- Signature of the fault under fix.

	current_failing_test_cases: DS_ARRAYED_LIST [STRING]
			-- List of failing test case files for fixing.

	current_passing_test_cases: DS_ARRAYED_LIST [STRING]
			-- List of passing test case files for fixing.

	last_class_text: detachable STRING
			-- Class text from last building.

	test_cases: LINKED_LIST [TUPLE [agent_name: STRING; uuid: STRING]]
			-- List of test cases. `agent_name' is the name of an agent to invoke a test case,
			-- `uuid' is the universal identifier for that test case.

feature -- Basic operation

	build
			-- Build the class text for the root class in `system'.
			-- The class text is available in `last_class_text'.
		local
			l_root_class_name: STRING
			l_executor: STRING
		do
			l_root_class_name := afx_project_root_class
			create test_cases.make

			create l_executor.make (4096 * 4)
				-- Note that one failing test case is added TWICE to the executor.
				-- The first execution is to reproduce the failure, and the second for dynamic analysis.
			append_test_to_executor (l_executor, current_failing_test_cases.first, current_fault_signature, False, Mode_execute)
			current_failing_test_cases.do_all (agent append_test_to_executor (l_executor, ?, current_fault_signature, False, Mode_monitor))

			current_passing_test_cases.do_all (agent append_test_to_executor (l_executor, ?, current_fault_signature, True, Mode_monitor))

			last_class_text := Root_class_body_template.twin
			last_class_text.replace_substring_all ("${CLASS_NAME}", l_root_class_name)
			last_class_text.replace_substring_all ("${RELEVANT_TYPES_FEATURE}", relevant_types_feature_text)
			last_class_text.replace_substring_all ("${INITIALIZE_TEST_CASES}", feature_for_initialize_test_cases (test_cases))
			last_class_text.replace_substring_all ("${FIRST_FAILING_TEST_CASE_UUID}", feature_for_first_test_case_uuid)
			last_class_text.replace_substring_all ("${EXECUTE_TEST_CASES}", feature_for_execute_test_cases)
			last_class_text.replace_substring_all ("${TEST_CASES}", l_executor)
		end

feature{NONE} -- Auxiliary operation

	test_case_folder: STRING
			-- Folder storing test cases.
		do
			Result := config.test_case_path
		end

	relevant_types_feature_text: STRING
			-- Text for relevant types feature.
		local
			l_types: DS_HASH_SET [STRING]
			l_feature_text: STRING
			l_feature_body: STRING
			l_list: LEAF_AS_LIST
		do
			l_types := types_from_test_case_list (current_passing_test_cases)
			l_types := l_types.union (types_from_test_case_list (current_failing_test_cases))

			l_feature_text := "%Trelevant_types%N%T%Tlocal%N%T%T%Tl_type: TYPE [detachable ANY]%N%T%Tdo%N$(FEAT_BODY)%N%T%Tend%N"
			from
				l_feature_body := ""
				l_types.start
			until
				l_types.after
			loop
				l_feature_body.append ("%T%T%Tl_type := {" + l_types.item_for_iteration + "}%N")
				l_types.forth
			end
			l_feature_text.replace_substring_all ("$(FEAT_BODY)", l_feature_body)

			result := l_feature_text.twin
		end

	types_from_test_case_list (a_test_case_files: DS_ARRAYED_LIST [STRING]): DS_HASH_SET [STRING]
			-- All variable types mentioned by the test cases in `a_test_case_files'.
		require
			test_case_files_attached: a_test_case_files /= Void
		local
			l_test_case_file_path: STRING
			l_cursor: DS_ARRAYED_LIST_CURSOR [STRING]
		do
			create Result.make_equal (5)

			from
				l_cursor := a_test_case_files.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_test_case_file_path := l_cursor.item

				Result.append (types_from_test_case (l_test_case_file_path))

				l_cursor.forth
			end
		ensure
			result_not_empty: Result /= Void and then Result.count /= 0
		end

	types_from_test_case (a_file: STRING): DS_HASH_SET [STRING]
			-- All variable types mentioned by the test case in `a_file'.
			-- `a_file' is the full path to the test case.
		require
			file_name_not_empty: a_file /= Void and then not a_file.is_empty
		local
			l_tc_path: FILE_NAME
			l_file: PLAIN_TEXT_FILE
			l_line: STRING
			l_type: STRING
			l_start_mark, l_end_mark: STRING
			l_start_count, l_end_count: INTEGER
			l_start_pos, l_end_pos: INTEGER
			l_done: BOOLEAN
		do
			-- Get types from the file.
			create l_file.make_open_read (a_file)
			if l_file.is_open_read then
				l_start_mark := once "<variable_declaration>"
				l_start_count := l_start_mark.count
				l_end_mark := once "</variable_declaration>"
				l_end_count := l_end_mark.count

				from l_file.read_line
				until l_file.after or l_done
				loop
					l_line := l_file.last_string.twin
					l_start_pos := l_line.substring_index (l_start_mark, 1)
					l_end_pos := l_line.substring_index (l_end_mark, 1)

					if l_start_pos /= 0 and then l_end_pos /= 0 then
						if l_start_pos + l_start_count < l_end_pos then
							l_line := l_line.substring (l_start_pos + l_start_count, l_end_pos - 1)
							Result := types_from_variable_declaration (l_line)
						else
							create Result.make (1)
						end
						l_done := True
					end

					l_file.read_line
				end
				l_file.close
			else
				create Result.make (1)
				Result.set_equality_tester (String_equality_tester)
			end
		ensure
			result_not_empty: Result /= Void and then Result.count /= 0
		end

	types_from_variable_declaration (a_dec: STRING): DS_HASH_SET [STRING]
			-- Types referenced by a variable declaration.
		require
			dec_not_empty: a_dec /= Void and then not a_dec.is_empty
		local
			l_dec: STRING
			l_vars: LIST [STRING]
			l_var, l_type: STRING
			l_reg: RX_PCRE_REGULAR_EXPRESSION
		do
			create l_reg.make
			l_reg.compile ("v_[0-9]+:(.+)")

			l_dec := a_dec.twin
			l_dec.prune_all_trailing ('$')
			l_dec.prune_all (' ')
			l_vars := l_dec.split ('$')

			create Result.make (l_vars.count)
			Result.set_equality_tester (String_equality_tester)

			from l_vars.start
			until l_vars.after
			loop
				l_var := l_vars.item_for_iteration
				l_reg.match (l_var)
				check l_reg.has_matched end
				Result.force (l_reg.captured_substring (1))

				l_vars.forth
			end
		ensure
			result_not_empty: Result /= Void and then Result.count /= 0
		end

	append_test_to_executor (a_executor: STRING; a_test_class_name: STRING; a_test: EPA_TEST_CASE_SIGNATURE; a_passing: BOOLEAN; a_execution_mode: INTEGER)
			-- Append the execution command of the test with its name 'a_test_class_name' to the execution string 'a_executor'.
			-- The way this test is executed depends on the execution mode given by 'a_execution_mode'.
		local
			l_test_case_class_file_base_name: STRING
			l_test_executor: STRING
			l_slices: LIST [STRING]
		do
			l_test_case_class_file_base_name := base_eiffel_file_name_from_full_path (a_test_class_name)
			l_test_executor := Execute_test_case_feature_template.twin
			l_test_executor.replace_substring_all ("${TEST_CASE_INDEX}", test_case_index.out)
			l_test_executor.replace_substring_all ("${TEST_CASE_CLASS_NAME}", l_test_case_class_file_base_name.as_upper)
			l_test_executor.replace_substring_all ("${EXECUTION_MODE}", a_execution_mode.out)

			a_executor.append (l_test_executor)
			a_executor.append ("%N%N")

			if a_execution_mode = Mode_monitor then
				l_slices := string_slices (l_test_case_class_file_base_name, "__")
				test_cases.extend (["execute_test_case_" + test_case_index.out, l_slices.last])
			end

			test_case_index := test_case_index + 1
		end

	feature_for_initialize_test_cases (a_test_cases: like test_cases): STRING
			-- Feature text for `initialize_test_cases', which setup test cases from `a_test_cases'.
		do
			create Result.make (2048)
			Result.append ("%Tinitialize_test_cases%N")
			Result.append ("%T%T%T-- Initialize `test_cases'.%N")
			Result.append ("%T%Tdo%N")
			Result.append ("%T%T%Tcreate test_cases.make (" + a_test_cases.count.out + ")%N")
			Result.append ("%T%T%Ttest_cases.compare_objects%N")
			from
				a_test_cases.start
			until
				a_test_cases.after
			loop
				Result.append ("%T%T%Ttest_cases.extend (agent ")
				Result.append (a_test_cases.item_for_iteration.agent_name)
				Result.append (", %"")
				Result.append (a_test_cases.item_for_iteration.uuid)
				Result.append ("%")%N")
				a_test_cases.forth
			end

			Result.append ("%T%Tend%N")
		end

	feature_for_execute_test_cases: STRING
			-- Feature text for `execute_test_cases'.
		do
			create Result.make (1024)
			Result.append ("%Texecute_test_cases%N")
			Result.append ("%T%T%T--Execute test cases.%N")
			Result.append ("%T%Tdo%N")
			Result.append ("%T%T%Texecute_test_case_0%N")
			from
				test_cases.start
			until
				test_cases.after
			loop
				Result.append ("%T%T%T")
				Result.append (test_cases.item_for_iteration.agent_name)
				Result.append ("%N")
				test_cases.forth
			end
			Result.append ("%T%Tend%N")
		end

	feature_for_first_test_case_uuid: STRING
			-- Feature text to return the UUID of the first failing test case from `a_failing_test_cases'
		local
			l_cursor: CURSOR
			l_uuid: STRING
			l_signature: EPA_TEST_CASE_SIGNATURE
		do
			create l_signature.make_with_string (base_eiffel_file_name_from_full_path(current_failing_test_cases.first))
			check same_uuid: l_signature.uuid ~ current_fault_signature.uuid end
			l_uuid := current_fault_signature.uuid

			Result := First_failing_test_case_uuid_feature_template.twin
			Result.replace_substring_all ("${UUID}", l_uuid)
		end

feature{NONE} -- Implementation

	test_case_index: INTEGER
			-- Index of the NEXT test case executor.

feature{NONE} -- Root class template

	Root_class_body_template: STRING =
	"[
class
	${CLASS_NAME}
	
inherit
	AFX_INTERPRETER
	
create
	make
		
		
feature{NONE} -- Implementation

${INITIALIZE_TEST_CASES}

${RELEVANT_TYPES_FEATURE}

${FIRST_FAILING_TEST_CASE_UUID}

${EXECUTE_TEST_CASES}

feature{NONE} -- Implementation

${TEST_CASES}

end

	]"

	First_failing_test_case_uuid_feature_template: STRING = "%Tfirst_failing_test_case_uuid: STRING = %"${UUID}%"%N%N"

	Execute_test_case_feature_template: STRING =
	"[
		execute_test_case_${TEST_CASE_INDEX}
			local
				l_tc: ${TEST_CASE_CLASS_NAME}
				l_retried: BOOLEAN
			do
				if not l_retried then
					create l_tc
					l_tc.set_execution_mode (${EXECUTION_MODE})
					l_tc.generated_test_1
				end
			rescue
				exception_count := exception_count + 1
				l_retried := True
				retry
			end
	]"

end
