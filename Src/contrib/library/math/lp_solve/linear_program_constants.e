note
	description: "[
		Constants for lp_solve, the linear programming solver.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LINEAR_PROGRAM_CONSTANTS

feature -- Constraint Sign

	constraint_sign_free: INTEGER = 0
	constraint_sign_less_than_or_equal: INTEGER = 1
	constraint_sign_greater_than_or_equal: INTEGER = 2
	constraint_sign_equal: INTEGER = 3

feature -- Result Type

	result_type_optimal: INTEGER = 0
	result_type_suboptimal: INTEGER = 1
	result_type_infeasible: INTEGER = 2
	result_type_unbounded: INTEGER = 3
	result_type_timeout: INTEGER = 7
	result_type_presolved: INTEGER = 9

end
