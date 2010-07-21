note
	description: "Class representing a node in a path given by decision trees"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_DECISION_TREE_PATH_NODE

--create
--	make

feature -- Access

	attribute_name: STRING
			-- Name of the attribute

	operator_name: STRING
			-- Name of the operator

	value_name: STRING
			-- Value of the attribute

end
