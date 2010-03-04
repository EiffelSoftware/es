indexing

	description:

		"Data structures that can be traversed forward and backward"

	library: "Gobo Eiffel Structure Library"
	copyright: "Copyright (c) 1999-2001, Eric Bezault and others"
	license: "MIT License"
	date: "$Date$"
	revision: "$Revision$"

deferred class DS_BILINEAR [G]

inherit

	DS_LINEAR [G]
		redefine
			new_cursor,
			cursor_off
		end

feature -- Access

	last: G is
			-- Last item in container
			-- sl_ignore
		require
			not_empty: not is_empty
		deferred
		ensure
			has_last: has (Result)
		end

	new_cursor: DS_BILINEAR_CURSOR [G] is
			-- New external cursor for traversal
			-- sl_ignore
		deferred
		end

feature -- Status report

	is_last: BOOLEAN is
			-- Is internal cursor on last item?
			-- sl_ignore
		do
			Result := cursor_is_last (internal_cursor)
		ensure
			not_empty: Result implies not is_empty
			not_off: Result implies not off
			definition: Result implies (item_for_iteration = last)
		end

	before: BOOLEAN is
			-- Is there no valid position to left of internal cursor?
			-- sl_ignore
		do
			Result := cursor_before (internal_cursor)
		end

feature -- Cursor movement

	finish is
			-- Move internal cursor to last position.
			-- sl_ignore
		do
			cursor_finish (internal_cursor)
		ensure
			empty_behavior: is_empty implies before
			not_empty_behavior: not is_empty implies is_last
		end

	back is
			-- Move internal cursor to previous position.
			-- sl_ignore
		require
			not_before: not before
		do
			cursor_back (internal_cursor)
		end

	search_back (v: G) is
			-- Move internal cursor to first position at or before current
			-- position where `item_for_iteration' and `v' are equal.
			-- (Use `equality_tester''s comparison criterion
			-- if not void, use `=' criterion otherwise.)
			-- Move `before' if not found.
			-- sl_ignore
		require
			not_off: not off or before
		do
			cursor_search_back (internal_cursor, v)
		end

	go_before is
			-- Move internal cursor to `before' position.
			-- sl_ignore
		do
			cursor_go_before (internal_cursor)
		ensure
			before: before
		end

feature {DS_CURSOR} -- Cursor implementation

	cursor_off (a_cursor: like new_cursor): BOOLEAN is
			-- Is there no item at `a_cursor' position?
		require else
			--SLS1-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c;pos:_p;iters:_i})
		do
			Result := cursor_after (a_cursor) or cursor_before (a_cursor)
		ensure then
			--SLS1-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c;pos:_p;iters:_i}) * IsOff(Current,{res:Result;ref:a_cursor;iters:_i;content:_c})
		end

feature {DS_BILINEAR_CURSOR} -- Cursor implementation

	cursor_is_last (a_cursor: like new_cursor): BOOLEAN is
			-- Is `a_cursor' on last item?
		require
			--SL-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c;pos:_p;iters:_i})
			--a_cursor_not_void: a_cursor /= Void
			--a_cursor_valid: valid_cursor (a_cursor)
		deferred
		ensure
			--SL-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c;pos:_p;iters:_i}) * IsLast(Current,{res:Result;ref:a_cursor;iters:_i;content:_c)
			--not_empty: Result implies not is_empty
			--a_cursor_not_off: Result implies not cursor_off (a_cursor)
			--definition: Result implies (cursor_item (a_cursor) = last)
		end

	cursor_before (a_cursor: like new_cursor): BOOLEAN is
			-- Is there no valid position to left of `a_cursor'?
		require
			--SL-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c;pos:_p;iters:_i})
			--a_cursor_not_void: a_cursor /= Void
			--a_cursor_valid: valid_cursor (a_cursor)
		deferred
		ensure
			--SL-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c;pos:_p;iters:_i}) * IsBefore(Current,{res:Result;ref:a_cursor;iters:_i;content:_c)
		end

	cursor_finish (a_cursor: like new_cursor) is
			-- Move `a_cursor' to last position.
		require
			--SL-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c;pos:_p;iters:_i1})
			--a_cursor_not_void: a_cursor /= Void
			--a_cursor_valid: valid_cursor (a_cursor)
		deferred
		ensure
			--SL-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c;pos:_p;iters:_i2}) * Finished(Current,{ref:a_cursor;olditers:_i1;newiters:_i2;content:_c})
			--empty_behavior: is_empty implies cursor_before (a_cursor)
			--not_empty_behavior: not is_empty implies cursor_is_last (a_cursor)
		end

	cursor_back (a_cursor: like new_cursor) is
			-- Move `a_cursor' to previous position.
		require
			--SL-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c;pos:_p;iters:_i1}) * IsBefore(Current,{res:false();ref:a_cursor;iters:_i1;content:_c})
			--a_cursor_not_void: a_cursor /= Void
			--a_cursor_valid: valid_cursor (a_cursor)
			--a_cursor_not_before: not cursor_before (a_cursor)
		deferred
		ensure
			--SL-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c;pos:_p;iters:_i2}) * MovedForth(Current,{ref:a_cursor;newiters:_i2;olditers:_i1;content:_c})
		end

	cursor_search_back (a_cursor: like new_cursor; v: G) is
			-- Move `a_cursor' to first position at or before its current
			-- position where `cursor_item (a_cursor)' and `v' are equal.
			-- (Use `equality_tester''s comparison criterion
			-- if not void, use `=' criterion otherwise.)
			-- Move `before' if not found.
		require
			--SL-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c;pos:_p;iters:_i1})
			--a_cursor_not_void: a_cursor /= Void
			--a_cursor_valid: valid_cursor (a_cursor)
			--a_cursor_not_off: not cursor_off (a_cursor) or cursor_before (a_cursor)
		deferred
		ensure
			--SL-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c;pos:_p;iters:_i2}) * SearchedBack(Current,{ref:a_cursor;newiters:_i2;olditers:_i1;content:_c;val:v})
		end

	cursor_go_before (a_cursor: like new_cursor) is
			-- Move `a_cursor' to `before' position.
		require
			--SL-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c;pos:_p;iters:_i1})
			--a_cursor_not_void: a_cursor /= Void
			--a_cursor_valid: valid_cursor (a_cursor)
		deferred
		ensure
			--SL-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c;pos:_p;iters:_i2}) * MovedToBefore(Current,{ref:a_cursor;newiters:_i2;olditers:_i1;content:_c})
			--a_cursor_before: cursor_before (a_cursor)
		end

invariant

	not_both: initialized implies (not (after and before))
	before_constraint: initialized implies (before implies off)

end
