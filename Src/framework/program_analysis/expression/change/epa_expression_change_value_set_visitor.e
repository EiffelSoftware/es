note
	description: "Summary description for {EPA_EXPRESSION_CHANGE_VALUE_SET_VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_EXPRESSION_CHANGE_VALUE_SET_VISITOR

feature -- Process

	process_expression_change_value_set (a_values: EPA_EXPRESSION_CHANGE_VALUE_SET)
			-- Process `a_values'
		deferred
		end

	process_integer_range (a_values: EPA_INTEGER_RANGE)
			-- Process `a_values'.
		deferred
		end

end
