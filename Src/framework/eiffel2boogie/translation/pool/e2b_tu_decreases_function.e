note
	description: "[
		Translation unit for the decreases function of an Eiffel routine.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_TU_DECREASES_FUNCTION

inherit
	E2B_TU_FEATURE

create
	make

feature -- Access

	base_id: STRING = "decreases-function"
			-- <Precursor>

feature -- Basic operations

	translate
			-- <Precursor>
		local
			l_translator: E2B_ROUTINE_TRANSLATOR
		do
			create l_translator.make
			l_translator.translate_decreases_function (feat, type)
		end

end
