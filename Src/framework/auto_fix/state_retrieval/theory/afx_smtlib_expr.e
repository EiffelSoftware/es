note
	description: "Summary description for {AFX_SMTLIB_EXPR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SMTLIB_EXPR

inherit
	AFX_SOLVER_EXPR
		redefine
			is_smtlib,
			is_axiom,
			is_function
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

	is_smtlib: BOOLEAN = True
			-- Is current expression in SMTLIB format?

	is_axiom: BOOLEAN
			-- Is current expression an axiom?
		do
			Result := expression.starts_with ({AFX_SOLVER_CONSTANTS}.smtlib_axiom_header)
		end

	is_function: BOOLEAN
			-- Is current expression a function declaration?
		do
			Result := expression.starts_with ({AFX_SOLVER_CONSTANTS}.smtlib_function_header)
		end

end
