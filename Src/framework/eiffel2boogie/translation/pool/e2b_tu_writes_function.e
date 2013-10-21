note
	description: "[
		Translation unit for the writes function of an Eiffel routine.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_TU_WRITES_FUNCTION

inherit

	E2B_TU_FEATURE

create
	make

feature -- Access

	base_id: STRING = "writes-function"
			-- <Precursor>

feature -- Basic operations

	translate
			-- <Precursor>
		local
			l_translator: E2B_ROUTINE_TRANSLATOR
		do
			create l_translator.make
			l_translator.translate_writes_function (feat, type)
		end

end
