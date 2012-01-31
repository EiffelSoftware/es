note
	description: "Summary description for {FORGET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FORGET

inherit
	SIMPLE
create
	make

feature -- Initialization

	make (x: VARIABLE)
			-- Build as representing `forget x'.
		require
				target_exists: x /= Void
		do
			target := x
		end

feature -- Status report


feature -- Access

	target: VARIABLE
			-- Target of forget (`x' in `forget x').

feature -- Basic operations

	update (a: ALIAS_RELATION)
			-- Make `a' include aliases induced by forget instruction.
		do
			a.remove_item (target)
		end

feature -- Input and output

	out: STRING
			-- Printable representation of assignment.
		do
			Result := tabs + "forget " + target.name + New_line
		end
invariant
	target_exists: target /= Void
end
