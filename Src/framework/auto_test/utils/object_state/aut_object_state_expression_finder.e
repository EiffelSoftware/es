note
	description: "Class to collect expressions that can be used to abstract a set of objects"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_OBJECT_STATE_EXPRESSION_FINDER

inherit
	EPA_UTILITY

	EPA_SHARED_EQUALITY_TESTERS

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize.
		do
		end

feature -- Access

	variable_expressions: DS_HASH_SET [EPA_EXPRESSION]
			-- Expressions for `variables'

	functions_by_target: HASH_TABLE [DS_HASH_SET [EPA_EXPRESSION], STRING]
			-- Table of function expressions by their target variable
			-- Key is the variale name, value is the set of expressions of the same target.
			-- Each expression must be a qualified call, for example "v_1.exhausted".

	attributes_by_target: HASH_TABLE [DS_HASH_SET [EPA_EXPRESSION], STRING]
			-- Table of attribute expressions by their target variable
			-- Key is the variale name, value is the set of expressions of the same target.
			-- Each expression must be a qualified call, for example "v_1.count".

	variables: HASH_TABLE [TYPE_A, STRING]
			-- Table of variables found by last `search_for_feature'
			-- Key is variable name, value is the resolved type of that variable

	operand_map: DS_HASH_TABLE [STRING, INTEGER]
			-- Operand map for `variables'
			-- Key is 0-based operand index, key is variable name

feature -- Basic operations

	search_for_feature (a_context_class: CLASS_C; a_feature: FEATURE_I; a_prestate: BOOLEAN; a_is_creation: BOOLEAN; a_root_class: CLASS_C; a_target_type: TYPE_A)
			-- Search for expressions, make results avaiable in `expressions'.
			-- The expressions are related to `a_feature' viewed in `a_context_class'.
			-- `a_prestate' indicates whether the found expressions are to be evaluated before
			-- the execution of the test case. This is important because expressions such as "Result"
			-- does not make sense to be evaluated before the test case execution.
			-- `a_is_creation' indicates if `a_feature' is used as a creation procedure.
			-- `a_root_class' should be the root class of the interpreter.
			-- `a_target_type' indicates the type of the target of `a_feature'.
		local
			l_finder: EPA_TYPE_BASED_FUNCTION_FINDER
			l_data: like variables_from_feature_signature
		do
			l_data := variables_from_feature_signature (a_context_class, a_feature, a_context_class, a_prestate, a_is_creation, a_target_type)
			variables := l_data.variable_types
			operand_map := l_data.operand_map

				-- Search for expressions.
			create l_finder.make_for_variables (variables, Void)
			l_finder.set_should_search_for_query_with_precondition (False)
			l_finder.search (Void)
				-- Analyze result from search.
			analyze_result (l_finder)
		end

	search_for_variables (a_variables: HASH_TABLE [TYPE_A, STRING])
			-- Search expressions among `a_variables'.
			-- `a_variable' is a table, key is variable name, value is variable type.
		local
			l_finder: EPA_TYPE_BASED_FUNCTION_FINDER
			l_context: EPA_CONTEXT
		do
			variables := a_variables
			create operand_map.make (0)
			create l_finder.make_for_variables (a_variables, Void)
			l_finder.set_should_search_for_query_with_precondition (False)
			l_finder.search (Void)

				-- Analyze result from search.
			analyze_result (l_finder)
		end

feature{NONE} -- Implementation

	variables_from_feature_signature (a_context_class: CLASS_C; a_feature: FEATURE_I; a_root_class: CLASS_C; a_pre_state: BOOLEAN; a_creation: BOOLEAN; a_target_type: TYPE_A): TUPLE [variable_types: HASH_TABLE [TYPE_A, STRING]; operand_map: DS_HASH_TABLE [STRING, INTEGER]]
			-- Variables extracted from the signature of `a_feature' viewed in `a_context_class'.
			-- `a_root_class' is the root class of the interpreter.
			-- The result is a table. Key is variable name, value is the type of that variable.
			-- `a_pre_state' indicates if the variables are retrieved before the execution of the test case.
			-- `a_creation' indicates if `a_feature' is used as a creation procedure.
		local
			l_operands: like operand_types_with_feature
			l_operand_names: like operands_with_feature
			l_variables: HASH_TABLE [TYPE_A, STRING]
			l_operand_map: DS_HASH_TABLE [STRING, INTEGER]
			l_index: INTEGER
			l_var_name: STRING
			l_result_pos: INTEGER
			l_query: BOOLEAN
		do
			l_operands := resolved_operand_types_with_feature (a_feature, a_context_class, a_target_type)
			l_operand_names := operands_with_feature (a_feature)
			create l_variables.make (l_operands.count)
			l_variables.compare_objects
			create l_operand_map.make (l_operands.count)
			from
				l_query := a_feature.has_return_value
				l_result_pos := l_operands.count - 1
				l_operands.start
			until
				l_operands.after
			loop
				l_index := l_operands.key_for_iteration

				if a_pre_state implies (not (a_creation and l_index = 0) and not (l_query and l_index = l_result_pos)) then
					l_var_name := variable_name (l_index)
					l_variables.put (l_operands.item_for_iteration, l_var_name)
					l_operand_map.force_last (l_var_name, l_index)
				end
				l_operands.forth
			end
			Result := [l_variables, l_operand_map]
		end

	variable_name (a_index: INTEGER): STRING
			-- Variable name for object with index `a_index'.
		do
			create Result.make (5)
			Result.append (once "v_")
			Result.append (a_index.out)
		end

	analyze_result (a_finder: EPA_TYPE_BASED_FUNCTION_FINDER)
			-- Analyze results from `a_finder'.
		local
			l_func: EPA_FUNCTION
			l_variables: like variables
			l_functions: DS_HASH_SET [EPA_FUNCTION]
			l_index: INTEGER
			l_target_var: STRING
			l_expr_by_target: like functions_by_target
			l_attr_by_target: like attributes_by_target
			l_grouped_exprs: DS_HASH_SET [EPA_EXPRESSION]
			l_variable_exprs: like variable_expressions
			l_cursor: DS_HASH_SET_CURSOR [EPA_FUNCTION]
			l_message: STRING
			l_body: STRING
			l_dest: detachable like functions_by_target
			l_feat: FEATURE_I
			l_context: EPA_CONTEXT
		do
			l_variables := variables
			create l_context.make (variables)
			l_functions := a_finder.argumentless_functions.union (a_finder.composed_functions)


				-- Setup `expressoins_by_target'.
			create functions_by_target.make (l_variables.count)
			l_expr_by_target := functions_by_target
			l_expr_by_target.compare_objects
			create attributes_by_target.make (l_variables.count)
			l_attr_by_target := attributes_by_target
			l_attr_by_target.compare_objects

			from
				l_functions.start
			until
				l_functions.after
			loop
				l_func := l_functions.item_for_iteration
				check l_func.is_nullary end
					-- We only collect queries of basic type.
				if l_func.result_type.is_basic then
						-- Get the target of `l_func' because `l_func' should be a qualified call.
					l_body := l_func.body
					l_index := l_body.index_of ('.', 1)
					l_target_var := l_body.substring (1, l_index - 1)
					check l_variables.has (l_target_var) end
					l_message := l_body.substring (l_index + 1, l_body.count)

					if l_message.has ('(') then
							-- This is for sure a function.
						l_dest := l_expr_by_target
					else
						l_feat := l_variables.item (l_target_var).associated_class.feature_named (l_message)
						if l_feat.is_constant then
								-- No need to evaluate constants.
							l_dest := Void
						elseif l_feat.is_attribute then
							l_dest := l_attr_by_target
						else
							l_dest := l_expr_by_target
						end
					end

						-- Group expressions based on their qualified target name `l_target_var'.
					if l_dest /= Void then
						l_dest.search (l_target_var)
						if l_dest.found then
							l_grouped_exprs := l_dest.found_item
						else
							create l_grouped_exprs.make (20)
							l_grouped_exprs.set_equality_tester (expression_equality_tester)
							l_dest.put (l_grouped_exprs, l_target_var)
						end
						l_grouped_exprs.force_last (l_func.as_expression (l_context))
					end
				end
				l_functions.forth
			end

				-- Setup `variable_expressions'.
			create variable_expressions.make (l_variables.count)
			l_variable_exprs := variable_expressions
			l_variable_exprs.set_equality_tester (expression_equality_tester)
			from
				l_cursor := a_finder.variable_functions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_variable_exprs.force_last (l_cursor.item.as_expression (l_context))
				l_cursor.forth
			end
		end

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
