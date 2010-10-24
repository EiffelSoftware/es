note
	description: "Summary description for {SSA_NESTED}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SSA_NESTED

inherit
	SSA_EXPR

create
	make

feature
	make (a_target: SSA_EXPR; a_name: STRING; a_args: LIST [SSA_EXPR])
		do
			target := a_target
			name := a_name
			args := a_args
		end

	target: SSA_EXPR
	name: STRING
	args: LIST [SSA_EXPR]

end
