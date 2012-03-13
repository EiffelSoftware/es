note
	description: "Instruction, with label, that records a snapshot of the current alias relation"
	fixme: "THIS CLASS HAS ONLY MINIMIALLY BEEN TESTED SO FAR -- BM March 2012"

class
	SNAP

inherit
	SIMPLE
create
	make

feature -- Initialization

	make (l: STRING)
			-- Build with empty alias relation; associate with label `l'.
		require
			label_exists: l /= Void
			label_not_empty: not l.is_empty
		do
			create record.make
			label := l
		end


feature -- Access

	record: ALIAS_RELATION
			-- Alias relation recorded for this location.

	label: STRING
			-- Label associated with this snap instruction.
			-- Labels for different snap instructions should be different,
			-- but this rule is not enforced.

feature -- Basic operations

	update (a: ALIAS_RELATION)
			-- Make `a' include aliases induced by forget instruction.
		do
			record.add (a)
		end

feature -- Input and output

	out: STRING
			-- Printable representation of snap.
		do
			Result := tabs + "snap " + New_line
		end


	printout
			-- Print recorded alias relation, with tag
		do
			io.put_new_line
			record.printout ("Snapshot at " + label)
		end
invariant
	record_exists: record /= Void
end

