note
	description: "[
		Translation unit for a ghost function.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_TU_GHOST_FUNCTION

inherit

	E2B_TU_FEATURE

create
	make

feature -- Access

	base_id: STRING = "ghost-function"
			-- <Precursor>

feature -- Basic operations

	translate
			-- <Precursor>
		local
			l_translator: E2B_GHOST_TRANSLATOR
		do
			create l_translator
			l_translator.translate_ghost_function (feat, type)
		end

end
