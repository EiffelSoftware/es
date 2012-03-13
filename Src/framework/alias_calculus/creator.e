note
	description: "Summary description for {CREATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
class
	CREATOR
inherit
	SIMPLE

create
	make

feature -- Initialization

	make (x: VARIABLE)
			-- Build as representing `create x'.
		require
				target_exists: x /= Void
		do
			target := x
		end

feature -- Status report


feature -- Access

	target: VARIABLE
			-- Target of creation (`x'in `create x').

feature -- Basic operations

	update (a: ALIAS_RELATION)
			-- Make `a' include aliases induced by creation instruction.
		do
			a.remove_item (target)
		end

feature -- Input and output

	out: STRING
			-- Printable representation of creation instruction.
		do
			Result := tabs + "create " + target.name + New_line
		end

invariant
	target_exists: target /= Void
end
