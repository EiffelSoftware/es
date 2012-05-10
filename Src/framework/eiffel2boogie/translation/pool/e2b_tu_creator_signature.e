note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_TU_CREATOR_SIGNATURE

inherit

	E2B_TRANSLATION_UNIT

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
			id := "create/" + type_id (a_context_type) + "/" + feature_id (a_feature)
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
			create l_translator.make
		end

end
