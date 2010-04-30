note
	description: "Summary description for {AUT_TEST_CASE_SUMMARIZATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_TEST_CASE_SUMMARIZATION

inherit
	EPA_UTILITY

	ITP_VARIABLE_CONSTANTS

	EPA_HASH_CALCULATOR

	ERL_G_TYPE_ROUTINES

	SHARED_TYPES

create
	make

feature -- Initialization

	make (a_class_name, a_code, a_operands, a_trace,
					a_pre_state, a_post_state: STRING;)
			-- Initialization.
		do
			class_name_str := a_class_name
			code_str := a_code
			operands_str := a_operands
			trace_str := a_trace
			pre_state_str := a_pre_state
			post_state_str := a_post_state

			is_summarization_available := True
		end

feature -- Access

	class_name_str: STRING
	code_str: STRING
	operands_str: STRING
	trace_str: STRING
	pre_state_str: STRING
	post_state_str: STRING

feature -- Query

	class_: CLASS_C
			-- Class under test.
		require
			summarization_available: is_summarization_available
		do
			Result := first_class_starts_with_name (class_name_str)
			set_summarization_availability (Result /= Void)
		end

	feature_: FEATURE_I
			-- Feature under test.
		require
			test_case_attached: test_case /= Void
			summarization_available: is_summarization_available
		do
			Result := test_case.feature_to_call
			set_summarization_availability (Result /= Void)
		end

	test_case: AUT_CALL_BASED_REQUEST
			-- An {AUT_CALL_BASED_REQUEST} object as the test case.
		require
			summarization_available: is_summarization_available
		do
			if test_case_cache = Void then
				test_case_cache := test_case_from_string (code_str)
			end
			Result := test_case_cache
			set_summarization_availability (Result /= Void)
		end

	operand_type_table: HASH_TABLE [TYPE_A, ITP_VARIABLE]
			-- Hashtable mapping operands to their types.
		require
			summarization_available: is_summarization_available
		local
		do
			if operand_type_table_cache = Void then
				operand_type_table_cache := variable_type_table_from_declaration (operands_str)
			end
			Result := operand_type_table_cache
			set_summarization_availability (Result /= Void)
		end

	operand_name_type_in_string_table: HASH_TABLE [STRING, STRING]
			-- Hashtable mapping operand names to their types, all in {STRING}.
		require
			summarization_available: is_summarization_available
		local
			l_operand_type_table: like operand_type_table
		do
			if operand_name_type_in_string_table_cache = Void then
				l_operand_type_table := operand_type_table
				from
					create operand_name_type_in_string_table_cache.make (l_operand_type_table.count + 1)
					l_operand_type_table.start
				until
					l_operand_type_table.after
				loop
					operand_name_type_in_string_table_cache.put (
						l_operand_type_table.item_for_iteration.name,
						l_operand_type_table.key_for_iteration.name (variable_name_prefix))
					l_operand_type_table.forth
				end
			end
			Result := operand_name_type_in_string_table_cache
			set_summarization_availability (Result /= Void)
		end

	operand_position_name_table: HASH_TABLE[STRING, INTEGER]
			-- Hashtable mapping 0-based operand position to the variable name.
		require
			test_case_attached: test_case /= Void
			summarization_available: is_summarization_available
		local
			l_test_case: like test_case
			l_operand_indexes: SPECIAL[INTEGER]
			l_index: INTEGER
		do
			if operand_position_name_table_cache = Void then
				l_test_case := test_case
				l_operand_indexes := l_test_case.operand_indexes
				create operand_position_name_table_cache.make (l_operand_indexes.count)
				from
					l_index := 0
				until
					l_index >= l_operand_indexes.count
				loop
					operand_position_name_table_cache.put (variable_name_prefix + l_operand_indexes[l_index].out, l_index)
					l_index := l_index + 1
				end
			end
			Result := operand_position_name_table_cache
			set_summarization_availability (Result /= Void)
		end

	pre_state: EPA_STATE
			-- Object state before testing.
		require
			summarization_available: is_summarization_available
		do
			if pre_state_cache = Void then
				pre_state_cache := state_from_string (pre_state_str)
			end
			Result := pre_state_cache
			set_summarization_availability (Result /= Void)
		end

	post_state: EPA_STATE
			-- Object state after testing.
		require
			summarization_available: is_summarization_available
		do
			if post_state_cache = Void then
				post_state_cache := state_from_string (post_state_str)
			end
			Result := post_state_cache
			set_summarization_availability (Result /= Void)
		end

	target: ITP_VARIABLE
			-- Target of the test case.
		require
			test_case_attached: test_case /= Void
			summarization_available: is_summarization_available
		do
			Result := test_case.target
			set_summarization_availability (Result /= Void)
		end

	context: EPA_CONTEXT
			-- Context for type checking the expressions in pre/post_states.
		do
			if context_cache = Void then
				create context_cache.make_with_variable_names (operand_name_type_in_string_table)
			end
			Result := context_cache
		end

feature -- Status report

	is_summarization_available: BOOLEAN assign set_summarization_availability
			-- Is summarization resolution successful so far?
			-- After each lazy evaluation, this status can be set to 'False' if the information is not available.
			-- And the this change is irreversible.

	is_execution_successful: BOOLEAN
			-- Is the execution successful?
		do
			Result := trace_str.is_empty
		end

	is_feature_query: BOOLEAN
			-- Is the feature under test a query?
		do
			Result := test_case_cache.feature_to_call.type /= void_type
		end

	is_feature_creation: BOOLEAN
			-- Is the feature under test a creation feature?
        local
        	l_creators: HASH_TABLE[EXPORT_I, STRING]
		do
        	l_creators := test_case.class_of_target_type.creators
        	if l_creators = Void and then feature_.feature_name ~ "default_create"
        			or else l_creators /= Void and then l_creators.has (feature_.feature_name) then
        		Result := True
        	else
        		Result := False
        	end
		end

feature -- Status set

	set_summarization_availability (a_status: BOOLEAN)
			-- Set `is_summarization_available' with 'a_status'.
		do
			is_summarization_available := a_status
		end

feature{NONE} -- Implementation

	operand_type_table_cache: detachable like operand_type_table
			-- Cache for `operand_type_table'.

	operand_name_type_in_string_table_cache: detachable like operand_name_type_in_string_table
			-- Cache for `operand_name_type_in_string_table'.

	operand_position_name_table_cache: detachable like operand_position_name_table
			-- Cache for `operand_position_name_table'.

	context_cache: detachable like context
			-- Cache for `context'

	pre_state_cache: detachable EPA_STATE
			-- Cache for `pre_state'.

	post_state_cache: detachable EPA_STATE
			-- Cache for `post_state'.

	test_case_cache: detachable AUT_CALL_BASED_REQUEST
			-- Cache for `test_case'.

	reset_cache
			-- Reset all cached data.
		do
			operand_type_table_cache := Void
			operand_name_type_in_string_table_cache := Void
			operand_position_name_table_cache := Void
			context_cache := Void
			pre_state_cache := Void
			post_state_cache := Void
			test_case_cache := Void
		end

	variable_type_table_from_declaration (a_var_str: STRING): like operand_type_table
			-- Resolve the variables and their types from multiple lines of variable declaration.
		require
			is_summarization_available: is_summarization_available
			var_str_attached: a_var_str /= Void
		local
			l_str: STRING
			l_list: LIST [STRING]
			l_line: STRING
			l_var_name: STRING
			l_type_str: STRING
			l_start_index, l_end_index: INTEGER
			l_var: ITP_VARIABLE
			l_index: INTEGER
			l_type: TYPE_A
			l_table: like operand_type_table
		do
			l_str := a_var_str

			-- Split types into lines of declarations
			l_str.prune_all ('%R')
			l_str.prune_all_leading ('%N')
			l_str.prune_all_trailing ('%N')
			l_list := l_str.split ('%N')

			-- Analyze variables and their types.
			from
				-- Make sure the table has size at least 1.
				create l_table.make (l_list.count + 1)
				l_table.compare_objects
				l_list.start
			until
				l_list.after
			loop
				l_line := l_list.item_for_iteration
				if not l_line.is_empty then
					l_end_index := l_line.index_of (':', 1)

					-- Variable.
					l_var_name := l_line.substring (1, l_end_index - 1)
					l_var_name.prune_all (' ')
					l_index := variable_index (l_var_name, variable_name_prefix)

					-- Type.
					l_type_str := l_line.substring (l_end_index + 1, l_line.count)
					l_type_str.prune_all (' ')
					l_type := base_type (l_type_str)

					create l_var.make (l_index)
					l_table.put (l_type, l_var)
				end

				l_list.forth
			end

			Result := l_table
		end

	state_from_string (a_state_string: STRING): EPA_STATE
			-- State from state string.
		require
			operand_type_table_attached: operand_type_table /= Void
		local
			l_context: like context
			l_exp_type: TYPE_A
			l_valid_exp: BOOLEAN
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
		do
			l_context := context
			l_str := a_state_string.twin

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
					l_valid_exp := True
					-- Object state.
					l_start_index := 4
					l_end_index := l_line.last_index_of ('=', l_line.count) - 1

					if l_end_index /= -1 then
						-- Prepend "var." to the expression
						l_exp_str := l_var_name.twin
						l_exp_str.append (once ".")
						l_exp_str.append (l_line.substring (l_start_index, l_end_index))
						l_exp_type := l_context.expression_text_type (l_exp_str)
						create l_expr.make_with_text_and_type (l_context.class_, l_context.feature_, l_exp_str, l_context.class_, l_exp_type)

						-- Value of the expression.
						l_start_index := l_end_index + 2
						l_val_str := l_line.substring (l_start_index, l_line.count)
						l_val_str.prune_all (' ')

						if l_val_str ~ once "[[Error]]" then
							-- For example: "--|valid_index_set = [[Error]]"
							l_valid_exp := False
						elseif l_val_str.is_integer then
							create {EPA_INTEGER_VALUE} l_value.make (l_val_str.to_integer)
						elseif l_val_str.is_boolean then
							create {EPA_BOOLEAN_VALUE} l_value.make (l_val_str.to_boolean)
						else
							check not_supported: False end
						end
					elseif l_line.substring_index ("[[Void]]", 1) /= -1 then
						-- "--|[[Void]]"
						l_exp_str := l_var_name.twin
						l_exp_type := l_context.expression_text_type (l_exp_str)
						create l_expr.make_with_text_and_type (l_context.class_, l_context.feature_, l_exp_str, l_context.class_, l_exp_type)
						create {EPA_VOID_VALUE} l_value.make
					end

					-- Store the <expr, value> pair
					if l_valid_exp and then not l_equations.has (l_expr) then
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

			create Result.make_from_expression_value (l_equations, class_, feature_)
		end

	test_case_from_string (a_string: STRING): AUT_CALL_BASED_REQUEST
			-- Get the test case from its string representation.
		local
			l_parser: AUT_REQUEST_PARSER
			l_input: STRING
			l_request: AUT_REQUEST
		do
			l_input := ":execute "
			l_input.append (a_string)

			create l_parser.make (system, create {AUT_ERROR_HANDLER}.make (system))
			l_parser.set_input (l_input)
			l_parser.parse

			if not l_parser.has_error and then attached {AUT_CALL_BASED_REQUEST} l_parser.last_request as lt_call then
				-- Explictly set the target type, which will be needed when finding out the 'feature_to_call'.
				if attached {AUT_INVOKE_FEATURE_REQUEST}lt_call as lt_invoke then
					lt_invoke.set_target_type (base_type (operand_name_type_in_string_table[lt_invoke.target.name (variable_name_prefix)]))
				end
				Result := lt_call
			else
				check bad_feature_call: False end
			end
		end

	key_to_hash: DS_LINEAR [INTEGER]
			-- <Precursor>
		local
			l_list: DS_ARRAYED_LIST [INTEGER]
		do
			create l_list.make (3)
			l_list.force_last (class_.hash_code)
			l_list.force_last (feature_.feature_name_id)

			Result := l_list
		end


;note
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
