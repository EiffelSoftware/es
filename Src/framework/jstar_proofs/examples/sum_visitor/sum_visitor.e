note
	description: "Summary description for {SUM_VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	sl_predicate: "Visitor(x, {context:y}) = x.<SUM_VISITOR.sum> |-> y"
	sl_predicate_export: "Visited(x, {context:y; ast:a; content:z}) = x.<SUM_VISITOR.sum> |-> builtin_plus(y, sum(z)) * Ast(a, {content:z})"
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
			-- Note that `sum' is not initialized - Eiffel default initialization is exploited
		ensure
			--SL-- Visitor$(Current, {context:0})
		end

	sum: INTEGER

	visit_plus (p: PLUS_NODE)
		require else
			--SLS-- Current: SUM_VISITOR * Visitor(Current, {context:_z}) * p: PLUS_NODE * Ast(p, {content:_x})
		do
			p.left.accept (Current)
			p.right.accept (Current)
		ensure then
			--SLS-- Visited(Current, {context:_z; ast:p; content:_x})
		end

	visit_const (c: CONST_NODE)
		require else
			--SLS-- Current: SUM_VISITOR * Visitor(Current, {context:_z}) * c: CONST_NODE * Ast(c, {content:_x})
		do
			sum := sum + c.value
		ensure then
			--SLS-- Visited(Current, {context:_z; ast:c; content:_x})
		end

end
