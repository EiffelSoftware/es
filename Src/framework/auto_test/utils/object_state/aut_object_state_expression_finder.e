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

	EPA_STRING_UTILITY

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

	object_equality_comparisons: LINKED_LIST [TUPLE [a_variable1: EPA_EXPRESSION; a_variable2: EPA_EXPRESSION]]
			-- List of variable pairs which needs object comparison

	reference_equality_comparisons: LINKED_LIST [TUPLE [a_variable1: EPA_EXPRESSION; a_variable2: EPA_EXPRESSION]]
			-- List of variable pairs which needs reference comparison

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
			create object_equality_comparisons.make
			create reference_equality_comparisons.make
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
			create object_equality_comparisons.make
			create reference_equality_comparisons.make
			variables := a_variables
			create operand_map.make (0)
			create l_finder.make_for_variables (a_variables, Void)
			l_finder.set_should_search_for_query_with_precondition (False)
			l_finder.search (Void)

				-- Analyze result from search.
			analyze_result (l_finder)
		end

	search_for_expressions (a_context_class: CLASS_C; a_feature: FEATURE_I; a_creation: BOOLEAN; a_expressions: LINKED_LIST [EPA_EXPRESSION]; a_root_class: CLASS_C; a_target_type: TYPE_A)
			-- Search for single rooted expression from `a_expressions' in the context of `a_context_class' and `a_feature'.
			-- Make result available in `variable_expressions', `functions_by_target' and `attributes_by_target'.
			-- `a_expressions' are in the form of "Current.has (v)".
			-- `a_creation' indicates if `a_feature' is tested as a creation procedure.
			-- `a_root_class' should be the root class of the interpreter.
			-- `a_target_type' indicates the type of the target of `a_feature'.
		local
			l_operands: like variables_from_feature_signature
			l_mentioned_opds: HASH_TABLE [EPA_EXPRESSION, STRING] -- Keys are operand names, values are operend expressions
			l_curly_expr: STRING
			l_opd_map: DS_HASH_TABLE [STRING, INTEGER]
			l_opd_expr: EPA_AST_EXPRESSION
			l_single_rooted_exprs: like single_rooted_expressions
			l_cursor: DS_HASH_TABLE_CURSOR [TUPLE [variable_indexes: DS_HASH_SET [INTEGER_32]; canonical_form: STRING_8], EPA_EXPRESSION]
			l_opd_indexes: DS_HASH_SET [INTEGER]
			l_subexpr: EPA_EXPRESSION
			l_types: HASH_TABLE [TYPE_A, STRING_8]
			l_opd_name: STRING
			l_opd_index: INTEGER
			l_opd_type: TYPE_A
			l_obj_comp: TUPLE [expression1: EPA_EXPRESSION; expression2: EPA_EXPRESSION]
			l_comp_info: like expression_comparison_info
		do
			l_opd_map := operands_with_feature (a_feature)
			create variable_expressions.make (10)
			variable_expressions.set_equality_tester (expression_equality_tester)
			create functions_by_target.make (10)
			functions_by_target.compare_objects
			create attributes_by_target.make (10)
			attributes_by_target.compare_objects
			create variables.make (10)
			variables.compare_objects
			create operand_map.make (10)
			create object_equality_comparisons.make
			create reference_equality_comparisons.make

			l_operands := variables_from_feature_signature (a_context_class, a_feature, a_root_class, True, a_creation, a_target_type)
			l_types := l_operands.variable_types
			create l_mentioned_opds.make (l_operands.count)
			l_operands.compare_objects

				-- Iterate through all expressions in `a_expressions' and
				-- collect mentioned operands and single-rooted expressions.
			across a_expressions as l_exprs loop
				l_curly_expr := expression_with_curly_braced_operands (a_context_class, a_feature, l_exprs.item)
				across curly_braced_variables_from_expression (l_curly_expr) as l_curly_opds loop
						-- Collect mentioned operand.
					l_opd_name := l_opd_map.item (l_curly_opds.item)
					l_opd_index := l_curly_opds.item
					l_opd_type := l_types.item (l_operands.operand_map.item (l_opd_index))
					create l_opd_expr.make_with_type (a_context_class, a_feature, ast_from_expression_text (l_opd_name), a_context_class, l_opd_type)
					l_mentioned_opds.force (l_opd_expr, l_curly_opds.key)
					variable_expressions.force_last (l_opd_expr)
					variables.force (l_opd_type, l_operands.operand_map.item (l_opd_index))
					operand_map.force (l_operands.operand_map.item (l_opd_index), l_opd_index)
				end

					-- Collect single-rooted expressions, used for
					-- calculating `functions_by_target' and `attributes_by_target'.				
				from
					l_single_rooted_exprs := single_rooted_expressions (l_curly_expr, a_context_class, a_feature)
					l_cursor := l_single_rooted_exprs.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					l_opd_indexes := l_cursor.item.variable_indexes
					l_subexpr := l_cursor.key
					analyze_expression (l_subexpr, a_context_class, a_feature, l_types)
					l_cursor.forth
				end

					-- Collect object comparison expression, and setup
					-- object_comparisons.
				l_comp_info := expression_comparison_info (l_exprs.item, True)
				across l_comp_info.operands as l_comparisons loop
					l_obj_comp := l_comparisons.item
					if
						not l_obj_comp.expression1.is_constant and then
						not l_obj_comp.expression2.is_constant and then
						not l_obj_comp.expression1.text.has ('(') and then
						not l_obj_comp.expression2.text.has ('(') and then
						not l_obj_comp.expression1.text.has ('.') and then
						not l_obj_comp.expression2.text.has ('.')
					then
						reference_equality_comparisons.extend ([l_obj_comp.expression1, l_obj_comp.expression2])
					end
				end

				l_comp_info := expression_comparison_info (l_exprs.item, False)
				across l_comp_info.operands as l_comparisons loop
					l_obj_comp := l_comparisons.item
					if
						not l_obj_comp.expression1.is_constant and then
						not l_obj_comp.expression2.is_constant and then
						not l_obj_comp.expression1.text.has ('(') and then
						not l_obj_comp.expression2.text.has ('(') and then
						not l_obj_comp.expression1.text.has ('.') and then
						not l_obj_comp.expression2.text.has ('.')
					then
						object_equality_comparisons.extend ([l_obj_comp.expression1, l_obj_comp.expression2])
					end
				end
			end
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

	analyze_expression (a_expression: EPA_EXPRESSION; a_context_class: CLASS_C; a_feature: FEATURE_I; a_operand_types: HASH_TABLE [TYPE_A, STRING])
			-- Analyze `a_expression' in the context of `a_feature' from `a_context_class'.
			-- If `a_expression' is an attribute access, put it into `attributes_by_target'.
			-- If `a_epxression' is an function access, put it into `functions_by_target'.
			-- `a_operand_types' is a hash-table, keys are opernad names such as "Current", "v", values
			-- are their resolved types.
		local
			l_text: STRING
			l_index1: INTEGER
			l_target_name: STRING
			l_feat_name: STRING
			l_target_type: TYPE_A
			l_feat: FEATURE_I
			l_set: DS_HASH_SET [EPA_EXPRESSION]
			l_container: HASH_TABLE [DS_HASH_SET [EPA_EXPRESSION], STRING]
		do

			l_text := a_expression.text.twin
			l_index1 := l_text.index_of ('.', 1)
			if l_index1 > 0 then
				l_target_name := l_text.substring (1, l_index1 - 1)
				if l_text.has ('(') then
					l_feat_name := l_text.substring (l_index1 + 1, l_text.index_of ('(', l_index1 + 1) - 1)
					l_feat_name.left_adjust
					l_feat_name.right_adjust
				else
					l_feat_name := l_text.substring (l_index1 + 1, l_text.count)
				end
				l_target_type := a_operand_types.item (l_target_name)
				if attached {CLASS_C} l_target_type.associated_class as l_class then
					l_feat := l_class.feature_named (l_feat_name)
					if l_feat /= Void and then l_feat.has_return_value then
						if l_feat.is_attribute or l_feat.is_constant then
							l_container := attributes_by_target
						else
							l_container := functions_by_target
						end
						l_container.search (l_target_name)
						if l_container.found then
							l_set := l_container.found_item
						else
							create l_set.make (10)
							l_set.set_equality_tester (expression_equality_tester)
							l_container.force (l_set, l_target_name)
						end
						l_set.force_last (a_expression)
					end
				end
			end
		end

	expression_comparison_info (a_expr: EPA_EXPRESSION; a_for_reference: BOOLEAN):
		TUPLE [operands: LINKED_LIST [TUPLE [expression1: EPA_EXPRESSION; expression2: EPA_EXPRESSION]];
		       expressions: LINKED_LIST [TUPLE [expression1: EPA_EXPRESSION; expression2: EPA_EXPRESSION]]]
			-- Information if `a_expr' is an object (in)equality comparision between two expressions
			-- `expression1' and `expression2' are the two expressions involved in the comparison.
		local
			l_equal_ast: BIN_TILDE_AS
			l_inequal_ast: BIN_NOT_TILDE_AS
			l_left, l_right: detachable EXPR_AS
			l_is_equal: BOOLEAN
			l_left_expr, l_right_expr: EPA_AST_EXPRESSION
			l_finder: EPA_OPERAND_COMPARISON_FINDER
		do
			create l_finder
			if a_for_reference then
				l_finder.find_reference_comparisons (a_expr, a_expr.class_, a_expr.feature_)
			else
				l_finder.find_object_comparisons (a_expr, a_expr.class_, a_expr.feature_)
			end
			Result := [l_finder.last_comparisons, l_finder.last_feature_value_comparisons]
--			if attached {BIN_TILDE_AS} a_expr.ast as l_equal then
--				l_is_equal := True
--				l_left := l_equal.left
--				l_right := l_equal.right
--			elseif attached {BIN_NOT_TILDE_AS} a_expr.ast as l_inequal then
--				l_is_equal := False
--				l_left := l_inequal.left
--				l_right := l_inequal.right
--			end
--			if l_left /= Void and then l_right /= Void then
--				create l_left_expr.make_with_feature (a_expr.class_, a_expr.feature_, l_left, a_expr.written_class)
--				create l_right_expr.make_with_feature (a_expr.class_, a_expr.feature_, l_right, a_expr.written_class)
--				Result := [l_left_expr, l_right_expr, l_is_equal]
--			end
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
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
