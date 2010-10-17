note
	description: "Summary description for {AFX_EXPRESSION_VALUE_VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_EXPRESSION_VALUE_VISITOR

feature -- Process

	process_boolean_value (a_value: EPA_BOOLEAN_VALUE)
			-- Process `a_value'.
		deferred
		end

	process_random_boolean_value (a_value: EPA_RANDOM_BOOLEAN_VALUE)
			-- Process `a_value'.
		deferred
		end

	process_integer_value (a_value: EPA_INTEGER_VALUE)
			-- Process `a_value'.
		deferred
		end

	process_real_value (a_value: EPA_REAL_VALUE)
			-- Process `a_value'.
		deferred
		end

	process_pointer_value (a_value: EPA_POINTER_VALUE)
			-- Process `a_value'.
		deferred
		end

	process_random_integer_value (a_value: EPA_RANDOM_INTEGER_VALUE)
			-- Process `a_value'.
		deferred
		end

	process_nonsensical_value (a_value: EPA_NONSENSICAL_VALUE)
			-- Process `a_value'.
		deferred
		end

	process_void_value (a_value: EPA_VOID_VALUE)
			-- Process `a_value'.
		deferred
		end

	process_any_value (a_value: EPA_ANY_VALUE)
			-- Process `a_value'.
		deferred
		end

	process_reference_value (a_value: EPA_REFERENCE_VALUE)
			-- Process `a_value'.
		deferred
		end

	process_ast_expression_value (a_value: EPA_AST_EXPRESSION_VALUE)
			-- Process `a_value'.
		deferred
		end

	process_string_value (a_value: EPA_STRING_VALUE)
			-- Process `a_value'.
		deferred
		end

	process_set_value (a_value: EPA_EXPRESSION_SET_VALUE)
			-- Process `a_value'.
		deferred
		end

	process_numeric_range_value (a_value: EPA_NUMERIC_RANGE_VALUE)
			-- Process `a_value'.
		deferred
		end
		
end
