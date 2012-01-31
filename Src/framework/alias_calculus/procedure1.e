note
	description: "Procedure with a body and no argument."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PROCEDURE1
inherit
	CONSTRUCT

create
	make

feature {NONE} -- Initializaation

	make (n: STRING)
				-- Initialize with name `n'.
			require
				name_exists: n /= Void
				name_non_empty: not n.is_empty

			do
				name := n
				create aliases.make
			ensure
				set: name = n
				aliases_exist: aliases /= Void
				aliases_empty: aliases.is_empty

			end



feature -- Access

	body: COMPOUND assign set_body
			-- Procedure body.

	name: STRING
			-- Procedure name.

feature -- Status report

	is_indenting: BOOLEAN
			-- Should sub-components be indented one more level?
			-- Here no (the compound).
		do
			Result := True
		end

	is_steady: BOOLEAN
			-- Has alias computation reached a steady point?

feature -- Element change

	set_body (b: COMPOUND)
			-- Make `b' the procedure's body
		require
			body_exists: b /= Void
		do
			body := b
		ensure
			set: body = b
		end

feature {PROGRAM} -- Basic operations

	update (a: ALIAS_RELATION)
			-- Make `a' include aliases induced by main procedure.
		note
			caveat: "[
					PROCEDURE1 is not a descendant of INSTRUCTION;
					as a result this routine is specific to PROCEDURE1
					(i.e. not an effecting of INSTRUCTION's `update'
					as can be found in COMPOUND etc.)
					]"
		do
			body.update (a)
			is_steady := a.is_deep_equal (aliases)
			if not is_steady then
				aliases := a.deep_twin
			end
		end

feature -- Input and output

	out: STRING
			-- Printable representation of procedure
			-- (essentially its body, indented).
		do
			Result :=
					tabs + "Procedure " + name + New_line +
					body.out +
					tabs + "End " + name + New_line
		end

feature {CALL} -- Implementation

	aliases: ALIAS_RELATION
			-- Aliases computed so far.

invariant
		name_exists: name /= Void
		name_non_empty: not name.is_empty
end
