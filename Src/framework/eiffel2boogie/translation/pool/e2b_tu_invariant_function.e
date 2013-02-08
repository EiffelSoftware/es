note
	description: "Summary description for {E2B_TU_INVARIANT_FUNCTION}."
	author: ""
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
			-- TODO
		do
			type := a_type
			id := "inv/" + type_id (a_type)
		end

feature -- Access

	type: TYPE_A
			-- Context type of routine to be translated.

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
