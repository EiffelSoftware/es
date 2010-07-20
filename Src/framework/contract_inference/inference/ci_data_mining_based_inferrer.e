note
	description: "Contract inferrer based on data mining techniques"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CI_DATA_MINING_BASED_INFERRER

inherit
	CI_INFERRER
		redefine
			is_arff_needed,
			is_expression_value_map_needed
		end

feature -- Status report

	is_arff_needed: BOOLEAN = True
			-- Is ARFF data needed?

	is_expression_value_map_needed: BOOLEAN = True
			-- Is expression to its value set mapping needed?

end
