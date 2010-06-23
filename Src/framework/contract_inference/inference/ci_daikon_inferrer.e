note
	description: "Contract inferrer using Daikon"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_DAIKON_INFERRER

inherit
	CI_INFERRER

feature -- Basic operations

	infer (a_data: LINKED_LIST [CI_TEST_CASE_TRANSITION_INFO])
			-- Infer contracts from `a_data', which is transition data collected from
			-- executed test cases.
		do
			transition_data := a_data
			setup_data_structures

			build_interface_transitions
			generate_daikon_files
		end

	generate_daikon_files
			-- Generate Daikon files.
		local
			l_declaration_file_name: FILE_NAME
			l_trace_file_name: FILE_NAME
			l_declaraction_file: PLAIN_TEXT_FILE
			l_trace_file: PLAIN_TEXT_FILE
		do
			create daikon_printer.make_with_selection_function (
				agent (a_equation: EPA_EQUATION): BOOLEAN
					local
						l_text: STRING
					do
						l_text := a_equation.expression.text
						Result :=
							not l_text.has ('=') and then
							not l_text.has ('~')
					end)
			daikon_printer.set_is_union_mode (False)
			interface_transitions.do_all (agent daikon_printer.extend_transition ({SEM_FEATURE_CALL_TRANSITION}?))
			daikon_printer.generate (class_under_test, feature_under_test)

			create l_declaration_file_name.make_from_string (config.data_directory)
			l_declaration_file_name.set_file_name (feature_under_test.feature_name + ".decls")
			create l_declaraction_file.make_create_read_write (l_declaration_file_name)
			l_declaraction_file.put_string (daikon_printer.last_declarations.out)
			l_declaraction_file.close

			create l_trace_file_name.make_from_string (config.data_directory)
			l_trace_file_name.set_file_name (feature_under_test.feature_name + ".dtrace")
			create l_trace_file.make_create_read_write (l_trace_file_name)
			l_trace_file.put_string (daikon_printer.last_trace.out)
			l_trace_file.close
		end

feature{NONE} -- Implementation

	interface_transitions: DS_HASH_TABLE [SEM_FEATURE_CALL_TRANSITION, CI_TEST_CASE_TRANSITION_INFO]
			-- Table of interface transtions
			-- Key is test case, value is the interface transition adapted from the transition in that test case.
			-- The pre- and post-conditions of the interface transition only mentions operands in the feature.

	daikon_printer: CI_TRANSITION_TO_DAIKON_PRINTER
			-- Printer to output `interface_transitions' into Daikon input file

feature{NONE} -- Implementation

	build_interface_transitions
			-- Build `interface_transitions' from `transition_data'.
		local
			l_transition: SEM_FEATURE_CALL_TRANSITION
			l_test_case: CI_TEST_CASE_TRANSITION_INFO
			l_original_transition: SEM_FEATURE_CALL_TRANSITION
		do
			create interface_transitions.make (transition_data.count)
			interface_transitions.set_key_equality_tester (ci_test_case_transition_info_equality_tester)

				-- Iterate through all test cases in `transition_data',
				-- for each test case, build the corresponding interface transition.
			across transition_data as l_test_cases loop
				l_test_case := l_test_cases.item
				l_original_transition := l_test_case.transition
				create l_transition.make (
					l_test_case.test_case_info.class_under_test,
					l_test_case.test_case_info.feature_under_test,
					l_test_case.test_case_info.operand_map,
					l_test_case.transition.context,
					l_test_case.transition.is_creation)
				l_transition.set_uuid (l_original_transition.uuid)
				l_transition.set_precondition (l_original_transition.interface_precondition.subtraction (l_original_transition.written_preconditions))
				l_transition.set_postcondition (l_original_transition.interface_postcondition.subtraction (l_original_transition.written_postconditions))
				interface_transitions.force_last (l_transition, l_test_case)
			end
		end

end
