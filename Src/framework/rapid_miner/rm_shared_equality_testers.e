note
	description: "Shared equality tests in RapidMiner library"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_SHARED_EQUALITY_TESTERS

feature -- Equality testers

	rm_decision_tree_path_equality_tester: RM_DECISION_TREE_PATH_EQUALITY_TESTER
			-- Equality tester for objects of type {RM_DECISION_TREE_PATH}
		once
			create Result
		end

end
