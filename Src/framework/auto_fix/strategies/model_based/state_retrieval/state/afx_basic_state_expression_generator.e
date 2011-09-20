note
	description: "Summary description for {AFX_BASIC_STATE_EXPRESSION_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BASIC_STATE_EXPRESSION_GENERATOR

inherit
	AFX_RELEVANT_STATE_EXPRESSION_GENERATOR

feature -- Generation

	generate (a_written_class: CLASS_C; a_feature: FEATURE_I; a_expressions: HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION])
			-- <Precursor>
		local
			l_gen: EPA_NESTED_EXPRESSION_GENERATOR
			l_skeleton: EPA_STATE_SKELETON
		do
			create l_gen.make
			l_gen.generate (a_written_class, a_feature)
			update_expressions_with_ranking (
				a_expressions,
				accesses_as_skeleton (l_gen.accesses, a_written_class, a_feature),
				{AFX_EXPR_RANK}.rank_basic)
		end

feature{NONE} -- Implementation

	accesses_as_skeleton (a_accesses: LIST [EPA_ACCESS]; a_class: CLASS_C; a_feature: detachable FEATURE_I): EPA_STATE_SKELETON
			-- `accesses' as skeleton in the context of
			-- `a_class' and `a_feature'.
		do
			create Result.make_with_accesses (a_class, a_feature, a_accesses)
		end

end
