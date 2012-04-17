note
	description: "Summary description for {EPA_BEHAVIORAL_MODEL_TRANSITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_BEHAVIORAL_MODEL_TRANSITION

inherit

	HASHABLE
		redefine out, is_equal end

	EPA_UTILITY
		redefine out, is_equal end

	DEBUG_OUTPUT
		redefine out, is_equal end

create
	make, make_from_string

feature -- Initialization

	make (a_feature: EPA_FEATURE_WITH_CONTEXT_CLASS; a_pre_state, a_post_state: EPA_STATE)
			-- Initialize from `a_feature' and two states.
		require
			all_attached: a_feature /= Void and then a_pre_state /= Void and then a_post_state /= Void
			about_same_class: a_pre_state.class_.class_id = a_post_state.class_.class_id
						and then a_feature.context_class.class_id = a_post_state.class_.class_id
			public_argumentless_command: a_feature.is_argumentless_public_command
		do
			transition_feature := a_feature
			summarize_state_changes (a_pre_state, a_post_state)
		end

	make_from_string (a_string: STRING)
			-- Initialize a transition from `a_string', in the same format as from `out'.
		require
			string_not_empty: a_string /= Void and then not a_string.is_empty
		local
			l_start_index, l_end_index: INTEGER
			l_class_name, l_feature_name: STRING
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_pairs: LIST [STRING]
			l_pair, l_query_name, l_value_name: STRING
			l_index: INTEGER
		do
			l_start_index := 1
			l_end_index := a_string.index_of ('.', l_start_index)
			l_class_name := a_string.substring (l_start_index, l_end_index - 1)
			l_class := first_class_starts_with_name (l_class_name)
			l_start_index := l_end_index + 1
			l_end_index := a_string.index_of ('[', l_start_index)
			l_feature_name := a_string.substring (l_start_index, l_end_index - 1)
			l_feature := l_class.feature_named_32 (l_feature_name)
			create transition_feature.make (l_feature, l_class)

			l_start_index := l_end_index + 1
			l_end_index := a_string.count
			l_pairs := a_string.substring (l_start_index, l_end_index - 1).split (';')
			from
				create state_changes.make_equal (l_pairs.count)
				l_pairs.start
			until l_pairs.after
			loop
				l_pair := l_pairs.item_for_iteration
				l_index := l_pair.index_of (':', 1)
				if l_index /= 0 then
					l_query_name := l_pair.substring (1, l_index - 1)
					l_value_name := l_pair.substring (l_index + 1, l_pair.count)
					if l_value_name.is_case_insensitive_equal ("True") then
						state_changes.force (True, l_query_name)
					elseif l_value_name.is_case_insensitive_equal ("False") then
						state_changes.force (False, l_query_name)
					else
						check Should_not_happen: False end
					end
				end
				l_pairs.forth
			end
		end

feature -- Access

	state_changes: DS_HASH_TABLE [BOOLEAN, STRING]
			-- State changes in the transition.
			-- Key: query whose value has changed after the transition.
			-- Val: new value of the expression.

	transition_feature: EPA_FEATURE_WITH_CONTEXT_CLASS
			-- Feature called to emit the transition.

feature -- Status report

	is_valid: BOOLEAN
			-- Is current transition valid?
		do
			Result := transition_feature /= Void and then transition_feature.is_argumentless_public_command
					and then state_changes /= Void
		end

	does_change_query (a_query_name: STRING): BOOLEAN
			-- Does current transition change the value of a query with `a_query_name'.
		require
			valid_transition: is_valid
		do
			Result := state_changes.has (a_query_name)
		end

	is_changeless: BOOLEAN
			-- Is the transition changing state?
		do
			Result := state_changes.is_empty
		end

	is_equal (a_other: like Current): BOOLEAN
			-- <Precursor>
		do
			Result := out ~ a_other.out
		end

feature -- Query

	changed_value_for_query (a_query_name: STRING): BOOLEAN
			-- Changed value of `a_query_name' after the transition.
		require
			valid_transition: is_valid
			does_change_query: does_change_query (a_query_name)
		do
			Result := state_changes.item (a_query_name)
		end

	hash_code: INTEGER
			-- <Precursor>
		do
			Result := out.hash_code
		end

	usefulness (a_change_requirement: DS_HASH_TABLE [BOOLEAN, STRING]): INTEGER
			-- Usefulness of the transition in terms the number of query changes it can achieve when invoked.
			-- `a_change_requirement': query name --> new value.
			-- `Result': the numbers of queries it can change.
		local
			l_query: STRING
		do
			Result := 0
			from a_change_requirement.start
			until a_change_requirement.after
			loop
				l_query := a_change_requirement.key_for_iteration
				if state_changes.has (l_query) and then state_changes.item (l_query) = a_change_requirement.item (l_query) then
					Result := Result + 1
				end
				a_change_requirement.forth
			end
		end

feature -- Output

	out: STRING
			-- <Precursor>
			-- Eg.: ARRAY.forth[before:False;after:True]
		do
			if out_cache = Void then
				out_cache := ""
				if state_changes /= Void then
					from state_changes.start
					until state_changes.after
					loop
						out_cache := out_cache + state_changes.key_for_iteration + ":" + state_changes.item_for_iteration.out + ";"
						state_changes.forth
					end
				end
				out_cache := transition_feature.out + "[" + out_cache + "]"
			end
			Result := out_cache
		end

	debug_output: STRING
			-- <Precursor>
		do
			Result := out
		end

feature{NONE} -- Cache

	out_cache: STRING
			-- Cache for `out'.

feature{NONE} -- Implementation

	summarize_state_changes (a_pre_state, a_post_state: EPA_STATE)
			-- Summarize the state changes from `a_pre_state' and `a_post_state'.
			-- Make the changes available in `state_changes'.
		local
			l_pre_table, l_post_table: DS_HASH_TABLE [BOOLEAN, STRING]
			l_value: BOOLEAN
			l_query: STRING
		do
			l_pre_table := query_name_and_value_map_from_state (a_pre_state)
			l_post_table := query_name_and_value_map_from_state (a_post_state)

			create state_changes.make_equal (l_pre_table.count)
			from l_pre_table.start
			until l_pre_table.after
			loop
				l_query := l_pre_table.key_for_iteration
				l_value := l_pre_table.item_for_iteration

				if l_post_table.has (l_query) and then l_post_table.item (l_query) = not l_value then
					state_changes.force (not l_value, l_query)
				end
				l_pre_table.forth
			end
		end

	query_name_and_value_map_from_state (a_state: EPA_STATE): DS_HASH_TABLE [BOOLEAN, STRING]
			-- Map from query names to their values, according to `a_state'.
		require
			state_attached: a_state /= Void
		local
			l_table: DS_HASH_TABLE [BOOLEAN, STRING]
			l_pair: TUPLE[value: BOOLEAN; query: STRING]
		do
			from
				create Result.make_equal (a_state.count)
				a_state.start
			until
				a_state.after
			loop
				l_pair := query_name_and_value_from_equation (a_state.item_for_iteration)
				if l_pair.query /= Void then
					Result.force (l_pair.value, l_pair.query)
				end
				a_state.forth
			end
		end

	query_name_and_value_from_equation (a_equation: EPA_EQUATION): TUPLE[BOOLEAN, STRING]
			-- Query name and its value from `a_equation'.
			-- Return [False, Void] in case of mal-formed expression or non-sensical value.
		require
			equation_attached: a_equation /= Void
		local
			l_expr: EPA_EXPRESSION
			l_boolean_type, l_expr_type: TYPE_A
			l_query_name: STRING
			l_val: EPA_EXPRESSION_VALUE
			l_boolean_value: BOOLEAN
		do
			l_expr := a_equation.expression
			l_val := a_equation.value

			if l_expr.type /= Void and then l_expr.type.is_boolean
					and then l_val /= Void and then l_val.is_boolean and then not l_val.is_nonsensical then
				l_query_name := feature_name_from_qualified_call (l_expr.text)
				l_boolean_value := l_val.is_true_boolean
				Result := [l_boolean_value, l_query_name]
			else
				Result := [False, Void]
			end
		end

	feature_name_from_qualified_call (a_call: STRING): STRING
			-- Parse the feature name from a qualified feature call, and return the feature name.
			-- A qualified feature call has the form "v_5.feature_name".
		require
			call_not_empty: a_call /= Void and then not a_call.is_empty
		local
			l_dot_position: INTEGER
			l_count: INTEGER
		do
			l_dot_position := a_call.index_of ('.', 1)
			check has_feature_name: l_dot_position /= a_call.count end
			if l_dot_position > 0 then
				Result := a_call.substring (l_dot_position + 1, a_call.count)
			else
				Result := a_call.twin
			end
			if Result /= Void then
				Result.prune_all (' ')
			end
		end

;note
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
