note
	description: "Construct iterating a base construct."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	REPETITION
inherit
	CONTROL
		redefine
			is_applicable
		end

feature -- Status report

	is_applicable (a: ALIAS_RELATION): BOOLEAN
			-- Is loop ready to be applied to ` a' ?
		do
			Result := (body /= Void)
		end

	is_indenting: BOOLEAN
			-- Should sub-components be indented one more level?
			-- Here yes.
		do
			Result := True
		end

feature -- Access

	body: COMPOUND assign set_body
			-- Instructions to be iterated.

feature -- Element change

	set_body (b: COMPOUND)
			-- Make `t' the body.
		require
			exists: b /= Void
		do
			body := b
		ensure
			set: body = b
		end

feature {NONE} -- Implementation

	iterate (a: ALIAS_RELATION; i: INTEGER)
			-- Make `a' include aliases induced by ONE iteration of loop body;
			-- output alias information.
			-- `i' is the index of the iteration.
		require
			positive: i > 0
			alias_exists: a /= Void
		local
			itertext: STRING
		do
			iterate_silent (a, i)
			debug ("ITERATE")
			 	itertext := " iterations"; if i = 1 then itertext := " iteration" end
				a.printout ("after " + i.out + itertext)
			end
		end

	iterate_silent (a: ALIAS_RELATION; i: INTEGER)
			-- Make `a' include aliases induced by ONE iteration of loop body.
			-- `i' is the index of the iteration.
		require
			positive: i > 0
			alias_exists: a /= Void
		do
			body.update (a)
		end
end
