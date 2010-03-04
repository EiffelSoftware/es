indexing

	description:

		"Cursors for data structures that may be traversed forward and backward"

	library: "Gobo Eiffel Structure Library"
	copyright: "Copyright (c) 1999-2001, Eric Bezault and others"
	license: "MIT License"
	date: "$Date$"
	revision: "$Revision$"
	js_logic: "logic"
	js_abstraction: "abs"

deferred class DS_BILINEAR_CURSOR [G]

inherit

	DS_LINEAR_CURSOR [G]
		redefine
			container,
			next_cursor
		end

feature -- Access

	container: DS_BILINEAR [G] is
			-- Data structure traversed
		require else
			--SL-- Cursor(Current,{ds:_ds})
		deferred
		ensure then
			--SL-- Cursor(Current,{ds:_ds}) * Result = _ds
		end

feature -- Status report

	is_last: BOOLEAN is
			-- Is cursor on last item?
		require
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i})
		do
			Result := container.cursor_is_last (Current)
		ensure
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i}) * IsLast(_ds,{res:Result;ref:Current;iters:_i;content:_c})
			--not_empty: Result implies not container.is_empty
			--not_off: Result implies not off
		end

	before: BOOLEAN is
			-- Is there no valid position to left of cursor?
		require
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i})
		do
			Result := container.cursor_before (Current)
		ensure
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i}) * IsBefore(_ds,{res:Result;ref:Current;iters:_i;content:_c})
		end

feature -- Cursor movement

	finish is
			-- Move cursor to last position.
		require
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i1})
		do
			container.cursor_finish (Current)
		ensure
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i2}) * Finished(_ds,{ref:Current;olditers:_i1;newiters:_i2;content:_c})
			--empty_behavior: container.is_empty implies before
			--last_or_before: is_last xor before
		end

	back is
			-- Move cursor to previous position.
		require
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i1}) * IsBefore(_ds,{res:false();ref:Current;iters:_i1;content:_c})
			--not_before: not before
		do
			container.cursor_back (Current)
		ensure
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i2}) * MovedForth(_ds,{ref:Current;newiters:_i2;olditers:_i1;content:_c})
		end

	search_back (v: G) is
			-- Move to first position at or before current
			-- position where `item' and `v' are equal.
			-- (Use `equality_tester''s criterion from `container'
			-- if not void, use `=' criterion otherwise.)
			-- Move `before' if not found.
		require
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i1})
			--not_off: not off or before
		do
			container.cursor_search_back (Current, v)
		ensure
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i2}) * SearchedBack(_ds,{ref:Current;newiters:_i2;olditers:_i1;content:_c;val:v})
		end

	go_before is
			-- Move cursor to `before' position.
		require
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i1})
		do
			container.cursor_go_before (Current)
		ensure
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i2}) * MovedToBefore(_ds,{ref:Current;newiters:_i2;olditers:_i1;content:_c})
			--before: before
		end

feature {DS_BILINEAR} -- Implementation

	next_cursor: DS_BILINEAR_CURSOR [G]
			-- Next cursor
			-- (Used by `container' to keep track of traversing
			-- cursors (i.e. cursors associated with `container'
			-- and which are not currently `off').)

invariant

	not_both: not (after and before)
	before_constraint: before implies off

end
