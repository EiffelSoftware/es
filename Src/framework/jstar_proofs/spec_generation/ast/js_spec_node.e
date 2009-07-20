indexing
	description: "The root of the AST hierarchy."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	JS_SPEC_NODE

feature

	accept (v: JS_SPEC_VISITOR)
		deferred
		end

end
