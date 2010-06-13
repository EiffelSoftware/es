note
	description: "Function with an integer argument and that integer argument has both a lower bound and an upper bound"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_FUNCTION_WITH_INTEGER_DOMAIN

inherit
	HASHABLE

	INTERNAL_COMPILER_STRING_EXPORTER

create
	make

feature{NONE} -- Initialization

	make (a_target_variable_name: like target_variable_name; a_function_name: like function_name; a_lower_bound: INTEGER; a_upper_bound: INTEGER; a_context: like context)
			-- Initialize Current.
		require
			function_valid: is_function_with_single_integer_argument (a_target_variable_name, a_function_name, a_context)
			range_valid: a_lower_bound <= a_upper_bound + 1
		do
			target_variable_name := a_target_variable_name.twin
			function_name := a_function_name.twin
			lower_bound := a_lower_bound
			upper_bound := a_upper_bound
			context := a_context
			hash_code := (target_variable_name + once "." + function_name).hash_code
		end

feature -- Access

	context: EPA_CONTEXT
			-- Context in which current exists

	target_variable_name: STRING
			-- Name of the target varaible of current function

	function_name: STRING
			-- Name of current function

	lower_bound: INTEGER
			-- Lower bound of current domain

	upper_bound: INTEGER
			-- Upper bound of current domain

	target_variable_class: CLASS_C
			-- Class of target variable
		do
			Result := context.variable_class (target_variable_name)
			check Result /= Void end
		end

	function: FEATURE_I
			-- Function named `function_name' in `target_variable_class'
		do
			Result := target_variable_class.feature_named (function_name)
		end


	hash_code: INTEGER
			-- Hash code value

feature -- Status report

	is_function_with_single_integer_argument (a_target_variable_name: STRING; a_function_name: STRING; a_context: EPA_CONTEXT): BOOLEAN
			-- Does function named `a_function_name' in class of the variable named `a_target_variable_name' in `a_context'
			-- has only one integer argument?
		local
			l_class: CLASS_C
			l_feature: FEATURE_I
		do
			l_class := a_context.variable_type (a_target_variable_name).associated_class
			l_feature := l_class.feature_named (a_function_name)
			Result := l_feature.argument_count = 1 and then l_feature.arguments.first.is_integer
		end

invariant
	target_variable_exists: context.has_variable_named (target_variable_name)

end
