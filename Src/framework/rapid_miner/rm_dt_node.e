note
	description: "Class representing a node of the rapid miner decision tree."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_DT_NODE
create
	make

feature -- Access
	name : STRING
	is_leaf : BOOLEAN
	edges : LINKED_LIST[RM_DT_EDGE]

feature {NONE} -- Implementation
	make (a_name: STRING; a_is_leaf: BOOLEAN)
		do
			name := a_name
			is_leaf := a_is_leaf
			create edges.make
		end
feature -- Interface
	add_child(a_node: RM_DT_NODE; a_condition : STRING)
		local
			l_edge : RM_DT_EDGE
		do
			create l_edge.make (a_condition, a_node)
			edges.force (l_edge)
		end

	traverse_df
		do
			io.put_string ("Node-" + name)
			if is_leaf then
				io.put_string (" is leaf")
				if samples /= Void then
					io.put_string ("{")
					from samples.start until samples.after loop
						io.put_string (samples.key_for_iteration)
						io.put_string ("=")
						io.put_string (samples.item_for_iteration.out)
						samples.forth
					end
					io.put_string ("}")
				end
			end
			io.put_new_line
			from edges.start until edges.after loop
				io.put_string("Condition-")
				io.put_string (edges.item_for_iteration.condition)
				io.put_new_line
				edges.item_for_iteration.node.traverse_df
				edges.forth
			end
		end

	calculate_result(a_hash:HASH_TABLE[STRING,STRING]):STRING
		-- given a hash table with all the attributes as keys and their respective values, it will return the value calculated by the decision tree algorithm
		local
			l_is_found: BOOLEAN
			l_next_node: RM_DT_NODE
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
			-- parses the samples if any and fills the samples hash table
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

feature -- access
	samples: detachable HASH_TABLE[INTEGER, STRING]

invariant
	invariant_clause: True -- Your invariant here

end
