note
	description: "A simple singly-linked list."
	author: "Stephan van Staden"
	date: "$Date$"
	revision: "$Revision$"
	sl_predicate: "[
		LList(x, {list:l; lastremoved:r}) = x.<L_LIST.my_head> |-> _z * sll(_z, {last:Void; list:l}) * x.<L_LIST.my_size> |-> length(l) * x.<L_LIST.my_removed_item> |-> r
	]"
	js_logic: "l_list.logic"
	js_abstraction: "l_list.abs"

class
	L_LIST [G]

create
	init

feature {NONE} -- Creation

	init
		require
			--SL-- True
		do
			my_head := Void
			my_size := 0
		ensure
			--SL-- LList$(Current, {list:empty(); lastremoved:_r})
		end

feature

	add (e: G)
		require
			--SL-- LList$(Current, {list:_s; lastremoved:_r})
		local
			l_new_node: LIST_NODE [G]
		do
			create l_new_node.init (e, my_head)
			my_head := l_new_node
			my_size := my_size + 1
		ensure
			--SL-- LList$(Current, {list:cons(e, _s); lastremoved:_r})
		end

	remove_first
		require
			--SL-- LList$(Current, {list:cons(_x, _xs); lastremoved:_r})
		local
			l_removed_node: LIST_NODE [G]
		do
			l_removed_node := my_head
			my_head := my_head.next
			my_removed_item := l_removed_node.item
			my_size := my_size - 1
		ensure
			--SL-- LList$(Current, {list:_xs; lastremoved:_x})
		end

	removed_item: G
		require
			--SL-- LList$(Current, {list:_l; lastremoved:_r})
		do
			Result := my_removed_item
		ensure
			--SL-- Result = _r * LList$(Current, {list:_l; lastremoved:_r})
		end

	size: INTEGER
		require
			--SL-- LList$(Current, {list:_l; lastremoved:_r})
		do
			Result := my_size
		ensure
			--SL-- Result = length(_l) * LList$(Current, {list:_l; lastremoved:_r})
		end

feature {NONE} -- Implementation

	my_head: LIST_NODE [G]

	my_size: INTEGER

	my_removed_item: G

end
