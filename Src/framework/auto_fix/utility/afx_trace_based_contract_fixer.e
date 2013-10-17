note
	description: "Summary description for {AFX_TRACE_BASED_CONTRACT_FIXER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_TRACE_BASED_CONTRACT_FIXER

	inherit

		AFX_SHARED_SESSION

feature -- Access

	last_contract_fixes: DS_LIST [AFX_CONTRACT_FIX_ACROSS_FEATURES]

		do
			if last_contract_fixes_cache = Void then
				create {DS_ARRAYED_LIST [AFX_CONTRACT_FIX_ACROSS_FEATURES]}last_contract_fixes_cache.make (10)
			end
			Result := last_contract_fixes_cache
		end

feature{NONE} -- Implementation

	prune_stronger_expressions (a_expressions: DS_ARRAYED_LIST [EPA_AST_EXPRESSION]; a_expressions_to_sets: DS_HASH_TABLE [EPA_HASH_SET[STRING], EPA_AST_EXPRESSION])
			-- `a_expressions' should be ordered through `expressions_ordered_by_set_size', weaker expressions appear later.
		local
			l_expression_cursor: DS_ARRAYED_LIST_CURSOR[EPA_AST_EXPRESSION]
			l_expression: EPA_AST_EXPRESSION
			l_observed_hash_sets: EPA_HASH_SET[EPA_HASH_SET[STRING]]
			l_hash_set: EPA_HASH_SET[STRING]
			l_is_stronger: BOOLEAN
		do
			from
				l_expression_cursor := a_expressions.new_cursor
				create l_observed_hash_sets.make_equal (a_expressions.count + 1)
				l_expression_cursor.finish
			until
				l_expression_cursor.before
			loop
					-- Set of hash values associated to the expression
				l_expression := l_expression_cursor.item
				if a_expressions_to_sets.has (l_expression) then
					l_hash_set := a_expressions_to_sets.item (l_expression)
						-- Is it stronger than a previous expression?
					l_is_stronger := False
					from l_observed_hash_sets.start
					until l_observed_hash_sets.after or else l_is_stronger
					loop
						if l_observed_hash_sets.item_for_iteration.is_superset (l_hash_set) and then l_observed_hash_sets.item_for_iteration /~ l_hash_set then
							l_is_stronger := True
						end

						l_observed_hash_sets.forth
					end

					if l_is_stronger then
						a_expressions.remove_at_cursor (l_expression_cursor)
					else
						l_observed_hash_sets.force (l_hash_set)
					end
				else
					a_expressions.remove_at_cursor (l_expression_cursor)
				end

				l_expression_cursor.back
			end
		end

	prune_weaker_expressions (a_expressions: DS_ARRAYED_LIST [EPA_AST_EXPRESSION]; a_expressions_to_sets: DS_HASH_TABLE [EPA_HASH_SET[STRING], EPA_AST_EXPRESSION])
			-- `a_expressions' should be ordered through `expressions_ordered_by_set_size', weaker expressions appear later.
		local
			l_expression_cursor: DS_ARRAYED_LIST_CURSOR[EPA_AST_EXPRESSION]
			l_expression: EPA_AST_EXPRESSION
			l_observed_hash_sets: EPA_HASH_SET[EPA_HASH_SET[STRING]]
			l_hash_set: EPA_HASH_SET[STRING]
			l_is_weaker: BOOLEAN
		do
			from
				l_expression_cursor := a_expressions.new_cursor
				l_expression_cursor.start
			until
				l_expression_cursor.after
			loop
					-- Set of hash values associated to the expression
				l_expression := l_expression_cursor.item
				if a_expressions_to_sets.has (l_expression) then
					l_hash_set := a_expressions_to_sets.item (l_expression)
						-- Is it weaker than a previous expression?
					l_is_weaker := False
					from l_observed_hash_sets.start
					until l_observed_hash_sets.after or else l_is_weaker
					loop
						if l_observed_hash_sets.item_for_iteration.is_subset (l_hash_set) then
							l_is_weaker := True
						end

						l_observed_hash_sets.forth
					end

					if l_is_weaker then
						a_expressions.remove_at_cursor (l_expression_cursor)
					else
						l_expression_cursor.forth
					end
				else
					a_expressions.remove_at_cursor (l_expression_cursor)
				end
			end
		end

	expressions_ordered_by_set_size (a_exprs: DS_LINEAR [EPA_AST_EXPRESSION]; a_expressions_to_sets: DS_HASH_TABLE [EPA_HASH_SET[STRING], EPA_AST_EXPRESSION]): DS_ARRAYED_LIST [EPA_AST_EXPRESSION]
		local
			l_sorter: DS_QUICK_SORTER[EPA_AST_EXPRESSION]
		do
			create Result.make_equal (a_exprs.count + 1)
			a_exprs.do_if (agent Result.force_last, agent a_expressions_to_sets.has)
			create l_sorter.make (create {AGENT_BASED_EQUALITY_TESTER [EPA_AST_EXPRESSION]}.make (
					agent (e1, e2: EPA_AST_EXPRESSION; expressions_to_sets: DS_HASH_TABLE [DS_HASH_SET[STRING], EPA_AST_EXPRESSION]): BOOLEAN
						local
							l_set_size1, l_set_size2: INTEGER
						do
							if expressions_to_sets.has (e1) then
								l_set_size1 := expressions_to_sets.item (e1).count
							end
							if expressions_to_sets.has (e2) then
								l_set_size2 := expressions_to_sets.item (e2).count
							end
							Result := l_set_size1 < l_set_size2
						end (?, ?, a_expressions_to_sets)))
			l_sorter.sort (Result)
		end


	expressions_to_satisfying_state_hashes (a_traces: DS_LIST [AFX_PROGRAM_EXECUTION_TRACE]; a_class: CLASS_C; a_feature: FEATURE_I; a_expressions: DS_LINEAR [EPA_AST_EXPRESSION]; a_state_criterion: FUNCTION[ANY,TUPLE [AFX_PROGRAM_EXECUTION_STATE], BOOLEAN]): TUPLE [DS_HASH_TABLE [EPA_HASH_SET[STRING], EPA_AST_EXPRESSION], EPA_HASH_SET[EPA_AST_EXPRESSION]]
				-- All `expressions' should be defined in `a_class'.`a_feature'.
		local
			l_hash_table: DS_HASH_TABLE [EPA_HASH_SET[STRING], EPA_AST_EXPRESSION]
			l_invariants: EPA_HASH_SET[EPA_AST_EXPRESSION]
			l_trace_cursor: DS_LIST_CURSOR [AFX_PROGRAM_EXECUTION_TRACE]
			l_trace: AFX_PROGRAM_EXECUTION_TRACE
			l_uuid: STRING
			l_state: EPA_STATE
			l_state_hash: INTEGER
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_true_expressions: EPA_HASH_SET [EPA_AST_EXPRESSION]
			l_expression_cursor: DS_LINEAR_CURSOR [EPA_AST_EXPRESSION]
			l_expression: EPA_AST_EXPRESSION
			l_hash_set: EPA_HASH_SET[STRING]
		do
			create l_hash_table.make_equal (a_expressions.count + 1)
			create l_invariants.make_equal (a_expressions.count + 1)
			a_expressions.do_all (agent l_invariants.force)

			l_expression_cursor := a_expressions.new_cursor
			from
				l_trace_cursor := a_traces.new_cursor
				l_trace_cursor.start
			until
				l_trace_cursor.after
			loop
				l_trace := l_trace_cursor.item
				l_uuid := l_trace.test_case.id

				across l_trace as lt_state_cursor loop
					if a_state_criterion = Void or else a_state_criterion.item ([lt_state_cursor.item]) then
						l_state := lt_state_cursor.item.state
						l_state_hash := l_state.hash_code
						l_class := l_state.class_
						l_feature := l_state.feature_

						if l_class ~ a_class and then l_feature ~ a_feature then
							l_true_expressions := true_expressions_from_state (l_state)
							from l_expression_cursor.start
							until l_expression_cursor.after
							loop
								l_expression := l_expression_cursor.item
								if l_true_expressions.has (l_expression) then
									if not l_hash_table.has (l_expression) then
										create l_hash_set.make_equal (a_traces.count + 1)
										l_hash_table.force (l_hash_set, l_expression)
									end
									l_hash_table.item (l_expression).force (l_uuid + "#" + lt_state_cursor.item.location.out)
								else
									l_invariants.remove (l_expression)
								end
								l_expression_cursor.forth
							end
						end
					end
				end
				l_trace_cursor.forth
			end

			Result := [l_hash_table, l_invariants]
		end

	summary_of_traces (a_traces: DS_LIST [AFX_PROGRAM_EXECUTION_TRACE]; a_features: DS_LIST [AFX_FEATURE_TO_MONITOR]; a_use_union: BOOLEAN): DS_HASH_TABLE [TUPLE[pre, post: EPA_HASH_SET[EPA_AST_EXPRESSION]], AFX_FEATURE_TO_MONITOR]
			--
		local
			l_summary: EPA_HASH_SET [EPA_AST_EXPRESSION]
			l_trace_cursor: DS_LIST_CURSOR [AFX_PROGRAM_EXECUTION_TRACE]
			l_trace: AFX_PROGRAM_EXECUTION_TRACE
			l_state: AFX_PROGRAM_EXECUTION_STATE
			l_feature_with_context: AFX_FEATURE_TO_MONITOR
			l_feature: FEATURE_I
			l_class: CLASS_C
			l_true_expressions, l_old_summary: EPA_HASH_SET [EPA_AST_EXPRESSION]
			l_is_first_occurrence: BOOLEAN
		do
			create Result.make_equal (a_features.count + 1)
			create l_summary.make_equal (64)
			from
				l_trace_cursor := a_traces.new_cursor
				l_trace_cursor.start
			until
				l_trace_cursor.after
			loop
				l_trace := l_trace_cursor.item

				across l_trace as l_state_cursor loop
					l_state := l_state_cursor.item
					l_is_first_occurrence := False
					create l_feature_with_context.make_from_feature_with_context_class (l_state.location.context)

					if a_features.has (l_feature_with_context) then
							-- Ensure the summary entry for the feature in `Result'
						if not Result.has (l_feature_with_context) then
							Result.force ([Void, Void], l_feature_with_context)
						end

							-- Ensure the storage for pre/post summary
						if l_state.location.breakpoint_index = 1 then
							l_old_summary := Result.item (l_feature_with_context).pre
							if l_old_summary = Void then
								create l_old_summary.make_equal (64)
								Result.item (l_feature_with_context).pre := l_old_summary
								l_is_first_occurrence := True
							end
						else
							l_old_summary := Result.item (l_feature_with_context).post
							if l_old_summary = Void then
								create l_old_summary.make_equal (64)
								Result.item (l_feature_with_context).post := l_old_summary
								l_is_first_occurrence := True
							end
						end

							-- Update summary using the new state.
						l_true_expressions := true_expressions_from_state (l_state.state)
						if a_use_union or else (l_old_summary.is_empty and then l_is_first_occurrence) then
							l_old_summary.merge (l_true_expressions)
							l_is_first_occurrence := False
						else
							l_old_summary.intersect (l_true_expressions)
						end
					end
				end

				l_trace_cursor.forth
			end
		end

	true_expressions_from_state (a_state: EPA_STATE): EPA_HASH_SET [EPA_AST_EXPRESSION]
		local
		do
			create Result.make_equal (a_state.count)
			from a_state.start
			until a_state.after
			loop
				if a_state.item_for_iteration.value.is_true_boolean and then attached {EPA_AST_EXPRESSION} a_state.item_for_iteration.expression as lt_expr then
					Result.force (lt_expr)
				end
				a_state.forth
			end
		end

	expressions_in_order (a_exprs: DS_LINEAR [EPA_AST_EXPRESSION]): DS_ARRAYED_LIST [EPA_AST_EXPRESSION]
		local
			l_sorter: DS_QUICK_SORTER[EPA_AST_EXPRESSION]
		do
			create Result.make_equal (a_exprs.count + 1)
			a_exprs.do_all (agent Result.force_last)
			create l_sorter.make (create {AGENT_BASED_EQUALITY_TESTER [EPA_AST_EXPRESSION]}.make (agent (e1, e2: EPA_AST_EXPRESSION): BOOLEAN do Result := e1.text.count < e2.text.count end))
			l_sorter.sort (Result)
		end

	prune_disjunctions_of_true_expressions (a_true_expressions: DS_ARRAYED_LIST [EPA_AST_EXPRESSION])
			-- `a_true_expressions' should be ordered by the lengths of expressions.
		local
			l_remaining, l_removing: EPA_HASH_SET[STRING]
			l_is_redundant: BOOLEAN
		do
			create l_remaining.make_equal (a_true_expressions.count + 1)
			create l_removing.make_equal (a_true_expressions.count + 1)
			from a_true_expressions.start
			until a_true_expressions.after
			loop
				l_is_redundant := False
				if attached {AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION} a_true_expressions.item_for_iteration as lt_aspect
						and then lt_aspect.operator = {AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION}.Operator_boolean_or_else then
					if l_remaining.has (lt_aspect.left_operand.text) or else l_remaining.has (lt_aspect.right_operand.text) then
						l_is_redundant := True
					end
				end
				if l_is_redundant then
					a_true_expressions.remove_at
				else
					l_remaining.force (a_true_expressions.item_for_iteration.text)
					a_true_expressions.forth
				end
			end
		end

	reset
		do
			last_contract_fixes_cache := Void
		end

feature -- Constants

	max_strengthening_fixes: INTEGER = 4
	max_weakening_fixes: INTEGER = 4

feature{NONE} -- Cache

	last_contract_fixes_cache: like last_contract_fixes

end
