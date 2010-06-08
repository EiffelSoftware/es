note
	description: "Summary description for {LIST_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	sl_predicate: "[
		Node(x, {item:i; next:n}) = x.<LIST_NODE.my_item> |-> i * x.<LIST_NODE.my_next> |-> n
	]"
	js_logic: "list_node.logic"
	js_abstraction: "list_node.abs"

class
	LIST_NODE [G]

create
	init

feature {NONE} -- Creation

	init (i: G; n: LIST_NODE [G])
		require
			--SL-- True
		do
			my_item := i
			my_next := n
		ensure
			--SL-- Node$(Current, {item:i; next:n})
		end

feature -- Access

	item: G
		require
			--SL-- Node$(Current, {item:_i; next:_n})
		do
			Result := my_item
		ensure
			--SL-- Node$(Current, {item:_i; next:_n}) * Result = _i
		end

	next: LIST_NODE [G]
		require
			--SL-- Node$(Current, {item:_i; next:_n})
		do
			Result := my_next
		ensure
			--SL-- Node$(Current, {item:_i; next:_n}) * Result = _n
		end

feature -- Status setting

	set_item (i: G)
		require
			--SL-- Node$(Current, {item:_i; next:_n})
		do
			my_item := i
		ensure
			--SL-- Node$(Current, {item:i; next:_n})
		end

	set_next (n: LIST_NODE [G])
		require
			--SL-- Node$(Current, {item:_i; next:_n})
		do
			my_next := n
		ensure
			--SL-- Node$(Current, {item:_i; next:n})
		end

feature {NONE} -- Implementation

	my_item: G

	my_next: LIST_NODE [G]

end
