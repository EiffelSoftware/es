indexing
	description: "Generic lists"
	author: "Ruihua Jin"
	date: "$Date$"
	revision: "$Revision$"

class
	GSUBLIST[G]

inherit
	GLIST[G]
		rename
			item as subitem,
			next as subnext
		redefine
			put
		end

feature
	count: INTEGER

feature
	put (a_item: G) is
			-- Put a_item at the end of the list and increase count by 1.
		do
			if (subitem = Void) then
				set_item (a_item)
			else
				if (subnext = Void) then
					create subnext
					subnext.set_item (a_item)
				else
					subnext.put (a_item)
				end
			end
			count := count + 1
		end
end
