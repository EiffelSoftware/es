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
			--SL-- Visitor(Current, {context:_z}) * c: CONST_NODE * Ast(c, {content:_x})
		deferred
		ensure
			--SL-- Visited(Current, {context:_z; ast:c; content:_x})
		end

	visit_plus (p: PLUS_NODE)
		require
			--SL-- Visitor(Current, {context:_z}) * p: PLUS_NODE * Ast(p, {content:_x})
		deferred
		ensure
			--SL-- Visited(Current, {context:_z; ast:p; content:_x})
		end

end
