note
	description: "Summary description for {AFX_INTEGRAL_EXPRESSION_COMBINATION_WITHIN_FEATURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_INTEGRAL_EXPRESSION_COMBINATION_WITHIN_FEATURE

inherit
	AFX_INTEGRAL_EXPRESSION_COMBINATION_STRATEGY

create
	default_create

feature	-- Basic operation

	combinations_with_indexes (a_class: CLASS_C; a_feature: FEATURE_I; a_integrals: DS_HASH_TABLE [DS_HASH_SET [INTEGER], STRING]; a_combinations: LINKED_LIST [EPA_HASH_SET [STRING]])
					: DS_LINEAR[TUPLE [op1: STRING; op2: STRING; idx: INTEGER]]
			-- <Precursor>
			-- Strategy that combines integral expressions from the same feature.
		local
			l_comb: EPA_HASH_SET [STRING]
			l_max_index, l_min_index: INTEGER
			l_text1, l_text2: STRING
			l_index_range1, l_index_range2, l_index_range_in_common: DS_HASH_SET [INTEGER]
			l_index: INTEGER
			l_relations: DS_LINKED_LIST [TUPLE [STRING, STRING, INTEGER]]
		do
			create l_relations.make

			from a_combinations.start
			until a_combinations.after
			loop
				l_comb := a_combinations.item_for_iteration
				check with_count_2: l_comb.count = 2 end

				l_text1 := l_comb.first
				l_text2 := l_comb.last

				-- Index 0 implies the combinations are to be monitored everywhere within the feature.
				l_relations.force_last ([l_text1, l_text2, 0])

--				check text_registered: a_integrals.has (l_text2) end
--				l_index_range2 := a_integrals.item (l_text2)

--				-- Use the intersection range of two expressions.
--				l_index_range_in_common := l_index_range1.intersection (l_index_range2)
--				if not l_index_range_in_common.is_empty then
--					from l_index_range_in_common.start
--					until l_index_range_in_common.after
--					loop
--						l_index := l_index_range_in_common.item_for_iteration
--						l_relations.force_last ([l_text1, l_text2, l_index])

--						l_index_range_in_common.forth
--					end
--				end

				a_combinations.forth
			end

			Result := l_relations
		end

end
