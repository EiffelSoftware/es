note
	description: "A simple singly-linked list."
	author: "Stephan van Staden"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	L_LIST [G]
feature

	add (e: G)
		require
			--SL-- list(Current, Void, _s)
		deferred
		ensure
			--SL-- list(Current, Void, cons(e, _s))
		end

	remove_first
		require
			--SL-- length(_l) /= 0 * list(Current, Void, _l)
		deferred
		ensure
			--SL-- _l = cons(_x, _xs) * list(Current, Void, _xs) * Current.<L_LIST.removed_item> |-> _x
		end

	removed_item: G

	size: INTEGER
		require
			--SL-- list(Current, Void, _s)
		deferred
		ensure
			--SL-- Result = length(_s) * list(Current, Void, _s)
		end

end
