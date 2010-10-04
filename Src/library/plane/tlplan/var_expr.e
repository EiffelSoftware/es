note
	description: "Summary description for {VAR_EXPR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VAR_EXPR

inherit
	EXPR

create
	make_var

feature
	make_var (a_op : STRING)
		do
			make ("?" + a_op, create {ARRAYED_LIST[EXPR]}.make (0))
		end


end
