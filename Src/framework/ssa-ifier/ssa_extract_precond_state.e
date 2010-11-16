note
	description: "Summary description for {SSA_EXTRACT_PRECOND_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SSA_EXTRACT_PRECOND_STATE

inherit
	SHARED_SERVER

create
	make

feature
	class_: CLASS_C
	name: STRING
	replace: SSA_REPLACEMENT


	text: STRING
		do
--			Result := context
		end

	make (a_class: CLASS_C; a_name: STRING; a_replace: SSA_REPLACEMENT)
		require
			attached a_replace
		do
			class_ := a_class
			name := a_name
			replace := a_replace
--			context := ""

--			construct_state_export
		end

end
