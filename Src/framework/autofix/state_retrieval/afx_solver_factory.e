note
	description: "Summary description for {AFX_SOLVER_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SOLVER_FACTORY

feature -- Access

	is_for_smtlib: BOOLEAN
			-- Is SMTLIB format used for reasoning?
		do
			Result := is_for_smtlib_cell.item
		end

	is_for_boogie: BOOLEAN
			-- Is Boogie format used for reasoning?
		do
			Result := is_for_boogie_cell.item
		end

feature -- Solver input file generator

	solver_file_generator: AFX_SOLVER_FILE_GENERATOR
			-- Generator for solver input file.
		do
			if is_for_smtlib then
				Result := smtlib_file_generator
			else
				check False end
			end
		end

feature -- Solver launcher

	solver_launcher: AFX_SOLVER_LAUNCHER
			-- Z3 launcher
		do
			if is_for_smtlib then
				Result := z3_launcher
			else
				check False end
			end
		end

feature -- Access

	new_solver_expression_from_string (a_text: STRING): AFX_SOLVER_EXPR
			-- New solver expression from `a_text'
		do
			if is_for_smtlib then
				create {AFX_SMTLIB_EXPR} Result.make (a_text)
			else
				create {AFX_BOOGIE_EXPR} Result.make (a_text)
			end
		end

feature -- Setting

	use_smtlib
			-- Set to use SMTLIB as format for reasoning.
		do
			is_for_smtlib_cell.replace (True)
			is_for_boogie_cell.replace (False)
		end

	use_boogie
			-- Set to use Boogie as format for reasoning.
		do
			is_for_smtlib_cell.replace (False)
			is_for_boogie_cell.replace (True)
		end

feature{NONE} -- Implementation

	is_for_boogie_cell: CELL [BOOLEAN]
			-- Cell to store value for `is_for_boogie'
		once
			create Result.put (False)
		end

	is_for_smtlib_cell: CELL [BOOLEAN]
			-- Cell to store value for `is_for_smtlib'
		once
			create Result.put (True)
		end

	smtlib_file_generator: AFX_SMTLIB_FILE_GENERATOR
			-- SMTLIB file generator
		once
			create Result
		end

	z3_launcher: AFX_SMTLIB_LAUNCHER
			-- Z3 launcher
		once
			create Result
		end

end
