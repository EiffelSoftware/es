note
	description: "Summary description for {AFX_SMTLIB_EXPR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SMTLIB_EXPR

inherit
	HASHABLE
		redefine
			is_equal
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

feature -- Access

	expression: STRING
			-- SMTLIB expression

feature -- Access

	hash_code: INTEGER
			-- Hash code value
		do
			Result := expression.hash_code
		end

feature -- Equality

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result := expression ~ other.expression
		end

end
