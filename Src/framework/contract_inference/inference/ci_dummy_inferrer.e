note
	description: "Summary description for {CI_DUMMY_INFERRER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_DUMMY_INFERRER

inherit
	CI_INFERRER
		redefine
			is_arff_needed
		end

feature -- Status report

	is_arff_needed: BOOLEAN = True
			-- Is ARFF data needed?

feature -- Basic operations

	infer (a_data: like data)
			-- Infer contracts from `a_data', which is transition data collected from
			-- executed test cases.
		do
				-- Initialize.
			data := a_data
			setup_data_structures

				-- Setup results.
			create last_preconditions.make (10)
			last_preconditions.set_equality_tester (expression_equality_tester)
			create last_postconditions.make (10)
			last_postconditions.set_equality_tester (expression_equality_tester)

			setup_last_contracts
		end

end
