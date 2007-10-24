indexing
	description: "Default implementation of MML_PAIR"
	version: "$Id$"
	author: "Bernd Schoeller"
	copyright: "see License.txt"

class
	MML_DEFAULT_PAIR [G,H]

inherit
	MML_PAIR [G,H]
		redefine
			out
		end

create
	make_from

feature {NONE} -- Initialization

	make_from (one: G; two: H) is
			-- Create a new pair with `one' and `two'.
		do
			first := one
			second := two
		end

feature -- Access

	first: G
			-- The first element of `current'.

	second: H
			-- The second element of `current'.

feature -- Status Report

	is_identity : BOOLEAN is
			-- Does `current' only contain identical elements?
		do
			Result := equal_value (first, second)
		end

feature -- Inversion

	inversed: MML_PAIR[H, G] is
			-- The inverse pair of `current'.
		do
			create {MML_DEFAULT_PAIR[H,G]}Result.make_from (second, first)
		end

feature -- Comparison

	equals, infix "|=|" (other: MML_ANY): BOOLEAN is
			-- Are the two models equivalent ?
		local
			as_pair: MML_PAIR[G,H]
		do
			as_pair ?= other
			if as_pair /= Void then
				Result :=
					equal_value (first, as_pair.first) and
					equal_value (second, as_pair.second)
			else
				Result := false
			end
		end

feature -- Output

	out: STRING is
			-- Print the pair in a nice form.
		do
			Result := "("
			if first = Void then
				Result.append ("Void")
			else
				Result.append(first.out)
			end
			Result.append(",")
			if second = Void then
				Result.append ("Void")
			else
				Result.append(second.out)
			end
			Result.append(")")
		end

end
