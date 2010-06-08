note
	description: "Summary description for {AST_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AST_NODE

feature

	accept (v: VISITOR)
		require
			--SL-- Ast(Current, {content:_x}) * Visitor(v, {context:_z})
		deferred
		ensure
			--SL-- Visited(v, {context:_z; ast:Current; content:_x})
		end

end
