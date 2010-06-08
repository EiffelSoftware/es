indexing

	description:

		"Cursors for set traversals"

	library: "Gobo Eiffel Structure Library"
	copyright: "Copyright (c) 2001, Eric Bezault and others"
	license: "MIT License"
	date: "$Date$"
	revision: "$Revision$"
	js_logic: "logic"
	js_abstraction: "abs"

deferred class DS_SET_CURSOR [G]

inherit

	DS_LINEAR_CURSOR [G]
		redefine
			container,
			next_cursor
		end

feature -- Access

	container: DS_SET [G] is
			-- Set traversed
		require else
			--SL-- Cursor(Current,{ds:_ds})
		deferred
		ensure then
			--SL-- Cursor(Current,{ds:_ds}) * Result = _ds
		end

feature {DS_SET} -- Implementation

	next_cursor: DS_SET_CURSOR [G]
			-- Next cursor
			-- (Used by `container' to keep track of traversing
			-- cursors (i.e. cursors associated with `container'
			-- and which are not currently `off').)

end
