note
	description: "Edge in control flow graph (CFG), which is directed, from start_node to end_node"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_CFG_EDGE

inherit
	HASHABLE

feature -- Access

	start_node: EPA_BASIC_BLOCK
			-- Starting node of current edge

	end_node: EPA_BASIC_BLOCK
			-- End node of current edge

	hash_code: INTEGER
			-- Hash code value
		do
			if hash_code_internal = 0 then
				hash_code_internal := (start_node.hash_code.out + "," + end_node.hash_code.out).hash_code
			end
			Result := hash_code_internal
		end

feature -- Setting

	set_start_node (a_node: like start_node)
			-- Set `start_node' with `a_node'.
		do
			start_node := a_node
		ensure
			start_node_set: start_node = a_node
		end

	set_end_node (a_node: like end_node)
			-- Set `end_node' with `a_node'.
		do
			end_node := a_node
		ensure
			end_node_set: end_node = a_node
		end

feature{NONE} -- Implementation

	hash_code_internal: INTEGER
			-- Cache for `hash_code'

end
