note
	description: "Class representing the edge in the rapid miner decision tree."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_DT_EDGE
create
	make

feature -- Access
	operator: STRING
	value: STRING
	node : RM_DT_NODE
	condition: STRING
		do
			Result := operator + value
		end

	does_satisfy_condition(a_value:STRING):BOOLEAN
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


feature {NONE} -- creation
	make(a_condition:STRING; a_node:RM_DT_NODE)
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

invariant
	invariant_clause: True -- Your invariant here

end
