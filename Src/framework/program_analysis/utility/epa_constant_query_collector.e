note
	description: "Class to collect queries that return a constant value"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_CONSTANT_QUERY_COLLECTOR

inherit
	INTERNAL_COMPILER_STRING_EXPORTER

	EPA_UTILITY

feature -- Access

	quries (a_class: CLASS_C): HASH_TABLE [STRING, STRING]
			-- Queries in `a_class' that return a constant value
			-- Keys are feature names, values are the constants that those features return
		local
			l_feat_tbl: FEATURE_TABLE
			l_features: LINKED_LIST [FEATURE_I]
			l_cursor: CURSOR
			l_consts: like constants
			l_const_feats: like queries_with_constant_result
		do
			l_features := features_from_class (a_class)
			l_consts := constants (l_features)
			l_const_feats := queries_with_constant_result (l_features, l_consts)

			create Result.make (10)
			Result.compare_objects

			across l_consts as l_cons loop
				Result.force (l_cons.item, l_cons.key)
			end
			across l_const_feats as l_cons loop
				Result.force (l_cons.item, l_cons.key)
			end
		end

feature{NONE} -- Implementation

	features_from_class (a_class: CLASS_C): LINKED_LIST [FEATURE_I]
			-- Features from `a_class'
		local
			l_feat_tbl: FEATURE_TABLE
			l_cursor: CURSOR
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

	constants (a_features: LINKED_LIST [FEATURE_I]): HASH_TABLE [STRING, STRING]
			-- Constants in `a_class' that return a constant value
			-- Keys are feature names, values are the constant that those features return
		local
			l_c: CONSTANT_I
		do
			create Result.make (10)
			across a_features as l_feats loop
				if l_feats.item.is_constant then
					check attached {CONSTANT_I} l_feats.item as l_const then
						Result.force (l_const.value.dump, l_const.feature_name.as_lower)
					end
				end
			end
		end

	queries_with_constant_result (a_features: LINKED_LIST [FEATURE_I]; a_constant: like constants): HASH_TABLE [STRING, STRING]
			-- Queries that are not a constant, but return constant value.
			-- For example, in the feature body of a query, there is only one line "Result := True".
			-- `a_features' are a list of feature from which Result are selected.
			-- `a_constants' are a list of features that are constants.
			-- Result is a hash-table. Keys are feature names, values are the constant that those features return
		local
			l_feat: FEATURE_I
			l_is_constant: BOOLEAN
			l_text: STRING
		do
			create Result.make (10)
			Result.compare_objects
			across a_features as l_features loop
				l_feat := l_features.item
				l_is_constant := False
				if not l_feat.is_constant and then l_feat.has_return_value and then not l_feat.is_attribute then
					if attached {EIFFEL_LIST [INSTRUCTION_AS]} body_compound_ast_from_feature (l_feat) as l_compound then
						if l_compound.count = 1 and then attached {ASSIGN_AS} l_compound.first as l_assign then
							if attached {RESULT_AS} l_assign.target then
								if attached {INTEGER_AS} l_assign.source then
									l_is_constant := True
								elseif attached {BOOL_AS} l_assign.source then
									l_is_constant := True
								elseif attached {VOID_AS} l_assign.source then
									l_is_constant := True
								else
									l_text := text_from_ast (l_assign.source)
									across a_constant as l_consts until l_is_constant loop
										if l_text ~ l_consts.key then
											Result.force (l_consts.item, l_feat.feature_name.as_lower)
											l_is_constant := True
										end
									end
									l_is_constant := False
								end
								if l_is_constant then
									Result.force (text_from_ast (l_assign.source), l_feat.feature_name.as_lower)
								end
							end
						end
					end
				end
			end
		end


end
