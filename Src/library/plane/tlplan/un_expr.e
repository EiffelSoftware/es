note
	description: "Summary description for {UN_EXPR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	UN_EXPR

inherit
	EXPR

create
	make_un

feature
	make_un (a_op : STRING; expr: EXPR)
		do
			make (a_op, create {ARRAYED_LIST[EXPR]}.make_from_array (<<expr>>))
		end

end
