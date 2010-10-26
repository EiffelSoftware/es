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
	make,
	make_as_target,
	make_as_result,
	make_as_argument

feature{NONE} -- Initialization

	make (a_position: INTEGER)
			-- Initialize Current.
		do
			position := a_position
			if a_position = target_variable_position then
				is_target := True
			elseif a_position = result_variable_position then
				is_result := True
			else
				is_argument := True
			end
		end

	make_as_target
			-- Initialize Current as a target variable position.
		do
			make (target_variable_position)
		end

	make_as_result
			-- Initialize Current as a result variable position.
		do
			make (result_variable_position)
		end

	make_as_argument (i: INTEGER)
			-- Initialize Current as the `i'-th argument position.
		require
			i_valid: i > 0
		do
			make (i)
		end

feature -- Access

	position: INTEGER
			-- Position of current variable

	hash_code: INTEGER
			-- Hash code value
		do
			if is_result then
					-- For result position, since hash code cannot be negative,
					-- we use a special value for the hash code.

				Result := 65536
			else
				Result := position
			end
		end

feature -- Status report

	is_target: BOOLEAN
			-- Is Current a target?

	is_argument: BOOLEAN
			-- Is Current an argument?

	is_result: BOOLEAN
			-- Is Current a result?

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

feature -- Constants

	target_variable_position: INTEGER = 0
			-- Position of target

	result_variable_position: INTEGER = -1
			-- Position of result variable

invariant
	position_non_negative: position >= -1
	target_position_valid: is_target implies position = 0
	result_position_valid: is_result implies position = -1
	argument_position_valid: is_argument implies position > 0

end
