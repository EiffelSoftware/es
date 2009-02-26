indexing
	description: "Summary description for {GENERIC_CELL}."
	date: "$Date$"
	revision: "$Revision$"

class
	GENERIC_CELL [G]

create
	set_item

feature -- Access

	item: G
			-- Cell element

feature -- Element change

	set_item (a_item: G)
			-- Set `item' to `a_item'.
		do
			item := a_item
		ensure
			item_set: item = a_item
		end

end
