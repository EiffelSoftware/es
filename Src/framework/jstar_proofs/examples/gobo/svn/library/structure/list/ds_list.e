indexing

	description:

		"List structures"

	library: "Gobo Eiffel Structure Library"
	copyright: "Copyright (c) 1999-2001, Eric Bezault and others"
	license: "MIT License"
	date: "$Date$"
	revision: "$Revision$"

deferred class DS_LIST [G]

inherit

	DS_BILINEAR [G]
		redefine
			new_cursor
		end

	DS_INDEXABLE [G]

feature -- Access

	index: INTEGER is
			-- Index of current internal cursor position
			-- sl_ignore
		do
			Result := cursor_index (internal_cursor)
		ensure
			valid_index: valid_index (Result)
		end

	new_cursor: DS_LIST_CURSOR [G] is
			-- New external cursor for traversal
			-- sl_ignore
		deferred
		end

feature -- Status report

	valid_index (i: INTEGER): BOOLEAN is
			-- Is `i' a valid index value?
			-- sl_ignore
		do
			Result := 0 <= i and i <= (count + 1)
		ensure
			definition: Result = (0 <= i and i <= (count + 1))
		end

feature -- Cursor movement

	go_i_th (i: INTEGER) is
			-- Move internal cursor to `i'-th position.
			-- sl_ignore
		require
			valid_index: valid_index (i)
		do
			cursor_go_i_th (internal_cursor, i)
		ensure
			moved: index = i
		end

feature -- Element change

	put_left (v: G) is
			-- Add `v' to left of internal cursor position.
			-- Do not move cursors.
			-- sl_ignore
		require
			extendible: extendible (1)
			not_before: not before
		do
			put_left_cursor (v, internal_cursor)
		ensure
			one_more: count = old count + 1
		end

	put_left_cursor (v: G; a_cursor: like new_cursor) is
			-- Add `v' to left of `a_cursor' position.
			-- Do not move cursors.
			-- (Synonym of `a_cursor.put_left (v)'.)
		require
			--SL-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c1;pos:_p1;iters:_i1}) * IsBefore(Current,{res:false();ref:a_cursor;iters:_i1;content:_c1) * IsExtendible(Current,{res:true();elems:1})
			--extendible: extendible (1)
			--cursor_not_void: a_cursor /= Void
			--valid_cursor: valid_cursor (a_cursor)
			--not_before: not a_cursor.before
		deferred
		ensure
			--SL-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c2;pos:_p2;iters:_i2}) * EqualAfterPutLeft(Current,{newcontent:_c2;newpos:_p2;newiters:_i2;oldcontent:_c1;oldpos:_p1;olditers:_i1;ref:a_cursor;with:v})
			--one_more: count = old count + 1
		end

	put_right (v: G) is
			-- Add `v' to right of internal cursor position.
			-- Do not move cursors.
			-- sl_ignore
		require
			extendible: extendible (1)
			not_after: not after
		do
			put_right_cursor (v, internal_cursor)
		ensure
			one_more: count = old count + 1
		end

	put_right_cursor (v: G; a_cursor: like new_cursor) is
			-- Add `v' to right of `a_cursor' position.
			-- Do not move cursors.
			-- (Synonym of `a_cursor.put_right (v)'.)
		require
			--SL-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c1;pos:_p1;iters:_i1}) * IsAfter(Current,{res:false();ref:a_cursor;iters:_i1;content:_c1) * IsExtendible(Current,{res:true();elems:1})
			--extendible: extendible (1)
			--cursor_not_void: a_cursor /= Void
			--valid_cursor: valid_cursor (a_cursor)
			--not_after: not a_cursor.after
		deferred
		ensure
			--SL-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c2;pos:_p2;iters:_i2}) * EqualAfterPutRight(Current,{newcontent:_c2;newpos:_p2;newiters:_i2;oldcontent:_c1;oldpos:_p1;olditers:_i1;ref:a_cursor;with:v})
			--one_more: count = old count + 1
		end

	force_left (v: G) is
			-- Add `v' to left of internal cursor position.
			-- Do not move cursors.
			-- sl_ignore
		require
			not_before: not before
		do
			force_left_cursor (v, internal_cursor)
		ensure
			one_more: count = old count + 1
		end

	force_left_cursor (v: G; a_cursor: like new_cursor) is
			-- Add `v' to left of `a_cursor' position.
			-- Do not move cursors.
			-- (Synonym of `a_cursor.force_left (v)'.)
			-- sl_ignore
		require
			cursor_not_void: a_cursor /= Void
			valid_cursor: valid_cursor (a_cursor)
			not_before: not a_cursor.before
		deferred
		ensure
			one_more: count = old count + 1
		end

	force_right (v: G) is
			-- Add `v' to right of internal cursor position.
			-- Do not move cursors.
			-- sl_ignore
		require
			not_after: not after
		do
			force_right_cursor (v, internal_cursor)
		ensure
			one_more: count = old count + 1
		end

	force_right_cursor (v: G; a_cursor: like new_cursor) is
			-- Add `v' to right of `a_cursor' position.
			-- Do not move cursors.
			-- (Synonym of `a_cursor.force_right (v)'.)
			-- sl_ignore
		require
			cursor_not_void: a_cursor /= Void
			valid_cursor: valid_cursor (a_cursor)
			not_after: not a_cursor.after
		deferred
		ensure
			one_more: count = old count + 1
		end

	replace_at (v: G) is
			-- Replace item at internal cursor position by `v'.
			-- Do not move cursors.
			-- sl_ignore
		require
			not_off: not off
		do
			internal_cursor.replace (v)
		ensure
			same_count: count = old count
			replaced: item_for_iteration = v
		end

	replace_at_cursor (v: G; a_cursor: like new_cursor) is
			-- Replace item at `a_cursor' position by `v'.
			-- Do not move cursors.
			-- (Synonym of `a_cursor.replace (v)'.)
			-- sl_ignore
		require
			cursor_not_void: a_cursor /= Void
			valid_cursor: valid_cursor (a_cursor)
			not_off: not a_cursor.off
		do
			a_cursor.replace (v)
		ensure
			same_count: count = old count
			replaced: a_cursor.item = v
		end

	extend_left (other: DS_LINEAR [G]) is
			-- Add items of `other' to left of internal cursor position.
			-- Keep items of `other' in the same order.
			-- Do not move cursors.
			-- sl_ignore
		require
			other_not_void: other /= Void
			extendible: extendible (other.count)
			not_before: not before
		do
			extend_left_cursor (other, internal_cursor)
		ensure
			new_count: count = old count + old other.count
			same_order: (not other.is_empty) implies (item (old index) = other.first)
		end

	extend_left_cursor (other: DS_LINEAR [G]; a_cursor: like new_cursor) is
			-- Add items of `other' to left of `a_cursor' position.
			-- Keep items of `other' in the same order.
			-- Do not move cursors.
			-- (Synonym of `a_cursor.extend_left (other)'.)
			-- sl_ignore
		require
			other_not_void: other /= Void
			extendible: extendible (other.count)
			cursor_not_void: a_cursor /= Void
			valid_cursor: valid_cursor (a_cursor)
			not_before: not a_cursor.before
		deferred
		ensure
			new_count: count = old count + old other.count
			same_order: (not other.is_empty) implies (item (old (a_cursor.index)) = other.first)
		end

	extend_right (other: DS_LINEAR [G]) is
			-- Add items of `other' to right of internal cursor position.
			-- Keep items of `other' in the same order.
			-- Do not move cursors.
			-- sl_ignore
		require
			other_not_void: other /= Void
			extendible: extendible (other.count)
			not_after: not after
		do
			extend_right_cursor (other, internal_cursor)
		ensure
			new_count: count = old count + old other.count
			same_order: (not other.is_empty) implies (item (index + 1) = other.first)
		end

	extend_right_cursor (other: DS_LINEAR [G]; a_cursor: like new_cursor) is
			-- Add items of `other' to right of `a_cursor' position.
			-- Keep items of `other' in the same order.
			-- Do not move cursors.
			-- (Synonym of `a_cursor.extend_right (other)'.)
			-- sl_ignore
		require
			other_not_void: other /= Void
			extendible: extendible (other.count)
			cursor_not_void: a_cursor /= Void
			valid_cursor: valid_cursor (a_cursor)
			not_after: not a_cursor.after
		deferred
		ensure
			new_count: count = old count + old other.count
			same_order: (not other.is_empty) implies (item (a_cursor.index + 1) = other.first)
		end

	append_left (other: DS_LINEAR [G]) is
			-- Add items of `other' to left of internal cursor position.
			-- Keep items of `other' in the same order.
			-- Do not move cursors.
			-- sl_ignore
		require
			other_not_void: other /= Void
			not_before: not before
		do
			append_left_cursor (other, internal_cursor)
		ensure
			new_count: count = old count + old other.count
			same_order: (not other.is_empty) implies (item (old index) = other.first)
		end

	append_left_cursor (other: DS_LINEAR [G]; a_cursor: like new_cursor) is
			-- Add items of `other' to left of `a_cursor' position.
			-- Keep items of `other' in the same order.
			-- Do not move cursors.
			-- (Synonym of `a_cursor.append_left (other)'.)
			-- sl_ignore
		require
			other_not_void: other /= Void
			cursor_not_void: a_cursor /= Void
			valid_cursor: valid_cursor (a_cursor)
			not_before: not a_cursor.before
		deferred
		ensure
			new_count: count = old count + old other.count
			same_order: (not other.is_empty) implies (item (old (a_cursor.index)) = other.first)
		end

	append_right (other: DS_LINEAR [G]) is
			-- Add items of `other' to right of internal cursor position.
			-- Keep items of `other' in the same order.
			-- Do not move cursors.
			-- sl_ignore
		require
			other_not_void: other /= Void
			not_after: not after
		do
			append_right_cursor (other, internal_cursor)
		ensure
			new_count: count = old count + old other.count
			same_order: (not other.is_empty) implies (item (index + 1) = other.first)
		end

	append_right_cursor (other: DS_LINEAR [G]; a_cursor: like new_cursor) is
			-- Add items of `other' to right of `a_cursor' position.
			-- Keep items of `other' in the same order.
			-- Do not move cursors.
			-- (Synonym of `a_cursor.append_right (other)'.)
			-- sl_ignore
		require
			other_not_void: other /= Void
			cursor_not_void: a_cursor /= Void
			valid_cursor: valid_cursor (a_cursor)
			not_after: not a_cursor.after
		deferred
		ensure
			new_count: count = old count + old other.count
			same_order: (not other.is_empty) implies (item (a_cursor.index + 1) = other.first)
		end

feature -- Removal

	remove_at is
			-- Remove item at internal cursor position.
			-- Move any cursors at this position `forth'.
			-- sl_ignore
		require
			not_off: not off
		do
			remove_at_cursor (internal_cursor)
		ensure
			one_less: count = old count - 1
		end

	remove_at_cursor (a_cursor: like new_cursor) is
			-- Remove item at `a_cursor' position.
			-- Move any cursors at this position `forth'.
			-- (Synonym of `a_cursor.remove'.)
			-- sl_ignore
		require
			cursor_not_void: a_cursor /= Void
			valid_cursor: valid_cursor (a_cursor)
			not_off: not a_cursor.off
		deferred
		ensure
			one_less: count = old count - 1
		end

	remove_left is
			-- Remove item to left of internal cursor position.
			-- Move any cursors at this position `forth'.
			-- sl_ignore
		require
			not_empty: not is_empty
			not_before: not before
			not_first: not is_first
		do
			remove_left_cursor (internal_cursor)
		ensure
			one_less: count = old count - 1
		end

	remove_left_cursor (a_cursor: like new_cursor) is
			-- Remove item to left of `a_cursor' position.
			-- Move any cursors at this position `forth'.
			-- (Synonym of `a_cursor.remove_left'.)
			-- sl_ignore
		require
			not_empty: not is_empty
			cursor_not_void: a_cursor /= Void
			valid_cursor: valid_cursor (a_cursor)
			not_before: not a_cursor.before
			not_first: not a_cursor.is_first
		deferred
		ensure
			one_less: count = old count - 1
		end

	remove_right is
			-- Remove item to right of internal cursor position.
			-- Move any cursors at this position `forth'.
			-- sl_ignore
		require
			not_empty: not is_empty
			not_after: not after
			not_last: not is_last
		do
			remove_right_cursor (internal_cursor)
		ensure
			one_less: count = old count - 1
		end

	remove_right_cursor (a_cursor: like new_cursor) is
			-- Remove item to right of `a_cursor' position.
			-- Move any cursors at this position `forth'.
			-- (Synonym of `a_cursor.remove_right'.)
			-- sl_ignore
		require
			not_empty: not is_empty
			cursor_not_void: a_cursor /= Void
			valid_cursor: valid_cursor (a_cursor)
			not_after: not a_cursor.after
			not_last: not a_cursor.is_last
		deferred
		ensure
			one_less: count = old count - 1
		end

	prune_left (n: INTEGER) is
			-- Remove `n' items to left of internal cursor position.
			-- Move all cursors `off'.
			-- sl_ignore
		require
			valid_n: 0 <= n and n < index
		do
			prune_left_cursor (n, internal_cursor)
		ensure
			new_count: count = old count - n
		end

	prune_left_cursor (n: INTEGER; a_cursor: like new_cursor) is
			-- Remove `n' items to left of `a_cursor' position.
			-- Move all cursors `off'.
			-- (Synonym of `a_cursor.prune_left (n)'.)
			-- sl_ignore
		require
			cursor_not_void: a_cursor /= Void
			valid_cursor: valid_cursor (a_cursor)
			valid_n: 0 <= n and n < a_cursor.index
		deferred
		ensure
			new_count: count = old count - n
		end

	prune_right (n: INTEGER) is
			-- Remove `n' items to right of internal cursor position.
			-- Move all cursors `off'.
			-- sl_ignore
		require
			valid_n: 0 <= n and n <= (count - index)
		do
			prune_right_cursor (n, internal_cursor)
		ensure
			new_count: count = old count - n
		end

	prune_right_cursor (n: INTEGER; a_cursor: like new_cursor) is
			-- Remove `n' items to right of `a_cursor' position.
			-- Move all cursors `off'.
			-- (Synonym of `a_cursor.prune_right (n)'.)
			-- sl_ignore
		require
			cursor_not_void: a_cursor /= Void
			valid_cursor: valid_cursor (a_cursor)
			valid_n: 0 <= n and n <= (count - a_cursor.index)
		deferred
		ensure
			new_count: count = old count - n
		end

	delete (v: G) is
			-- Remove all occurrences of `v'.
			-- (Use `equality_tester''s comparison criterion
			-- if not void, use `=' criterion otherwise.)
			-- Move all cursors `off'.
			-- sl_ignore
		deferred
		ensure
			deleted: not has (v)
			new_count: count = old (count - occurrences (v))
		end

feature {DS_LIST_CURSOR} -- Cursor implementation

	cursor_index (a_cursor: like new_cursor): INTEGER is
			-- Index of `a_cursor''s current position
		require
			--SL-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c;pos:_p;iters:_i})
			--cursor_not_void: a_cursor /= Void
			--a_cursor_valid: valid_cursor (a_cursor)
		deferred
		ensure
			--SL-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c;pos:_p;iters:_i}) * Index(Current,{index:Result;ref:a_cursor;iters:_i;content:_c})
			--valid_index: valid_index (Result)
		end

	cursor_go_i_th (a_cursor: like new_cursor; i: INTEGER) is
			-- Move `a_cursor' to `i'-th position.
		require
			--SL-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c;pos:_p;iters:_i1}) * IsValidIndex(Current,{res:true();index:i;content:_c})
			--cursor_not_void: a_cursor /= Void
			--a_cursor_valid: valid_cursor (a_cursor)
			--valid_index: valid_index (i)
		deferred
		ensure
			--SL-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c;pos:_p;iters:_i2}) * WentToIndex(Current,{ref:a_cursor;index:i;newiters:_i2;olditers:_i1;content:_c})
			--moved: cursor_index (a_cursor) = i
		end

end
