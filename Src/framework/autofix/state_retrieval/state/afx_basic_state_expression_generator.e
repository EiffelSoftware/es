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

	generate (a_spot: EPA_TEST_CASE_INFO; a_expressions: HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION])
			-- <Precursor>
		local
			l_gen: EPA_NESTED_EXPRESSION_GENERATOR
			l_skeleton: AFX_STATE_SKELETON
		do
			create l_gen.make
			l_gen.generate (a_spot.recipient_written_class, a_spot.recipient_)
			update_expressions_with_ranking (
				a_expressions,
				accesses_as_skeleton (l_gen.accesses, a_spot.recipient_class_, a_spot.recipient_),
				{AFX_EXPR_RANK}.rank_basic)
		end

feature{NONE} -- Implementation

	accesses_as_skeleton (a_accesses: LIST [EPA_ACCESS]; a_class: CLASS_C; a_feature: detachable FEATURE_I): AFX_STATE_SKELETON
			-- `accesses' as skeleton in the context of
			-- `a_class' and `a_feature'.
		do
			create Result.make_with_accesses (a_class, a_feature, a_accesses)
		end

end
