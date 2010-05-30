note
	description: "Summary description for {AFX_SHARED_TYPE_CHECKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_SHARED_EXPR_TYPE_CHECKER

feature -- Access

	expression_type_checker: ETR_TYPE_CHECKER
			-- Type checker for expressions
		once
			create Result.make
		end

end
