note
	description: "Edge in control flow graph (CFG), which is directed, from start_node to end_node"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_CFG_EDGE

inherit
	HASHABLE
		undefine
			out
		end

	DEBUG_OUTPUT
		redefine
			out
		end

feature{NONE} -- Initialization

	make (a_start_node: like start_node; a_end_node: like end_node)
			-- Initialize Current.
		do
			start_node := a_start_node
			end_node := a_end_node
		end

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

	out: STRING
			-- String representation of Current
		do
			Result := debug_output
		end

feature -- Status report

	is_true_branch: BOOLEAN
			-- Is Current an true-branch edge?
		do
		end

	is_false_branch: BOOLEAN
			-- Is Current an false-branch edge?
		do
		end

	is_seqential_branch: BOOLEAN
			-- Is Current a sequential edge?
		do
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
