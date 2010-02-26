note
	description: "Summary description for {EPA_FEATURE_FINDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_FEATURE_FINDER

feature -- Access

	last_found_features: LINKED_LIST [FEATURE_I]
			-- Features that are found by last `find'

	feature_selection_agent: FUNCTION [ANY, TUPLE [FEATURE_I], BOOLEAN]
			-- Agent to select a feature,
			-- If this return returns True with a given feature, that feature is selected, otherwise,
			-- that feature is ignored.
		deferred
		ensure
			result_attached: Result /= Void
		end

feature -- Basic operations

	find (a_class: CLASS_C)
			-- Find features in `a_class' which satisfies `feature_selection_agent',
			-- make result available in `last_found_features'.
			-- Create a new instance of `last_found_features'.
		deferred
		ensure
			last_found_features_attached: last_found_features /= Void
		end

feature{NONE} -- Implementation

	features (a_class: CLASS_C): LINKED_LIST [FEATURE_I]
			-- List of all features from `a_class'
		local
			l_cursor: CURSOR
			l_feat_tbl: FEATURE_TABLE
		do
			create Result.make
			l_feat_tbl := a_class.feature_table
			l_cursor := l_feat_tbl.cursor
			from
				l_feat_tbl.start
			until
				l_feat_tbl.after
			loop
				Result.extend (l_feat_tbl.item_for_iteration)
				l_feat_tbl.forth
			end
			l_feat_tbl.go_to (l_cursor)
		end

end
