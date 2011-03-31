note
	description: "Pre-state predicate reductor by calling some features"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_STATE_CHANGING_PRECONDITION_REDUCTOR

inherit
	AUT_PRECONDITION_REDUCTOR

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
		do
				-- Retrieve objects that satisfy partial state predicate.
			select_current_partial_predicate
			l_partial_state := current_partial_predicate.partial
			l_unsatisfied_state := current_partial_predicate.dropped
			l_transition_candidates := transitions_to_satisfy_predicate (l_unsatisfied_state)
			set_should_quit (l_transition_candidates.is_empty)
			if not should_quit then
				retrieve_object_combinations
				set_should_quit (object_combinations.is_empty)
				if not should_quit then
						-- Search for transitions that can satisfy the unsatisfied part of the state `l_unsatisfied_state'.
					across l_transition_candidates as l_transitions until should_quit loop
							-- Try to call the selected feature once.
						create l_trans.make
						l_trans.extend (l_transitions.item)
						try_to_satisfy_current_property_by_calling_features (l_trans)

							-- Try to call the selected feature twice.
						if not is_reduction_successful then
							create l_trans.make
							l_trans.extend (l_transitions.item)
							l_trans.extend (l_transitions.item)
							try_to_satisfy_current_property_by_calling_features (l_trans)
						end
					end
				end
			end
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
		do
			l_class := a_predicate.class_
			l_feature := a_predicate.feature_
			l_written_class := a_predicate.written_class

			create l_operand_map.make (1)
			create l_operand.make_with_text (l_class, l_feature, "Current", l_written_class)
			l_operand_map.force_last (0, l_operand)

			create Result.make
			Result.extend (["back", l_operand_map])
			create Result.make
		end

	transitions (a_preconditions: LINKED_LIST [STRING]; a_postconditions: LINKED_LIST [STRING]; a_variables: HASH_TABLE [TYPE_A, STRING]): LINKED_LIST [TUPLE [feature_name: STRING; operand_map: HASH_TABLE [INTEGER, STRING]]]
			--
		do

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
				20)
			object_combinations := object_retriever.last_objects
			update_queryable_id_set (used_queryable_ids, object_combinations)
		end

	calculate_partial_predicates
			-- Calculate `partial_predicates' from `current_predicate'.
		local
			l_analyzer: AUT_EXPRESSION_STRUCTURE_ANALYZER
			l_dnf_components: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
		do
			create partial_predicates.make
			create l_analyzer

			if current_predicate.text.has_substring (" and ") then
				across l_analyzer.partial_components (current_predicate.expression, " and ", 1) as l_parts loop
					partial_predicates.extend ([l_parts.item.remaining_expression, l_parts.item.dropped_components.first])
				end
			elseif current_predicate.text.has_substring (" or ") then
				from
					l_dnf_components := l_analyzer.decomposed_expressions (current_predicate.expression, " or ").new_cursor
					l_dnf_components.start
				until
					l_dnf_components.after
				loop
					partial_predicates.extend ([true_expression, l_dnf_components.item])
					l_dnf_components.forth
				end
			else
				partial_predicates.extend ([true_expression, current_predicate.expression])
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
