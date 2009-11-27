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

	generate (a_spot: AFX_TEST_CASE_INFO; a_expressions: HASH_TABLE [AFX_EXPR_RANK, AFX_EXPRESSION])
			-- <Precursor>
		local
			l_gen: AFX_NESTED_EXPRESSION_GENERATOR
			l_skeleton: AFX_STATE_SKELETON
		do
			create l_gen.make
			l_gen.generate (a_spot.recipient_class_, a_spot.recipient_)
			update_expressions_with_ranking (
				a_expressions,
				l_gen.accesses_as_skeleton (a_spot.recipient_class_, a_spot.recipient_),
				{AFX_EXPR_RANK}.rank_basic)
		end
end
