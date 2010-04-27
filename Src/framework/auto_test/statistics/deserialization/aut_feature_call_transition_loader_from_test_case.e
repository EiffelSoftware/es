note
	description: "Summary description for {AUT_TEST_CASE_LOADER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_FEATURE_CALL_TRANSITION_LOADER_FROM_TEST_CASE

inherit
	EPA_UTILITY

	ITP_VARIABLE_CONSTANTS

	ERL_G_TYPE_ROUTINES

create
	make

feature -- Initialization

	make (a_session: AUT_SESSION)
			-- Initialization.
		do
			session := a_session
		end

feature -- Access

	session: AUT_SESSION
			-- Session.

	last_transition: detachable SEM_FEATURE_CALL_TRANSITION
			-- Transition from last `load_transition' operation.


feature -- Operation

	load_transition (a_file: STRING)
			-- Load a transition from a test case file 'a_file'.
			-- Save the result into `last_transition'.
		local
			l_file: KL_TEXT_INPUT_FILE
			l_content, l_line: STRING
			l_reg: RX_PCRE_REGULAR_EXPRESSION
		do
			last_transition := Void

			create l_file.make (a_file)
			l_file.open_read
			if l_file.is_open_read then
				create l_content.make (l_file.count)
				from
					l_file.rewind
				until
					l_file.end_of_file
				loop
					l_file.read_line
					l_content.append (l_file.last_string)
					l_content.append_character ('%N')
				end

				parse_transition_from_string (l_content)
			end
		end

feature{NONE} -- Implementation

	last_class: detachable CLASS_C
			-- Class of the last feature call.

	last_feature: detachable FEATURE_I
			-- Feature of the last feature call.

	last_feature_call: detachable AUT_CALL_BASED_REQUEST
			-- Feature call.

	last_pre_state: detachable EPA_STATE
			-- Object state before the transition.

	last_post_state: detachable EPA_STATE
			-- Object state after the transition.

	last_operand_names: detachable HASH_TABLE[STRING, INTEGER]
			-- Hashtable mapping 0-based operand index to the variable name.
		require
			last_feature_call_attached: last_feature_call /= Void
		local
			l_feature_call: like last_feature_call
			l_operand_indexes: SPECIAL[INTEGER]
			l_index: INTEGER
		do
			l_feature_call := last_feature_call
			l_operand_indexes := l_feature_call.operand_indexes
			create Result.make (l_operand_indexes.count)
			from
				l_index := 0
			until
				l_index >= l_operand_indexes.count
			loop
				Result.put (variable_name_prefix + l_operand_indexes[l_index].out, l_index)
				l_index := l_index + 1
			end
		end

	last_operand_types: detachable HASH_TABLE[STRING, STRING]
			-- Map between operand name and its associated type.

	parse_transition_from_string (a_string: STRING)
			-- Parse a {SEM_FEATURE_CALL_TRANSITION} from 'a_string'.
		local
			l_string: STRING
			l_exception_trace: STRING
			l_class_under_test, l_feature_under_test: STRING
			l_code: STRING
			l_operands_declaration: STRING
			l_pre_state_report, l_post_state_report: STRING
			l_context: EPA_CONTEXT
			l_pos, l_count: INTEGER
			l_reg: RX_PCRE_REGULAR_EXPRESSION
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_var_table: HASH_TABLE [TYPE_A, ITP_VARIABLE]
			l_pre_state, l_post_state: EPA_STATE_TRANSITION_MODEL_STATE
			l_is_creation: BOOLEAN
		do
			l_count := a_string.count

--			-- Pre object
--			l_reg := reg_pre_object
--			l_reg.match (a_string)
--			check l_reg.has_matched end
--			l_pre_object := l_reg.captured_substring (1)
--			l_pos := l_reg.captured_end_position (1)

--			-- Post object
--			l_reg := reg_post_object
--			l_reg.match_substring (a_string, l_pos, l_count)
--			check l_reg.has_matched end
--			l_post_object := l_reg.captured_substring (1)
--			l_pos := l_reg.captured_end_position (1)

			-- Exception trace
			l_reg := Reg_exception_trace
			l_reg.reset
			l_reg.match (a_string)
			check l_reg.has_matched end
			l_exception_trace := l_reg.captured_substring (1)

			-- Extra information
			l_reg := reg_extra_information
			l_reg.reset
			l_reg.match (a_string)
			check l_reg.has_matched end
			l_string := l_reg.captured_substring (1)
			l_count := l_string.count

			-- Class under test
			l_reg := reg_class_under_test
			l_reg.reset
			l_reg.match (l_string)
			check l_reg.has_matched end
			l_class_under_test := l_reg.captured_substring (1)
			l_pos := l_reg.captured_end_position (1)

			-- Feature under test
			l_reg := reg_feature_under_test
			l_reg.reset
			l_reg.match_substring (l_string, l_pos, l_count)
			check l_reg.has_matched end
			l_feature_under_test := l_reg.captured_substring (1)
			l_pos := l_reg.captured_end_position (1)

			-- Code
			l_reg := Reg_code
			l_reg.reset
			l_reg.match_substring (l_string, l_pos, l_count)
			check l_reg.has_matched end
			l_code := l_reg.captured_substring (1)
			l_pos := l_reg.captured_end_position (1)

			-- Operands declaration
			l_reg := reg_operands_declaration
			l_reg.reset
			l_reg.match_substring (l_string, l_pos, l_count)
			check l_reg.has_matched end
			l_operands_declaration := l_reg.captured_substring (1)
			l_pos := l_reg.captured_end_position (1)

			-- Pre state report
			l_reg := reg_pre_state
			l_reg.reset
			l_reg.match_substring (l_string, l_pos, l_count)
			check l_reg.has_matched end
			l_pre_state_report := l_reg.captured_substring (1)
			l_pos := l_reg.captured_end_position (1)

			-- Post state report
			l_reg := reg_post_state
			l_reg.reset
			l_reg.match_substring (l_string, l_pos, l_count)
			check l_reg.has_matched end
			l_post_state_report := l_reg.captured_substring (1)

			last_class := first_class_starts_with_name (l_class_under_test)
			check last_class /= Void end
			last_feature := last_class.feature_named (l_feature_under_test)
			last_operand_types := variable_type_table_from_string (l_operands_declaration)
			last_feature_call := feature_call_from_string (l_code)
--			last_operand_names := operand_name_list

			create l_context.make_with_variable_names (last_operand_types)
			last_pre_state := state_from_string (l_context, l_pre_state_report)
			last_post_state := state_from_string (l_context, l_post_state_report)

--			l_var_table := var_table_from_declaration (l_variable_declaration)

--			create l_pre_state.make_from_string (l_class, l_feature, l_pre_state_report, l_var_table)
--			create l_post_state.make_from_string (l_class, l_feature, l_post_state_report, l_var_table)
			if attached {AUT_CREATE_OBJECT_REQUEST} last_feature_call then
				l_is_creation := True
			else
				l_is_creation := False
			end
			create last_transition.make (last_class, last_feature, last_operand_names, l_context, l_is_creation)
			last_transition.set_precondition (last_pre_state)
			last_transition.set_postcondition (last_post_state)
		end

	state_from_string (a_context: EPA_CONTEXT; a_state_string: STRING):EPA_STATE --_TRANSITION_MODEL_STATE
			-- State from state string.
		require
			last_operand_types_attached: last_operand_types /= Void
		local
			l_exp_type: TYPE_A
			l_str: STRING
			l_list: LIST [STRING]
			l_line: STRING
			l_var_name: STRING
			l_exp_str: STRING
			l_val_str: STRING
			l_start_index, l_end_index: INTEGER
			l_new_var_index: INTEGER
			l_new_var_name: STRING
			l_expr: EPA_AST_EXPRESSION
			l_value: EPA_EXPRESSION_VALUE
			l_equations: HASH_TABLE [EPA_EXPRESSION_VALUE, EPA_AST_EXPRESSION]
		do			l_str := a_state_string.twin

			-- Split types into lines of declarations
			l_str.prune_all ('%R')
			l_str.prune_all_leading ('%N')
			l_str.prune_all_trailing ('%N')
			l_list := l_str.split ('%N')

			from
				create l_equations.make (l_list.count + 1)
				l_equations.compare_objects
				l_list.start
			until
				l_list.after
			loop
				l_line := l_list.item_for_iteration

				if l_line.starts_with ("--|") then
					-- Object state.
					l_start_index := 4
					l_end_index := l_line.last_index_of ('=', l_line.count) - 1

					if l_end_index /= -1 then
						-- Prepend "var." to the expression
						l_exp_str := l_var_name.twin
						l_exp_str.append (once ".")
						l_exp_str.append (l_line.substring (l_start_index, l_end_index))
						l_exp_type := a_context.expression_text_type (l_exp_str)
						create l_expr.make_with_text_and_type (a_context.class_, a_context.feature_, l_exp_str, a_context.class_, l_exp_type)
	--					create l_expr.make_with_text (class_, Void, l_exp_str, class_)

						-- Value of the expression.
						l_start_index := l_end_index + 2
						l_val_str := l_line.substring (l_start_index, l_line.count)
						l_val_str.prune_all (' ')
						if l_val_str.is_integer then
							create {EPA_INTEGER_VALUE} l_value.make (l_val_str.to_integer)
						elseif l_val_str.is_boolean then
							create {EPA_BOOLEAN_VALUE} l_value.make (l_val_str.to_boolean)
						else
							check not_supported: False end
						end
					elseif l_line.substring_index ("[[Void]]", 1) /= -1 then
						-- "--|[[Void]]"
						l_exp_str := l_var_name.twin
						l_exp_type := a_context.expression_text_type (l_exp_str)
						create l_expr.make_with_text_and_type (a_context.class_, a_context.feature_, l_exp_str, a_context.class_, l_exp_type)
						create {EPA_VOID_VALUE} l_value.make
					end


					-- Store the <expr, value> pair
					if not l_equations.has (l_expr) then
						l_equations.put (l_value, l_expr)
					end

				elseif l_line.starts_with ("--") then
					-- Object name and type.
					l_start_index := l_line.index_of ('v', 1)
					l_end_index := l_line.index_of (':', l_start_index) - 1
					l_var_name := l_line.substring (l_start_index, l_end_index)
					l_var_name.prune_all (' ')
				end

				l_list.forth
			end

			create Result.make_from_expression_value (l_equations, last_class, last_feature)
		end

	operand_name_list: HASH_TABLE[STRING, INTEGER]
			-- List of operand names, in the order of their position in the feature call.
		local
			l_feature_call: like last_feature_call
			l_operand_indexes: SPECIAL[INTEGER]
			l_index: INTEGER
		do
			l_feature_call := last_feature_call
			l_operand_indexes := l_feature_call.operand_indexes
			create Result.make (l_operand_indexes.count)
			from
				l_index := 0
			until
				l_index < l_operand_indexes.count
			loop
				Result.put (variable_name_prefix + l_operand_indexes[l_index].out, l_index)
				l_index := l_index + 1
			end
		end

	variable_type_table_from_string (a_string: STRING): HASH_TABLE[STRING, STRING]
			-- A table of variable type and variable name, as declared in 'a_string'.
			-- 'a_string': variable declarations separated by '$'
		local
			l_str: STRING
			l_list: LIST [STRING]
			l_table: like last_operand_types
			l_line: STRING
			l_var_name: STRING
			l_type_str: STRING
			l_start_index, l_end_index: INTEGER
			l_type: TYPE_A
		do
			l_str := a_string
			l_list := l_str.split ('$')

			-- Analyze variables and their types.
			create l_table.make (l_list.count + 1)
			l_table.compare_objects

			from
--				create variable_index_map.make (l_list.count + 1)
--				variable_index_map.compare_objects
--				l_new_index := 1
				l_list.start
			until l_list.after
			loop
				l_line := l_list.item_for_iteration
				l_end_index := l_line.index_of (':', 1)

				-- Variable.
				l_var_name := l_line.substring (1, l_end_index - 1)
				l_var_name.prune_all (' ')
--				l_old_index := variable_index (l_var_name, variable_name_prefix)

				-- Type.
				l_type_str := l_line.substring (l_end_index + 1, l_line.count)
				l_type_str.prune_all (' ')
--				l_type := base_type (l_type_str)

				l_table.put (l_type_str, l_var_name)
--				-- The order of variables
--				register_variable_renaming (l_old_index, l_new_index, l_type)

--				l_new_index := l_new_index + 1
				l_list.forth
			end
			Result := l_table

--			-- Apply variable renaming to relevant strings.
--			apply_renaming (operands_str)
--			apply_renaming (code_str)
--			apply_renaming (pre_state_str)
--			apply_renaming (post_state_str)
		end

	feature_call_from_string (a_string: STRING): AUT_CALL_BASED_REQUEST
			-- Get the feature call from its string representation.
		local
			l_parser: AUT_REQUEST_PARSER
			l_input: STRING
			l_request: AUT_REQUEST
		do
			l_input := ":execute "
			l_input.append (a_string)

			create l_parser.make (system, session.error_handler)
			l_parser.set_input (l_input)
			l_parser.parse

			if not l_parser.has_error and then attached {AUT_CALL_BASED_REQUEST} l_parser.last_request as lt_call then
				-- Explictly set the target type, which will be needed when finding out the 'feature_to_call'.
				if attached {AUT_INVOKE_FEATURE_REQUEST}lt_call as lt_invoke then
					lt_invoke.set_target_type (base_type (last_operand_types[lt_invoke.target.name (variable_name_prefix)]))
				end
				Result := lt_call
			else
				check bad_feature_call: False end
			end
		end

	var_table_from_declaration (a_string: STRING): HASH_TABLE [TYPE_A, ITP_VARIABLE]
			-- Parse the variable table from a variable declaration string.
		local
			l_lines: LIST[STRING]
			l_line: STRING
			l_var_str, l_type_str: STRING
			l_var_index: INTEGER
			l_var: ITP_VARIABLE
			l_type: TYPE_A
			l_pos, l_count: INTEGER
		do
			a_string.prune_all ('?')
			a_string.prune_all_leading ('%N')
			a_string.prune_all_trailing ('%N')
			l_lines := a_string.split ('%N')
			create Result.make (l_lines.count + 1)

			if not l_lines.is_empty then
				from
					l_lines.start
				until
					l_lines.after
				loop
					l_pos := l_line.index_of (':', 1)
					l_var_str := l_line.substring (1, l_pos - 1)
					l_type_str := l_line.substring (l_pos + 1, l_count)

					-- Get variable's index and the type.
					l_var_index := variable_index (l_var_str, variable_name_prefix)
					create l_var.make (l_var_index)
					l_type := base_type (l_type_str)
					Result.force (l_type, l_var)

					l_lines.forth
				end
			end
		end

	Eiffel_id_pattern: STRING = "([A-Z]|[a-z])([a-z]|[A-Z]|[0-9]|_)*"

	Reg_extra_information: RX_PCRE_REGULAR_EXPRESSION
		once
			create Result.make
			Result.set_caseless (True)
			Result.set_multiline (True)
			Result.set_dotall (True)
			Result.compile ("--<extra_information>(.*)--</extra_information>")
		end

	Reg_class_under_test: RX_PCRE_REGULAR_EXPRESSION
		once
			create Result.make
			Result.set_caseless (True)
			Result.set_multiline (True)
			Result.set_dotall (True)
			Result.compile ("<class_under_test>(" + Eiffel_id_pattern + ")</class_under_test>")
		end

	Reg_feature_under_test: RX_PCRE_REGULAR_EXPRESSION
		once
			create Result.make
			Result.set_caseless (True)
			Result.set_multiline (True)
			Result.set_dotall (True)
			Result.compile ("<feature_under_test>(" + Eiffel_id_pattern + ")</feature_under_test>")
		end

	Reg_code: RX_PCRE_REGULAR_EXPRESSION
		once
			create Result.make
			Result.set_caseless (True)
			Result.set_multiline (True)
			Result.set_dotall (True)
			Result.compile ("<code>(.*)</code>")
		end

	Reg_exception_trace: RX_PCRE_REGULAR_EXPRESSION
		once
			create Result.make
			Result.set_caseless (True)
			Result.set_multiline (True)
			Result.set_dotall (True)
			Result.compile ("--<exception_trace>(.*)--</exception_trace>")
		end

	Reg_variable_declaration: RX_PCRE_REGULAR_EXPRESSION
		once
			create Result.make
			Result.set_caseless (True)
			Result.set_multiline (True)
			Result.set_dotall (True)
			Result.compile ("<variable_declaration>(.*)</variable_declaration>")
		end

	Reg_operands_declaration: RX_PCRE_REGULAR_EXPRESSION
		once
			create Result.make
			Result.set_caseless (True)
			Result.set_multiline (True)
			Result.compile ("<operands_declaration>(.*)</operands_declaration>")
		end

	reg_pre_state: RX_PCRE_REGULAR_EXPRESSION
		once
			create Result.make
			Result.set_caseless (True)
			Result.set_multiline (True)
			Result.set_dotall (True)
			Result.compile ("--<pre_state>(.*)--</pre_state>")
		end

	reg_post_state: RX_PCRE_REGULAR_EXPRESSION
		once
			create Result.make
			Result.set_caseless (True)
			Result.set_multiline (True)
			Result.set_dotall (True)
			Result.compile ("--<post_state>(.*)--</post_state>")
		end

--	Reg_pre_object: RX_PCRE_REGULAR_EXPRESSION
--		once
--			create Result.make
--			Result.set_caseless (True)
--			Result.set_multiline (True)
--			Result.compile ("--<pre_object>((.)*)--</pre_object>")
--		end

--	Reg_post_object: RX_PCRE_REGULAR_EXPRESSION
--		once
--			create Result.make
--			Result.set_caseless (True)
--			Result.set_multiline (True)
--			Result.compile ("--<post_object>((.)*)--</post_object>")
--		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
