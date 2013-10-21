note
	description: "[
		Translation unit for a ghost attribute.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_TU_GHOST_ATTRIBUTE

inherit

	E2B_TU_FEATURE

create
	make

feature -- Access

	base_id: STRING = "ghost-attribute"
			-- <Precursor>

feature -- Basic operations

	translate
			-- <Precursor>
		local
			l_translator: E2B_GHOST_TRANSLATOR
		do
			create l_translator
			l_translator.translate_ghost_attribute (feat, type)
		end

end
