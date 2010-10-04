note
	description: "Summary description for {CONST_EXPR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONST_EXPR

inherit
	EXPR

create
	make_const

feature
	make_const (a_op : STRING)
		do
			make (a_op, create {ARRAYED_LIST[EXPR]}.make (0))
		end
end
