note
	description: "Class representing a node in a path given by decision trees."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_DECISION_TREE_PATH_NODE

create
	make

feature -- Creation

	make(a_attribute_name: STRING; a_operator_name: STRING; a_value_name: STRING)
		do
			attribute_name := a_attribute_name
			operator_name := a_operator_name
			value_name := a_value_name
		ensure
			attribute_name_set: attribute_name = a_attribute_name
			operator_name_set: operator_name = a_operator_name
			value_name_set: value_name = a_value_name
		end

feature -- Access

	attribute_name: STRING
			-- Name of the attribute

	operator_name: STRING
			-- Name of the operator

	value_name: STRING
			-- Value of the attribute

feature -- Setters

	set_operator_name (a_operator_name: STRING)
			-- Set `operator_name' with `a_operator_name'.
		do
			operator_name := a_operator_name
		ensure
			is_accurate_set: operator_name = a_operator_name
		end

	set_value_name (a_value_name: STRING)
			-- Set `value_name' with `a_value_name'.
		do
			value_name := a_value_name
		ensure
			is_value_name: value_name = a_value_name
		end

end
