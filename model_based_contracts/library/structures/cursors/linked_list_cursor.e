indexing

	description:
		"Cursors for linked lists"
	legal: "See notice at end of class."

	status: "See notice at end of class."
	names: linked_list_cursor, cursor;
	contents: generic;
	model: position;
	model_links: list;
	date: "$Date$"
	revision: "$Revision$"

class LINKED_LIST_CURSOR [G] inherit

	CURSOR

create
	make

feature {NONE} -- Initialization

	make (active_element: like active; aft, bef: BOOLEAN; l: LINKED_LIST [G]) is
			-- Create a cursor and set it up on `active_element'.
		require
			l_exists: l /= Void
			active_element_from_l: active_element /= Void implies l.first_element.distance (active_element) >= 0
		do
			active := active_element
			after := aft
			before := bef
			list := l
		ensure
		-- ensure: model
			list_effect: list = l
			position_effect_before: bef implies position = 0
			position_effect_after: aft implies position = l.sequence.count + 1
			position_effect_not_off: not aft and not bef implies position = l.first_element.distance (active_element) + 1
		end

feature {LINKED_LIST} -- Implementation

	active: ?LINKABLE [G]
			-- Current element in linked list
		attribute
		ensure
		-- ensure: model
			definition: Result = list.first_element.i_th_cell (position)
		end

	after: BOOLEAN
			-- Is there no valid cursor position to the right of cursor?
		attribute
		ensure
		-- ensure: model
			definition: Result = (position = list.sequence.count + 1)
		end

	before: BOOLEAN
			-- Is there no valid cursor position to the right of cursor?
		attribute
		ensure
		-- ensure: model
			definition: Result = (position = 0)
		end

feature -- Model
	list: LINKED_LIST [G]
			-- List to which the cursor is attached

	position: INTEGER
			-- Cursor position
		do
			if before then
				Result := 0
			elseif after then
				Result := list.sequence.count + 1
			else
				Result := list.first_element.distance (active) + 1
			end
		end

invariant
	not_both: not (before and after)
	no_active_not_on: active = Void implies (before or after)

indexing
	library:	"EiffelBase: Library of reusable components for Eiffel."
	copyright:	"Copyright (c) 1984-2008, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"







end -- class LINKED_LIST_CURSOR



