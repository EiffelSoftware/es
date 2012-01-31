note
	description: "Instruction checking that two expressions are distinct."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CUT

inherit
	ASSIGNMENT

create
	make

feature -- Initialization

	make (f, s: EXPRESSION)
			-- Build as representing the distinct pair [`f', `s'].
		require
				first_exists: f /= Void
				second_exists: s /= Void
		do
			first := f
			second := s
		end

feature -- Status report


feature -- Access

	first: EXPRESSION
			-- First term of comparison.

	second: EXPRESSION
			-- Second term of comparison.

feature -- Basic operations
	update (a: ALIAS_RELATION)
			-- If [`first', `second'] is an alias pair, remove it.
		do
			a.remove_one_pair (first, second)
		end

feature -- Input and output
	out: STRING
			-- Printable representation of assignment.
		do
			Result :=
				tabs + "cut " + first.name + ", " + second.name + New_line
		end
invariant
	first_exists: first /= Void
	second_exists: second /= Void
end
