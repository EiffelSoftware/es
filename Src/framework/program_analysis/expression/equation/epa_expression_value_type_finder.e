note
	description: "Summary description for {EPA_EQUATION_TYPE_FINDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXPRESSION_VALUE_TYPE_FINDER

inherit
	EPA_EXPRESSION_VALUE_VISITOR

feature -- Find

	find
			--
		do
			value.process (Current)
		end

feature -- Access

	type: STRING
			--

	value: EPA_EXPRESSION_VALUE
			--

feature -- Setting

	set_value (a_value: like value)
			--
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
			type := "EPA_BOOLEAN_VALUE"
		end

	process_random_boolean_value (a_value: EPA_RANDOM_BOOLEAN_VALUE)
			-- Process `a_value'.
		do
			type := "EPA_RANDOM_BOOLEAN_VALUE"
		end

	process_integer_value (a_value: EPA_INTEGER_VALUE)
			-- Process `a_value'.
		do
			type := "EPA_INTEGER_VALUE"
		end

	process_real_value (a_value: EPA_REAL_VALUE)
			-- Process `a_value'.
		do
			type := "EPA_REAL_VALUE"
		end

	process_pointer_value (a_value: EPA_POINTER_VALUE)
			-- Process `a_value'.
		do
			type := "EPA_POINTER_VALUE"
		end

	process_random_integer_value (a_value: EPA_RANDOM_INTEGER_VALUE)
			-- Process `a_value'.
		do
			type := "EPA_RANDOM_INTEGER_VALUE"
		end

	process_nonsensical_value (a_value: EPA_NONSENSICAL_VALUE)
			-- Process `a_value'.
		do
			type := "EPA_NONSENSICAL_VALUE"
		end

	process_void_value (a_value: EPA_VOID_VALUE)
			-- Process `a_value'.
		do
			type := "EPA_VOID_VALUE"
		end

	process_any_value (a_value: EPA_ANY_VALUE)
			-- Process `a_value'.
		do
			type := "EPA_ANY_VALUE"
		end

	process_reference_value (a_value: EPA_REFERENCE_VALUE)
			-- Process `a_value'.
		do
			type := "EPA_REFERENCE_VALUE"
		end

	process_ast_expression_value (a_value: EPA_AST_EXPRESSION_VALUE)
			-- Process `a_value'.
		do
			type := "EPA_AST_EXPRESSION_VALUE"
		end

	process_string_value (a_value: EPA_STRING_VALUE)
			-- Process `a_value'.
		do
			type := "EPA_STRING_VALUE"
		end

	process_set_value (a_value: EPA_EXPRESSION_SET_VALUE)
			-- Process `a_value'.
		do
			type := "EPA_EXPRESSION_SET_VALUE"
		end

	process_numeric_range_value (a_value: EPA_NUMERIC_RANGE_VALUE)
			-- Process `a_value'.
		do
			type := "EPA_NUMERIC_RANGE_VALUE"
		end

end
