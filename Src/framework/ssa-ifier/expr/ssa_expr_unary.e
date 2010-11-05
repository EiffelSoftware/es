note
	description: "Summary description for {SSA_EXPR_UNARY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SSA_EXPR_UNARY

inherit
	SSA_EXPR

create
	make

feature
	make (a_op: STRING; a_expr: SSA_EXPR)
		require
			non_void_un_expr: attached a_expr
		do
			op := a_op
			expr := a_expr
		end

	op: STRING
	expr: SSA_EXPR

	as_code: STRING
		do
			Result := op + "(" + expr.as_code + ")"
		end

	replacements: LIST [SSA_REPLACEMENT]
		do
			check unimplemented: False end
		end
end
