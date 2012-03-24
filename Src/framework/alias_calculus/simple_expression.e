note
	description: "Summary description for {SIMPLE_EXPRESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SIMPLE_EXPRESSION

inherit
	EXPRESSION



feature -- Status report
		is_inverse (v: SIMPLE_EXPRESSION): BOOLEAN
			-- Is `v' the same variable with different polarity?
			-- (False by default.)
		do
			Result := False
		end

feature -- Access

	initial: SIMPLE_EXPRESSION
			-- The starting variable of the expression;
			-- here, the variable itself.
		do
			Result := Current
		end

	full_aliases (a: ALIAS_RELATION; xcl: detachable VARIABLE): SORTED_TWO_WAY_LIST [EXPRESSION]
			-- List (possibly empty) of expressions other than `xcl' and aliased
			-- to current simple expression in `a'.
			-- Ignore `xcl' if void.
		do
			Result := a.aliases (Current)
			if xcl /= Void then
				from
					Result.start
				until
					Result.after
				loop
					if Result.item.initial ~ xcl then
						Result.remove		-- Performs a `forth'
					else
						Result.forth
					end
				end
			end
		end

feature -- Transformation

	as_multidot: MULTIDOT
			-- Multidot made of this sole single expression.
		do
			create Result.make_from_simple_expression (Current)
		end

feature -- Input and output

	printout
			-- Print representation of simple expression.
		do
			print (name)
			io.put_new_line
		end

end
