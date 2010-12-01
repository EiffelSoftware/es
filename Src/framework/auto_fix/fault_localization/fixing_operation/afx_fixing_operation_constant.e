note
	description: "Summary description for {AFX_FIXING_OPERATION_CONSTANT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_FIXING_OPERATION_CONSTANT

inherit
	ANY
		undefine
			is_equal,
			copy
		end

feature -- Status report

	is_valid_type (a_type: INTEGER): BOOLEAN
			-- Is `a_type' a valid fixing operation type?
		do
			Result := Fixing_operation_lower_bound < a_type and then a_type < Fixing_operation_upper_bound
		end

	is_valid_type_for_integer (a_type: INTEGER): BOOLEAN
			-- Is `a_type' a valid fixing operation type for a target of INTEGER?
		do
			Result := Fixing_operation_integer_increase_by_one <= a_type and then a_type <= Fixing_operation_integer_set_to_minus_one
		end

	is_valid_type_for_boolean (a_type: INTEGER): BOOLEAN
			-- Is `a_type' a valid fixing operation type for a target of BOOLEAN?
		do
			Result := a_type = Fixing_operation_boolean_negate
		end

	is_valid_type_for_reference (a_type: INTEGER): BOOLEAN
			-- Is `a_type' a valid fixing operation type for a reference target?
		do
			Result := a_type = Fixing_operation_reference_call_command
		end

	is_valid_type_for_integers (a_type: INTEGER): BOOLEAN
			-- Is `a_type' a valid fixing operation type for two fixing targets of INTEGERs?
		do
			Result := Fixing_operation_integers_set_equal_forward <= a_type and then a_type <= Fixing_operation_integers_set_less_by_one_backward
		end

feature -- Constant

	Fixing_operation_lower_bound: INTEGER = 0

	-- Operation types for one fixing target.
	Fixing_operation_integer_increase_by_one: INTEGER = 1
	Fixing_operation_integer_decrease_by_one: INTEGER = 2
	Fixing_operation_integer_set_to_zero: INTEGER = 3
	Fixing_operation_integer_set_to_one: INTEGER = 4
	Fixing_operation_integer_set_to_minus_one: INTEGER = 5
	Fixing_operation_boolean_negate: INTEGER = 6
	Fixing_operation_reference_call_command: INTEGER = 7

	-- Operation types for two fixing targets.
	Fixing_operation_integers_set_equal_forward: INTEGER = 8
	Fixing_operation_integers_set_equal_backward: INTEGER = 9
	Fixing_operation_integers_set_bigger_by_one_forward: INTEGER = 10
	Fixing_operation_integers_set_bigger_by_one_backward: INTEGER = 11
	Fixing_operation_integers_set_less_by_one_forward: INTEGER = 12
	Fixing_operation_integers_set_less_by_one_backward: INTEGER = 13

	Fixing_operation_upper_bound: INTEGER = 14

end
