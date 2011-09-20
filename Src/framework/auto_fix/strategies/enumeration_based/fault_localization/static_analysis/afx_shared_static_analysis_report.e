note
	description: "Summary description for {AFX_SHARED_STATIC_ANALYSIS_REPORT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_SHARED_STATIC_ANALYSIS_REPORT

inherit
	ANY
		undefine
			is_equal,
			copy
		end

feature -- Access

--	exception_signature: AFX_EXCEPTION_SIGNATURE assign set_exception_signature
--			-- Signature of the exception.
--		do
--			Result := exception_signature_cell.item
--		end

--	exception_recipient_feature: AFX_EXCEPTION_RECIPIENT_FEATURE
--			-- Recipient feature of `exception_signature'.
--		do
--			Result := exception_recipient_feature_cell.item
--		end

--	control_distance_report: AFX_CONTROL_DISTANCE_REPORT assign set_control_distance_report
--			-- Shared control distance report.
--		do
--			Result := control_distance_report_cell.item
--		end

--	exception_spot: AFX_EXCEPTION_SPOT assign set_exception_spot
--			-- Information about the exception spot.
--		do
--			Result := exception_spot_cell.item
--		end

--	state_skeleton_for_feature (a_class: CLASS_C; a_feature: FEATURE_I): EPA_STATE_SKELETON
--			-- State skeleton for `a_feature' from `a_class'.
--		local
--			l_feature_with_context: AFX_FEATURE_WITH_CONTEXT_CLASS
--			l_expr_list: ARRAYED_LIST [EPA_EXPRESSION]
--			l_expressions_to_monitor: like expressions_to_monitor
--		do
--			create l_feature_with_context.make (a_feature, a_class)
--			if repository_for_state_skeleton_for_feature.has (l_feature_with_context) then
--				Result := repository_for_state_skeleton_for_feature.item (l_feature_with_context)
--			else
--				l_expressions_to_monitor := expressions_to_monitor (l_feature_with_context)
--				create l_expr_list.make (l_expressions_to_monitor.count)
--				l_expressions_to_monitor.keys.do_all (agent l_expr_list.force)
--				create Result.make_with_expressions (a_class, a_feature, l_expr_list)
--				repository_for_state_skeleton_for_feature.force (Result, l_feature_with_context)
--			end
--		end

--	derived_state_skeleton_for_feature (a_class: CLASS_C; a_feature: FEATURE_I): AFX_PROGRAM_STATE_SKELETON
--			-- Derived state skeleton for `a_feature'.
--		local
--			l_feature_with_context: AFX_FEATURE_WITH_CONTEXT_CLASS
--			l_expressions_to_monitor: like expressions_to_monitor
--			l_expressions: EPA_HASH_SET [EPA_EXPRESSION]
--			l_builder: AFX_DERIVED_STATE_SKELETON_BUILDER
--		do
--			create l_feature_with_context.make (a_feature, a_class)
--			if repository_for_derived_state_skeleton.has (l_feature_with_context) then
--				Result := repository_for_derived_state_skeleton.item (l_feature_with_context)
--			else
--				l_expressions_to_monitor := expressions_to_monitor (l_feature_with_context)
--				create l_expressions.make_equal (l_expressions_to_monitor.count)
--				l_expressions_to_monitor.keys.do_all (agent l_expressions.force)
--				create l_builder
--				l_builder.build_skeleton (Current, l_expressions)
--				Result := l_builder.last_derived_skeleton
--				repository_for_derived_state_skeleton.force (Result, l_feature_with_context)
--			end
--		end

--	expressions_to_monitor (a_feature: AFX_FEATURE_WITH_CONTEXT_CLASS): DS_HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]
--			-- Expressions that can be monitored in `a_feature'.
--			-- Key: expressions.
--			-- Val: ranking of expressions.
--		local
--			l_table: DS_HASH_TABLE [DS_HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION], AFX_FEATURE_WITH_CONTEXT_CLASS]
--			l_ranking: DS_HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]
--		do
--			l_table := repository_for_expressions_to_monitor
--			if l_table.has (a_feature) then
--				Result := l_table.item (a_feature)
--			else
--				Result := Void
--			end
--		end

--feature{AFX_SHARED_STATIC_ANALYSIS_REPORT} -- Repository access

--	repository_for_expressions_to_monitor: DS_HASH_TABLE [DS_HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION], AFX_FEATURE_WITH_CONTEXT_CLASS]
--			-- Repository for expressions to monitor, regarding different features.
--			-- Key: feature with context;
--			-- Val: expressions to monitor within the feature.
--		do
--			Result := repository_for_expressions_to_monitor_cell.item
--		ensure
--			result_attached: Result /= Void
--		end

--	repository_for_state_skeleton_for_feature: DS_HASH_TABLE [EPA_STATE_SKELETON, AFX_FEATURE_WITH_CONTEXT_CLASS]
--			-- Repository for state skeleton for feature.
--		do
--			Result := repository_for_state_skeleton_for_feature_cell.item
--		ensure
--			result_attached: Result /= Void
--		end

--	repository_for_derived_state_skeleton: DS_HASH_TABLE [AFX_PROGRAM_STATE_SKELETON, AFX_FEATURE_WITH_CONTEXT_CLASS]
--			-- Repository for derived state skeletons.
--		do
--			Result := repository_for_derived_state_skeleton_cell.item
--		ensure
--			result_attached: Result /= VOid
--		end

feature{AFX_SHARED_STATIC_ANALYSIS_REPORT} -- Status set

	set_exception_signature (a_signature: AFX_EXCEPTION_SIGNATURE)
			-- Set `exception_signature'.
		do
			exception_signature_cell.put (a_signature)
		end

	set_exception_recipient_feature (a_feature: AFX_EXCEPTION_RECIPIENT_FEATURE)
			-- Set `exception_recipient_feature'.
		do
			exception_recipient_feature_cell.put (a_feature)
		end

--	set_control_distance_report (a_report: like control_distance_report)
--			-- Set `control_distance_report'.
--		do
--			control_distance_report_cell.put (a_report)
--		end

--	set_exception_spot (a_spot: AFX_EXCEPTION_SPOT)
--			-- Set `exception_spot'.
--		do
--			exception_spot_cell.put (a_spot)
--		end

--	set_expressions_to_monitor_for_feature (a_feature: AFX_FEATURE_WITH_CONTEXT_CLASS; a_expressions: DS_HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION])
--			-- Set `a_expressions' to be monitored for `a_feature'.
--		require
--			feature_attached: a_feature /= Void
--			expressions_attached: a_expressions /= Void
--		do
--			repository_for_expressions_to_monitor.force (a_expressions, a_feature)
--		end

--	reset_all_expressions_to_monitor
--			-- Reset `repository_for_expressions_to_monitor'.
--		local
--			l_table: DS_HASH_TABLE [DS_HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION], AFX_FEATURE_WITH_CONTEXT_CLASS]
--		do
--			create l_table.make_equal (10)
--			repository_for_expressions_to_monitor_cell.put (l_table)
--		end

--	reset_all_state_skeletons
--			-- Reset `repository_for_state_skeleton_for_feature'.
--		local
--			l_table: DS_HASH_TABLE [EPA_STATE_SKELETON, AFX_FEATURE_WITH_CONTEXT_CLASS]
--		do
--			create l_table.make_equal (10)
--			repository_for_state_skeleton_for_feature_cell.put (l_table)
--		end

--	reset_all_derived_state_skeletons
--			-- Reset all derived state skeletons.
--		local
--			l_table: DS_HASH_TABLE [AFX_PROGRAM_STATE_SKELETON, AFX_FEATURE_WITH_CONTEXT_CLASS]
--		do
--			create l_table.make_equal (10)
--			repository_for_derived_state_skeleton_cell.put (l_table)
--		end

feature{NONE} -- Shared storage

	exception_signature_cell: CELL [AFX_EXCEPTION_SIGNATURE]
			-- Cell for `exception_signature'.
		once
			create Result.put(Void)
		end

	exception_recipient_feature_cell: CELL [AFX_EXCEPTION_RECIPIENT_FEATURE]
			-- Cell for `exception_recipient_feature'.
		once
			create Result.put (Void)
		end

--	control_distance_report_cell: CELL [AFX_CONTROL_DISTANCE_REPORT]
--			-- Storage for `control_distance_report'.
--		once
--			create Result.put (Void)
--		end

--	exception_spot_cell: CELL [AFX_EXCEPTION_SPOT]
--			-- Storage for `exception_spot'.
--		once
--			create Result.put (Void)
--		end

--	repository_for_expressions_to_monitor_cell: CELL [DS_HASH_TABLE [DS_HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION], AFX_FEATURE_WITH_CONTEXT_CLASS]]
--			-- Storage for `relevant_expressions_by_feature'.
--		once
--			create Result.put (Void)
--			reset_all_expressions_to_monitor
--		end

--	repository_for_state_skeleton_for_feature_cell: CELL [DS_HASH_TABLE [EPA_STATE_SKELETON, AFX_FEATURE_WITH_CONTEXT_CLASS]]
--			-- Cell for `repository_for_state_skeleton_for_feature'.
--		once
--			create Result.put(Void)
--			reset_all_state_skeletons
--		end

--	repository_for_derived_state_skeleton_cell: CELL [DS_HASH_TABLE [AFX_PROGRAM_STATE_SKELETON, AFX_FEATURE_WITH_CONTEXT_CLASS]]
--			-- Cell for `repository_for_derived_state_skeleton'.
--		once
--			create Result.put(Void)
--			reset_all_derived_state_skeletons
--		end


end
