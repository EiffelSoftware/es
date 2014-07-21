note
	description: "Summary description for {AFX_FIX_TO_FAULT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_CONTRACT_FIX_TO_FAULT

inherit
	AFX_FIX_TO_FAULT
		undefine copy, out end

	DS_HASH_TABLE [AFX_CONTRACT_FIX_TO_FEATURE, AFX_FEATURE_TO_MONITOR]
		rename make as make_table
		undefine is_equal, out end

	AFX_SHARED_SESSION
		undefine copy, is_equal, out end

	DEBUG_OUTPUT
		undefine copy, is_equal, out end

	AFX_UTILITY
		undefine copy, is_equal, out end

create
	make

feature{NONE} -- Initialization

	make
		do
			make_general
			make_equal (1)
		end

feature -- Access

	contract_clauses_after_fix: DS_HASH_TABLE [TUPLE [pre, post: EPA_HASH_SET [EPA_EXPRESSION]], AFX_FEATURE_TO_MONITOR]
			--
		local
			l_cursor: DS_HASH_TABLE_CURSOR [AFX_CONTRACT_FIX_TO_FEATURE, AFX_FEATURE_TO_MONITOR]
		do
			if contract_clauses_after_fix_cache = Void then
				create contract_clauses_after_fix_cache.make_equal (10)
				from
					l_cursor := new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					contract_clauses_after_fix_cache.force (l_cursor.item.contract_clauses_after_fix, l_cursor.key)

					l_cursor.forth
				end
			end
			Result := contract_clauses_after_fix_cache
		end

feature -- Redefinition

	signature: STRING
			-- <Precursor>
		do
			Result := "Subject=Fix to contract;ID=Auto-" + id.out + ";Validity=" + is_valid.out + ";Type=" + change_type_str + ";"
		end

	out: STRING
			-- <Precursor>
		do
			create Result.make (1024)

				-- CAUTION: We use the fault_signature_id from command line argument, instead
				--			of the one from the fault replay (session.fault_signature_id),
				-- 			which contains more detailed info though.
				--			In this way, we can match the fixes to the faults in AutoDebug.
				--			See: AFX_CODE_FIX_TO_FAULT
			Result.append ("  -- FaultID:" + session.config.fault_signature_id + ";%N")
			Result.append ("  -- FixInfo:" + signature + "%N")
			Result.append (formatted_output)
		end

	debug_output: STRING
			-- <Precursor>
		do
			Result := out
		end

	change_type_str: STRING
		local
			l_strengthening, l_weakening: BOOLEAN
		do
			l_strengthening := is_strengthening
			l_weakening := is_weakening
			if l_strengthening and then l_weakening then
				Result := "Weaken and strengthen"
			elseif l_strengthening then
				Result := "Strengthen"
			elseif l_weakening then
				Result := "Weaken"
			end
		ensure
			Result /= Void
		end

	is_strengthening: BOOLEAN
		local
			l_cursor: DS_HASH_TABLE_CURSOR [AFX_CONTRACT_FIX_TO_FEATURE, AFX_FEATURE_TO_MONITOR]
		do
			from
				l_cursor := new_cursor
				l_cursor.start
			until
				l_cursor.after or else Result
			loop
				Result := Result or else l_cursor.item.is_strengthening

				l_cursor.forth
			end
		end

	is_weakening: BOOLEAN
		local
			l_cursor: DS_HASH_TABLE_CURSOR [AFX_CONTRACT_FIX_TO_FEATURE, AFX_FEATURE_TO_MONITOR]
		do
			from
				l_cursor := new_cursor
				l_cursor.start
			until
				l_cursor.after or else Result
			loop
				Result := Result or else l_cursor.item.is_weakening

				l_cursor.forth
			end
		end

	formatted_output: STRING
			-- <Precursor>
		local
			l_cursor: DS_HASH_TABLE_CURSOR [AFX_CONTRACT_FIX_TO_FEATURE, AFX_FEATURE_TO_MONITOR]
		do
			if formatted_output_cache = Void then
				formatted_output_cache := ""
				if not is_empty then
					from
						l_cursor := new_cursor
						l_cursor.start
					until
						l_cursor.after
					loop
						formatted_output_cache.append (l_cursor.item.out)
						l_cursor.forth
					end
					formatted_output_cache := formatted_output_cache.substring (1, formatted_output_cache.count)
				end
			end
			Result := formatted_output_cache
		end

feature -- Operation

	add_component (a_component: AFX_CONTRACT_FIX_TO_FEATURE)
			--
		require
			a_component /= Void
		local
			l_old: AFX_CONTRACT_FIX_TO_FEATURE
		do
			if not has (a_component.context_feature) then
				force (a_component, a_component.context_feature)
			else
				l_old := item (a_component.context_feature)
				l_old.merge (a_component)
			end

			contract_clauses_after_fix_cache := Void
			formatted_output_cache := Void
		end

	add_components (a_components: DS_LIST [AFX_CONTRACT_FIX_TO_FEATURE])
			--
		require
			a_components /= Void
		do
			a_components.do_all (agent add_component)
		end

	compute_ranking_wrt_trace_repository (a_traces: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY; a_all_features_to_monitor: DS_ARRAYED_LIST [AFX_FEATURE_TO_MONITOR])
			--
		local
			l_new_contracts: DS_HASH_TABLE [TUPLE [pre: EPA_HASH_SET [EPA_EXPRESSION]; post: EPA_HASH_SET [EPA_EXPRESSION]], AFX_FEATURE_TO_MONITOR]
			l_feature_cursor: DS_ARRAYED_LIST_CURSOR [AFX_FEATURE_TO_MONITOR]
			l_features_to_monitor_by_names: DS_HASH_TABLE [AFX_FEATURE_TO_MONITOR, STRING]
			l_trace_cursor: DS_HASH_TABLE_CURSOR [AFX_PROGRAM_EXECUTION_TRACE, EPA_TEST_CASE_INFO]
			l_trace: AFX_PROGRAM_EXECUTION_TRACE
			l_state_cursor: LINKED_LIST_ITERATION_CURSOR [AFX_PROGRAM_EXECUTION_STATE]
			l_execution_state: AFX_PROGRAM_EXECUTION_STATE
			l_location: AFX_PROGRAM_LOCATION
			l_feature_to_monitor: AFX_FEATURE_TO_MONITOR
			l_is_failing, l_is_invalid, l_is_pre, l_is_post: BOOLEAN
			l_nbr_failing, l_nbr_invalid: INTEGER
			l_pre, l_post, l_contract, l_true_expressions: EPA_HASH_SET [EPA_EXPRESSION]
			l_contract_clauses_after_fix: DS_HASH_TABLE [TUPLE [pre, post: EPA_HASH_SET [EPA_EXPRESSION]], AFX_FEATURE_TO_MONITOR]
			l_true_value: EPA_BOOLEAN_VALUE
			l_true_expressions_from_state: EPA_HASH_SET [EPA_EXPRESSION]
		do
				-- New contracts for all features under monitoring.
			create l_new_contracts.make_equal (a_all_features_to_monitor.count + 1)
			l_contract_clauses_after_fix := contract_clauses_after_fix
			from
				l_feature_cursor := a_all_features_to_monitor.new_cursor
				l_feature_cursor.start
			until
				l_feature_cursor.after
			loop
				if l_contract_clauses_after_fix.has (l_feature_cursor.item) then
					l_new_contracts.force (l_contract_clauses_after_fix.item (l_feature_cursor.item), l_feature_cursor.item)
				else
					l_new_contracts.force (l_feature_cursor.item.contracts, l_feature_cursor.item)
				end
				l_feature_cursor.forth
			end

			l_nbr_failing := 0
			l_nbr_invalid := 0
			create l_true_value.make (True)
			l_features_to_monitor_by_names := features_to_monitor_by_names (a_all_features_to_monitor)
			from
				l_trace_cursor := a_traces.new_cursor
				l_trace_cursor.start
			until
				l_trace_cursor.after
			loop
				l_trace := l_trace_cursor.item

				from
					l_is_failing := False
					l_is_invalid := False
					l_state_cursor := l_trace.new_cursor
					l_state_cursor.start
				until
					l_state_cursor.after or else l_is_failing or else l_is_invalid
				loop
					l_execution_state := l_state_cursor.item
					l_location := l_execution_state.location

					if l_features_to_monitor_by_names.has (l_location.context.qualified_feature_name) then
						l_feature_to_monitor := l_features_to_monitor_by_names.item (l_location.context.qualified_feature_name)
						l_is_pre := l_location.breakpoint_index = l_feature_to_monitor.breakpoint_to_evaluate_precondition
						l_is_post:= l_location.breakpoint_index = l_feature_to_monitor.breakpoint_to_evaluate_postcondition

							-- FIXME: do we need to use expression text for comparison?
						if l_is_pre or l_is_post then
							l_true_expressions_from_state := l_execution_state.state.expressions_with_value (l_true_value)
							if l_is_pre then
								l_contract := l_new_contracts.item (l_feature_to_monitor).pre
							else
								l_contract := l_new_contracts.item (l_feature_to_monitor).post
							end
							if not l_contract.is_subset (l_true_expressions_from_state) then
								if l_feature_to_monitor ~ session.feature_under_test and then l_is_pre then
									l_is_invalid := True
									l_nbr_invalid := l_nbr_invalid + 1
								else
									l_is_failing := True
									l_nbr_failing := l_nbr_failing + 1
								end
							end
						end
					end
					l_state_cursor.forth
				end

				l_trace_cursor.forth
			end

			set_ranking (Ranking_weight_for_failing * l_nbr_failing + Ranking_weight_for_invalid * l_nbr_invalid)
		end

feature{NONE} -- Implementation

	feature_to_monitor_from_context (a_context_feature: EPA_FEATURE_WITH_CONTEXT_CLASS): AFX_FEATURE_TO_MONITOR
			--
		local
			l_cursor: DS_HASH_TABLE_CURSOR [AFX_CONTRACT_FIX_TO_FEATURE, AFX_FEATURE_TO_MONITOR]
		do
			from
				l_cursor := new_cursor
				l_cursor.start
			until
				l_cursor.after or else Result /= Void
			loop
				if l_cursor.key.is_about_same_feature (a_context_feature) then
					Result := l_cursor.key
				end
				l_cursor.forth
			end
		end

feature{NONE} -- Cache

	formatted_output_cache: STRING

	contract_clauses_after_fix_cache: like contract_clauses_after_fix

feature -- Constant

	Ranking_weight_for_failing: INTEGER = 10000
	Ranking_weight_for_invalid: INTEGER = 1
end
