note
	description: "Utilities"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_UTILITY

inherit
	EPA_TYPE_UTILITY

	EPA_UTILITY

feature

	principal_variable_from_anon_content (a_string: STRING): INTEGER
			-- Returns the index of the principal variable by taking the most frequent one
			-- occuring in `a_string'
		local
			l_counts: HASH_TABLE[INTEGER,INTEGER]
			l_pos: INTEGER
			l_in_index: BOOLEAN
			l_cur_index_str: STRING
			l_cur_index: INTEGER
			l_max_count: INTEGER
			l_max: INTEGER
		do
			from
				create l_counts.make (10)
				l_max_count := -1
				l_max := -1
				l_pos := 1
			until
				l_pos > a_string.count
			loop
				if a_string.item (l_pos) = '{' then
					l_in_index := true
					create l_cur_index_str.make (3)
				elseif l_in_index and a_string.item (l_pos) = '}' then
					l_in_index := false
					l_cur_index := l_cur_index.to_integer
					-- Keep track how often a variable occured
					if l_counts.has (l_cur_index) then
						l_counts[l_cur_index] := l_counts[l_cur_index]+1
					else
						l_counts[l_cur_index] := 1
					end

					if l_counts[l_cur_index]>l_max_count then
						l_max_count := l_counts[l_cur_index]
						l_max := l_cur_index
					end
				else
					if l_in_index then
						l_cur_index_str.extend (a_string.item (l_pos))
					end
				end
				l_pos := l_pos + 1
			end

			Result := l_max
		end

	selected_expressions (
		a_transitions: LINKED_LIST [SEM_TRANSITION];
		a_pre_state: BOOLEAN; a_union_mode: BOOLEAN;
		a_selection_function: detachable FUNCTION [ANY, TUPLE [equation: EPA_EQUATION; transition: SEM_TRANSITION; pre_state: BOOLEAN], BOOLEAN]): HASH_TABLE [TYPE_A, STRING]
			-- expression table from `a_transitions'
			-- `a_pre_state' indicates if the expressions come from pre-state or post-state.
			-- If `a_union_mode' is True, an expressions is in the result table if and only if it appears in all transitions from `a_transitions',
			-- otherwise, that expressions will be in the result table if it appears in at least one transition from `a_transitions'.
			-- `a_selection_function' also decides if an expression will be selected or not: If it returns True, an expression will be selected.
			-- If `a_selection_function' is Void, all candidate expression is selected.
			-- Key of the result table is anonymous text of an expression, value of the result table is the type of that expression.
		local
			l_frequence_tbl: DS_HASH_TABLE [INTEGER, STRING]
			l_type_tbl: DS_HASH_TABLE [TYPE_A, STRING]
			l_state_cursor: DS_HASH_SET_CURSOR [EPA_EQUATION]
			l_expression: EPA_EXPRESSION
			l_count: INTEGER
			l_anonymous_expr: STRING
			l_transition: SEM_TRANSITION
			l_state: EPA_STATE
		do
			create l_frequence_tbl.make (100)
			l_frequence_tbl.set_key_equality_tester (string_equality_tester)
			create l_type_tbl.make (100)
			l_type_tbl.set_key_equality_tester (string_equality_tester)

				-- Collect the number of times that each expression appears in all transitions.
			across a_transitions as l_trans loop
				l_transition := l_trans.item
				from
					if a_pre_state then
						l_state := l_transition.preconditions
					else
						l_state := l_transition.postconditions
					end
					l_state_cursor := l_state.new_cursor
					l_state_cursor.start
				until
					l_state_cursor.after
				loop
					if a_selection_function = Void or else a_selection_function.item ([l_state_cursor.item, l_transition, a_pre_state]) then
						l_expression := l_state_cursor.item.expression
						l_anonymous_expr := l_transition.anonymous_expression_text (l_expression)
						l_frequence_tbl.force_last (l_frequence_tbl.item (l_anonymous_expr) + 1, l_anonymous_expr)
						l_type_tbl.force_last (l_expression.resolved_type (l_transition.context_type), l_anonymous_expr)
					end
					l_state_cursor.forth
				end
			end

				-- Collect all the expressions to be translated as attributes.
			create Result.make (l_frequence_tbl.count)
			Result.compare_objects

			from
				l_count := a_transitions.count
				l_frequence_tbl.start
			until
				l_frequence_tbl.after
			loop
				if a_union_mode or else (l_frequence_tbl.item_for_iteration = l_count) then
					Result.force (l_type_tbl.item (l_frequence_tbl.key_for_iteration), l_frequence_tbl.key_for_iteration)
				end
				l_frequence_tbl.forth
			end
		end

feature -- Names

	variable_name_with_prefix (a_prefix: STRING; a_id: INTEGER): STRING
			-- Variable name with `a_prefix' and `a_id',
			-- for example, "v_12" if `a_prefix' is "v_" and `a_id' is 12.
		do
			create Result.make (5)
			Result.append (a_prefix)
			Result.append (a_id.out)
		end

	variable_name_with_default_prefix (a_id: INTEGER): STRING
			-- Variable name with prefix "v_" and `a_id',
			-- for example, "v_12" if `a_prefix' is "v_" and `a_id' is 12.
		do
			create Result.make (5)
			Result.append (once "v_")
			Result.append (a_id.out)
		end

end
