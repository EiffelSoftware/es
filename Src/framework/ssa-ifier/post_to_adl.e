note
	description: "Summary description for {POST_TO_ADL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	POST_TO_ADL

inherit
	PRE_TO_ADL

create
	make

feature
	wrap_expr_in_add (l_as: EXPR_AS)
		local
			un_op: UN_EXPR
			add_del: STRING
			pred_expr: EXPR
		do
			l_as.process (Current)

			if last_expr.op.is_equal ("not") then
				add_del := "del"
				pred_expr := last_expr.exprs [1]
			else
				add_del := "add"
				pred_expr := last_expr
			end

			create un_op.make_un (add_del, pred_expr)
			last_expr := un_op
		end

end
