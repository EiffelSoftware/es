note
	description: "Visitor for {IR_TERM_VALUE}s"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	IR_TERM_VALUE_VISITOR

feature -- Process

	process_boolean_term_value (a_value: IR_BOOLEAN_VALUE)
			-- Process `a_value'.
		deferred
		end

	process_integer_term_value (a_value: IR_INTEGER_VALUE)
			-- Process `a_value'.
		deferred
		end

	process_string_term_value (a_value: IR_STRING_VALUE)
			-- Process `a_value'.
		deferred
		end

	process_integer_range_term_value (a_value: IR_INTEGER_RANGE_VALUE)
			-- Process `a_value'.
		deferred
		end

	process_double_term_value (a_value: IR_DOUBLE_VALUE)
			-- Process `a_value'.
		deferred
		end

end
