note
	description: "Summary description for {AFX_TRACE_BASED_CONTRACT_WEAKENER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_TRACE_BASED_CONTRACT_WEAKENER

inherit
	AFX_TRACE_BASED_CONTRACT_FIXER

feature -- Basic operation

	fix_traces (a_regular_traces, a_relaxed_traces: DS_LIST [AFX_PROGRAM_EXECUTION_TRACE]; a_features: DS_LIST [AFX_FEATURE_TO_MONITOR]; a_written_contracts_of_features: like written_contracts_of_features)
			-- <Precursor>
			--
			-- The first feature from `a_features' is called the "TARGET" feature in this process.
			-- Weaken only the contracts of the TARGET feature, strengthen the contracts of the others.
		local
			l_fixes_to_target_feature: DS_ARRAYED_LIST [AFX_CONTRACT_FIX_PER_FEATURE]
			l_failing_regular_traces, l_all_passing_traces, l_failing_relaxed_traces: DS_ARRAYED_LIST [AFX_PROGRAM_EXECUTION_TRACE]
		do
			features_to_fix := a_features
			regular_traces := a_regular_traces
			relaxed_traces := a_relaxed_traces
			written_contracts_of_features := a_written_contracts_of_features

			create l_all_passing_traces.make_equal (a_regular_traces.count + a_relaxed_traces.count + 1)
			a_regular_traces.do_if (agent l_all_passing_traces.force_last, agent {AFX_PROGRAM_EXECUTION_TRACE}.is_passing)
			a_relaxed_traces.do_if (agent l_all_passing_traces.force_last, agent {AFX_PROGRAM_EXECUTION_TRACE}.is_passing)
			create l_failing_relaxed_traces.make_equal (a_relaxed_traces.count + 1)
			a_relaxed_traces.do_if (agent l_failing_relaxed_traces.force_last, agent {AFX_PROGRAM_EXECUTION_TRACE}.is_failing)
			l_fixes_to_target_feature := contract_fixes_to_target_feature (l_all_passing_traces, l_failing_relaxed_traces)

			create l_failing_regular_traces.make_equal (a_regular_traces.count + 1)
			a_regular_traces.do_if (agent l_failing_regular_traces.force_last, agent {AFX_PROGRAM_EXECUTION_TRACE}.is_failing)
			last_contract_fixes_cache := fixes_based_on_those_to_target_features (l_fixes_to_target_feature, regular_traces)
		end

feature -- Access

	regular_traces: DS_LIST [AFX_PROGRAM_EXECUTION_TRACE]

	relaxed_traces: DS_LIST [AFX_PROGRAM_EXECUTION_TRACE]

	all_traces: DS_LIST [AFX_PROGRAM_EXECUTION_TRACE]
		local
			l_traces: DS_ARRAYED_LIST[AFX_PROGRAM_EXECUTION_TRACE]
		do
			create l_traces.make_equal (regular_traces.count + relaxed_traces.count + 1)
			regular_traces.do_all (agent l_traces.force_last)
			relaxed_traces.do_all (agent l_traces.force_last)
			Result := l_traces
		end

	features_to_fix: DS_LIST [AFX_FEATURE_TO_MONITOR]

	target_feature: AFX_FEATURE_TO_MONITOR
		require
			feature_to_fix_not_empty: not features_to_fix.is_empty
		do
			Result := features_to_fix.first
		end

	written_contracts_of_features: DS_HASH_TABLE [TUPLE[pre, post: EPA_HASH_SET[EPA_AST_EXPRESSION]], AFX_FEATURE_TO_MONITOR]
			-- Map from features to their written contracts.

feature{NONE} -- Access

	traces_to_keep: DS_LIST [AFX_PROGRAM_EXECUTION_TRACE]
	traces_to_reject: DS_LIST [AFX_PROGRAM_EXECUTION_TRACE]
	traces_for_implication_inference: DS_LIST [AFX_PROGRAM_EXECUTION_TRACE]

feature{NONE} -- Implementation

	fixes_based_on_those_to_target_features (a_fixes_to_target_feature: DS_ARRAYED_LIST [AFX_CONTRACT_FIX_PER_FEATURE]; a_traces: DS_LIST [AFX_PROGRAM_EXECUTION_TRACE]): DS_ARRAYED_LIST [AFX_CONTRACT_FIX_ACROSS_FEATURES]
		local
			l_fix_cursor: DS_ARRAYED_LIST_CURSOR [AFX_CONTRACT_FIX_PER_FEATURE]
			l_fix_to_target: AFX_CONTRACT_FIX_PER_FEATURE
			l_non_target_features: like features_to_fix
			l_traces_to_reject: DS_ARRAYED_LIST [AFX_PROGRAM_EXECUTION_TRACE]
			l_trace_groups_from_new_contracts_for_target_feature: like trace_groups_from_new_contracts_for_target_feature
			l_strengthener: AFX_TRACE_BASED_CONTRACT_STRENGTHENER
			l_strengthenings: DS_LIST [AFX_CONTRACT_FIX_ACROSS_FEATURES]
			l_strengthening_cursor: DS_LIST_CURSOR [AFX_CONTRACT_FIX_ACROSS_FEATURES]
			l_fix_across_features: AFX_CONTRACT_FIX_ACROSS_FEATURES
			l_is_precondition_violation: BOOLEAN
		do
			l_is_precondition_violation := session.exception_signature.is_precondition_violation
			create Result.make_equal (max_strengthening_fixes * max_weakening_fixes)
			if not a_fixes_to_target_feature.is_empty then
				l_non_target_features := features_to_fix.twin
					-- we do not strengthen the precondition of the feature triggering the pre-violation.
				if session.exception_signature.is_precondition_violation then
					l_non_target_features.remove_first
				end
				create l_strengthener

				from
					l_fix_cursor := a_fixes_to_target_feature.new_cursor
					l_fix_cursor.start
				until
					l_fix_cursor.after
				loop
					l_fix_to_target := l_fix_cursor.item

					l_trace_groups_from_new_contracts_for_target_feature := trace_groups_from_new_contracts_for_target_feature (a_traces, l_fix_to_target)
					l_strengthener.fix_traces (l_trace_groups_from_new_contracts_for_target_feature.satisfying, l_trace_groups_from_new_contracts_for_target_feature.not_satisfying, all_traces, l_non_target_features)
					l_strengthenings := l_strengthener.last_contract_fixes
					if l_strengthenings.is_empty then
							-- Weakening alone is enough.
						create l_fix_across_features.make_equal (1)
						if l_is_precondition_violation then
							l_fix_across_features.force ([l_fix_to_target, Void], l_fix_to_target.context_feature)
						else
							l_fix_across_features.force ([Void, l_fix_to_target], l_fix_to_target.context_feature)
						end
						Result.force_last (l_fix_across_features)
					else
							-- Fixes as weakening + strengthening
						from
							l_strengthening_cursor := l_strengthenings.new_cursor
							l_strengthening_cursor.start
						until
							l_strengthening_cursor.after
						loop
							l_fix_across_features := l_strengthening_cursor.item
							l_fix_across_features.merge_fix_per_feature (l_fix_to_target)
							Result.force_last (l_fix_across_features)

							l_strengthening_cursor.forth
						end
					end

					l_fix_cursor.forth
				end
			end
		end

	trace_groups_from_new_contracts_for_target_feature (a_traces: DS_LIST [AFX_PROGRAM_EXECUTION_TRACE]; a_fix: AFX_CONTRACT_FIX_PER_FEATURE): TUPLE[satisfying, not_satisfying: DS_ARRAYED_LIST [AFX_PROGRAM_EXECUTION_TRACE]]
		local
			l_satisfying_traces, l_not_satisfying_traces: DS_ARRAYED_LIST [AFX_PROGRAM_EXECUTION_TRACE]
			l_target_feature: like target_feature
			l_new_contracts, l_true_expressions: EPA_HASH_SET [EPA_AST_EXPRESSION]
			l_trace_cursor: DS_LIST_CURSOR [AFX_PROGRAM_EXECUTION_TRACE]
			l_trace: AFX_PROGRAM_EXECUTION_TRACE
			l_is_satisfying: BOOLEAN
			l_state: AFX_PROGRAM_EXECUTION_STATE
			l_is_precondition_violation: BOOLEAN
		do
			l_target_feature := target_feature
			l_is_precondition_violation := session.exception_signature.is_precondition_violation

			if l_is_precondition_violation and then a_fix.is_pre then
				l_new_contracts := written_contracts_of_features.item (l_target_feature).pre.twin
			elseif not l_is_precondition_violation and then not a_fix.is_pre then
				l_new_contracts := written_contracts_of_features.item (l_target_feature).post.twin
			end
			l_new_contracts.subtract (a_fix.clauses_to_remove)
			l_new_contracts.merge (a_fix.clauses_to_add)

			create l_satisfying_traces.make_equal (a_traces.count + 1)
			create l_not_satisfying_traces.make_equal (a_traces.count + 1)
			Result := [l_satisfying_traces, l_not_satisfying_traces]

			from
				l_trace_cursor := a_traces.new_cursor
				l_trace_cursor.start
			until
				l_trace_cursor.after
			loop
				l_trace := l_trace_cursor.item

				l_is_satisfying := True
				across l_trace as lt_state_cursor loop
					l_state := lt_state_cursor.item
					if l_state.location.context.is_about_same_feature (target_feature)
							and then ((l_state.location.breakpoint_index = 1 and then l_is_precondition_violation)
							  		  or else (l_state.location.breakpoint_index /= 1 and then not l_is_precondition_violation)) then
						l_true_expressions := true_expressions_from_state (l_state.state)
						if l_true_expressions.is_superset (l_new_contracts) then
							l_is_satisfying := True
						else
							l_is_satisfying := False
						end
					end
				end
				if l_is_satisfying then
					l_satisfying_traces.force_last (l_trace)
				else
					l_not_satisfying_traces.force_last (l_trace)
				end

				l_trace_cursor.forth
			end
		end

	contract_fixes_to_target_feature (a_passing_traces, a_failing_traces: DS_LIST [AFX_PROGRAM_EXECUTION_TRACE]): DS_ARRAYED_LIST [AFX_CONTRACT_FIX_PER_FEATURE]
			--
		local
			l_written_contract_expressions, l_written_contracts: EPA_HASH_SET[EPA_AST_EXPRESSION]
			l_summary: DS_HASH_TABLE [TUPLE [pre: EPA_HASH_SET [EPA_AST_EXPRESSION]; post: EPA_HASH_SET [EPA_AST_EXPRESSION]], AFX_FEATURE_TO_MONITOR]
			l_summary_from_relaxed_passings, l_summary_from_relaxed_failings: EPA_HASH_SET [EPA_AST_EXPRESSION]
			l_target_features: DS_ARRAYED_LIST [AFX_FEATURE_TO_MONITOR]
			l_valid_contracts, l_valid_contract_expressions, l_essential_contracts: EPA_HASH_SET [EPA_AST_EXPRESSION]
			l_contract_expression: EPA_AST_EXPRESSION
			l_contracts_to_remove, l_contracts_to_add, l_temp_contracts_to_add: EPA_HASH_SET [EPA_AST_EXPRESSION]
			l_contracts_to_remove_in_order, l_contracts_to_add_in_order, l_essential_contracts_in_order, l_valid_contracts_in_order: DS_ARRAYED_LIST [EPA_AST_EXPRESSION]
			l_contract_cursor: DS_LIST_CURSOR [EPA_AST_EXPRESSION]
			l_all_traces: DS_ARRAYED_LIST [AFX_PROGRAM_EXECUTION_TRACE]
			l_expressions_to_satisfying_state_hashes: DS_HASH_TABLE [EPA_HASH_SET[STRING], EPA_AST_EXPRESSION]
			l_written_contract_texts: EPA_HASH_SET [STRING]
			l_is_precondition_violation: BOOLEAN
			l_agent: FUNCTION[ANY, TUPLE[AFX_PROGRAM_EXECUTION_STATE], BOOLEAN]
			l_result, l_result_overall: TUPLE [htable: DS_HASH_TABLE [EPA_HASH_SET[STRING], EPA_AST_EXPRESSION]; invs: EPA_HASH_SET[EPA_AST_EXPRESSION]]
		do
			create Result.make_equal (max_weakening_fixes)

				-- Written contract expressions as state aspects.
			l_is_precondition_violation := session.exception_signature.is_precondition_violation
			if l_is_precondition_violation then
				l_written_contract_expressions := written_contracts_of_features.item (target_feature).pre.twin
			else
				l_written_contract_expressions := written_contracts_of_features.item (target_feature).post.twin
			end

			create l_written_contracts.make_equal (l_written_contract_expressions.count + 1)
			l_written_contract_expressions.do_all (
					agent (exp: EPA_AST_EXPRESSION; contracts: EPA_HASH_SET[EPA_AST_EXPRESSION])
						local
							l_aspect: AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION
						do
							l_aspect := create {AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION}.make_boolean_relation (
									target_feature.context_class, target_feature.feature_, target_feature.written_class, exp,  Void, {AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION}.operator_boolean_null)
							contracts.force (l_aspect)
						end (?, l_written_contracts))

			create l_target_features.make_equal (1)
			l_target_features.force_last (target_feature)

				-- Contracts that we can keep for the TARGET.
			l_summary := summary_of_traces (a_passing_traces, l_target_features, False)
			if l_summary.has (target_feature) then
				if l_is_precondition_violation then
					l_summary_from_relaxed_passings := l_summary.item (target_feature).pre
				else
					l_summary_from_relaxed_passings := l_summary.item (target_feature).post
				end
			end
			if l_summary_from_relaxed_passings = Void then
				create l_summary_from_relaxed_passings.make_equal (1)
			end
			l_valid_contracts := l_summary_from_relaxed_passings

				-- Contracts essential for ruling out bad inputs to TARGET
			l_summary := summary_of_traces (a_failing_traces, l_target_features, True)
			if l_summary.has (target_feature) then
				if l_is_precondition_violation then
					l_summary_from_relaxed_failings := l_summary.item (target_feature).pre
				else
					l_summary_from_relaxed_failings := l_summary.item (target_feature).post
				end
			end
			if l_summary_from_relaxed_failings = Void then
				create l_summary_from_relaxed_failings.make_equal (1)
			end
			l_essential_contracts := l_summary_from_relaxed_passings.subtraction (l_summary_from_relaxed_failings)

				-- Keep only the weakest ones from valid contracts and essential contracts.
			create l_all_traces.make_equal (regular_traces.count + relaxed_traces.count + 1)
			regular_traces.do_all (agent l_all_traces.force_last)
			relaxed_traces.do_all (agent l_all_traces.force_last)

			l_agent := agent (a_state: AFX_PROGRAM_EXECUTION_STATE; a_is_entry: BOOLEAN): BOOLEAN
						do
							Result := a_is_entry and then a_state.location.breakpoint_index = 1 or else not a_is_entry and then a_state.location.breakpoint_index > 1
						end (?, session.exception_signature.is_precondition_violation)

			l_valid_contracts_in_order := expressions_in_order (l_valid_contracts)
			prune_disjunctions_of_true_expressions (l_valid_contracts_in_order)
			l_result := expressions_to_satisfying_state_hashes (l_all_traces, target_feature.context_class, target_feature.feature_, l_valid_contracts_in_order, l_agent)
			l_expressions_to_satisfying_state_hashes := l_result.htable
			if not session.exception_signature.is_postcondition_violation then
					-- l_result.invs and l_valid_contracts_in_order contain the same set of expressions in case of postcondition violations.
				l_result.invs.do_all (agent l_valid_contracts_in_order.delete)
			end
			l_valid_contracts_in_order := expressions_ordered_by_set_size (l_valid_contracts_in_order, l_expressions_to_satisfying_state_hashes)
--			prune_stronger_expressions (l_valid_contracts_in_order, l_expressions_to_satisfying_state_hashes)

			l_essential_contracts_in_order := expressions_in_order (l_essential_contracts)
			prune_disjunctions_of_true_expressions (l_essential_contracts_in_order)

			l_result := expressions_to_satisfying_state_hashes (l_all_traces, target_feature.context_class, target_feature.feature_, l_essential_contracts_in_order, l_agent)
			l_result_overall := expressions_to_satisfying_state_hashes (l_all_traces, target_feature.context_class, target_feature.feature_, l_essential_contracts_in_order, Void)
				-- Use the invs of all interesting states as essential contracts.
			create l_essential_contracts.make_equal (l_result.invs.count + 1)
			l_result.invs.do_all (agent l_essential_contracts.force)
			if not session.exception_signature.is_postcondition_violation then
				l_result_overall.invs.do_all (agent l_essential_contracts.remove)
			end
			l_essential_contracts_in_order := expressions_in_order (l_essential_contracts)
			if session.exception_signature.is_postcondition_violation then
				prefer_equality_in_postcondition (l_essential_contracts_in_order)
			end


--			l_expressions_to_satisfying_state_hashes := l_result.htable
--			l_result.invs.do_all (agent l_essential_contracts_in_order.delete)
--			l_essential_contracts_in_order := expressions_ordered_by_set_size (l_essential_contracts_in_order, l_expressions_to_satisfying_state_hashes)
--			prune_stronger_expressions (l_essential_contracts_in_order, l_expressions_to_satisfying_state_hashes)

			l_contracts_to_remove := l_written_contracts.twin
			l_valid_contracts_in_order.do_all (agent l_contracts_to_remove.remove)

			l_contracts_to_add_in_order := l_essential_contracts_in_order.twin
			l_written_contracts.do_all (agent l_contracts_to_add_in_order.delete)
			create l_contracts_to_add.make_equal (l_contracts_to_add_in_order.count + 1)
			l_contracts_to_add_in_order.do_all (agent l_contracts_to_add.force)
--			l_contracts_to_add_in_order := expressions_in_order (l_contracts_to_add)

--			l_result := expressions_to_satisfying_state_hashes (l_all_traces, target_feature.context_class, target_feature.feature_, l_contracts_to_add, l_agent)
--			l_expressions_to_satisfying_state_hashes := l_result.htable
--			l_contracts_to_add_in_order := expressions_ordered_by_set_size (l_contracts_to_add, l_expressions_to_satisfying_state_hashes)

			append_fix (target_feature, l_is_precondition_violation, Void, l_contracts_to_remove, Result)
			from
				l_contract_cursor := l_contracts_to_add_in_order.new_cursor
				l_contract_cursor.start
			until
				l_contract_cursor.after or else Result.count >= max_weakening_fixes
			loop
				create l_temp_contracts_to_add.make_equal (1)
				l_temp_contracts_to_add.force (l_contract_cursor.item)
				append_fix (target_feature, l_is_precondition_violation, l_temp_contracts_to_add, l_contracts_to_remove, Result)

				l_contract_cursor.forth
			end
		end

	prefer_equality_in_postcondition (a_exprs: DS_ARRAYED_LIST[EPA_AST_EXPRESSION])
		local
			l_expr_cursor: DS_ARRAYED_LIST_CURSOR [EPA_AST_EXPRESSION]
			l_expr: EPA_AST_EXPRESSION
			l_expr_text: STRING
			l_equalities: DS_ARRAYED_LIST[EPA_AST_EXPRESSION]
		do
			from
				create l_equalities.make_equal (a_exprs.count + 1)
				l_expr_cursor := a_exprs.new_cursor
				l_expr_cursor.start
			until
				l_expr_cursor.after
			loop
				l_expr := l_expr_cursor.item
				l_expr_text := l_expr.text
				if
					(l_expr_text.has ('=') or else l_expr_text.has ('~'))
					and then not l_expr_text.has_substring ("/=")
					and then not l_expr_text.has_substring ("/~")
					and then not l_expr_text.has_substring (">")
					and then not l_expr_text.has_substring ("<")
					and then not l_expr_text.has_substring ("or else")
				then
					l_equalities.force_last (l_expr)
				end
				l_expr_cursor.forth
			end
			l_equalities.do_all (agent a_exprs.delete)
			a_exprs.append_first (l_equalities)
		end

	append_fix (a_feature: AFX_FEATURE_TO_MONITOR; a_is_pre: BOOLEAN; a_contracts_to_add, a_contracts_to_remove: EPA_HASH_SET [EPA_AST_EXPRESSION]; a_fixes: DS_ARRAYED_LIST [AFX_CONTRACT_FIX_PER_FEATURE])
		local
			l_fix: AFX_CONTRACT_FIX_PER_FEATURE
		do
			if (a_contracts_to_add /= Void and then not a_contracts_to_add.is_empty) or else (a_contracts_to_remove /= Void and then not a_contracts_to_remove.is_empty) then
				create l_fix.make (a_feature, a_is_pre, a_contracts_to_add, a_contracts_to_remove)
				a_fixes.force_last (l_fix)
			end
		end



end
