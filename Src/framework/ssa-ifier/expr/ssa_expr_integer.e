note
	description: "Summary description for {SSA_EXPR_INTEGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SSA_EXPR_INTEGER

inherit
	SSA_EXPR

create
	make

feature
	make (a_int: INTEGER)
		do
			integer := a_int
		end

	integer: INTEGER

	replacements: LIST [SSA_REPLACEMENT]
		do
			create {ARRAYED_LIST [SSA_REPLACEMENT]} Result.make (10)
		end

	as_code: STRING
		do
			Result := integer.out
		end

end
