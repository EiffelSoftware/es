note
	description: "Executable operation."
	author: "Bertrand Meyer"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	INSTRUCTION

inherit
	CONSTRUCT


feature -- Status report

	is_applicable (a: ALIAS_RELATION): BOOLEAN
			-- Can instruction be applied to ` a' ?
			-- (Yes by default.)
		do
			Result := True
		end

feature -- Element change

	update (a: ALIAS_RELATION)
				-- Make `a' include aliases induced by instruction.
		require
			relation_exists: a /= Void
			applicable: is_applicable (a)
		deferred
		end
end
