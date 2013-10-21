note
	description: "[
		Translation unit for the signature of a ghost routine.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_TU_GHOST_ROUTINE_SIGNATURE

inherit

	E2B_TU_FEATURE

create
	make

feature -- Access

	base_id: STRING = "ghost-routine-signature"
			-- <Precursor>

feature -- Basic operations

	translate
			-- <Precursor>
		local
			l_translator: E2B_GHOST_TRANSLATOR
		do
			create l_translator
			l_translator.translate_ghost_routine_signature (feat, type)
		end

end
