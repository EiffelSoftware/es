note
	description: "Translation unit for consistency checks on contracts of an Eiffel feature."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_TU_CONTRACT_CHECK

inherit
	E2B_TU_FEATURE

	E2B_SHARED_CONTEXT

create
	make

feature -- Access

	base_id: STRING = "contract-check"
			-- <Precursor>

feature -- Basic operations

	translate
			-- <Precursor>
		local
			l_translator: E2B_ROUTINE_TRANSLATOR
		do
			create l_translator.make
			l_translator.generate_frame_check (feat, type, False)
			if helper.has_functional_representation (feat) then
				l_translator.generate_frame_check (feat, type, True)
			end
		end

end
