note
	description: "Summary description for {CONSTRAINT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONSTRAINT

inherit
	LINEAR_PROGRAM_CONSTANTS

	HASHABLE

create
	make_with_program, make_linear

feature {NONE} -- Initialization

	make_with_program (a_program: LINEAR_PROGRAM)
		local
			l_lhs: LINKED_LIST [TERM]
		do
			create l_lhs.make
			assign_to_program_with_values (a_program, l_lhs, constraint_sign_equal, 0)

			hash_code := out.hash_code
		ensure
			program_set: linear_program = a_program
			initialized_left_hand_side: left_hand_side /= Void
		end

	make_linear (a_program: LINEAR_PROGRAM; multiplier: DOUBLE; variable1: VARIABLE; constant: DOUBLE; a_sign: like sign; variable2: VARIABLE)
			-- Create a 2-dimensional linear constraint in `a_program' of the form a*x + b [=] y
			-- where x and y are the `variable1' and `variable2', respectively, while a and b
			-- are the `multiplier' and `constant'. The sign of the equation is given by `a_sign'.
		local
			l_left_hand_side: ARRAYED_LIST[TERM]
			l_term: TERM
		do
			make_with_program (a_program)

				-- Rearrange the equation in the form
				-- a*x - y [=] -b
			create l_left_hand_side.make (2)

			create l_term.make (variable1, multiplier)
			l_left_hand_side.extend (l_term)

			create l_term.make (variable2, -1)
			l_left_hand_side.extend (l_term)

			set_left_hand_side (l_left_hand_side)

			set_constraint_sign (a_sign)
			set_right_hand_side (-constant)
		end

feature -- Access

	left_hand_side: LIST[TERM] assign set_left_hand_side

	sign: INTEGER assign set_constraint_sign

	right_hand_side: DOUBLE assign set_right_hand_side

	index: INTEGER
			-- The index of the constraint in the linear program.
		do
			Result := linear_program.constraints.index_of (Current, 1)
		end

	hash_code: INTEGER

feature -- Change

	set_left_hand_side (a_lhs: like left_hand_side)
			-- Set the left hand side of the constraint.
			-- Note: `a_lhs' must not provide all variables of the constraint
			-- and only the given ones will be modified. Variables not provided will
			-- maintain same value as before and will not be changed.
		do
			left_hand_side.wipe_out
			left_hand_side.append (a_lhs)

			update_left_hand_side
		end

	update_left_hand_side
			-- Update the left hand side variables and coefficients of the constraint.
			-- You should call this method when modifying or adding a term of the left hand side.
		local
			l_count: INTEGER
			l_variable_indices: ARRAY[INTEGER]
			l_coefficients: ARRAY[DOUBLE]
			l_v, l_c: ANY
			l_result: BOOLEAN
		do
			l_count := 0
			create l_variable_indices.make_filled (0, 1, left_hand_side.count)
			create l_coefficients.make_filled (0, 1, left_hand_side.count)

			across left_hand_side as term loop
				l_count := l_count + 1

				l_variable_indices[l_count] := term.item.variable.index
				l_coefficients[l_count] := term.item.coefficient
			end

			l_v := l_variable_indices.to_c
			l_c := l_coefficients.to_c

			l_result := c_set_left_hand_side (linear_program.internal_lp, index, l_count, $l_c, $l_v)
			check l_result end
		end

	set_constraint_sign (a_sign: like sign)
		require
			valid_sign_range: 0 <= a_sign and a_sign <= 3
		local
			l_result: BOOLEAN
		do
			l_result := c_set_constraint_sign (linear_program.internal_lp, index, a_sign)
			check l_result end

			sign := a_sign
		ensure
			sign_set: sign = a_sign
		end

	set_right_hand_side (a_rhs: like right_hand_side)
		local
			l_result: BOOLEAN
		do
			l_result := c_set_right_hand_side (linear_program.internal_lp, index, a_rhs)
			check l_result end

			right_hand_side := a_rhs
		ensure
			right_hand_side_set: right_hand_side = a_rhs
		end

	reinstate
			-- Insert the constraint back in the linear program to which it belonged.
		do
			assign_to_program_with_values (linear_program, left_hand_side, sign, right_hand_side)
		ensure
			-- same left hand side
			same_sign: old sign = sign
			same_right_hand_side: old right_hand_side = right_hand_side
			present: linear_program.constraints.has (Current)
		end

feature -- Delete

	remove
			-- Remove this constraint from the linear program.
		local
			l_result: BOOLEAN
		do
			l_result := c_delete_constraint (linear_program.internal_lp, index)
			check l_result end

			linear_program.constraints.go_i_th (index)
			linear_program.constraints.remove
		ensure
			removed: not linear_program.constraints.has (Current)
		end

feature {VARIABLE} -- Delete

	remove_variable (a_variable: VARIABLE)
			-- Remove from the left hand side the variable that has been removed.
		do
			from left_hand_side.start
			until left_hand_side.after
			loop
				if left_hand_side.item.variable = a_variable then
					left_hand_side.remove
				else
					left_hand_side.forth
				end
			end
		end

feature {NONE} -- Implementation

	linear_program: LINEAR_PROGRAM

	assign_to_program_with_values (lp: like linear_program; a_lhs: like left_hand_side; a_sign: like sign; a_rhs: like right_hand_side)
		require
			program_not_void: lp /= Void
			left_hand_side_not_void: a_lhs /= Void
		local
			l_row: ARRAY [DOUBLE]
			l_column: ARRAY [INTEGER]
			l_row_c, l_col_c: ANY
			l_result: BOOLEAN
		do
			linear_program := lp

			create {LINKED_LIST [TERM]}left_hand_side.make
			left_hand_side.append (a_lhs)

			sign := a_sign
			right_hand_side := a_rhs

			create l_row.make_filled (0, 1, a_lhs.count)
			create l_column.make_filled (0, 1, a_lhs.count)

			across left_hand_side as term loop
				l_row[term.cursor_index] := term.item.coefficient
				l_column[term.cursor_index] := term.item.variable.index
			end

			l_row_c := l_row.to_c
			l_col_c := l_column.to_c

			l_result := c_add_constraint (linear_program.internal_lp, 0, $l_row_c, $l_col_c, sign, right_hand_side)
			check l_result end

			linear_program.constraints.extend (Current)
				-- Force to update the left hand side
			update_left_hand_side
		ensure
			program_set: linear_program = lp
		end

feature {NONE} -- C Implementation

	c_add_constraint (a_lp: POINTER; a_count: INTEGER; a_row, a_column: POINTER; a_sign: INTEGER; right_handside: DOUBLE): BOOLEAN
		external
			"C signature (EIF_POINTER, int, REAL *, int *, int, REAL): EIF_BOOLEAN use %"lp_lib.h%""
		alias
			"add_constraintex"
		end

	c_delete_constraint (a_lp: POINTER; a_row: INTEGER): BOOLEAN
		external
			"C signature (EIF_POINTER, int): EIF_BOOLEAN use %"lp_lib.h%""
		alias
			"del_constraint"
		end

	c_set_left_hand_side (a_lp: POINTER; a_row, a_count: INTEGER; a_coefficients, a_indices: POINTER): BOOLEAN
		external
			"C signature (EIF_POINTER, int, int, REAL *, int *): EIF_BOOLEAN use %"lp_lib.h%""
		alias
			"set_rowex"
		end

	c_set_constraint_sign (a_lp: POINTER; a_row: INTEGER; a_sign: INTEGER): BOOLEAN
		external
			"C (EIF_POINTER, int, REAL): EIF_BOOLEAN | %"lp_lib.h%""
		alias
			"set_constr_type"
		end

	c_set_right_hand_side (a_lp: POINTER; a_row: INTEGER; a_value: DOUBLE): BOOLEAN
		external
			"C (EIF_POINTER, int, REAL): EIF_BOOLEAN | %"lp_lib.h%""
		alias
			"set_rh"
		end

end
