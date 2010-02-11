note
	description: "Summary description for {AFX_SMTLIB_EXPR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_SOLVER_EXPR

inherit
	HASHABLE
		redefine
			is_equal
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

feature -- Status report

	is_axiom: BOOLEAN
			-- Is current expression an axiom?
		do
		end

	is_function: BOOLEAN
			-- Is current expression a function declaration?
		do
		end

	is_smtlib: BOOLEAN
			-- Is current expression in SMTLIB format?
		do
		end

	is_boogie: BOOLEAN
			-- Is current expression in Boogie format?
		do
		end

feature -- Equality

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result := expression ~ other.expression
		end

end
