note
	description: "Class that represents position of a variable in a transition"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_TRANSITION_VARIABLE_POSITION

inherit
	HASHABLE

create
	make_as_target,
	make_as_result,
	make_as_argument,
	make_as_unspecified_argument,
	make_as_unspecified_interface_variable,
	make_as_unspecified_operand

feature{NONE} -- Initialization

	make_as_target
			-- Initialize Current as a target variable position.
		do
			position := target_variable_position
			is_target := True
			is_operand := True
			is_interface := True
		end

	make_as_result
			-- Initialize Current as a result variable position.
		do
			position := result_variable_position
			is_result := True
			is_interface := True
		end

	make_as_argument (i: INTEGER)
			-- Initialize Current as the `i'-th argument position.
			-- -2 means an arbitrary argument position.
		require
			i_valid: i > 0
		do
			position := i
			is_argument := True
			is_operand := True
			is_interface := True
		end

	make_as_unspecified_argument
			-- Initialize Current as unspecified argument.
		do
			position := unspecified_position
			is_argument := True
			is_operand := True
			is_interface := True
		end

	make_as_unspecified_operand
			-- Initialize Current as unspecified operand.
		do
			position := unspecified_position
			is_operand := True
			is_interface := True
		end

	make_as_unspecified_interface_variable
			-- Initialize Current as unspecified interface variable.
		do
			position := unspecified_position
			is_interface := True
		end

feature -- Access

	position: INTEGER
			-- Position of current variable

	hash_code: INTEGER
			-- Hash code value
		do
			Result := position
		end

feature -- Status report

	is_target: BOOLEAN
			-- Is Current a target?

	is_argument: BOOLEAN
			-- Is Current an argument?

	is_result: BOOLEAN
			-- Is Current a result?

	is_operand: BOOLEAN
			-- Is Current an operand (target + argument)?

	is_interface: BOOLEAN
			-- Is Current an inteface position (target + argument + result)?

	is_target_variable_position (a_position: INTEGER): BOOLEAN
			-- Is `a_position' a target position?
		do
			Result := a_position = target_variable_position
		end

	is_result_variable_position (a_position: INTEGER): BOOLEAN
			-- Is `a_position' a result position?
		do
			Result := a_position = result_variable_position
		end

	is_unspecified: BOOLEAN
			-- Is Current position unspecified?
		do
			Result := position = unspecified_position
		end

feature -- Constants

	target_variable_position: INTEGER = 0
			-- Position of target

	result_variable_position: INTEGER = 12768
			-- Position of result variable

	unspecified_position: INTEGER = 65535
			-- Unspecified position

end
