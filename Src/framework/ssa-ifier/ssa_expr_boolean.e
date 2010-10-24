note
	description: "Summary description for {SSA_EXPR_BOOLEAN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SSA_EXPR_BOOLEAN

inherit
	SSA_EXPR

create
	make

feature
	make (a_bool: BOOLEAN)
		do
			boolean := a_bool
		end

	boolean: BOOLEAN

end
