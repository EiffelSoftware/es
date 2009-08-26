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
			--SL-- Visitor(v, {context=_z}) * Ast(Current, {content=_x})
		deferred
		ensure
			--SL-- Visited(v, {content=_x; context=_z; ast=Current})
		end

end
