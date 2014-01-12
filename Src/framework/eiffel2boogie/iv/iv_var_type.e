note
	description: "Boogie types that are occurrences of a type variable."
	date: "$Date$"
	revision: "$Revision$"

class
	IV_VAR_TYPE

inherit
	IV_TYPE

create
	make_fresh

feature {NONE} -- Initialization

	make_fresh
			-- Create a type variable with a fresh name.
		do
			name := "T" + counter.item.out
			counter.set_item (counter.item + 1)
		end

feature -- Access

	name: STRING
			-- Type variable name.

feature -- Visitor

	process (a_visitor: IV_TYPE_VISITOR)
			-- Process type.
		do
			a_visitor.process_variable_type (Current)
		end

feature {NONE} -- Implementation

	counter: INTEGER_REF
			-- Global counter that stores the number of type variables created so far.
		once
			create Result
		end

end
