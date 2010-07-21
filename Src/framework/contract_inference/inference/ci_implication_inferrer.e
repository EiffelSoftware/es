note
	description: "Inferrer for implications using decision trees"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_IMPLICATION_INFERRER

inherit
	CI_DATA_MINING_BASED_INFERRER

feature -- Basic operations

	infer (a_data: like data)
			-- Infer contracts from `a_data', which is transition data collected from
			-- executed test cases.
		local
			l_tree_buidler: RM_DECISION_TREE_BUILDER
		do
		end

end
