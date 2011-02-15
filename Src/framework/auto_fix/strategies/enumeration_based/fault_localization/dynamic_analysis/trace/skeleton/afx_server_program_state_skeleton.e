note
	description: "Summary description for {AFX_SERVER_PROGRAM_STATE_SKELETON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SERVER_PROGRAM_STATE_SKELETON

inherit

	AFX_SHARED_SERVER_EXPRESSIONS_TO_MONITOR

	EPA_UTILITY

feature -- Access

	skeleton_breakpoint_specific (a_class: CLASS_C; a_feature: FEATURE_I): AFX_PROGRAM_STATE_SKELETON
			-- Program state skeleton regarding `a_feature' from `a_class'.
			-- The skeleton is breakpoint specific.
		local
		do

		end

	skeleton_breakpoint_unspecific (a_class: CLASS_C; a_feature: FEATURE_I): AFX_PROGRAM_STATE_SKELETON
			-- Program state skeleton regarding `a_feature' from `a_class'.
			-- The skeleton is breakpoint unspecific.
		local
			l_expressions_to_monitor: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			l_builder: AFX_PROGRAM_STATE_SKELETON_BUILDER
		do
			Result := skeleton_for_feature (breakpoint_unspecific_skeletons, a_class, a_feature)

			if Result = Void then
				l_expressions_to_monitor := server_expressions_to_monitor.set_of_expressions_to_monitor_without_bp_index (a_class, a_feature)
				create l_builder
				l_builder.build_skeleton (l_expressions_to_monitor)
				Result := l_builder.last_built_skeleton
				register_skeleton (breakpoint_unspecific_skeletons, a_class, a_feature, Result)
			end
		ensure
			result_attached: Result /= Void
		end

feature{NONE} -- Access

	breakpoint_unspecific_skeletons: DS_HASH_TABLE [ DS_HASH_TABLE [AFX_PROGRAM_STATE_SKELETON, INTEGER], INTEGER]
			-- Program state skeletons.
			-- Key: feature_id <- class_id
			-- Val: skeleton
		do
			if breakpoint_unspecific_skeletons_cache = Void then
				create breakpoint_unspecific_skeletons_cache.make (10)
			end

			Result := breakpoint_unspecific_skeletons_cache
		end

feature{NONE} -- Implementation

	skeleton_for_feature (a_skeletons: like breakpoint_unspecific_skeletons; a_class: CLASS_C; a_feature: FEATURE_I): AFX_PROGRAM_STATE_SKELETON
			-- Skeleton for `a_feature' from `a_class', from the registry `a_skeletons'.
		local
			l_class_id, l_feature_id: INTEGER
			l_table: DS_HASH_TABLE [AFX_PROGRAM_STATE_SKELETON, INTEGER]
		do
			l_class_id := a_class.class_id
			l_feature_id := a_feature.feature_id

			if a_skeletons.has (l_class_id) then
				l_table := a_skeletons.item (l_class_id)
				check table_attached: l_table /= Void end
				if l_table.has (l_feature_id) then
					Result := l_table.item (l_feature_id)
				end
			end
		end

	register_skeleton (a_skeletons: like breakpoint_unspecific_skeletons; a_class: CLASS_C; a_feature: FEATURE_I; a_skeleton: AFX_PROGRAM_STATE_SKELETON)
			-- Register `a_skeleton' into `a_skeletons', using keys from `a_class'.`a_feature'.
		require
			no_skeleton_registered: skeleton_for_feature (a_skeletons, a_class, a_feature) = Void
		local
			l_class_id, l_feature_id: INTEGER
			l_table: DS_HASH_TABLE [AFX_PROGRAM_STATE_SKELETON, INTEGER]
		do
			l_class_id := a_class.class_id
			l_feature_id := a_feature.feature_id

			if a_skeletons.has (l_class_id) then
				l_table := a_skeletons.item (l_class_id)
				check l_table /= Void and then not l_table.has (l_feature_id) end
			else
				create l_table.make (10)
				a_skeletons.force (l_table, l_class_id)
			end
			l_table.force (a_skeleton, l_feature_id)
		end

feature{NONE} -- Cache

	breakpoint_unspecific_skeletons_cache: like breakpoint_unspecific_skeletons
			-- Cache for `breakpoint_unspecific_skeletons'.

end
