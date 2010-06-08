indexing

	description:

		"Data structures that can be traversed. Traversable containers %
		%are equipped with an internal cursor and external cursors which %
		%can be used for simultaneous traversals."

	library: "Gobo Eiffel Structure Library"
	copyright: "Copyright (c) 1999-2007, Eric Bezault and others"
	license: "MIT License"
	date: "$Date$"
	revision: "$Revision$"
	sl_predicate: "IsOff(x,{res:ares;ref:aref;iters:i;content:c}) = undefined()"
	sl_predicate: "ItemAt(x,{res:res;ref:r;iters:i;content:c}) = undefined()"
	sl_predicate: "Moved(x,{ref:ref;destref:d;newiters:ni;olditers:oi}) = undefined()"
	sl_axioms: "[
		not_off_constraint: ItemAt(Current,{res:v;ref:other;iters:i;content:c1}) * Replaced(Current,{ref:cursor;value:w;newcontent:c2;oldcontent:c1;iters:i}) ==> IsOff(Current,{res:false();ref:other;iters:i;content:c2}) * ItemAt(Current,{res:v;ref:other;iters:i;content:c1}) * Replaced(Current,{ref:cursor;value:w;newcontent:c2;oldcontent:c1;iters:i})
		swapped_constraint: ItemAt(Current,{res:result1;ref:iter1;iters:i;content:c1}) * ItemAt(Current,{res:result2;ref:iter2;iters:i;content:c1}) * Replaced(Current,{ref:iter1;value:result2;newcontent:c2;oldcontent:c1;iters:i}) * Replaced(Current,{ref:iter2;value:result1;newcontent:c3;oldcontent:c2;iters:i}) ==> Swapped(Current,{ref1:iter1;ref2:iter2;iters:i;oldcontent:c1;newcontent:c3})
	]"
	--		item_implies_on: ItemAt(Current,{res:result;ref:iter;iters:i;content:c}) ==> IsOff(Current,{res:false();ref:iter;iters:i;content:c}) * ItemAt(Current,{res:result;ref:iter;iters:i;content:c})   [Unfortunately, jStar matching is too eager for this axiom, so we encode it explicitly in the logic file.]
	js_logic: "logic"
	js_abstraction: "abs"

deferred class DS_TRAVERSABLE [G]

inherit

	DS_CONTAINER [G]

feature -- Access

	item_for_iteration: G is
			-- Item at internal cursor position
			-- sl_ignore
		require
			--not_off: not off
			--SLS--
		do
			Result := cursor_item (internal_cursor)
		ensure
			--SLS--
		end

	new_cursor: DS_CURSOR [G] is
			-- New external cursor for traversal
			-- sl_ignore
		require
			--SL--
		deferred
		ensure
			--SL--
			--cursor_not_void: Result /= Void
			--valid_cursor: valid_cursor (Result)
		end

feature -- Status report

	off: BOOLEAN is
			-- Is there no item at internal cursor position?
			-- sl_ignore
		require
			--SLS--
		do
			Result := cursor_off (internal_cursor)
		ensure
			--SLS--
		end

	same_position (a_cursor: like new_cursor): BOOLEAN is
			-- Is internal cursor at same position as `a_cursor'?
			-- sl_ignore
		require
			--SLS--
			--a_cursor_not_void: a_cursor /= Void
		do
			Result := cursor_same_position (internal_cursor, a_cursor)
		ensure
			--SLS--
		end

	valid_cursor (a_cursor: DS_CURSOR [G]): BOOLEAN is
			-- Is `a_cursor' a valid cursor?
		require
			--SLS-- DS(Current,{content:_c;pos:_p;iters:_i}) * Cursor(a_cursor,{ds:_ds})
			--a_cursor_not_void: a_cursor /= Void
		do
			Result := a_cursor.container = Current
		ensure
			--SLS-- DS(Current,{content:_c;pos:_p;iters:_i}) * Cursor(a_cursor,{ds:_ds}) * Result = builtin_eq(_ds,Current)
		end

feature -- Cursor movement

	go_to (a_cursor: like new_cursor) is
			-- Move internal cursor to `a_cursor''s position.
			-- sl_ignore
		require
			--SLS-- sl_ignore
			--cursor_not_void: a_cursor /= Void
			--valid_cursor: valid_cursor (a_cursor)
		do
			cursor_go_to (internal_cursor, a_cursor)
		ensure
			--SLS--
			--same_position: same_position (a_cursor)
		end

feature {NONE} -- Cursor implementation

	set_internal_cursor (c: like internal_cursor) is
			-- Set `internal_cursor' to `c'.
			-- sl_ignore This feature is prematurely listed here.
		deferred
		ensure
			internal_cursor_set: internal_cursor = c
		end

	internal_cursor: like new_cursor
			-- Internal cursor

feature {DS_CURSOR} -- Cursor implementation

	cursor_item (a_cursor: like new_cursor): G is
			-- Item at `a_cursor' position
		require
			--SL1-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c;pos:_p;iters:_i}) * IsOff(Current,{res:false();ref:a_cursor;iters:_i;content:_c})
			--a_cursor_not_void: a_cursor /= Void
			--a_cursor_valid: valid_cursor (a_cursor)
			--a_cursor_not_off: not cursor_off (a_cursor)
		deferred
		ensure
			--SL1-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c;pos:_p;iters:_i}) * ItemAt(Current,{res:Result;ref:a_cursor;iters:_i;content:_c})
		end

	cursor_off (a_cursor: like new_cursor): BOOLEAN is
			-- Is there no item at `a_cursor' position?
		require
			--SL1-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c;pos:_p;iters:_i})
--Todo			--SL2-- DSExplicitInternal(Current,{content:_c;internal:a_cursor;pos:_p;iters:_i})
			--a_cursor_not_void: a_cursor /= Void
			--a_cursor_valid: valid_cursor (a_cursor)
		deferred
		ensure
			--SL1-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c;pos:_p;iters:_i}) * IsOff(Current,{res:Result;ref:a_cursor;iters:_i;content:_c})
--Todo			--SL2-- DSExplicitInternal(Current,{content:_c;internal:a_cursor;pos:_p;iters:_i}) * Result = builtin_eq(_p,off())
		end

	cursor_same_position (a_cursor, other: like new_cursor): BOOLEAN is
			-- Is `a_cursor' at same position as `other'?
			-- sl_ignore - Fill in this later when the semantics becomes clear.
		require
			a_cursor_not_void: a_cursor /= Void
			a_cursor_valid: valid_cursor (a_cursor)
			other_not_void: other /= Void
		deferred
		end

	cursor_go_to (a_cursor, other: like new_cursor) is
			-- Move `a_cursor' to `other''s position.
		require
			--SL1-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c;pos:_p;iters:_i1}) * Cursor(other,{ds:Current})
--Todo			--SL2-- DSExplicitInternal(Current,{content:_c;internal:a_cursor;pos:_;iters:_i}) * in(iter_pos(other,_p),_i) = true()
			--cursor_not_void: a_cursor /= Void
			--a_cursor_valid: valid_cursor (a_cursor)
			--other_not_void: other /= Void
			--other_valid: valid_cursor (other)
		deferred
		ensure
			--SL1-- Cursor(a_cursor,{ds:Current}) * DS(Current,{content:_c;pos:_p;iters:_i2}) * Cursor(other,{ds:Current}) * Moved(Current,{ref:a_cursor;destref:other;newiters:_i2;olditers:_i1})
--Todo			--SL2-- DSExplicitInternal(Current,{content:_c;internal:a_cursor;pos:_p;iters:_i})
			--same_position: cursor_same_position (a_cursor, other)
		end

	add_traversing_cursor (a_cursor: like new_cursor) is
			-- Add `a_cursor' to the list of traversing cursors
			-- (i.e. cursors associated with current container
			-- and which are not currently `off').
			-- sl_ignore
		require
			--SLS-- sl_ignore
			--a_cursor_not_void: a_cursor /= Void
		do
			if a_cursor /= internal_cursor then
				a_cursor.set_next_cursor (internal_cursor.next_cursor)
				internal_cursor.set_next_cursor (a_cursor)
			end
		ensure
			--SLS--
		end

	remove_traversing_cursor (a_cursor: like new_cursor) is
			-- Remove `a_cursor' from the list of traversing cursors
			-- (i.e. cursors associated with current container
			-- and which are not currently `off').
			-- sl_ignore
		require
			--SLS--
			--a_cursor_not_void: a_cursor /= Void
		local
			current_cursor, previous_cursor: like new_cursor
		do
			if a_cursor /= internal_cursor then
				from
					previous_cursor := internal_cursor
					current_cursor := previous_cursor.next_cursor
				until
					current_cursor = a_cursor or current_cursor = Void
				loop
					previous_cursor := current_cursor
					current_cursor := current_cursor.next_cursor
				end
				if current_cursor = a_cursor then
					previous_cursor.set_next_cursor (a_cursor.next_cursor)
					a_cursor.set_next_cursor (Void)
				end
			end
		ensure
			--SLS--
		end

feature {NONE} -- Implementation

	initialized: BOOLEAN is
			-- Some Eiffel compilers check invariants even when the
			-- execution of the creation procedure is not completed.
			-- (In this case, checking the assertions of the being
			-- created `internal_cursor' triggers the invariants
			-- on the current container. So these invariants need
			-- to be protected.)
			-- sl_ignore
		do
			Result := (internal_cursor /= Void)
		end

invariant

	empty_constraint: initialized implies (is_empty implies off)
	internal_cursor_not_void: initialized implies (internal_cursor /= Void)
	valid_internal_cursor: initialized implies valid_cursor (internal_cursor)

end
