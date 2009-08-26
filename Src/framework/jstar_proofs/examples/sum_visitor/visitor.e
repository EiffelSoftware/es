note
	description: "Summary description for {VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	VISITOR

feature

	visit_const (c: CONST_NODE)
		require
			--SL-- c: CONST_NODE * Visitor(Current, {context=_z}) * Ast(c, {content=_x})
		deferred
		ensure
			--SL-- Visited(Current, {content=_x; context=_z; ast=c})
		end

	visit_plus (p: PLUS_NODE)
		require
			--SL-- p: PLUS_NODE * Visitor(Current, {context=_z}) * Ast(p, {content=_x})
		deferred
		ensure
			--SL-- Visited(Current, {content=_x; context=_z; ast=p})
		end

end
