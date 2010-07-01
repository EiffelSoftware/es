note
	description: "Summary description for {RM_DECISION_TREE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_DECISION_TREE

create
	make

feature{NONE} -- creation
	make(a_root: RM_DT_NODE)
		do
			root := a_root
		end

feature -- interface

	clasify(a_hash: HASH_TABLE[STRING, STRING])
			-- executes the decision tree with this hash and stores the result in last_classification
		do
			last_classification := root.calculate_result (a_hash)
		end

	set_is_accurate(a_is_accurate: BOOLEAN)
			-- sets the accuracy
		do
			is_accurate := a_is_accurate
		end

feature -- access

	last_classification: STRING

	is_accurate: BOOLEAN

	root: RM_DT_NODE

end
