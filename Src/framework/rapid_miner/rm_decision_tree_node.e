note
	description: "Class representing a node of a RM_DECISION_TREE."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_DECISION_TREE_NODE
create
	make

feature -- Access
	name : STRING
			-- the name of the node.

	is_leaf : BOOLEAN
			-- is the node leaf or not.

	edges : LINKED_LIST[RM_DECISION_TREE_EDGE]
			-- all the edges leading out of that node.

	samples: detachable HASH_TABLE[INTEGER, STRING]
			-- holds the samples for that node. Samples are for example {True:5, False:0, STAY_FALSE:0}

feature {NONE} -- Creation

	make (a_name: STRING; a_is_leaf: BOOLEAN)
		do
			name := a_name
			is_leaf := a_is_leaf
			create edges.make
		end

feature -- Interface
	add_child(a_node: RM_DECISION_TREE_NODE; a_condition : STRING)
			-- Adds another node to the current's children.
		local
			l_edge : RM_DECISION_TREE_EDGE
		do
			create l_edge.make (a_condition, a_node)
			edges.force (l_edge)
		end


	calculate_result(a_hash:HASH_TABLE[STRING,STRING]):STRING
		-- given a hash table with all the attributes as keys and their respective values, it will return the value calculated by the decision tree algorithm
		local
			l_is_found: BOOLEAN
			l_next_node: RM_DECISION_TREE_NODE
		do
			if is_leaf then
				Result := name
			else
				from edges.start until l_is_found loop
					if edges.item_for_iteration.does_satisfy_condition (a_hash[name]) then
						l_next_node := edges.item_for_iteration.node
						l_is_found := True
					end
					edges.forth
				end
				Result := l_next_node.calculate_result(a_hash)
			end
		end

	parse_samples(a_line:STRING)
			-- parses the samples if any and fills the `samples' hash table
		require
			ends_with_curly_bracket: a_line.ends_with ("}")
		local
			l_index: INTEGER
			l_all: STRING
			l_list: LIST[STRING]
			l_equation: LIST[STRING]
		do
			create samples.make (5)
			l_index := a_line.last_index_of ('{', a_line.count)
			l_all := a_line.substring (l_index+1, a_line.count-1)
			l_list := l_all.split (',')

			from l_list.start until l_list.after loop
				l_equation := l_list.item_for_iteration.split ('=')
				l_equation[1].right_adjust
				l_equation[2].right_adjust
				l_equation[1].left_adjust
				l_equation[2].left_adjust
				samples.force (l_equation[2].to_integer, l_equation[1])
				l_list.forth
			end

		end


invariant
	invariant_clause: True -- Your invariant here

end
