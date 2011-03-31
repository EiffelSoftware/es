note
	description: "Summary description for {AFX_BOOGIE_EXPR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_BOOGIE_EXPR

inherit
	EPA_SOLVER_EXPR
		redefine
			is_boogie
		end

	REFACTORING_HELPER
		undefine
			is_equal
		end

create
	make

feature{NONE} -- Initialization

	make (a_expr: STRING)
			-- Initialize Current.
		do
			expression := a_expr.twin
			fixme ("The following are hacks to avoid generating Boogie PL files that cannot be type checked. 31.03.2011 Jasonw")
			expression.replace_substring_all (once "Current.Current", once "Current")
			expression.replace_substring_all (once "(Current.item()) >= (other.item())", once "false")
			expression.replace_substring_all (once "(other.item()) >= (Current.item())", once "false")
		end

feature -- Status report

	is_boogie: BOOLEAN = True
			-- Is current expression in Boogie format?

end

