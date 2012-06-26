note
	description: "Summary description for {EPA_EQUATION_TYPE_FINDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXPRESSION_VALUE_TYPE_FINDER

inherit
	EPA_EXPRESSION_VALUE_VISITOR

	EPA_EXPRESSION_VALUE_TYPE_CONSTANTS

feature -- Find

	find
			-- Find type of `value' and make result available in `type'
		do
			value.process (Current)
		end

feature -- Access

	type: STRING
			-- Last found type

	value: EPA_EXPRESSION_VALUE
			-- Value for which the type should be found

feature -- Setting

	set_value (a_value: like value)
			-- Set `value' to `a_value'
		require
			a_value_not_void: a_value /= Void
		do
			value := a_value
		ensure
			value_set: value = a_value
		end

feature -- Process

	process_boolean_value (a_value: EPA_BOOLEAN_VALUE)
			-- Process `a_value'.
		do
			type := boolean_value
		end

	process_random_boolean_value (a_value: EPA_RANDOM_BOOLEAN_VALUE)
			-- Process `a_value'.
		do
			type := random_boolean_value
		end

	process_integer_value (a_value: EPA_INTEGER_VALUE)
			-- Process `a_value'.
		do
			type := integer_value
		end

	process_real_value (a_value: EPA_REAL_VALUE)
			-- Process `a_value'.
		do
			type := real_value
		end

	process_pointer_value (a_value: EPA_POINTER_VALUE)
			-- Process `a_value'.
		do
			type := pointer_value
		end

	process_random_integer_value (a_value: EPA_RANDOM_INTEGER_VALUE)
			-- Process `a_value'.
		do
			type := random_integer_value
		end

	process_nonsensical_value (a_value: EPA_NONSENSICAL_VALUE)
			-- Process `a_value'.
		do
			type := nonsensical_value
		end

	process_void_value (a_value: EPA_VOID_VALUE)
			-- Process `a_value'.
		do
			type := void_value
		end

	process_any_value (a_value: EPA_ANY_VALUE)
			-- Process `a_value'.
		do
			type := any_value
		end

	process_reference_value (a_value: EPA_REFERENCE_VALUE)
			-- Process `a_value'.
		do
			type := reference_value
		end

	process_ast_expression_value (a_value: EPA_AST_EXPRESSION_VALUE)
			-- Process `a_value'.
		do
			type := ast_expression_value
		end

	process_string_value (a_value: EPA_STRING_VALUE)
			-- Process `a_value'.
		do
			type := string_value
		end

	process_set_value (a_value: EPA_EXPRESSION_SET_VALUE)
			-- Process `a_value'.
		do
			type := expression_set_value
		end

	process_numeric_range_value (a_value: EPA_NUMERIC_RANGE_VALUE)
			-- Process `a_value'.
		do
			type := numeric_range_value
		end

end
