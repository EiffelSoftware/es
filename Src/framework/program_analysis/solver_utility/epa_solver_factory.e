note
	description: "Summary description for {AFX_SOLVER_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_SOLVER_FACTORY

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


	skeleton_from_state (a_state: EPA_STATE): EPA_STATE_SKELETON
			-- Expression skeleton from `a_state'
		do
			create Result.make_basic (a_state.class_, a_state.feature_, a_state.count)
			a_state.do_all (
				agent (a_equation: EPA_EQUATION; a_skeleton: EPA_STATE_SKELETON)
					do
						a_skeleton.force_last (a_equation.expression)
					end (?, Result))
--		ensure
--			good_result: Result.count = a_state.count
		end

feature -- Solver input file generator

	solver_file_generator: EPA_SOLVER_FILE_GENERATOR
			-- Generator for solver input file.
		do
			if is_for_smtlib then
				Result := smtlib_file_generator
			else
				Result := bpl_generator
			end
		end

feature -- Solver expression generator

	solver_expression_generator: EPA_SOLVER_EXPRESSION_GENERATOR
			-- SMTLIB generator
		do
			if is_for_smtlib then
				Result := smtlib_expression_generator
			else
				Result := boogie_expression_generator
			end
		end

feature -- Solver launcher

	solver_launcher: EPA_SOLVER_FACILITY
			-- Z3 launcher
		do
			if is_for_smtlib then
				Result := z3_launcher
			else
				Result := boogie_launcher
			end
		end

feature -- Access

	new_solver_expression_from_string (a_text: STRING): EPA_SOLVER_EXPR
			-- New solver expression from `a_text'
		do
			if is_for_smtlib then
				create {EPA_SMTLIB_EXPR} Result.make (a_text)
			else
				create {EPA_BOOGIE_EXPR} Result.make (a_text)
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
			create Result.put (True)
		end

	is_for_smtlib_cell: CELL [BOOLEAN]
			-- Cell to store value for `is_for_smtlib'
		once
			create Result.put (False)
		end

	smtlib_file_generator: EPA_SMTLIB_FILE_GENERATOR
			-- SMTLIB file generator
		once
			create Result
		end

	bpl_generator: EPA_BPL_GENERATOR
			-- Boogie PL generator
		once
			create Result
		end

	z3_launcher: EPA_SMTLIB_FACILITY
			-- Z3 launcher
		once
			create Result
		end

	boogie_launcher: EPA_BOOGIE_FACILITY
			-- Z3 launcher
		once
			create Result
		end

	smtlib_expression_generator: EPA_SMTLIB_GENERATOR
			-- SMTLIB generator
		once
			create Result.make
		end

	boogie_expression_generator: EPA_BOOGIE_EXPRESSION_GENERATOR
			-- Boogie BPL code generator
		once
			create Result.make
		end

end
