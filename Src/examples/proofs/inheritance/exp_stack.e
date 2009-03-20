indexing
	description: "Summary description for {EXP_STACK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXP_STACK

feature

	item1, item2, item3: EXPRESSION

	count: INTEGER

	put (a_item: EXPRESSION; index: INTEGER)
		require
			0 < index and index < 4
		do
			if index = 1 then
				item1 := a_item
			end
			if index = 2 then
				item2 := a_item
			end
			if index = 3 then
				item3 := a_item
			end
		ensure
			index = 1 implies item1 = a_item and item2 = old item2 and item3 = old item3
			index = 2 implies item2 = a_item and item1 = old item1 and item3 = old item3
			index = 3 implies item3 = a_item and item1 = old item1 and item2 = old item2
		end

--	evaluate (index: INTEGER): INTEGER
--		do
--			if index = 1 then
--				Result := item1.sum
--			end
--			if index = 2 then
--				Result := item2.sum
--			end
--			if index = 3 then
--				Result := item3.sum
--			end
--		ensure
--			index = 1 implies Result = (agent item1.sum).postcondition ([])
--			index = 2 implies Result = item2.sum
--			index = 3 implies Result = item3.sum
--		end

end
