note
	description: "Summary description for {EBB_SHARED_HELPER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_SHARED_HELPER

feature {NONE} -- Helper functions

	features_written_in_class (a_class: CLASS_C): LIST [FEATURE_I]
			-- List of features written in class `a_class'.
		local
			l_feature: FEATURE_I
		do
			create {LINKED_LIST [FEATURE_I]} Result.make
			from
				a_class.feature_table.start
			until
				a_class.feature_table.after
			loop
				l_feature := a_class.feature_table.item_for_iteration
				if l_feature.written_in = a_class.class_id then
					Result.extend (l_feature)
				end
				a_class.feature_table.forth
			end
		end

end
