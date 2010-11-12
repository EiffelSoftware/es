note
	description: "Helper features used by different classes."
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
			if a_class.feature_table /= Void then
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

	is_feature_verified (a_feature: FEATURE_I): BOOLEAN
			-- Is feature `a_feature' verified?
		do
			Result := not a_feature.is_attribute and not a_feature.is_deferred and not a_feature.is_external
		end

	is_feature_data_verified (a_feature_data: EBB_FEATURE_DATA): BOOLEAN
			-- Is feature `a_feature_data' verified?
		do
			Result := is_feature_verified (a_feature_data.associated_feature)
		end


end
