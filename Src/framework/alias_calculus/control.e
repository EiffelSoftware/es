note
	description: "Summary description for {CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CONTROL

inherit
	INSTRUCTION

feature -- Basic operations

	update (a: ALIAS_RELATION)
			-- Make `a' include aliases induced by `i'.
		deferred
		end

end
