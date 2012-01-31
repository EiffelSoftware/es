note
	description: "Summary description for {EXPRESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EXPRESSION

inherit
	HASHABLE
		redefine
			is_equal
		select
			is_equal
		end

	COMPARABLE
		rename
			is_equal as old_is_equal
		end

feature -- Access


	dot_count: INTEGER
			-- Number of dots (can be > 1 only for multidot expressions).
		deferred
		end

	name: STRING
			-- Associated textual representation.
		deferred
		end

	hash_code: INTEGER
			-- Hash code value:
			-- obtained from string representation
		do
			Result := name.hash_code
		end

	prepended (x: SIMPLE_EXPRESSION): MULTIDOT
			-- `x.e' where `e' is current expression.
		require
			exists: x /= Void
		deferred
		end

	initial: SIMPLE_EXPRESSION
			-- The starting element: for a variable or `Current',
			-- itself; for a multidot `a.b.c...', `a'.
		deferred
		ensure
			exists: Result /= Void
		end

	full_aliases (a: ALIAS_RELATION; xcl: VARIABLE): SORTED_TWO_WAY_LIST [EXPRESSION]
			-- List (possibly empty) of expressions starting with a variable
			-- other than `xcl' and aliased to current expression in `a'.
			-- This includes indirect aliases: for `e.f', any `x.y' such that
			-- `e' is aliased to `x' and `f' to `y'.
			-- Ignore `xcl' if it is void.
			-- See in particular redefinition in MULTIDOT.
		deferred
		ensure
			list_exists: Result /= Void
			irreflexive: not Result.has (Current)
		end

	as_multidot: MULTIDOT
			-- Copy of current expression, viewed as a multidot.
		deferred
		end

	simplified: EXPRESSION
			-- Expression itself, or a SIMPLE_EXPRESSION equivalent if meaningful
			-- (caution: redefinitions may return a new object).
		do
			Result := Current
		end

feature -- Comparison

	is_equal (e: EXPRESSION): BOOLEAN
			-- Is `e' considered equal?
			-- Yes if and only if identical representations
		do
			if e/= Void then
				Result := (name ~ e.name)
			end
		end

		is_less alias "<"(e: EXPRESSION): BOOLEAN
			-- Is current expression greater than `e'?
		do
			if e/= Void then
				Result := (name < e.name)
			end
		end

feature -- Input and output


	printout
			-- Print representation of expression.
		deferred
		end

invariant
	name_exists: name /= Void
end
