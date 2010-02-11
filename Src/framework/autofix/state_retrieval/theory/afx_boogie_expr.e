note
	description: "Summary description for {AFX_BOOGIE_EXPR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BOOGIE_EXPR

inherit
	AFX_SOLVER_EXPR
		redefine
			is_boogie
		end

create
	make

feature{NONE} -- Initialization

	make (a_expr: STRING)
			-- Initialize Current.
		do
			expression := a_expr.twin
		ensure
			expression_set: expression ~ a_expr
		end

feature -- Status report

	is_boogie: BOOLEAN = True
			-- Is current expression in Boogie format?

end

