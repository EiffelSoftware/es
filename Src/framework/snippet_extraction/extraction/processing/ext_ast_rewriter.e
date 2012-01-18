note
	description: "Interface for rewriting ASTs."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EXT_AST_REWRITER [G -> AST_EIFFEL]

feature -- Access

	last_ast: detachable G
			-- AST transfomed by last `rewrite'.

feature -- Basic operations

	rewrite (a_ast: G)
			-- Rewrites `a_ast' and makes the
			-- result available in `last_ast'.
		deferred
		end

end
