indexing

	description:

		"Cursors for data structures that can be traversed forward"

	library: "Gobo Eiffel Structure Library"
	copyright: "Copyright (c) 1999-2001, Eric Bezault and others"
	license: "MIT License"
	date: "$Date$"
	revision: "$Revision$"
	js_logic: "logic"
	js_abstraction: "abs"

deferred class DS_LINEAR_CURSOR [G]

inherit

	DS_CURSOR [G]
		redefine
			container,
			next_cursor
		end

feature -- Access

	container: DS_LINEAR [G] is
			-- Data structure traversed
		require else
			--SL-- Cursor(Current,{ds:_ds})
		deferred
		ensure then
			--SL-- Cursor(Current,{ds:_ds}) * Result = _ds
		end

feature -- Status report

	is_first: BOOLEAN is
			-- Is cursor on first item?
		require
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i})
		do
			Result := container.cursor_is_first (Current)
		ensure
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i}) * IsFirst(_ds,{res:Result;ref:Current;iters:_i;content:_c})
			--not_empty: Result implies not container.is_empty
			--not_off: Result implies not off
		end

	after: BOOLEAN is
			-- Is there no valid position to right of cursor?
		require
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i})
		do
			Result := container.cursor_after (Current)
		ensure
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i}) * IsAfter(_ds,{res:Result;ref:Current;iters:_i;content:_c})
		end

feature -- Cursor movement

	start is
			-- Move cursor to first position.
		require
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i1})
		do
			container.cursor_start (Current)
		ensure
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i2}) * MovedToStart(_ds,{ref:Current;newiters:_i2;olditers:_i1;content:_c})
			--empty_behavior: container.is_empty implies after
			--first_or_after: is_first xor after
		end

	forth is
			-- Move cursor to next position.
		require
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i1}) * IsAfter(_ds,{res:false();ref:Current;iters:_i1;content:_c})
			--not_after: not after
		do
			container.cursor_forth (Current)
		ensure
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i2}) * MovedForth(_ds,{ref:Current;newiters:_i2;olditers:_i1;content:_c})
		end

	search_forth (v: G) is
			-- Move to first position at or after current
			-- position where `item' and `v' are equal.
			-- (Use `equality_tester''s criterion from `container'
			-- if not void, use `=' criterion otherwise.)
			-- Move `after' if not found.
		require
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i1})
			--not_off: not off or after
		do
			container.cursor_search_forth (Current, v)
		ensure
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i2}) * SearchedForth(_ds,{ref:Current;newiters:_i2;olditers:_i1;content:_c;val:v})
		end

	go_after is
			-- Move cursor to `after' position.
		require
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i1})
		do
			container.cursor_go_after (Current)
		ensure
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i2}) * MovedToAfter(_ds,{ref:Current;newiters:_i2;olditers:_i1;content:_c})
			--after: after
		end

feature {DS_LINEAR} -- Implementation

	next_cursor: DS_LINEAR_CURSOR [G]
			-- Next cursor
			-- (Used by `container' to keep track of traversing
			-- cursors (i.e. cursors associated with `container'
			-- and which are not currently `off').)

invariant

	after_constraint: after implies off

end
