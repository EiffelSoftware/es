note
	description: "Summary description for {SUM_VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	sl_predicate: "Visitor(x, {context=y}) = x.<SUM_VISITOR.amount> |-> y"
	sl_predicate: "Visited(x, {content=z; context=y; ast=a}) = x.<SUM_VISITOR.amount> |-> builtin_plus(y, sum(z)) * Ast(a, {content=z})"
	js_logic: "sum_visitor.logic"
	js_abstraction: "sum_visitor.abs"

class
	SUM_VISITOR

inherit
	VISITOR

create
	init

feature

	init
		require
			--SL-- True
		do
			-- Note that amount is not initialized - Eiffel default initialization is exploited
		ensure
			--SL-- Visitor$(Current, {context=0})
		end

	amount: INTEGER

	visit_plus (p: PLUS_NODE)
		require else
			--SLS-- p: PLUS_NODE * Current: SUM_VISITOR * Visitor(Current, {context=_z}) * Ast(p, {content=_x})
		do
			p.left.accept (Current)
			p.right.accept (Current)
		ensure then
			--SLS-- Visited(Current, {content=_x; context=_z; ast=p})
		end

	visit_const (c: CONST_NODE)
		require else
			--SLS-- c: CONST_NODE * Current: SUM_VISITOR * Visitor(Current, {context=_z}) * Ast(c, {content=_x})
		do
			amount := amount + c.value
		ensure then
			--SLS-- Visited(Current, {content=_x; context=_z; ast=c})
		end

end
