note
	description: "Summary description for {AFX_EXPRESSION_GENERATOR_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_EXPRESSION_GENERATOR_I

feature -- Access

	last_generation: HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]
			-- Expressions from last generation.
		deferred
		end

feature -- Basic operation

	generate (a_feature_with_context: EPA_FEATURE_WITH_CONTEXT_CLASS)
			-- Generate expressions for `a_feature_with_context'.
			-- The generated expressions are availbale in `last_generation'.
			-- Expressions are valid, in renaming, in `a_feature_with_context'.
		deferred
		end

end
