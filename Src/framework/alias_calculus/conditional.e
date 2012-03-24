note
	description: "[
			Conditional instruction, with a Then_part and an Else_part.
			By convention, they are both compounds.
			]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONDITIONAL

inherit
	CONTROL
		redefine
			is_applicable
		end

create
	make

feature -- Initialization

	make
			-- Set up Then_part and Else_part.
			-- Corrected BM 15.11.2009: No need to do anything,
			-- they will be set up by the program
		do
		end

feature -- Status report

	is_indenting: BOOLEAN
			-- Should sub-components be indented one more level?
			-- Here yes.
		do
			Result := True
		end

	is_applicable (a: ALIAS_RELATION): BOOLEAN
			-- Is conditioal ready to be applied to ` a' ?
		do
			Result := ((then_part /= Void) and (else_part /= Void))
		end

feature -- Access

	then_part: COMPOUND assign set_then
			-- Then part of conditional
		attribute
			create Result.make
		end

	else_part: COMPOUND assign set_else
			-- Else part of conditional
		attribute
			create Result.make
		end

feature -- Element change

	set_then (t: COMPOUND)
			-- Make `t' the Then_part
		require
			exists: t /= Void
		do
			then_part := t
		ensure
			set: then_part = t
		end


	set_else (e: COMPOUND)
			-- Make `e' the Else_part
		require
			exists: e /= Void
		do
			else_part := e
		ensure
			set: else_part = e
		end


feature -- Input and output

	out: STRING
			-- Printable representation of conditional.
		do
			Result :=
				tabs + "then" + New_line +
				then_part.out +
				tabs + "else" + New_line +
				else_part.out +
				tabs + "end" + New_line
		end

feature -- Basic operations

	update (a: ALIAS_RELATION)
			-- Make `a' include aliases induced by conditional.
		local
			other: ALIAS_RELATION
		do
--					FIXME: Fix `twin' from ALIAS_RELATION to avoid using `deep_twin'
--									BM 15.11.2009
			other := a.deep_twin
			a.update (then_part)
			other.update (else_part)
			a.add (other)
		end

end
