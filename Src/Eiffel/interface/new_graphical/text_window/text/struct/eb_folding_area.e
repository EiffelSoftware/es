indexing
	description: "[
				Structure containing all information of a area which can be folded, 
				Objects of this class are nodes of an AVL-tree used by
				]"
	author: "bherlig"
	date: "$06/21/06$"
	revision: "$0.5$"

class
	EB_FOLDING_AREA

	inherit
		COMPARABLE

create
	make

feature -- Initialization

	make (k: FEATURE_AS) is
			-- initialize current, set item start- & endlines, hidden := false
		require
			key_exists: k /= Void
		do
			item := k
			hidden := false
			start_line := k.start_location.line
			end_line := k.end_location.line
		ensure
			item_set: item = k
		end

--	make_with_hidden_status(k: FEATURE_AS; h: BOOLEAN) is
--			-- initialize current, set item start- & endlines, hidden := h
--		require
--			key_exists: k /= Void
--		do
--			item := k
--			start_line := k.start_location.line
--			end_line := k.end_location.line
--			hidden := true
--		ensure
--			item_set: item = k
--		end

feature -- hidden status change

	hide is
			-- hides 'current'
		do
			hidden := true
		end

	show is
		-- shows 'current'
		do
			hidden := false
		end

	toggle_hidden_status is
			-- changes 'hidden' to the opposite
		do
			hidden := not hidden
		end

feature -- hidden - access

	hidden: BOOLEAN
		-- is 'current' hidden?

feature -- Access

	item: FEATURE_AS
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

	height: INTEGER is
		-- height of the text inside the folding area
		do
			result :=  end_line - start_line
		end

feature -- Comparison

	infix "<" (other: like Current): BOOLEAN is
			-- Is current object less than `other'?
		do
			result := (current.start_line < other.start_line)
		end

feature {EB_SMART_EDITOR, EB_CLICKABLE_MARGIN} -- Element change

	set_start_line(a_line: like start_line) is
			-- sets 'start_line' to 'a_line'
		do
			start_line := a_line
		ensure
			correctly_set: start_line = a_line
		end

	set_end_line(a_line: like end_line) is
			-- sets 'start_line' to 'a_line'
		do
			end_line := a_line
		ensure
			correctly_set: end_line = a_line
		end

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

	set_item (i: FEATURE_AS) is
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
	height_positive: height >= 0

end -- class EB_FOLDING_AREA
