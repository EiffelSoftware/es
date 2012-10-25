note
	description: "A reader that reads the analysis results of a dynamic program %
		%analysis from disk."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DPA_READER

inherit
	EPA_EXPRESSION_VALUE_TYPE_CONSTANTS
		export
			{NONE} all
		end

feature -- Access

	class_: STRING
			-- Context class of `feature_'.
		deferred
		ensure
			Result_not_void: Result /= Void and Result.count >= 1
		end

	feature_: STRING
			-- Feature which was analyzed.
		deferred
		ensure
			Result_not_void: Result /= Void and Result.count >= 1
		end

	expression_evaluation_plan: DS_HASH_TABLE [DS_HASH_SET [INTEGER], STRING]
			-- Expression evaluation plan specifying the program locations at which an expression
			-- is evaluated before and after the execution of a program location.
			-- Keys are expressions.
			-- Values are program locations.
		deferred
		ensure
			Result_not_void: Result /= Void
		end

	number_of_transitions (a_expression: STRING; a_program_location: INTEGER): INTEGER
			-- Number of transitions for `a_expression' evaluated before and after
			-- the execution of `a_program_location'.
		require
			a_expression_not_void_and_empty: a_expression /= Void and then a_expression.count >= 1
			a_program_location_valid: a_program_location >= 1
		deferred
		ensure
			Result_positive: Result >= 0
		end

	transitions (a_expression: STRING; a_program_location: INTEGER):
		ARRAYED_LIST [EPA_VALUE_TRANSITION]
			-- Transitions for `a_expression' evaluated before and after the exeuction of
			-- `a_program_location'.
		require
			a_expression_not_void_and_empty: a_expression /= Void and then a_expression.count >= 1
			a_program_location_valid: a_program_location >= 1
		deferred
		ensure
			Result_not_void: Result /= Void
		end

	subset_of_transitions (
		a_expression: STRING;
		a_program_location: INTEGER;
		a_lower_bound: INTEGER;
		a_upper_bound: INTEGER
	): ARRAYED_LIST [EPA_VALUE_TRANSITION]
			-- Subset of transitions for `a_expression' evaluated before and after
			-- the execution of `a_program_location'.
			-- Valid values of `a_lower_bound' and `a_upper_bound' are in the interval between 1
			-- and `number_of_transitions'.
		require
			a_expression_not_void_and_empty: a_expression /= Void and then a_expression.count >= 1
			a_program_location_valid: a_program_location >= 1
			a_lower_bound_valid: a_lower_bound >= 1 and then
				a_lower_bound <= number_of_transitions (a_expression, a_program_location)
			a_upper_bound_valid: a_upper_bound >= 1 and then
				a_upper_bound <= number_of_transitions (a_expression, a_program_location)
			relationship_of_bounds_valid: a_lower_bound <= a_upper_bound
		deferred
		ensure
			Result_not_void: Result /= Void
			Result_size_correct: Result.count = a_upper_bound - a_lower_bound + 1
		end

feature {NONE} -- Implementation

	new_expression_value (a_value: STRING; a_type: STRING): EPA_EXPRESSION_VALUE
			-- Expression value based on `a_type' with value `a_value'.
		require
			a_value_not_void: a_value /= Void
			a_type_not_void: a_type /= Void
		do
			if
				a_type.is_equal (boolean_value)
			then
				create {EPA_BOOLEAN_VALUE} Result.make (a_value.to_boolean)
			elseif
				a_type.is_equal (integer_value)
			then
				create {EPA_INTEGER_VALUE} Result.make (a_value.to_integer)
			elseif
				a_type.is_equal (real_value)
			then
				create {EPA_REAL_VALUE} Result.make (a_value.to_real)
			elseif
				a_type.is_equal (pointer_value)
			then
				create {EPA_POINTER_VALUE} Result.make (a_value)
			elseif
				a_type.is_equal (nonsensical_value)
			then
				create {EPA_NONSENSICAL_VALUE} Result
			elseif
				a_type.is_equal (void_value)
			then
				create {EPA_VOID_VALUE} Result.make
			elseif
				a_type.is_equal (any_value)
			then
				create {EPA_ANY_VALUE} Result.make (a_value)
			else
				check
					not_suported: False
				end
			end
		end

	new_reference_value (a_value: STRING; a_class_id: STRING): EPA_REFERENCE_VALUE
			-- Reference value from `a_value' and `a_class_id'.
		require
			a_value_not_void: a_value /= Void
			a_class_id_not_void: a_class_id /= Void
		do
			create Result.make (a_value, create {CL_TYPE_A}.make (a_class_id.to_integer))
		ensure
			Result_not_void: Result /= Void
		end

	new_string_value (a_value: STRING; a_address: STRING): EPA_STRING_VALUE
			-- String value from `a_value' and `a_address'.
		require
			a_value_not_void: a_value /= Void
			a_address_not_void: a_address /= Void
		do
			create Result.make (a_address, a_value)
		ensure
			Result_not_void: Result /= Void
		end

end
