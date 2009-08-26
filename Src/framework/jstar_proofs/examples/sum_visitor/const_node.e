note
	description: "Summary description for {CONST_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	sl_predicate_export: "Ast(x, {content=y}) = y = const(_v) * x.<CONST_NODE.value> |-> _v"

class
	CONST_NODE

inherit
	AST_NODE

create
	init

feature

	init (v: INTEGER)
		require
			--SL-- True
		do
			value := v
		ensure
			--SL-- Ast$(Current, {content=const(v)})
		end

	value: INTEGER

	accept (v: VISITOR)
		require else
			--SLS-- Current: CONST_NODE * Visitor(v, {context=_z}) * Ast(Current, {content=_x})
		do
			v.visit_const (Current)
		ensure then
			--SLS-- Visited(v, {content=_x; context=_z; ast=Current})
		end

end
