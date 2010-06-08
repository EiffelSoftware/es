note
	description: "Summary description for {PLUS_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	sl_predicate_export: "Ast(x, {content:y}) = y = plus(_lv, _rv) * x.<PLUS_NODE.left> |-> _l * x.<PLUS_NODE.right> |-> _r * Ast(_l, {content:_lv}) * Ast(_r, {content:_rv})"

class
	PLUS_NODE

inherit
	AST_NODE

create
	init

feature

	init (l: AST_NODE; r: AST_NODE)
		require
			--SL-- Ast(l, {content:_x}) * Ast(r, {content:_y})
		do
			left := l
			right := r
		ensure
			--SL-- Ast$(Current, {content:plus(_x, _y)})
		end

	left: AST_NODE

	right: AST_NODE

	accept (v: VISITOR)
		require else
			--SLS-- Current: PLUS_NODE * Ast(Current, {content:_x}) * Visitor(v, {context:_z})
		do
			v.visit_plus (Current)
		ensure then
			--SLS-- Visited(v, {context:_z; ast:Current; content:_x})
		end

end
