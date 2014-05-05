note
	description: "Summary description for {SOFT_CONSTRAINT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SOFT_CONSTRAINT

inherit
	CONSTRAINT
		redefine
			make_with_program,
			update_left_hand_side
		end

create
	make_with_program, make_linear, make_single

feature {NONE} -- Initialization

	make_with_program (a_program: LINEAR_PROGRAM)
			-- Initialization for `Current'.
		local
			l_variable: VARIABLE
			l_term: TERM
		do
				-- Add a penalty variable to the object function
				-- TODO: decide what is the default penality term?
				-- For now: 250, 500, 750, 1000
			create l_variable.make_with_program (a_program)
			create penalty.make (l_variable, 1)

			create l_term.make (l_variable, .25)
			a_program.object_function.extend (l_term)
			a_program.update_object_function

			Precursor (a_program)
		end

	make_single (a_program: LINEAR_PROGRAM; a_multiplier: REAL_64; a_variabe: VARIABLE; a_sign: like sign; a_constant: REAL_64)
		local
			l_term: TERM
		do
			make_with_program (a_program)
			create l_term.make (a_variabe, a_multiplier)
			left_hand_side.extend (l_term)
			update_left_hand_side

			set_constraint_sign (a_sign)
			set_right_hand_side (a_constant)
		end

feature -- Access

	penalty: TERM
			-- The penalty term for violating the constraint.

feature -- Change

	update_left_hand_side
		require else
			penalty_not_present: not left_hand_side.has (penalty)
		local
			l_index: INTEGER
		do
			if sign = constraint_sign_greater_than_or_equal then
				penalty.coefficient := 1
			elseif sign = constraint_sign_less_than_or_equal or sign = constraint_sign_equal then
				penalty.coefficient := -1
			end

			left_hand_side.extend (penalty)
			l_index := left_hand_side.index_of (penalty, 1)

			Precursor

			left_hand_side.go_i_th (l_index)
			left_hand_side.remove
		ensure then
			penalty_not_present: not left_hand_side.has (penalty)
		end

end
