indexing
	description: "Generic lists"
	author: "Ruihua Jin"
	date: "$Date$"
	revision: "$Revision$"

class
	GLIST[G]

feature
	item: G
	next: like Current

feature

	put (a_item: G) is
			-- Put `a_item' at the end of the list.
		do
			if (item = Void) then
				item := a_item
			else
				if (next = Void) then
					create next
					next.set_item (a_item)
				else
					next.put (a_item)
				end
			end
		end

	set_item (a_item: G) is
			-- Set `item' to `a_item'.
		do
			item := a_item
		end

end
