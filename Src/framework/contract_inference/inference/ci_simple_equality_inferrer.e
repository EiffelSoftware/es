note
	description: "Class to infer simple equality properties in form of p = q."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_SIMPLE_EQUALITY_INFERRER

inherit
	CI_INFERRER
		redefine
			is_expression_value_map_needed
		end

feature -- Status report

	is_expression_value_map_needed: BOOLEAN = True
			-- Is expression to its value set mapping needed?

feature -- Basic operations

	infer (a_data: like data)
			-- Infer contracts from `a_data', which is transition data collected from
			-- executed test cases.
		do
				-- Initialize.
			data := a_data
			setup_data_structures

			logger.put_line_with_time_at_fine_level ("Start inferring simple equality properties.")

				-- Setup results.
			create last_preconditions.make (10)
			last_preconditions.set_equality_tester (expression_equality_tester)
			create last_postconditions.make (10)
			last_postconditions.set_equality_tester (expression_equality_tester)

			setup_last_contracts
		end

end
