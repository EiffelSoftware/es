note
	description: "This class is used internally by the rapid miner decision tree parsin algorithm."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_DT_STACK_ITEM
create
	make

feature -- Access
	node : RM_DT_NODE
	condition: STRING
	depth : INTEGER

feature
	set_condition(a_condition:STRING)
	do
		condition := a_condition
	ensure
		condition = a_condition
	end

feature {NONE} -- Implementation
	make(a_node: RM_DT_NODE; a_condition: STRING; a_depth : INTEGER)
		do
			node := a_node
			condition := a_condition
			depth := a_depth
		end
invariant
	invariant_clause: True -- Your invariant here

end
