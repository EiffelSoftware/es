note
	description: "Class representing a node in a path given by decision trees."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_DECISION_TREE_PATH_NODE

inherit
	DEBUG_OUTPUT

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

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := attribute_name + " " + operator_name + " " + value_name
		end

feature -- Setters

	set_operator_name (a_operator_name: STRING)
			-- Set `operator_name' with `a_operator_name'.
		do
			operator_name := a_operator_name.twin
		ensure
			is_accurate_set: operator_name ~ a_operator_name
		end

	set_value_name (a_value_name: STRING)
			-- Set `value_name' with `a_value_name'.
		do
			value_name := a_value_name.twin
		ensure
			is_value_name: value_name ~ a_value_name
		end

	set_attribute_name (a_name: STRING)
			-- Set `attribute_name' with `a_name'.
		do
			attribute_name := a_name.twin
		ensure
			attribute_name_set: attribute_name ~ a_name
		end

end
