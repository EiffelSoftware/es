note
	description: "Interface for rewriting ASTs."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EXT_AST_REWRITER [G -> AST_EIFFEL]

feature -- Access

	last_ast: detachable G
			-- Holes extracted by last `extract'.

feature -- Basic operations

	rewrite (a_ast: G)
			-- Rewrites `a_ast' and makes the
			-- result available in `last_ast'.
		deferred
		end

feature -- Configuration

	hole_factory: EXT_HOLE_FACTORY
		assign set_hole_factory
			-- Hole factory to create new instances with distinct identifiers.

	set_hole_factory (a_factory: EXT_HOLE_FACTORY)
			-- Sets `hole_factory'.
		require
			attached a_factory
		do
			hole_factory := a_factory
		end

end
