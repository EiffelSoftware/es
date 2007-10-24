indexing
	description: "Cells the FLAT_LINKED_LIST"
	version: "$Id$"
	author: "Bernd Schoeller, based on LINKABLE of EiffelBase"
	copyright: "http://archive.eiffel.com/products/base/license.txt"

class
	FLAT_LINKABLE [G]

inherit
	CELL [G]
		export
			{FLAT_LINKED_LIST,CELL}
				put
			{ANY}
				item
		end

feature -- Access

	right: like Current
			-- Right neighbor

feature {FLAT_LINKED_LIST,CELL} -- Implementation

	put_right (other: like Current) is
			-- Put `other' to the right of current cell.
		do
			right := other
		ensure
			chained: right = other
		end

	forget_right is
			-- Remove right link.
		do
			right := Void
		ensure
			not_chained: right = Void
		end

end -- class LINKABLE
