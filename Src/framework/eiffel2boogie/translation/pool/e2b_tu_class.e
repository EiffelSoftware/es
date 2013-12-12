note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_TU_CLASS

inherit

	E2B_TRANSLATION_UNIT

create
	make

feature {NONE} -- Implementation

	make (a_class: CLASS_C)
			-- Initialize translation unit for class `a_class'.
		do
			class_ := a_class
			id := "class/" + a_class.name_in_upper
		end

feature -- Access

	class_: CLASS_C
			-- Type to be translated.

	id: STRING
			-- <Precursor>

feature -- Basic operations

	translate
			-- <Precursor>
		local
			l_type_translator: E2B_TYPE_TRANSLATOR
		do
			create l_type_translator
			l_type_translator.generate_invariant_admissability_check (class_)
		end

end
