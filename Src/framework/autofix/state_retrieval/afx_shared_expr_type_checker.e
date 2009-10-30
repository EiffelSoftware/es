note
	description: "Summary description for {AFX_SHARED_TYPE_CHECKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SHARED_EXPR_TYPE_CHECKER

feature -- Access

	expression_type_checker: AFX_EXPRESSION_TYPE_CHECKER
			-- Type checker for expressions
		once
			create Result
		end

end
