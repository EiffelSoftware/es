note
	description: "Summary description for {CONST_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	sl_predicate_export: "Ast(x, {content:y}) = x.<CONST_NODE.value> |-> _v * y = const(_v)"

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
			--SL-- Ast$(Current, {content:const(v)})
		end

	value: INTEGER

	accept (v: VISITOR)
		require else
			--SLS-- Current: CONST_NODE * Ast(Current, {content:_x}) * Visitor(v, {context:_z})
		do
			v.visit_const (Current)
		ensure then
			--SLS-- Visited(v, {context:_z; ast:Current; content:_x})
		end

end
