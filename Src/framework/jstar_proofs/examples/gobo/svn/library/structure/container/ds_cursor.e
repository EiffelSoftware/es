indexing

	description:

		"Cursors for data structure traversals"

	library: "Gobo Eiffel Structure Library"
	copyright: "Copyright (c) 1999-2001, Eric Bezault and others"
	license: "MIT License"
	date: "$Date$"
	revision: "$Revision$"
--	sl_axioms: "[
--		type_stuff: Cursor(Current,{ds:d}) ==> !statictype(d,"DS_TRAVERSABLE") * Cursor(Current,{ds:d})
--	]"
	sl_predicate: "Cursor(x,{ds:d}) = undefined()" -- Here such that the prover generates default rules.
	js_logic: "logic"
	js_abstraction: "abs"

deferred class DS_CURSOR [G]

inherit

	ANY
		redefine
			copy,
			is_equal
		end

	KL_IMPORTED_ANY_ROUTINES
		undefine
			copy,
			is_equal
		end

feature -- Access

	item: G is
			-- Item at cursor position
		require
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i}) * IsOff(_ds,{res:false();ref:Current;iters:_i;content:_c})
			--not_off: not off
		do
			Result := container.cursor_item (Current)
		ensure
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i}) * ItemAt(_ds,{res:Result;ref:Current;iters:_i;content:_c})
		end

	container: DS_TRAVERSABLE [G] is
			-- Data structure traversed
		require
			--SL-- Cursor(Current,{ds:_ds})
		deferred
		ensure
			--SL-- Cursor(Current,{ds:_ds}) * Result = _ds
		end

feature -- Status report

	off: BOOLEAN is
			-- Is there no item at cursor position?
		require
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i})
		do
			Result := container.cursor_off (Current)
		ensure
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i}) * IsOff(_ds,{res:Result;ref:Current;iters:_i;content:_c})
		end

	same_position (other: like Current): BOOLEAN is
			-- Is current cursor at same position as `other'?
			-- sl_ignore - Fill in semantics later
		require
			other_not_void: other /= Void
		do
			Result := container.cursor_same_position (Current, other)
		end

	valid_cursor (other: like Current): BOOLEAN is
			-- Is `other' a valid cursor according
			-- to current traversal strategy?
		require
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i}) * Cursor(other,{ds:_ds2})
			--other_not_void: other /= Void
		do
			Result := container.valid_cursor (other)
		ensure
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i}) * Cursor(other,{ds:_ds2}) * Result = builtin_eq(_ds2,_ds)
			--Result implies container.valid_cursor (other)
		end

feature -- Cursor movement

	go_to (other: like Current) is
			-- Move cursor to `other''s position.
			-- sl_ignore
		require
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i1}) * Cursor(other,{ds:_ds})
			--other_not_void: other /= Void
			--other_valid: valid_cursor (other)
		do
			container.cursor_go_to (Current, other)
		ensure
			--SLS-- Cursor(Current,{ds:_ds}) * DS(_ds,{content:_c;pos:_p;iters:_i2}) * Cursor(other,{ds:_ds}) * Moved(_ds,{ref:Current;destref:other;newiters:_i2;olditers:_i1})
			--same_position: same_position (other)
		end

feature -- Duplication

	copy (other: like Current) is
			-- Copy `other' to current cursor.
			-- sl_ignore
		do
			if container /= Void and then not off then
				container.remove_traversing_cursor (Current)
			end
			standard_copy (other)
			next_cursor := Void
			if not off then
				container.add_traversing_cursor (Current)
			end
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN is
			-- Are `other' and current cursor at the same position?
			-- sl_ignore
		do
			if ANY_.same_types (Current, other) then
				Result := same_position (other)
			end
		end

feature {DS_TRAVERSABLE} -- Implementation

	next_cursor: DS_CURSOR [G]
			-- Next cursor
			-- (Used by `container' to keep track of traversing
			-- cursors (i.e. cursors associated with `container'
			-- and which are not currently `off').)

	set_next_cursor (a_cursor: like next_cursor) is
			-- Set `next_cursor' to `a_cursor'.
		require
			--SLS-- Current.<DS_CURSOR.next_cursor> |-> _
		do
			next_cursor := a_cursor
		ensure
			--SLS-- Current.<DS_CURSOR.next_cursor> |-> a_cursor
			--next_cursor_set: next_cursor = a_cursor
		end

invariant

	container_not_void: container /= Void
	empty_constraint: container.is_empty implies off

end
