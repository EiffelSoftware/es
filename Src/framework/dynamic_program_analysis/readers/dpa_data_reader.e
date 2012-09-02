note
	description: "A reader that reads the data from a dynamic program analysis from disk."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DPA_DATA_READER

inherit
	EPA_EXPRESSION_VALUE_TYPE_CONSTANTS

feature -- Access

	class_: STRING
			-- Context class of `feature_'.
		deferred
		ensure
			Result_not_void: Result /= Void and Result.count >= 1
		end

	feature_: STRING
			-- Feature that was analyzed.
		deferred
		ensure
			Result_not_void: Result /= Void and Result.count >= 1
		end

	analysis_order_pairs: LINKED_LIST [TUPLE [pre_state_bp: INTEGER; post_state_bp: INTEGER]]
			-- List of pre-state / post-state breakpoint pairs in the order they were analyzed.
			-- Note: The analysis order is not the same as the execution order which is complete
			-- whilst the analysis order only contains the hit pre-state / post-state breakpoints.
		deferred
		ensure
			Result_not_void: Result /= Void
		end

	analysis_order_pairs_count: INTEGER
			-- Number of pre-state / post-state breakpoint pairs.
		deferred
		ensure
			Result_positive: Result >= 0
		end

	limited_analysis_order_pairs (a_lower_bound: INTEGER; a_upper_bound: INTEGER): LINKED_LIST [TUPLE [pre_state_bp: INTEGER; post_state_bp: INTEGER]]
			-- Limited list of pre-state / post-state breakpoint pairs in the order they were analyzed.
			-- Valid values of `a_lower_bound' and `a_upper_bound' are in the interval between 1 and `analysis_order_pairs_count'
			-- Note: The analysis order is not the same as the execution order which is complete
			-- whilst the analysis order only contains the hit pre-state / post-state breakpoints.
		require
			a_lower_bound_valid: a_lower_bound >= 1 and a_lower_bound <= analysis_order_pairs_count
			a_upper_bound_valid: a_upper_bound >= 1 and a_upper_bound <= analysis_order_pairs_count
			relationship_of_bounds_valid: a_lower_bound <= a_upper_bound
		deferred
		ensure
			Result_not_void: Result /= Void
		end

	expressions_and_locations: LINKED_LIST [TUPLE [expression: STRING; location: INTEGER]]
			-- Expressions and locations at which they were evaluted during the analysis.
		deferred
		ensure
			Result_not_void: Result /= Void
		end

	expression_value_transitions_count (a_expression: STRING; a_location: INTEGER): INTEGER
			-- Number of value transitions of `a_expression' evaluated at `a_location'.
		require
			a_expression_not_void: a_expression /= Void and a_expression.count >= 1
			a_location_valid: a_location >= 1
		deferred
		ensure
			Result_positive: Result >= 0
		end

	expression_value_transitions (a_expression: STRING; a_location: INTEGER): LINKED_LIST [EPA_VALUE_TRANSITION]
			-- Value transitions of `a_expression' evaluated at `a_location'.
		require
			a_expression_not_void: a_expression /= Void and a_expression.count >= 1
			a_location_valid: a_location >= 1
		deferred
		ensure
			Result_not_void: Result /= Void
		end

	limited_expression_value_transitions (a_expression: STRING; a_location: INTEGER; a_lower_bound: INTEGER; a_upper_bound: INTEGER): LINKED_LIST [EPA_VALUE_TRANSITION]
			-- Limited value transitions of `a_expression' evaluated at `a_location'.
			-- Valid values of `a_lower_bound' and `a_upper_bound' are in the interval between 1 and `expression_value_transitions_count'
		require
			a_expression_not_void: a_expression /= Void and a_expression.count >= 1
			a_location_valid: a_location >= 1
			a_lower_bound_valid: a_lower_bound >= 1 and a_lower_bound <= expression_value_transitions_count (a_expression, a_location)
			a_upper_bound_valid: a_upper_bound >= 1 and a_upper_bound <= expression_value_transitions_count (a_expression, a_location)
			relationship_of_bounds_valid: a_lower_bound <= a_upper_bound
		deferred
		ensure
			Result_not_void: Result /= Void
		end

feature {NONE} -- Implementation

	value_from_data (a_value: STRING; a_type: STRING): EPA_EXPRESSION_VALUE
			-- Value based on `a_type' with value `a_value'
		require
			a_value_not_void: a_value /= Void
			a_type_not_void: a_type /= Void
		do
			if a_type.is_equal (boolean_value) then
				create {EPA_BOOLEAN_VALUE} Result.make (a_value.to_boolean)
			elseif a_type.is_equal (integer_value) then
				create {EPA_INTEGER_VALUE} Result.make (a_value.to_integer)
			elseif a_type.is_equal (real_value) then
				create {EPA_REAL_VALUE} Result.make (a_value.to_real)
			elseif a_type.is_equal (pointer_value) then
				create {EPA_POINTER_VALUE} Result.make (a_value)
			elseif a_type.is_equal (nonsensical_value) then
				create {EPA_NONSENSICAL_VALUE} Result
			elseif a_type.is_equal (void_value) then
				create {EPA_VOID_VALUE} Result.make
			elseif a_type.is_equal (any_value) then
				create {EPA_ANY_VALUE} Result.make (a_value)
			else
				check not_suported: False end
			end
		end

	ref_value_from_data (a_value: STRING; a_class_id: STRING): EPA_REFERENCE_VALUE
			-- Reference value from `a_value' and `a_class_id'
		require
			a_value_not_void: a_value /= Void
			a_class_id_not_void: a_class_id /= Void
		do
			create Result.make (a_value, create {CL_TYPE_A}.make (a_class_id.to_integer))
		end

	string_value_from_data (a_value: STRING; a_address: STRING): EPA_STRING_VALUE
			-- String value from `a_value' and `a_address'
		require
			a_value_not_void: a_value /= Void
			a_address_not_void: a_address /= Void
		do
			create Result.make (a_address, a_value)
		end

end
