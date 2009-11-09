note
	description: "Summary description for {AFX_SMTLIB_EXPR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SMTLIB_EXPR

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

feature -- Access

	expression: STRING
			-- SMTLIB expression

end
