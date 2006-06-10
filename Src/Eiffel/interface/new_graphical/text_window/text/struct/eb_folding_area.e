indexing
	description: "[
				Structure containing all information of a area which can be folded, 
				Objects of this class are nodes of an AVL-tree used by 
				]"
	author: "bherlig"
	date: "$06/06/06$"
	revision: "$0.1$"

class
	EB_FOLDING_AREA  [K -> INTEGER, G -> FEATURE_AS]

create
	make

feature -- Initialization

	make (k: K; d: G) is
			-- Set `key' and `item'.
		require
			key_exists: k /= Void
		do
			key := k
			item := d
		ensure
			key_set: key = k
			item_set: item = d
		end

feature -- Access

	key: K
			-- Key for `item'.

	item: G
			-- Data associated with `key'.

	left: like Current
			-- Left neighbour or child.

	right: like Current
			-- Right neighbour or child

	balance: INTEGER
			-- Height of right subtree minus height of left subtree.


	next, previous: like current
		-- pointers to other elements in the doubly-linked-leaf - list
		-- may be void

	start_line: INTEGER
		-- line on which the area starts
	end_line: INTEGER
		-- line on which the area ends

feature {EB_FOLDING_AREA_TREE} -- Element change

	set_left (a_left: like Current) is
			-- Set `left' to `a_left'.
		do
			left := a_left
		ensure
			left_assigned: left = a_left
		end

	set_right (a_right: like Current) is
			-- Set `right' to `a_right'.
		do
			right := a_right
		ensure
			right_assigned: right = a_right
		end

	set_item (i: G) is
			-- Replace `item' with `i'.
		do
			item := i
		ensure
			item_set: item = i
		end

	set_previous (a_previous: like Current) is
			-- Set `previous' to `a_previous'.
		do
			previous := a_previous
		ensure
			previous_assigned: previous = a_previous
		end

	set_next (a_next: like Current) is
			-- Set `next' to `a_next'.
		do
			next := a_next
		ensure
			next_assigned: next = a_next
		end

	set_balance (bal: INTEGER) is
			-- Set balance to `bal'.
		require
			small_balance: bal.abs <= 2
		do
			balance := bal
		ensure
			balance_set: balance = bal
		end

invariant
	small_balance: balance.abs <= 2

end -- class EB_FOLDING_AREA
