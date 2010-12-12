note
	description: "Equality tester for objects of type {RM_DECISION_TREE_PATH}"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_DECISION_TREE_PATH_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [RM_DECISION_TREE_PATH]
		redefine
			test
		end

feature -- Status report

	test (v, u: RM_DECISION_TREE_PATH): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result := v.debug_output ~ u.debug_output
			end
		end

end
