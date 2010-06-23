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
			interface_transitions := interface_transitions_from_test_cases (transition_data)
			generate_daikon_files

				-- Setup results.
			create last_preconditions.make (10)
			last_preconditions.set_equality_tester (expression_equality_tester)
			create last_postconditions.make (10)
			last_postconditions.set_equality_tester (expression_equality_tester)
			setup_last_contracts
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

end
