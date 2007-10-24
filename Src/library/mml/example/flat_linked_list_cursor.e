indexing
	description: "Cursor the FLAT_LINKED_LIST"
	version: "$Id$"
	author: "Bernd Schoeller, based on LINKED_LIST_CURSOR of EiffelBase"
	copyright: "http://archive.eiffel.com/products/base/license.txt"

class
	FLAT_LINKED_LIST_CURSOR[G]

inherit
	CURSOR

create
	make

feature {NONE} -- Initialization

	make (active_element: like active; aft, bef: BOOLEAN) is
			-- Create a cursor and set it up on `active_element'.
		do
			active := active_element
			after := aft
			before := bef
		end

feature {FLAT_LINKED_LIST} -- Implementation

	active: FLAT_LINKABLE [G]
			-- Current element in linked list

	after: BOOLEAN
			-- Is there no valid cursor position to the right of cursor?

	before: BOOLEAN
			-- Is there no valid cursor position to the right of cursor?

invariant
	not_both: not (before and after)
	no_active_not_on: active = Void implies (before or after)
end
