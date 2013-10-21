note
	description: "[
		Translation unit for the invariant function of an Eiffel class.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_TU_INVARIANT_FUNCTION

inherit

	E2B_TRANSLATION_UNIT

create
	make

feature {NONE} -- Implementation

	make (a_type: TYPE_A)
			-- Initialize translation unit for type `a_type'.
		do
			type := a_type
			id := "inv/" + type_id (a_type)
		end

feature -- Access

	type: TYPE_A
			-- Type to be translated.

	id: STRING
			-- <Precursor>

feature -- Basic operations

	translate
			-- <Precursor>
		local
			l_translator: E2B_TYPE_TRANSLATOR
		do
			create l_translator
			l_translator.translate_invariant_function (type)
		end

end
