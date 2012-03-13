note
	description: "Instruction without effect on the alias relation, prints out the alias relation associated with a snap instruction."
	author: "Bertrand Meyer"
	date: "$Date$"
	revision: "$Revision$"

class
	PRINTSNAP

inherit
	SIMPLE

create
	make

feature -- Initialization

	make (s: SNAP)
			-- Build associated with `s'.
		require
				snap_exists: s /= Void
		do
			snap := s
		end

feature -- Access

	snap: SNAP

feature -- Basic operations
	update (a: ALIAS_RELATION)
			-- Do not change `a' , but print the alias relation recorded for the
			-- associated snap instruction.

		do
			snap.printout
		end

feature -- Input and output

	out: STRING
			-- Printable representation of printout instruction.
		do
			Result := tabs + "printsnap " + snap.label + New_line
		end

invariant
	snap_exists: snap /= Void
end
