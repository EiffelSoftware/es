note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_TU_ROUTINE_IMPLEMENTATION

inherit

	E2B_TRANSLATION_UNIT

	E2B_HELPER

create
	make

feature {NONE} -- Implementation

	make (a_feature: FEATURE_I; a_context_type: TYPE_A)
			-- TODO
		require
			is_routine: a_feature.is_routine
		do
			routine := a_feature
			type := a_context_type
			id := "impl/" + type_id (a_context_type) + "/" + feature_id (a_feature)
		end

feature -- Access

	routine: FEATURE_I
			-- Routine to be translated.

	type: TYPE_A
			-- Context type of routine to be translated.

	id: STRING
			-- <Precursor>

feature -- Basic operations

	translate
			-- <Precursor>
		local
			l_translator: E2B_ROUTINE_TRANSLATOR
		do
			if boolean_feature_note_value (routine, "skip") = False then
				create l_translator.make
				l_translator.translate_routine_implementation (routine, type)
			end
		end

end
