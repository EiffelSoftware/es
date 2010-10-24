note
	description: "Summary description for {SSA_EXPR_VAR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SSA_EXPR_VAR

inherit
	SSA_EXPR

create
	make

feature
	make (a_name: STRING)
		do
			name := a_name
		end

	name: STRING

end
