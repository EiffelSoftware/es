note
	description: "Class representing the edge in a RM_DECISION_TREE."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_DECISION_TREE_EDGE

create
	make

feature {NONE} -- creation

	make (a_condition: STRING; a_node: RM_DECISION_TREE_NODE)
		do
			if a_condition.at (1).code = 226 then
				operator := "<="
				value := a_condition.substring (5, a_condition.count)
			else
				operator := a_condition.substring (1, 1)
				value := a_condition.substring (3, a_condition.count)
			end
			node := a_node
		end

feature -- Access

	operator: STRING
			-- operator for that edge

	value: STRING
			-- value which stays on the right side of the `operator'

	node : RM_DECISION_TREE_NODE
			-- the node to which this edge leads.

	condition: STRING
			-- appends the operator and value
		do
			Result := operator + value
		end

feature -- Status report

	is_condition_satisfied (a_value:STRING): BOOLEAN
			-- Calculates if `a_value' satisfies the condition(operator and value) of that edge.
		do
			if operator.is_equal ("=") then
				Result := a_value.is_equal (value)
			elseif operator.is_equal ("<") then
				Result := (a_value < value)
			elseif operator.is_equal ("<=") then
				Result := (a_value <= value)
			elseif operator.is_equal (">") then
				Result := (a_value > value)
			elseif operator.is_equal (">=") then
				Result := (a_value >= value)
			else
				Result := False
			end
		end

end
