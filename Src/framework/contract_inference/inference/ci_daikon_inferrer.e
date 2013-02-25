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
			logger.push_level ({ELOG_CONSTANTS}.debug_level)
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
				l_cursor := l_parser.last_daikon_results.new_cursor
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

			last_preconditions.append (contracts_from_daikon_results (l_parser.last_daikon_results, True))
			last_postconditions.append (contracts_from_daikon_results (l_parser.last_daikon_results, False))
			setup_last_contracts
		end

	contracts_from_daikon_results (a_results: DS_HASH_TABLE [DS_HASH_SET [DKN_INVARIANT], DKN_PROGRAM_POINT]; a_pre: BOOLEAN): DS_HASH_SET [EPA_EXPRESSION]
			-- Contract expressions from daikon result `a_results'.
			-- Return precondition expressions if `a_pre' is True; return postcondition expressions otherwise.
		require
			results_attached: a_results /= Void
		local
			l_ppt: DKN_PROGRAM_POINT
			l_daikon_invs: DS_HASH_SET [DKN_INVARIANT]
			l_daikon_invs_cursor: DS_HASH_SET_CURSOR [DKN_INVARIANT]
			l_inv_string: STRING
			l_inv_string_set: DS_HASH_SET [STRING]
			l_property: like candidate_property
			l_resolved_function: EPA_FUNCTION
			l_expression: EPA_EXPRESSION
			l_operand_string_table: HASH_TABLE [STRING_8, INTEGER_32]
		do
			if a_pre then
				l_ppt := variable_declaration.first
			else
				l_ppt := variable_declaration.last
			end
			l_daikon_invs := a_results.item (l_ppt)
			create Result.make_equal (l_daikon_invs.count + 1)

			from
				l_operand_string_table := operand_string_table_for_feature (feature_under_test)
				l_daikon_invs_cursor := l_daikon_invs.new_cursor
				l_daikon_invs_cursor.start
			until
				l_daikon_invs_cursor.after
			loop
				if attached {DKN_EXPRESSION_INVARIANT} l_daikon_invs_cursor.item as lt_inv then
						-- Keep only invariants of expression type.
					l_inv_string := eiffel_string_from_daikon_invariant (lt_inv.text)
					create l_inv_string_set.make_equal (2)
					l_inv_string_set.force_last (l_inv_string)
					l_property := candidate_property (l_inv_string_set, "or", l_operand_string_table)
					l_expression := expression_from_function (l_property.function, Void, l_property.operand_map, class_under_test, feature_under_test)
					Result.force_last (l_expression)
				end

				l_daikon_invs_cursor.forth
			end
		end

	eiffel_string_from_daikon_invariant (a_inv: STRING): STRING
			-- String containing valid eiffel expression text, derived from a daikon invariant `a_inv'.
			-- 1. Comparisons with True/False are simplified. E.g., "exp == True" becomes "exp" and "exp == False" becomes "not (exp)";
			-- 2. Comparisons between expressions are now through "=", instead of " == ";
			-- 3. Other expression texts stay unchanged.
		local
			l_sign: STRING
--			l_left_bound, l_right_bound: INTEGER
--			l_left_part, l_right_part: STRING
			l_parts: LIST [STRING_8]
		do
			l_sign := {EPA_CONSTANTS}.Query_value_separator
			Result := daikon_printer.decoded_daikon_name (a_inv)
			if Result.has_substring (l_sign) then
				l_parts := string_slices (Result, l_sign)
				check l_parts.count = 2 end
				if l_parts.last.as_lower ~ "true" then
					Result := l_parts.first
				elseif l_parts.last.as_lower ~ "false" then
					Result := "not (" + l_parts.first + ")"
				else
					Result := l_parts.first + " = " + l_parts.last
				end

--				l_left_bound  := Result.substring_index (l_sign, 1)
--				l_right_bound := l_left_bound + l_sign.count
--				l_left_part  := Result.substring (1, l_left_bound - 1)
--				l_right_part := Result.substring (l_right_bound, Result.count)
--				if l_right_part.as_upper ~ "TRUE" then
--					Result := l_left_part
--				elseif l_right_part.as_upper ~ "FALSE" then
--					Result := "not (" + l_left_part + ")"
--				else
--					Result.replace_substring_all (l_sign, " = ")
--				end
			end
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
