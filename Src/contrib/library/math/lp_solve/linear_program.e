note
	description: "[
		An object that represents a linear program. Linear programming is
		a technique to optimize a linear objective function subject to
		linear equality and inequality constraints of a set of variables.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LINEAR_PROGRAM

inherit
	MEMORY redefine dispose end

	LINEAR_PROGRAM_CONSTANTS

create
	make, make_with_mps

feature {NONE} -- Initialization

	make
		do
			internal_lp := c_make_lp (0, 0)
			create variables.make
			create constraints.make
			create object_function.make
		ensure
			is_initialized: not internal_lp.is_default_pointer
		end

	make_with_mps (a_mps_file: STRING)
		local
			l_mps_c: ANY
		do
			l_mps_c := a_mps_file.to_c
			internal_lp := c_read_mps ($l_mps_c, 4)
			create variables.make
			create constraints.make
			create object_function.make
		ensure
			is_initialized: not internal_lp.is_default_pointer
		end

feature -- Access

	last_result: INTEGER
			-- The last result for the solution of the linear program.

	last_solving_time: DOUBLE
			-- The time (in seconds) elapsed between the start and end of `solve'.
		do
			Result := c_time_elapsed (internal_lp)
		end

	variables: LINKED_LIST[VARIABLE]

	constraints: LINKED_LIST[CONSTRAINT]

	object_function: LINKED_LIST[TERM] assign set_object_function

	is_maximized: BOOLEAN
			-- Is the object function maximizied? The default value is False.
		do
			Result := c_is_maxim (internal_lp)
		end

feature -- Change

	set_object_function (a_object_function: like object_function)
			-- Set the object function of the linear program.
			-- Note: `a_object_function' must not provide all variables of the linear program
			-- and only the given ones will be modified. Variables not provided will
			-- maintain same value as before and will not changed.
		do
			object_function.wipe_out
			object_function.append (a_object_function)

			update_object_function
		end

	update_object_function
			-- Update the object function variables and coefficients of the linear program.
			-- You should call this method when modifying or adding a term of the object function.
		local
			l_variables_indices: ARRAY[INTEGER]
			l_coefficients: ARRAY[DOUBLE]
			l_var_c, l_coeff_c: ANY
			l_count: INTEGER
			l_result: BOOLEAN
		do
			create l_variables_indices.make_filled (0, 1, object_function.count)
			create l_coefficients.make_filled (0, 1, object_function.count)

			l_count := 0

			across object_function as term loop
				l_count := l_count + 1

				l_variables_indices[l_count] := term.item.variable.index
				l_coefficients[l_count] := term.item.coefficient
			end

			l_var_c := l_variables_indices.to_c
			l_coeff_c := l_coefficients.to_c

			l_result := c_set_object_function (internal_lp, l_count, $l_coeff_c, $l_var_c)
			check l_result end
		end

	maximize
			-- Set the direction of the object function to the maximum.
		do
			c_set_maxim (internal_lp)
		ensure
			maximization_set: is_maximized
		end

	minimize
			-- Set the direction of the object function to the minimum.
		do
			c_set_minim (internal_lp)
		ensure
			minimization_set: not is_maximized
		end

	solve
			-- Solve the linear program with the given constraints
			-- and object function.
		local
			l_variables: ARRAY[DOUBLE]
			l_var_c: ANY
			l_result: BOOLEAN
		do
			last_result := c_solve (internal_lp)

				-- Get optimal values of the variables and
				-- set them to their Eiffel counterpart
			create l_variables.make_filled (0, 1, variables.count)
			l_var_c := l_variables.to_c

			l_result := c_get_variables (internal_lp, $l_var_c)
			check l_result end

			across variables as variable loop
				variable.item.set_value (l_variables[variable.cursor_index])
			end
		end

	set_verbosity_level (a_level: INTEGER)
		do
			c_set_verbose (internal_lp, a_level)
		end

feature -- Output

	print_out
		do
			print_lp (internal_lp)
		end

feature -- Removal

	dispose
		do
				-- Delete the C linear program structure
			delete_lp (internal_lp)
		end

feature {LP_TEST, VARIABLE, CONSTRAINT} -- C Representation

	internal_lp: POINTER
		-- Pointer to the C representation of the linear program.

	is_add_row_mode: BOOLEAN
			-- Return True if add row mode is enabled, False otherwise.
			-- When add row mode is enabled adding a constraint performs best;
			-- when disabled then adding a variable performs best.
		do
			Result := c_is_add_row_mode (internal_lp)
		end

	enable_row_mode
		do
			if not is_add_row_mode then
				check c_set_add_row_mode (internal_lp, True) end
			end
		ensure
			is_mode_enabled: is_add_row_mode
		end

	disable_row_mode
		do
			if is_add_row_mode then
				check c_set_add_row_mode (internal_lp, False) end
			end
		ensure
			is_mode_disabled: not is_add_row_mode
		end

feature {NONE} -- C Implementation

	c_make_lp (a_rows, a_columns: INTEGER): POINTER
		external
			"C signature (int, int): EIF_POINTER use %"lp_lib.h%""
		alias
			"make_lp"
		end

	c_read_mps (a_mps_file: POINTER; a_verbose_leve: INTEGER): POINTER
		external
			"C signature (char *, int): EIF_POINTER use %"lp_lib.h%""
		alias
			"read_MPS"
		end

	c_add_variable (a_lp: POINTER; a_count: INTEGER; a_column: ARRAY[DOUBLE]; a_row: ARRAY[INTEGER]): BOOLEAN
		external
			"C signature (EIF_POINTER, int, REAL *, int *): EIF_BOOLEAN use %"lp_lib.h%""
		alias
			"add_columnex"
		end

	c_set_object_function (a_lp: POINTER; a_count: INTEGER; a_coefficients, a_indices: POINTER): BOOLEAN
		external
			"C signature (EIF_POINTER, int, REAL *, int *): EIF_BOOLEAN use %"lp_lib.h%""
		alias
			"set_obj_fnex"
		end

	c_solve (a_lp: POINTER): INTEGER
		external
			"C signature (EIF_POINTER): EIF_INTEGER use %"lp_lib.h%""
		alias
			"solve"
		end

	c_set_basis (a_lp, a_basis: POINTER; a_has_non_basic_variables: BOOLEAN): BOOLEAN
		external
			"C signature (EIF_POINTER, int *, unsigned char): EIF_BOOLEAN use %"lp_lib.h%""
		alias
			"set_basis"
		end

	c_get_variables (a_lp, a_variables: POINTER): BOOLEAN
		external
			"C signature (EIF_POINTER, REAL *): EIF_BOOLEAN use %"lp_lib.h%""
		alias
			"get_variables"
		end

	c_is_maxim (a_lp: POINTER): BOOLEAN
		external
			"C signature (EIF_POINTER): EIF_BOOLEAN use %"lp_lib.h%""
		alias
			"is_maxim"
		end

	c_set_maxim (a_lp: POINTER)
		external
			"C signature (EIF_POINTER) use %"lp_lib.h%""
		alias
			"set_maxim"
		end

	c_set_minim (a_lp: POINTER)
		external
			"C signature (EIF_POINTER) use %"lp_lib.h%""
		alias
			"set_minim"
		end

	c_is_add_row_mode (a_lp: POINTER): BOOLEAN
		external
			"C signature (EIF_POINTER): EIF_BOOLEAN use %"lp_lib.h%""
		alias
			"is_add_rowmode"
		end

	c_set_add_row_mode (a_lp: POINTER; turn_on: BOOLEAN): BOOLEAN
		external
			"C signature (EIF_POINTER, EIF_BOOLEAN): EIF_BOOLEAN use %"lp_lib.h%""
		alias
			"set_add_rowmode"
		end

	c_time_elapsed (a_lp: POINTER): DOUBLE
		external
			"C signature (EIF_POINTER): EIF_DOUBLE use %"lp_lib.h%""
		alias
			"time_elapsed"
		end

	c_set_verbose (a_lp: POINTER; a_level: INTEGER)
		external
			"C signature (EIF_POINTER, int) use %"lp_lib.h%""
		alias
			"set_verbose"
		end

	print_lp (a_lp: POINTER)
			-- Print the linear program. For debug purposes only.
		external
			"C signature (EIF_POINTER) use %"lp_lib.h%""
		end

	delete_lp (a_lp: POINTER)
		external
			"C signature (EIF_POINTER) use %"lp_lib.h%""
		end

end
