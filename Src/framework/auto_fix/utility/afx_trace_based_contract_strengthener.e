note
	description: "Summary description for {AFX_TRACE_BASED_CONTRACT_STRENGTHENER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_TRACE_BASED_CONTRACT_STRENGTHENER

inherit
	AFX_TRACE_BASED_CONTRACT_FIXER

feature -- Basic operation

	fix_traces (a_traces_to_keep, a_traces_to_reject, a_extra_traces_for_implication_inference: DS_LIST [AFX_PROGRAM_EXECUTION_TRACE]; a_features: DS_LIST [AFX_FEATURE_TO_MONITOR])
			-- <Precursor>
			--
			-- `a_relaxed_traces' not used in strengthening.
		local
			l_exception_signature: AFX_EXCEPTION_SIGNATURE
			l_non_target_features: DS_LIST [AFX_FEATURE_TO_MONITOR]
			l_passings, l_failings: DS_ARRAYED_LIST [AFX_PROGRAM_EXECUTION_TRACE]
			l_summary_of_passings, l_summary_of_failings: like summary_of_traces
		do
			reset
			traces_to_keep := a_traces_to_keep
			traces_to_reject := a_traces_to_reject
			traces_for_implication_inference := a_extra_traces_for_implication_inference.twin
			traces_to_keep.do_all (agent traces_for_implication_inference.force_last)
			traces_to_reject.do_all (agent traces_for_implication_inference.force_last)

				-- Do not strengthen the precondition of the failing feature, in case of precondition violation.
			l_exception_signature := session.exception_from_execution
			if l_exception_signature.is_precondition_violation and then a_features.first.context_class ~ l_exception_signature.exception_class and then a_features.first.feature_ ~ l_exception_signature.exception_feature then
				l_non_target_features := a_features.twin
				l_non_target_features.remove_first
			else
				l_non_target_features := a_features
			end

			l_summary_of_passings := summary_of_traces (traces_to_keep,   l_non_target_features, False)
			l_summary_of_failings := summary_of_traces (traces_to_reject, l_non_target_features, True )

			last_contract_fixes_cache := strengthenings_from_summaries (l_non_target_features, True, l_summary_of_passings, l_summary_of_failings)
		end

feature{NONE} -- Access

	traces_to_keep: DS_LIST [AFX_PROGRAM_EXECUTION_TRACE]
	traces_to_reject: DS_LIST [AFX_PROGRAM_EXECUTION_TRACE]
	traces_for_implication_inference: DS_LIST [AFX_PROGRAM_EXECUTION_TRACE]

feature{NONE} -- Implementation

	strengthenings_from_summaries (a_features: DS_LIST [AFX_FEATURE_TO_MONITOR]; a_is_pre: BOOLEAN; a_summary_from_passing, a_summary_from_failing: DS_HASH_TABLE [TUPLE[pre, post: EPA_HASH_SET[EPA_EXPRESSION]], AFX_FEATURE_TO_MONITOR]): DS_ARRAYED_LIST [AFX_CONTRACT_FIX_TO_FAULT]
			--
		local
			l_feature_cursor: DS_LIST_CURSOR [AFX_FEATURE_TO_MONITOR]
			l_feature: AFX_FEATURE_TO_MONITOR
			l_features_to_summary_differences: DS_HASH_TABLE [DS_ARRAYED_LIST [EPA_EXPRESSION], AFX_FEATURE_TO_MONITOR]
			l_difference: EPA_HASH_SET[EPA_EXPRESSION]
			l_expressions_to_satisfying_state_hashes: DS_HASH_TABLE [EPA_HASH_SET[STRING], EPA_EXPRESSION]
			l_expressions_in_order: DS_ARRAYED_LIST [EPA_EXPRESSION]
			l_number_of_combinations, l_fix_index: INTEGER
			l_fix: AFX_CONTRACT_FIX_TO_FAULT
			l_local_fix: AFX_CONTRACT_FIX_TO_FEATURE
			l_contracts_to_add, l_contracts_to_remove: EPA_HASH_SET [EPA_EXPRESSION]
			l_contract: EPA_EXPRESSION
			l_summary_difference_cursor: DS_HASH_TABLE_CURSOR [DS_ARRAYED_LIST [EPA_EXPRESSION], AFX_FEATURE_TO_MONITOR]
			l_result: TUPLE [htable: DS_HASH_TABLE [EPA_HASH_SET[STRING], EPA_EXPRESSION]; invs: EPA_HASH_SET[EPA_EXPRESSION]]
		do
			create Result.make (max_strengthening_fixes)

				-- Compute for each feature the expressions that can be used for strengthening.
			create l_features_to_summary_differences.make_equal (a_features.count + 1)
			from
				l_number_of_combinations := 1
				l_feature_cursor := a_features.new_cursor
				l_feature_cursor.start
			until
				l_feature_cursor.after
			loop
				l_feature := l_feature_cursor.item

				l_difference := difference_between_summaries (l_feature, a_is_pre, a_summary_from_passing, a_summary_from_failing)
				if not l_difference.is_empty then
					l_expressions_in_order := prune_disjunctions_of_true_expressions (l_difference)

					create l_difference.make_equal (l_expressions_in_order.count + 1)
					l_expressions_in_order.do_all (agent l_difference.force)
					l_result := expressions_to_satisfying_state_hashes (traces_for_implication_inference, l_feature.context_class, l_feature.feature_, l_difference, Void)
					l_expressions_to_satisfying_state_hashes := l_result.htable
					l_expressions_in_order := expressions_ordered_by_set_size (l_difference, l_expressions_to_satisfying_state_hashes)

					l_number_of_combinations := l_number_of_combinations * l_expressions_in_order.count
					l_features_to_summary_differences.force (l_expressions_in_order, l_feature)
				end

				l_feature_cursor.forth
			end

				-- Generate strengthening fixes
			from
				l_fix_index := 0
			until
				l_fix_index >= l_number_of_combinations or else l_fix_index >= max_strengthening_fixes
			loop
				create l_fix.make	-- .make_equal (l_features_to_summary_differences.count + 1)

				from
					l_summary_difference_cursor := l_features_to_summary_differences.new_cursor
					l_summary_difference_cursor.start
				until
					l_summary_difference_cursor.after
				loop
					l_feature := l_summary_difference_cursor.key
					l_expressions_in_order := l_summary_difference_cursor.item

					l_contract := l_expressions_in_order.item (l_fix_index \\ l_expressions_in_order.count + 1)
					create l_contracts_to_add.make_equal (1)
					l_contracts_to_add.force (l_contract)

					if a_is_pre then
						create l_local_fix.make (l_feature, l_contracts_to_add, Void, Void, Void)
					else
						create l_local_fix.make (l_feature, Void, Void, l_contracts_to_add, Void)
					end
					l_fix.add_component (l_local_fix)

					l_summary_difference_cursor.forth
				end
				if not l_fix.is_empty then
					Result.force_last (l_fix)
				end

				l_fix_index := l_fix_index + 1
			end


		end

	difference_between_summaries (a_feature: AFX_FEATURE_TO_MONITOR; a_is_pre: BOOLEAN; a_summary_from_passing, a_summary_from_failing: DS_HASH_TABLE [TUPLE[pre, post: EPA_HASH_SET[EPA_EXPRESSION]], AFX_FEATURE_TO_MONITOR]): EPA_HASH_SET[EPA_EXPRESSION]
		local
			l_passings, l_failings, l_differences: EPA_HASH_SET[EPA_EXPRESSION]
		do
			if a_summary_from_passing.has (a_feature) then
				if a_is_pre then
					l_passings := a_summary_from_passing.item (a_feature).pre
				else
					l_passings := a_summary_from_passing.item (a_feature).post
				end
			else
				l_passings := Void
			end

			if a_summary_from_failing.has (a_feature) then
				if a_is_pre then
					l_failings := a_summary_from_failing.item (a_feature).pre
				else
					l_failings := a_summary_from_failing.item (a_feature).post
				end
			else
				l_failings := Void
			end

			if l_passings /= Void and then l_failings /= Void then
				Result := l_passings.subtraction (l_failings)
			else
				-- Other cases not supported yet.
				create Result.make_equal (2)
			end
		end

end
