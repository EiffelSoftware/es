note
	description: "Summary description for {AFX_PROJECT_ROOT_FOR_FIXING_CONTRACTS_BUILDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROJECT_ROOT_FOR_FIXING_CONTRACTS_BUILDER

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

	make_with_test_cases (a_system: like system; a_failing_test_cases, a_passing_test_cases, a_relaxed_failing_test_cases, a_relaxed_passing_test_cases: DS_ARRAYED_LIST [STRING])
			-- Initialization.
		local
			l_cursor: DS_ARRAYED_LIST_CURSOR [STRING]
			l_index: INTEGER
			l_temp_tests: DS_ARRAYED_LIST [STRING]
		do
			system := a_system
			first_failing_test_case := a_failing_test_cases.first

			create test_cases_for_fixing.make_equal (a_passing_test_cases.count + a_failing_test_cases.count + 1)
			test_cases_for_fixing.append_last (selected_tests (a_failing_test_cases, (a_failing_test_cases.count + 1) // 2))
			test_cases_for_fixing.append_last (selected_tests (a_passing_test_cases, (a_passing_test_cases.count + 1) // 2))

			create test_cases_for_validation.make_equal (a_passing_test_cases.count + a_failing_test_cases.count + 1)
			test_cases_for_validation.append_last (a_failing_test_cases)
			test_cases_for_validation.append_last (a_passing_test_cases)

			create relaxed_test_cases.make_equal (a_relaxed_passing_test_cases.count + a_relaxed_failing_test_cases.count + 1)
			relaxed_test_cases.append_last (a_relaxed_failing_test_cases)
			relaxed_test_cases.append_last (a_relaxed_passing_test_cases)

			test_case_agents := initialize_test_case_agents (test_cases_for_validation, "execute_test_case_")
			relaxed_test_case_agents := initialize_test_case_agents (relaxed_test_cases, "execute_relaxed_test_case_")
		end

	selected_tests (a_tests: DS_ARRAYED_LIST [STRING]; a_max_count: INTEGER): DS_ARRAYED_LIST [STRING]
			--
		local
			l_cursor: DS_ARRAYED_LIST_CURSOR [STRING]
		do
			create Result.make_equal (a_tests.count)
			from
				l_cursor := a_tests.new_cursor
				l_cursor.start
			until
				l_cursor.after or else Result.count > a_max_count
			loop
				Result.force_last (l_cursor.item)
				l_cursor.forth
			end
		end

	initialize_test_case_agents (a_tests: DS_ARRAYED_LIST [STRING]; a_prefix: STRING): DS_HASH_TABLE [STRING, STRING]
			--
		local
			l_cursor: DS_ARRAYED_LIST_CURSOR [STRING]
		do
			create Result.make_equal (a_tests.count + 1)
			from
				l_cursor := a_tests.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.force (a_prefix + (Result.count + 1).out, l_cursor.item)
				l_cursor.forth
			end
		end

feature -- Access

	last_class_text: detachable STRING
			-- Class text from last building.

feature -- Access

	system: SYSTEM_I
			-- System under which test cases are analyzed

	first_failing_test_case: STRING

	test_cases_for_fixing: DS_ARRAYED_LIST [STRING]

	test_cases_for_validation: DS_ARRAYED_LIST [STRING]

	relaxed_test_cases: DS_ARRAYED_LIST [STRING]

	test_case_agents: DS_HASH_TABLE [STRING, STRING]

	relaxed_test_case_agents: DS_HASH_TABLE [STRING, STRING]

feature -- Basic operation

	build
			-- Build the class text for the root class in `system'.
			-- The class text is available in `last_class_text'.
		local
			l_root_class_name: STRING
			l_executor: STRING
			l_relaxed_executor: STRING
			l_validator: STRING
		do
			l_root_class_name := afx_project_root_class

			create l_executor.make (4096 * 4)
			create l_relaxed_executor.make (4096 * 4)
				-- Note that one failing test case is added TWICE to the executor.
				-- The first execution is to reproduce the failure, and the second for dynamic analysis.
			append_test_to_executor (l_executor, first_failing_test_case, Mode_execute, test_case_agents)
			test_cases_for_validation.do_all (agent append_test_to_executor (l_executor, ?, Mode_monitor, test_case_agents))
			relaxed_test_cases.do_all (agent append_test_to_executor (l_relaxed_executor, ?, Mode_monitor, relaxed_test_case_agents))

			last_class_text := Root_class_body_template.twin
			last_class_text.replace_substring_all ("${CLASS_NAME}", l_root_class_name)
			last_class_text.replace_substring_all ("${RELEVANT_TYPES_FEATURE}", relevant_types_feature_text)

			last_class_text.replace_substring_all ("${INITIALIZE_RELAXED_TEST_CASES}", feature_for_initialize_test_cases ("relaxed_test_cases", relaxed_test_cases, relaxed_test_case_agents))
			last_class_text.replace_substring_all ("${INITIALIZE_TEST_CASES}", feature_for_initialize_test_cases ("test_cases", test_cases_for_fixing, test_case_agents))
			last_class_text.replace_substring_all ("${INITIALIZE_TEST_CASES_FOR_CONTRACT_VALIDATION}", feature_for_initialize_test_cases ("test_cases_for_contract_validation", test_cases_for_validation, test_case_agents))

			last_class_text.replace_substring_all ("${FIRST_FAILING_TEST_CASE_UUID}", feature_for_first_test_case_uuid)
			last_class_text.replace_substring_all ("${EXECUTE_RELAXED_TEST_CASES}", feature_for_execute_test_cases ("relaxed_test_cases", relaxed_test_cases, relaxed_test_case_agents, Void))
			last_class_text.replace_substring_all ("${EXECUTE_TEST_CASES}", feature_for_execute_test_cases ("test_cases", test_cases_for_fixing, test_case_agents, "execute_test_case_0"))
			last_class_text.replace_substring_all ("${EXECUTE_TEST_CASES_FOR_CONTRACT_VALIDATION}", feature_for_execute_test_cases ("test_cases_for_contract_validation", test_cases_for_validation, test_case_agents, Void))

			last_class_text.replace_substring_all ("${RELAXED_TEST_CASES}", l_relaxed_executor)
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
			l_types := types_from_test_case_list (config.test_case_path, test_cases_for_validation)
			l_types := l_types.union (types_from_test_case_list (config.relaxed_test_case_path, relaxed_test_cases))

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

	types_from_test_case_list (a_dir: STRING; a_test_case_files: DS_ARRAYED_LIST [STRING]): DS_HASH_SET [STRING]
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

				Result.append (types_from_test_case (a_dir, l_test_case_file_path))

				l_cursor.forth
			end
		ensure
			result_not_empty: Result /= Void and then Result.count /= 0
		end

	types_from_test_case (a_dir, a_file: STRING): DS_HASH_SET [STRING]
			-- All variable types mentioned by the test case in `a_file'.
			-- `a_file' is the full path to the test case.
		require
			file_name_not_empty: a_file /= Void and then not a_file.is_empty
		local
			l_dir_path: PATH
			l_tc_path: FILE_NAME
			l_file: PLAIN_TEXT_FILE
			l_line: STRING
			l_type: STRING
			l_start_mark, l_end_mark: STRING
			l_start_count, l_end_count: INTEGER
			l_start_pos, l_end_pos: INTEGER
			l_done: BOOLEAN
		do
			create l_dir_path.make_from_string (a_dir)
			-- Get types from the file.
			create l_file.make_with_path (l_dir_path.extended (a_file))
			l_file.open_read
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
				create Result.make_equal (1)
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

			create Result.make_equal (l_vars.count)

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

	append_test_to_executor (a_executor: STRING; a_test_class_name: STRING; a_execution_mode: INTEGER; a_test_agents: DS_HASH_TABLE [STRING, STRING])
			-- Append the execution command of the test at 'a_test_class_path' to the execution string 'a_executor'.
			-- The way this test is executed depends on the execution mode given by 'a_execution_mode'.
		local
			l_test_case_class_file_base_name, l_prefix: STRING
			l_test_executor: STRING
			l_slices: LIST [STRING]
			l_agent_name: STRING
			l_test_cases: like test_case_agents
			l_index: INTEGER
		do
			if a_test_class_name ~ first_failing_test_case and then a_execution_mode = mode_execute then
				l_agent_name := "execute_test_case_0"
			else
				l_agent_name := a_test_agents.item (a_test_class_name)
			end
			l_test_case_class_file_base_name := base_eiffel_file_name_from_full_path (a_test_class_name)
			l_test_executor := l_agent_name + "%N" + Execute_test_case_feature_template
			l_test_executor.replace_substring_all ("${TEST_CASE_CLASS_NAME}", l_test_case_class_file_base_name.as_upper)
			l_test_executor.replace_substring_all ("${EXECUTION_MODE}", a_execution_mode.out)

			a_executor.append (l_test_executor)
			a_executor.append ("%N%N")
		end

	feature_for_initialize_test_cases (a_category_name: STRING; a_tests: DS_ARRAYED_LIST [STRING]; a_test_agents: DS_HASH_TABLE [STRING, STRING]): STRING
			-- Feature text for `initialize_test_cases', which setup test cases from `a_test_cases'.
		local
			l_cursor: DS_ARRAYED_LIST_CURSOR [STRING]
			l_category_name, l_test_name, l_uuid, l_agent_name: STRING
			l_list: LIST[STRING]
		do
			l_category_name := a_category_name.twin
			create Result.make (2048)
			Result.append ("%Tinitialize_" + l_category_name + "%N")
			Result.append ("%T%T%T-- Initialize `" + l_category_name + "'.%N")
			Result.append ("%T%Tdo%N")
			Result.append ("%T%T%Tcreate " + l_category_name + ".make (" + (a_test_agents.count + 1).out + ")%N")
			Result.append ("%T%T%T" + l_category_name + ".compare_objects%N")
			from
				l_cursor := a_tests.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_test_name := l_cursor.item.twin
				l_agent_name := a_test_agents.item (l_test_name)
				l_test_name.replace_substring_all ("__", "#")
				l_uuid := l_test_name.split ('#').last

				Result.append ("%T%T%T" + l_category_name + ".extend (agent ")
				Result.append (l_agent_name)
				Result.append (", %"")
				Result.append (l_uuid)
				Result.append ("%")%N")

				l_cursor.forth
			end

			Result.append ("%T%Tend%N")
		end

	feature_for_execute_test_cases (a_category_name: STRING; a_tests: DS_ARRAYED_LIST [STRING]; a_test_agents: DS_HASH_TABLE [STRING, STRING]; a_extra_test: STRING): STRING
			-- Feature text for `execute_test_cases'.
		local
			l_cursor: DS_ARRAYED_LIST_CURSOR [STRING]
			l_test: STRING

			l_name: STRING
			l_test_cases: like test_case_agents
		do
			create Result.make (1024)
			Result.append ("%Texecute_" + a_category_name + "%N")
			Result.append ("%T%Tdo%N")

			if a_extra_test /= Void then
				Result.append ("%T%T%T%T" + a_extra_test + "%N")
			end

			from
				l_cursor := a_tests.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_test := l_cursor.item
				Result.append ("%T%T%T%T")
				Result.append (a_test_agents.item (l_test))
				Result.append ("%N")

				l_cursor.forth
			end
			Result.append ("%T%Tend%N")
		end

	feature_for_first_test_case_uuid: STRING
			-- Feature text to return the UUID of the first failing test case from `a_failing_test_cases'
		local
			l_test_name: STRING
			l_uuid: STRING
			l_signature: EPA_TEST_CASE_SIGNATURE
		do
			l_test_name := base_eiffel_file_name_from_full_path(first_failing_test_case)
			l_test_name.replace_substring_all ("__", "#")
			l_uuid := l_test_name.split ('#').last

			Result := First_failing_test_case_uuid_feature_template.twin
			Result.replace_substring_all ("${UUID}", l_uuid)
		end

feature{NONE} -- Implementation

	test_case_index: INTEGER
			-- Index of the NEXT test case executor.

	relaxed_test_case_index: INTEGER

feature{NONE} -- Root class template

	Root_class_body_template: STRING =
"[
class
	${CLASS_NAME}
	
inherit
	AFX_INTERPRETER
		redefine 
			execute_relaxed_test_cases,
			execute_test_cases_for_contract_validation
		end
	
	EXCEPTIONS

create
	make
		
		
feature{NONE} -- Implementation

${INITIALIZE_TEST_CASES}

${INITIALIZE_TEST_CASES_FOR_CONTRACT_VALIDATION}

${INITIALIZE_RELAXED_TEST_CASES}

${RELEVANT_TYPES_FEATURE}

${FIRST_FAILING_TEST_CASE_UUID}

${EXECUTE_TEST_CASES}

${EXECUTE_TEST_CASES_FOR_CONTRACT_VALIDATION}

${EXECUTE_RELAXED_TEST_CASES}

feature{NONE} -- Implementation

${TEST_CASES}

${RELAXED_TEST_CASES}

end

]"

	First_failing_test_case_uuid_feature_template: STRING = "%Tfirst_failing_test_case_uuid: STRING = %"${UUID}%"%N%N"

	Execute_test_case_feature_template: STRING =
"[
		local
			l_tc: ${TEST_CASE_CLASS_NAME}
			l_retried: BOOLEAN
		do
			if not l_retried then
				log_message ("Executing ${TEST_CASE_CLASS_NAME}%N")
				create l_tc
				l_tc.set_execution_mode (${EXECUTION_MODE})
				l_tc.generated_test_1
			end
		rescue
			log_message ("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<%N")
			log_message (exception_manager.last_exception.original.trace)
			log_message (">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>%N")
			exception_count := exception_count + 1
			l_retried := True
			retry
		end
]"


end
