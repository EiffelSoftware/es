note
	description: "Class to infer linear regression related contracts"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_LINEAR_REGRESSION_INFERRER

inherit
	CI_DATA_MINING_BASED_INFERRER
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
			arff_relation := data.arff_relation.cloned_object

			logger.put_line_with_time_at_fine_level ("Start inferring linear regression related contracts.")

				-- Setup results.
			create last_preconditions.make (10)
			last_preconditions.set_equality_tester (expression_equality_tester)
			create last_postconditions.make (10)
			last_postconditions.set_equality_tester (expression_equality_tester)
			setup_last_contracts


		end

end
