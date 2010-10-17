note
	description: "Summary description for {SSA_ARG_INSTANTITATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SSA_ARG_INSTANTIATE

create
	make

feature
	formal_name: STRING
	actual_name: STRING
	type: TYPE_A

	make (a_form, a_actual: STRING; a_type: TYPE_A)
		do
			type := a_type
			formal_name := a_form
			actual_name := a_actual
		end

end
