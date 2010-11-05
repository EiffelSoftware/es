note
	description: "Summary description for {SSA_EXPR_BIN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SSA_EXPR_BIN

inherit
	SSA_EXPR

create
	make

feature
	make (a_op: STRING; a_e1, a_e2: SSA_EXPR)
		do
			op := a_op
			expr1 := a_e1
			expr2 := a_e2
		end

	op: STRING
	expr1, expr2: SSA_EXPR

	as_code: STRING
		do
			Result := "(" + expr1.as_code + ") " + op + " (" + expr2.as_code + ")"
		end

	replacements: LIST [SSA_REPLACEMENT]
		do
			check unimplemented: False end
		end

end
