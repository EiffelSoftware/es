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
			-- `a_condition' is the condition that leads to `a_node'
		do
			if a_condition.at (1).code = 226 then
				operator := "<="
				value := a_condition.substring (5, a_condition.count)
			else
				operator := a_condition.substring (1, a_condition.index_of (' ', 2) - 1)
				value := a_condition.substring (a_condition.index_of (' ', 2) + 1, a_condition.count)
			end
			node := a_node
		end

feature -- Access

	operator: STRING
			-- Operator for that edge

	value: STRING
			-- Value which stays on the right side of the `operator'

	node : RM_DECISION_TREE_NODE
			-- The node to which this edge leads.

	condition: STRING
			-- Appends the operator and value
		do
			Result := operator + value
		end

feature -- Status report

	is_condition_satisfied (a_value: STRING): BOOLEAN
			-- Calculates if `a_value' satisfies the condition(operator and value) of that edge.
		do
			if operator ~ once "=" then
				Result := a_value.is_equal (value)

			elseif operator ~ once "<" then
				Result := a_value.to_double < value.to_double

			elseif operator ~ once "<=" then
				Result := a_value.to_double <= value.to_double

			elseif operator ~ once ">" then
				Result := a_value.to_double > value.to_double

			elseif operator ~ once ">=" then
				Result := a_value.to_double >= value.to_double

			else
				Result := False
			end
		end

end
