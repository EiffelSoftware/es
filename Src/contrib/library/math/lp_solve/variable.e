note
	description: "Variables for a linear program."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VARIABLE

inherit
	HASHABLE

create
	make_with_program

feature {NONE} -- Initialization

	make_with_program (a_program: LINEAR_PROGRAM)
		require
			program_not_void: a_program /= Void
		local
			columns: ARRAY[DOUBLE]
			rows: ARRAY[INTEGER]
			l_col_c, l_row_c: ANY
			l_result: BOOLEAN
		do
			linear_program := a_program

			create columns.make_empty
			create rows.make_empty

			l_col_c := columns.to_c
			l_row_c := rows.to_c

			l_result := c_add_variable (linear_program.internal_lp, 0, $l_col_c, $l_row_c)

				-- Make sure the variable was created correctly
			check l_result end

			linear_program.variables.extend (Current)
			hash_code := out.hash_code
		ensure
			program_set: linear_program = a_program
		end

feature -- Access

	value: DOUBLE
			-- The current value for the variable.

	minimum: DOUBLE
			-- The minimum bound for the variable.

	maximum: DOUBLE
			-- The maximum bound for the varable.

	index: INTEGER
			-- The index of the variable in the linear program.
		do
			Result := linear_program.variables.index_of (Current, 1)
		end

	hash_code: INTEGER

feature -- Change

	set_value (a_value: DOUBLE)
		do
			value := a_value
		ensure
			value_set: value = a_value
		end

	set_minimum (a_minimum: DOUBLE)
		local
			l_result: BOOLEAN
		do
			l_result := c_set_minimum (linear_program.internal_lp, index, a_minimum)
			check l_result end

			minimum := a_minimum
		ensure
			minimum_set: minimum = a_minimum
		end

	set_maximum (a_maximum: DOUBLE)
		local
			l_result: BOOLEAN
		do
			l_result := c_set_maximum (linear_program.internal_lp, index, a_maximum)
			check l_result end

			maximum := a_maximum
		ensure
			maximum_set: maximum = a_maximum
		end

	set_bounds (a_minimum, a_maximum: DOUBLE)
		require
			non_negative_minimum: a_minimum >= 0
			non_negative_maximum: a_maximum >= 0
			max_greater_than_min: a_maximum >= a_minimum
		local
			l_result: BOOLEAN
		do
			l_result := c_set_bounds (linear_program.internal_lp, index, a_minimum, a_maximum)
			check l_result end

			minimum := a_minimum
			maximum := a_maximum
		ensure
			minimum_set: minimum = a_minimum
			maximum_set: maximum = a_maximum
		end

feature -- Delete

	remove
			-- Remove the variable from the linear program.
		local
			l_result: BOOLEAN
		do
				-- Add row mode must be disabled before removing a variable.
			linear_program.disable_row_mode

			l_result := c_delete_column (linear_program.internal_lp, index)
			check l_result end
			linear_program.variables.go_i_th (index)
			linear_program.variables.remove

			across linear_program.constraints as constraint loop
				constraint.item.remove_variable (Current)
			end
		end

feature {NONE} -- Implementation

	linear_program: LINEAR_PROGRAM

feature {NONE} -- C Implementation

	c_add_variable (a_lp: POINTER; a_count: INTEGER; a_column, a_row: POINTER): BOOLEAN
		external
			"C signature (EIF_POINTER, int, REAL *, int *): EIF_BOOLEAN use %"lp_lib.h%""
		alias
			"add_columnex"
		end

	c_set_minimum (a_lp: POINTER; a_column: INTEGER; a_minimum: DOUBLE): BOOLEAN
		external
			"C (EIF_POINTER, int, REAL): EIF_BOOLEAN | %"lp_lib.h%""
		alias
			"set_lowbo"
		end

	c_set_maximum (a_lp: POINTER; a_column: INTEGER; a_maximum: DOUBLE): BOOLEAN
		external
			"C signature (EIF_POINTER, int, REAL): EIF_BOOLEAN use %"lp_lib.h%""
		alias
			"set_upbo"
		end

	c_set_bounds (a_lp: POINTER; a_column: INTEGER; a_minimum, a_maximum: DOUBLE): BOOLEAN
		external
			"C signature (EIF_POINTER, int, REAL, REAL): EIF_BOOLEAN use %"lp_lib.h%""
		alias
			"set_bounds"
		end

	c_delete_column (a_lp: POINTER; a_column: INTEGER): BOOLEAN
		external
			"C signature (EIF_POINTER, int): EIF_BOOLEAN use %"lp_lib.h%""
		alias
			"del_column"
		end

end
