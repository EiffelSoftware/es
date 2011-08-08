note
	description: "[
		Class to rewrite statements from a callee context into a caller context
		Note: not all statements are rewritable.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_STATEMENT_REWRITER

inherit
	EPA_FEATURE_CALL_COLLECTOR_UTILITY

feature -- Access

	last_ast: AST_EIFFEL
			-- AST node rewritten by last `rewrite'.

feature -- Basic operations

	rewrite (a_ast: AST_EIFFEL; a_caller_context: CALL_AS; a_target_type: TYPE_A)
			-- Rewrite `a_ast' into the caller context defined by `a_target_type' and `a_caller_context'.
			-- Make result available in `last_ast'.
		do
		end

end
