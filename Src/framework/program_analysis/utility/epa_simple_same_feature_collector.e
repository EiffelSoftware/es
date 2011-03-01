note
	description: "Class to collect features with the same signature and body"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_SIMPLE_SAME_FEATURE_COLLECTOR

inherit
	EPA_UTILITY

	EPA_STRING_UTILITY

feature -- Access

	features: LINKED_LIST [LINKED_LIST [FEATURE_I]]
			-- Features that are collected by last `collect'
			-- Every item in the list is another list.
			-- Every inner list stores the set of features with
			-- the same signature and body.

feature -- Basic operations

	collect (a_features: LINKED_LIST [FEATURE_I])
			-- Collect features with the same signature and
			-- body from `a_features'. Make result available
			-- in `features'.
		local
			l_feat_tbl: HASH_TABLE [LINKED_LIST [FEATURE_I], STRING] -- Keys are feature body text, values are features with the same body and signature.
			l_bodys: HASH_TABLE [STRING, STRING] -- Keys are feature identifier (CLASS_NAME.feature_name), values are feature body text
			l_feats: LINKED_LIST [FEATURE_I]
			l_feat: FEATURE_I
			l_feat2: FEATURE_I
			l_feat_body: STRING
			l_feat2_body: STRING
			l_list: LINKED_LIST [FEATURE_I]
		do
			create features.make
			create l_feat_tbl.make (50)
			l_feat_tbl.compare_objects
			create l_bodys.make (50)
			l_bodys.compare_objects

			l_feats := a_features.twin
			from

			until
				l_feats.count <= 1
			loop
				l_feats.start
				l_feat := l_feats.item_for_iteration
				if not (l_feat.is_constant or l_feat.is_external or l_feat.is_attribute) then
					l_feat_body := body_of_feature_in_table (l_feat, l_bodys)
					l_feats.remove
					if l_feat_body /= Void then
						from
							l_feats.start
						until
							l_feats.after
						loop
							l_feat2 := l_feats.item_for_iteration
							if not (l_feat2.is_constant or l_feat2.is_external or l_feat2.is_attribute) then
								if is_feature_of_same_signature (l_feat, l_feat2) then
									l_feat2_body := body_of_feature_in_table (l_feat2, l_bodys)
									if l_feat2_body /= Void then
										if l_feat_body ~ l_feat2_body then
											l_feat_tbl.search (l_feat_body)
											if l_feat_tbl.found then
												l_list := l_feat_tbl.found_item
											else
												create l_list.make
												l_feat_tbl.force (l_list, l_feat_body)
												l_list.extend (l_feat)
											end
											l_list.extend (l_feat2)
											l_feats.remove
										else
											l_feats.forth
										end
									else
										l_feats.remove
									end
								else
									l_feats.forth
								end
							else
								l_feats.remove
							end
						end
					end
				end
			end
			across l_feat_tbl as l_tbl loop
				features.extend (l_tbl.item)
			end
		end

feature{NONE} -- Implementation

	body_of_feature_in_table (a_feature: FEATURE_I; a_bodys: HASH_TABLE [STRING, STRING]): detachable STRING
			-- Body of `a_feature'.
			-- Also put that body into `a_bodys'.
			-- Keys of `a_bodys' are feature identifier (CLASS_NAME.feature_name), values are feature body text
		local
			l_id: STRING
		do
			l_id := class_name_dot_feature_name (a_feature.written_class, a_feature)
			a_bodys.search (l_id)
			if a_bodys.found then
				Result := a_bodys.found_item
			else
				if attached {DO_AS} body_ast_from_feature (a_feature) as l_do then
					Result := text_from_ast (l_do)
					a_bodys.force (Result, l_id)
				else
					a_bodys.force (Void, l_id)
				end
			end
		end

end
