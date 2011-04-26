note
	description: "Pre-state predicate reductor by calling some features"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_STATE_CHANGING_PRECONDITION_REDUCTOR

inherit
	AUT_PRECONDITION_REDUCTOR

	EPA_STRING_UTILITY
		undefine
			system
		end

create
	make

feature -- Status report

	has_next_step: BOOLEAN
			-- Does `Current' have a next step to execute?			
		do
			Result := not should_quit and not is_reduction_successful and not partial_predicates.is_empty
		end

feature -- Execution

	start
			-- Start execution of task.
		do
			create true_expression.make_with_text (current_predicate.expression.class_, current_predicate.expression.feature_, "True", current_predicate.expression.written_class)
			calculate_partial_predicates
			set_should_quit (partial_predicates.is_empty)
			set_is_reduction_successful (False)
		end

	step
			-- Perform a next step.
		local
			l_partial_state: EPA_EXPRESSION
			l_unsatisfied_state: EPA_EXPRESSION
			l_trans: LINKED_LIST [TUPLE [feature_name: STRING_8; operand_map: DS_HASH_TABLE [INTEGER_32, EPA_EXPRESSION]]]
			l_transition_candidates: LINKED_LIST [TUPLE [feature_name: STRING_8; operand_map: DS_HASH_TABLE [INTEGER_32, EPA_EXPRESSION]]]
			l_skip: BOOLEAN
		do
				-- Retrieve objects that satisfy partial state predicate.
			select_current_partial_predicate
			l_partial_state := current_partial_predicate.partial
			l_unsatisfied_state := current_partial_predicate.dropped
			l_transition_candidates := transitions_to_satisfy_predicate (l_unsatisfied_state)
			if not should_quit and then not l_transition_candidates.is_empty then
				retrieve_object_combinations
				if not should_quit and then not object_combinations.is_empty then
						-- Search for transitions that can satisfy the unsatisfied part of the state `l_unsatisfied_state'.
					across l_transition_candidates as l_transitions until should_quit loop
							-- Try to call the selected feature once.
						create l_trans.make
						l_trans.extend (l_transitions.item)
						if l_transitions.item.feature_name.is_empty then
							l_skip := False
							across 1 |..| 3 as l_times until l_skip or should_quit loop
								try_to_satisfy_current_property_by_calling_features (l_trans)
								restart_interpreter_when_necessary
							end
						else
							try_to_satisfy_current_property_by_calling_features (l_trans)
							restart_interpreter_when_necessary
						end

--							-- Try to call the selected feature twice.
--						if not is_reduction_successful then
--							create l_trans.make
--							l_trans.extend (l_transitions.item)
--							l_trans.extend (l_transitions.item)
--							try_to_satisfy_current_property_by_calling_features (l_trans)
--						end
					end
				end
			end
			restart_interpreter_when_necessary
		end

	cancel
			-- Abort current execution.
		do
			set_should_quit (True)
		end

	try_to_satisfy_current_property_by_calling_features (a_features: LINKED_LIST [TUPLE [feature_name: STRING_8; operand_map: DS_HASH_TABLE [INTEGER_32, EPA_EXPRESSION]]])
			-- Try to call `a_features' in order to satisfy `current_predicate'.
		local
			l_satisfier: AUT_PRESTATE_PREDICATE_SATISFIER
		do
			create l_satisfier.make_with_transition (system, interpreter, error_handler, current_predicate, object_combinations, a_features)
			execute_task (l_satisfier)
			if l_satisfier.is_current_predicate_satisfied then
				set_is_reduction_successful (True)
				set_should_quit (True)
			end
		end

feature{NONE} -- Implementation

	transitions_to_satisfy_predicate (a_predicate: EPA_EXPRESSION): LINKED_LIST [TUPLE [feature_name: STRING; operand_map: DS_HASH_TABLE [INTEGER, EPA_EXPRESSION]]]
			-- Features that might be used to satisfy `a_predicate'.
			-- Result is a list of features. `feature_name' is the name of the feature.
			-- `operand_map' is a hash-table, keys are variable expressions from `a_predicate', and
			-- values are 0-based operand indexes of the feature.
			-- For example, if `a_predicate' is "l.has (v)", and the result has a feature named "extend",
			-- then in `operand_map': "l" -> 0, and "v" -> 1.
		local
			l_operand_map: DS_HASH_TABLE [INTEGER, EPA_EXPRESSION]
			l_operand: EPA_AST_EXPRESSION
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_written_class: CLASS_C

			l_transition_finder: AUT_TRANSITION_FINDER
			l_preconditions: LINKED_LIST [STRING]
			l_postconditions: LINKED_LIST [STRING]
			l_variables: HASH_TABLE [TYPE_A, STRING]

			l_curly_expr: STRING
			l_subexprs: like single_rooted_expressions
			l_subexpr_cursor: DS_HASH_TABLE_CURSOR [TUPLE [variable_indexes: DS_HASH_SET [INTEGER]; canonical_form: STRING], EPA_EXPRESSION]
			l_qualified_calls: INTEGER
			l_qualified_call: EPA_EXPRESSION
			l_ast: EXPR_AS
			l_ast2: EXPR_AS
			l_precondition_str: STRING
			l_postcondition_str: STRING
			l_operand_names: like operands_with_feature
			l_operand_types: like resolved_operand_types_with_feature
			l_opd_name: STRING
			l_opd_type: TYPE_A
			l_opd_index: INTEGER
			l_target_name: STRING
			l_index: INTEGER
			l_class_name: STRING
			l_text: STRING
			l_target_class: CLASS_C
		do

			create Result.make
			if not a_predicate.text.has ('.') and then a_predicate.text.has ('~') and then a_predicate.text.has_substring (once "not") then
				Result.extend (["", Void])
			else
				l_class := a_predicate.class_
				l_feature := a_predicate.feature_
				l_written_class := a_predicate.written_class

				l_curly_expr := expression_with_curly_braced_operands (l_class, l_feature, a_predicate)

					-- Find out the qualified call in `a_predicate'.
				l_subexprs := single_rooted_expressions (l_curly_expr, l_class, l_feature)
				from
					l_subexpr_cursor := l_subexprs.new_cursor
					l_subexpr_cursor.start
				until
					l_subexpr_cursor.after
				loop
					if l_subexpr_cursor.key.text.has ('.') then
						l_qualified_calls := l_qualified_calls + 1
						l_qualified_call :=l_subexpr_cursor.key
					end
					l_subexpr_cursor.forth
				end

					-- We only handle the case where there is a single qualified call in `a_predicate'.
				if l_qualified_calls = 1 then
					l_ast := ast_without_surrounding_paranthesis (a_predicate.ast)
						-- Handle double negation in form of "not (not xxx))"
					if attached {UN_NOT_AS} l_ast as l_not then
						l_ast2 := ast_without_surrounding_paranthesis (l_not.expr)
						if attached {UN_NOT_AS} l_ast2 as l_not2 then
							l_ast := ast_without_surrounding_paranthesis (l_not2.expr)
						end
					end

					l_operand_names := operands_with_feature (l_feature)
					l_operand_types := resolved_operand_types_with_feature (l_feature, l_class, l_class.constraint_actual_type)

					if attached {UN_NOT_AS} l_ast as l_not then
							-- Negation.
						if attached {BIN_EQ_AS} l_not.expr as l_equation and then attached {INTEGER_AS} l_equation.right then
								-- not (expr = int)
							l_precondition_str := "True"
							l_postcondition_str := l_qualified_call.text + " >= old " + l_qualified_call.text
						else
								-- not (expr)
							l_precondition_str := l_qualified_call.text.twin
							l_postcondition_str := "not " + l_qualified_call.text
						end
					else
						if attached {BIN_EQ_AS} l_ast as l_equation and then attached {INTEGER_AS} l_equation.right then
								-- expr = int
							l_precondition_str := "True"
							l_postcondition_str := l_qualified_call.text + " >= old " + l_qualified_call.text
						else
								-- expr
							l_precondition_str := "not " + l_qualified_call.text
							l_postcondition_str := l_qualified_call.text.twin
						end
					end
					create l_variables.make (3)
					l_variables.compare_objects
					l_text := l_qualified_call.text.twin
					across 0 |..| 9 as l_indexes loop
						l_text.replace_substring_all ({ITP_SHARED_CONSTANTS}.variable_name_prefix + l_indexes.item.out, curly_brace_surrounded_integer (l_indexes.item))
					end
					across curly_braced_variables_from_expression (l_text) as l_operands loop
						l_opd_index := l_operands.item
						l_opd_name := l_operand_names.item (l_opd_index)
						l_opd_type := l_operand_types.item (l_opd_index)
						l_variables.force (l_opd_type, l_opd_name)
					end

					l_index := l_qualified_call.text.index_of ('.', 1)
					l_target_name := l_qualified_call.text.substring (1, l_index - 1)
					l_target_name.remove_head (2)
					l_target_class := l_variables.item (l_operand_names.item (l_target_name.to_integer)).associated_class
					l_class_name := output_type_name (l_target_class.name_in_upper)

					create l_preconditions.make
					l_preconditions.extend (l_precondition_str)
					create l_postconditions.make
					l_postconditions.extend (l_postcondition_str)

					if not connection.is_connected then
						connection.reinitialize
					end
					create l_transition_finder.make (l_variables, l_preconditions, l_postconditions, connection)
					l_transition_finder.set_log_manager (query_log_manager)
					l_transition_finder.set_class_name (l_class_name)
					l_transition_finder.find
					Result := transitions (l_class, l_feature, l_target_class, l_transition_finder.last_transitions)
				end
			end
		end

	transitions (a_class: CLASS_C; a_feature: FEATURE_I; a_feature_target_class: CLASS_C; a_transitions: LINKED_LIST [TUPLE [feature_name: STRING_8; operand_map: HASH_TABLE [INTEGER_32, STRING_8]]]): LINKED_LIST [TUPLE [feature_name: STRING; operand_map: DS_HASH_TABLE [INTEGER, EPA_EXPRESSION]]]
			--
		local
			l_opd_names: like operand_name_index_with_feature
			l_opd_count: INTEGER
			l_opd_exprs: like operand_expressions_with_feature
			l_feat_name: STRING
			l_feat: FEATURE_I
			l_feat_call_id: STRING
			l_opd_map: HASH_TABLE [INTEGER, STRING]
			l_opd_name: STRING
			l_opd_index: INTEGER
			l_callee_opd_count: INTEGER
			l_callee_opd_index: INTEGER
			l_added: DS_HASH_SET [STRING]
			l_table: DS_HASH_TABLE [INTEGER, EPA_EXPRESSION]
			l_parts: LIST [STRING]
			l_str: STRING
			l_referenced: INTEGER
		do
			create Result.make
			l_opd_names := operand_name_index_with_feature (a_feature, a_class)
			l_opd_exprs := operand_expressions_with_feature (a_class, a_feature)
			l_opd_count := a_feature.argument_count
			create l_added.make (10)
			l_added.set_equality_tester (string_equality_tester)
			across a_transitions as l_trans loop
				l_feat_name := l_trans.item.feature_name
				l_feat := a_feature_target_class.feature_named (l_feat_name)
				if l_feat /= Void and then not l_feat.has_return_value then
					l_callee_opd_count := l_feat.argument_count
					l_opd_map :=  l_trans.item.operand_map
					create l_feat_call_id.make (64)
					l_feat_call_id.append (l_feat_name)
					l_feat_call_id.append_character (';')
					l_referenced := 0
					across 0 |..| l_opd_count as l_opd_indexes loop
						l_opd_index := l_opd_indexes.item
						l_opd_name := l_opd_names.item (l_opd_index)
						l_opd_map.search (l_opd_name)
						if l_opd_map.found and then l_opd_map.found_item <= l_callee_opd_count then
							l_feat_call_id.append_integer (l_opd_index)
							l_feat_call_id.append_character ('_')
							l_feat_call_id.append_integer (l_opd_map.found_item)
							l_referenced := l_referenced + 1
						else
							l_feat_call_id.append_integer (l_opd_index)
							l_feat_call_id.append_character ('_')
							l_feat_call_id.append_character ('x')
						end
						l_feat_call_id.append_character (';')
					end
					if l_referenced > 0 then
						l_added.search (l_feat_call_id)
						if not l_added.found then
							l_added.force_last (l_feat_call_id)
							create l_table.make (5)
							l_table.set_key_equality_tester (expression_equality_tester)
							l_parts := l_feat_call_id.split (';')
							l_parts.start
							l_parts.remove
							from
								l_parts.start
							until
								l_parts.after
							loop
								l_str := l_parts.item_for_iteration
								if not l_str.is_empty then
									if l_str.substring (3, 3).is_integer then
										l_opd_index := l_str.substring (1, 1).to_integer
										l_callee_opd_index := l_str.substring (3, 3).to_integer
										l_table.force_last (l_callee_opd_index, l_opd_exprs.item (l_opd_index))
									end
								end
								l_parts.forth
							end
							Result.extend ([l_feat_name, l_table])
						end
					end
				end
			end
		end

	object_combinations: LINKED_LIST [SEMQ_RESULT]
			-- Objects that satisfy the partial predicate from `current_partial_predicate'

	current_partial_predicate: TUPLE [partial: EPA_EXPRESSION; dropped: EPA_EXPRESSION]
			-- Current partial predicate to try out

	partial_predicates: LINKED_LIST [TUPLE [partial: EPA_EXPRESSION; dropped: EPA_EXPRESSION]]
			-- Partial predicates from `current_predicate'
			-- `partial' is the remaining part from `current_predicate' and `dropped' is the dropped part.
			-- `dropped' is the part to satisfy by calling some state-changing commands.

feature{NONE} -- Implementation

	true_expression: EPA_AST_EXPRESSION
			-- True expression

	retrieve_object_combinations
			-- Retrieve `object_combinations' from semantic database			
		do
			object_retriever.retrieve_objects (
				current_partial_predicate.partial,
				current_predicate.context_class,
				current_predicate.feature_,
				True,
				True,
				connection,
				used_queryable_ids,
				False,
				10, False) -- We only retrieve 10 object combinations because transitions are expensive, we don't want so many calls.
			object_combinations := object_retriever.last_objects
			update_queryable_id_set (used_queryable_ids, object_combinations)
		end

	calculate_partial_predicates
			-- Calculate `partial_predicates' from `current_predicate'.
		local
			l_assertions: ARRAY [EPA_EXPRESSION]
			l_preconditions: LINKED_LIST [EPA_EXPRESSION]
			l_expr: EPA_EXPRESSION
			l_partial: like partialness_of_expression
			l_parts: LINKED_LIST [EPA_EXPRESSION]
			i: INTEGER
		do
			create partial_predicates.make

				-- Collect preconditions of `feature_' and `current_predicate' together,
				-- and treat them equally. Because we may be able to first drop some precondition
				-- assertion and then satisfy it by calling some feature later.
			l_preconditions := qualified_preconditions (feature_, class_).twin
			from
				l_preconditions.start
			until
				l_preconditions.after
			loop
				if l_preconditions.item.text.has_substring (once "(1)") then
					l_preconditions.remove
				else
					l_preconditions.forth
				end
			end
			create l_assertions.make (1, l_preconditions.count + 1)
			i := 1
			across l_preconditions as l_pres loop
				l_assertions.put (l_pres.item, i)
				i := i + 1
			end
			l_assertions.put (current_predicate.expression, i)

				-- Iterate through all collected assertions and try to drop part of it one by one.
			across 1 |..| l_assertions.upper as l_indexes loop
				l_expr := l_assertions.item (l_indexes.item)
					-- We don't drop expressions mentioning Void.
				if not l_expr.text.has_substring (once "Void") then
					across partialness_of_expression (l_expr) as l_partials loop
						create l_parts.make
						l_parts.extend (l_partials.item.partial)
						across 1 |..| l_assertions.upper as l_indexes2 loop
							 if l_indexes2.item /= l_indexes.item then
							 	l_parts.extend (l_assertions.item (l_indexes2.item))
							 end
						end
						partial_predicates.extend ([anded_expression (class_, feature_, class_, l_parts), l_partials.item.dropped])
					end
				end
			end
		end

	anded_expression (a_class: CLASS_C; a_feature: FEATURE_I; a_written_class: CLASS_C; a_expressions: LINKED_LIST [EPA_EXPRESSION]): EPA_EXPRESSION
			-- An expression with all components in `a_expressions' anded together
		local
			l_text: STRING
		do
			if a_expressions.count = 1 then
				Result := a_expressions.first
			else
				create l_text.make (128)
				across a_expressions as l_exprs loop
					if not l_text.is_empty then
						l_text.append (" and ")
					end
					l_text.append_character ('(')
					l_text.append (l_exprs.item.text)
					l_text.append_character (')')
				end
				create {EPA_AST_EXPRESSION} Result.make_with_text (a_class, a_feature, l_text, a_written_class)
			end
		end

	partialness_of_expression (a_expr: EPA_EXPRESSION): LINKED_LIST [TUPLE [partial: EPA_EXPRESSION; dropped: EPA_EXPRESSION]]
			-- Partialness information from `a_expr'.
		local
			l_analyzer: AUT_EXPRESSION_STRUCTURE_ANALYZER
			l_dnf_components: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
		do
			create l_analyzer
			create Result.make
			if a_expr.text.has_substring (" and ") then
				across l_analyzer.partial_components (a_expr, " and ", 1) as l_parts loop
					Result.extend ([l_parts.item.remaining_expression, l_parts.item.dropped_components.first])
				end
			elseif a_expr.text.has_substring (" or ") then
				from
					l_dnf_components := l_analyzer.decomposed_expressions (a_expr, " or ").new_cursor
					l_dnf_components.start
				until
					l_dnf_components.after
				loop
					Result.extend ([true_expression, l_dnf_components.item])
					l_dnf_components.forth
				end
			else
				Result.extend ([true_expression, a_expr])
			end

		end

	qualified_preconditions (a_feature: FEATURE_I; a_class: CLASS_C): LINKED_LIST [EPA_EXPRESSION]
			-- List of preconditions from `a_feature'
			-- All the returned preconditions are qualified, i.e., "not Current.off" instead of "not off".
		local
			l_qualifier: EPA_EXPRESSION_QUALIFIER
			l_extractor: EPA_CONTRACT_EXTRACTOR
			l_pre_str: STRING
			l_pre_expr: EPA_AST_EXPRESSION
		do
			create Result.make
			create l_qualifier
			create l_extractor
			across l_extractor.precondition_of_feature (a_feature, a_class) as l_pres loop
				l_qualifier.qualify_only_current (l_pres.item)
				l_pre_str := l_qualifier.last_expression
				create l_pre_expr.make_with_text (l_pres.item.class_, l_pres.item.feature_, l_pre_str, l_pres.item.written_class)
				Result.extend (l_pre_expr)
			end
		end

	select_current_partial_predicate
			-- Select next `current_partial_predicate' from `partial_predicates'.
		do
			current_partial_predicate := partial_predicates.first
			partial_predicates.start
			partial_predicates.remove
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
