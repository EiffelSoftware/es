note
	description: "Contract inferrer using Daikon"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_DAIKON_INFERRER

inherit
	CI_INFERRER

	EPA_PROCESS_UTILITY

feature -- Basic operations

	infer (a_data: like data)
			-- Infer contracts from `a_data', which is transition data collected from
			-- executed test cases.
		local
			l_daikon_output: STRING
			l_parser: DKN_RESULT_PARSER
			l_cursor: DS_HASH_TABLE_CURSOR [DS_HASH_SET [DKN_INVARIANT], DKN_PROGRAM_POINT]
			l_cur2: DS_HASH_SET_CURSOR [DKN_INVARIANT]
		do
			logger.put_line_with_time ("Start generating contracts using Daikon.")

			data := a_data
			setup_data_structures
			generate_daikon_files

				-- Execute Daikon and parse output.
			logger.push_fine_level
			logger.put_line ("Command: " + daikon_command)
			logger.put_line ("Daikon output:")
			l_daikon_output := output_from_program (daikon_command, Void)
			logger.put_line (l_daikon_output)
			logger.put_line ("")
			logger.pop_level

			create l_parser
			l_parser.parse_from_string (l_daikon_output, variable_declaration)

			logger.put_line_with_time ("Found the following Daikon invariants:")
			from
				l_cursor := l_parser.last_invariants.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				logger.put_line (once "%TProgram point: " + l_cursor.key.daikon_name)
				from
					l_cur2 := l_cursor.item.new_cursor
					l_cur2.start
				until
					l_cur2.after
				loop
					logger.put_line (once "%T%T" + l_cur2.item.text)
					l_cur2.forth
				end
				l_cursor.forth
			end

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
			l_declaraction_file: PLAIN_TEXT_FILE
			l_trace_file: PLAIN_TEXT_FILE
		do
			create daikon_printer.make_with_selection_function (
				agent (a_equation: EPA_EQUATION; a_transition: SEM_TRANSITION; a_pre_state: BOOLEAN): BOOLEAN
					local
						l_text: STRING
					do
						l_text := a_equation.expression.text
						Result :=
							not l_text.has ('=') and then
							not l_text.has ('~') and then
							not a_equation.value.is_nonsensical
					end)
			daikon_printer.set_is_union_mode (False)
			interface_transitions.do_all (agent daikon_printer.extend_transition ({SEM_FEATURE_CALL_TRANSITION}?))
			daikon_printer.generate (class_under_test, feature_under_test)

			create l_declaraction_file.make_create_read_write (declaration_file_name)
			variable_declaration := daikon_printer.last_declarations
			l_declaraction_file.put_string (daikon_printer.last_declarations.out)
			l_declaraction_file.close

			create l_trace_file.make_create_read_write (trace_file_name)
			l_trace_file.put_string (daikon_printer.last_trace.out)
			l_trace_file.close
		end

feature{NONE} -- Implementation

	interface_transitions: DS_HASH_TABLE [SEM_FEATURE_CALL_TRANSITION, CI_TEST_CASE_TRANSITION_INFO]
			-- Table of interface transtions
			-- Key is test case, value is the interface transition adapted from the transition in that test case.
			-- The pre- and post-conditions of the interface transition only mentions operands in the feature.
		do
			Result := data.interface_transitions
		end

	daikon_printer: CI_TRANSITION_TO_DAIKON_PRINTER
			-- Printer to output `interface_transitions' into Daikon input file

	variable_declaration: DKN_DECLARATION
			-- Daikon program point and variable declaration

	trace_file_name: FILE_NAME
			-- Trace file name
		do
			create Result.make_from_string (config.data_directory)
			Result.set_file_name (class_under_test.name_in_upper + "__" + feature_under_test.feature_name + ".dtrace")
		end

	declaration_file_name: FILE_NAME
			-- Declaration file name
		do
			create Result.make_from_string (config.data_directory)
			Result.set_file_name (class_under_test.name_in_upper + "__" + feature_under_test.feature_name + ".decls")
		end

	daikon_command: STRING
			-- Command line option to launch daikon
		do
			create Result.make (256)
			if {PLATFORM}.is_windows then
				Result.append ("java daikon.Daikon ")
			else
				Result.append ("/usr/bin/java daikon.Daikon ")
			end
			Result.append (trace_file_name)
			Result.append_character (' ')
			Result.append (declaration_file_name)
		end

end
