note
	description: "Summary description for {BIN_EXPR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BIN_EXPR

inherit
	EXPR

create
	make_bin

feature
	make_bin (a_op : STRING; expr1, expr2 : EXPR)
		do
			make (a_op, create {ARRAYED_LIST[EXPR]}.make_from_array (<<expr1,expr2>>))
		end

end
