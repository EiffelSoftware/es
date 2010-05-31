note
	description: "Summary description for {AUT_PRECONDITION_CONSTRAINT_SOLVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PRECONDITION_CONSTRAINT_SOLVER

inherit
	AUT_SHARED_PREDICATE_CONTEXT

create
	make

feature -- Initialization

	make, initialize (a_feature: like feature_; a_solvable_preconditions: like linear_solvable_preconditions; a_operands: like operand_candidate; a_interpreter: like interpreter; a_tried_context: like tried_context; a_bound_operands: like bound_operands) is
			-- Initialize.
		require
			a_feature_attached: a_feature /= Void
			a_solvable_preconditions_attached: a_solvable_preconditions /= Void
			a_operands_attached: a_operands /= Void
			a_interpreter_attached: a_interpreter /= Void
			a_tried_context_attached: a_tried_context /= Void
		do
			feature_ := a_feature
			linear_solvable_preconditions := a_solvable_preconditions
			operand_candidate := a_operands
			interpreter := a_interpreter
			tried_context := a_tried_context
			bound_operands := a_bound_operands
		end

feature -- Access

	feature_: AUT_FEATURE_OF_TYPE
			-- Feature whose precondition is to be evaluated

	linear_solvable_preconditions: DS_LINKED_LIST [AUT_PREDICATE_ACCESS_PATTERN]
			-- Linearly solvable precondition predicates for `feature_'

	operand_candidate: ARRAY [detachable ITP_VARIABLE]
			-- Operand candidate where solved arguments should be placed.

	solution: DS_HASH_TABLE [INTEGER, INTEGER]
			-- Table of last linearly sovled operands
			-- [operand value, operand index]
			-- Operand index is 0-based, but in here the operand is already larger than 0,
			-- because linear constraint solving for target operand is not supported.
			-- Only has effect if `has_last_solution' is True

	tried_context: DS_HASH_SET [STRING]
			-- Context where linear constraint solving has been tried on
			-- The items in this set is a string representation of all the values of the
			-- constraining queries of `feature_'

	bound_operands: HASH_TABLE [ITP_VARIABLE, INTEGER]
			-- List of variables that are already bound in `operand_candidate'
			-- [Variable, its 0-based operand index]

feature -- Status report

	has_solution: BOOLEAN
			-- Is there is solution for constraint argument(s)?

feature -- Basic operations

	solve is
			-- Solve linear constraint.
			-- If there is a solution, set `has_solution' to True and put the solution in `solution';
			-- otherwise set `has_solution' to False.
		local
			l_state: HASH_TABLE [STRING, STRING]
			l_proof_obligation: STRING
			l_constraining_queries: DS_HASH_SET [STRING]
			l_new_query_name: STRING
			l_query_name: detachable STRING
			l_pattern_table: DS_HASH_TABLE [AUT_PREDICATE_ACCESS_PATTERN, AUT_PREDICATE]

			l_solver: AUT_LINEAR_CONSTRAINT_SOLVER
			l_smt_solver: AUT_SAT_BASED_LINEAR_CONSTRAINT_SOLVER
			l_config: like configuration
			l_lp_solve_enabled: BOOLEAN
			l_target_var: ITP_VARIABLE
			l_context: like context_representation
		do
			l_config := configuration
			has_solution := False
			is_lp_linear_solvable_model_correct := True

				-- Ask for states of the target object.
				-- the value of constraining queries are in the retrieved states.
			l_target_var := operand_candidate.item (0)
			if l_target_var /= Void and then interpreter.typed_object_pool.is_variable_defined (l_target_var) then
				l_state := interpreter.object_state (l_target_var)
			else
				create l_state.make (0)
			end

			l_context := context_representation (l_state)
				-- Only when linear constraint solving has not been done on the same context, we continue doing the solving.
			if not tried_context.has (l_context) then
				tried_context.force_last (l_context)
					-- Solve linear constraints.
				l_lp_solve_enabled := l_config.is_lpsolve_linear_constraint_solver_enabled
				if
					l_lp_solve_enabled and then
					is_lp_linear_solvable_model_correct
				then
					l_solver := lp_constraint_solver (l_state)
					l_solver.solve
					has_solution := l_solver.has_last_solution
					is_lp_linear_solvable_model_correct := l_solver.is_input_format_correct
				end

				if
					l_config.is_smt_linear_constraint_solver_enabled and then
					not has_solution and then
					(l_lp_solve_enabled implies not is_lp_linear_solvable_model_correct) -- Only in case when lp_solve model input is of wrong format,
																						 -- we need smt solve, because if lp_solve model is correct,
																						 -- and lpsolve cannot generate solution, then SMT solver cannot
																						 -- generate a solution either, becaue there is no valid solution.
				then
					l_smt_solver := smt_linear_constraint_solver (l_state)
					l_smt_solver.set_enforce_used_value_rate (l_config.smt_enforce_old_value_rate)
					l_smt_solver.set_use_predefined_value_rate (l_config.smt_use_predefined_value_rate)
					l_solver := l_smt_solver
					l_solver.solve
					has_solution := l_solver.has_last_solution
				end

				if has_solution then
					solution := l_solver.last_solution
				end

					-- Constraint solving is marked as failed if the interpreter went wrong.		
				if is_lp_linear_solvable_model_correct then
					is_lp_linear_solvable_model_correct := interpreter.is_ready and then interpreter.is_running
				end
			end
		end


feature{NONE} -- Implementation

	interpreter: AUT_INTERPRETER_PROXY
			-- Interpreter of current test session

	configuration: TEST_GENERATOR is
			-- Configuration of current test session
		do
			Result := interpreter.configuration
		ensure
			good_result: Result = interpreter.configuration
		end

	smt_linear_constraint_solver (a_state: HASH_TABLE [STRING, STRING]): AUT_SAT_BASED_LINEAR_CONSTRAINT_SOLVER is
			-- SMT-based linear constraint solver with context queries stored in `a_state'
		require
			a_state_attached: a_state /= void
			smt_linear_constraint_solving_enabled: configuration.is_smt_linear_constraint_solver_enabled
		do
			create {AUT_SAT_BASED_LINEAR_CONSTRAINT_SOLVER} Result.make (feature_, linear_solvable_preconditions, a_state, interpreter.configuration)
		ensure
			result_attached: Result /= Void
		end

	lp_constraint_solver (a_state: HASH_TABLE [STRING, STRING]): AUT_LINEAR_CONSTRAINT_SOLVER is
			-- lpsolve linear constraint solver with context queries stored in `a_state'
		require
			a_state_attached: a_state /= void
			lp_linear_constraint_solving_enabled: configuration.is_lpsolve_linear_constraint_solver_enabled
		do
			create {AUT_LP_BASED_LINEAR_CONSTRAINT_SOLVER} Result.make (feature_, linear_solvable_preconditions, a_state, interpreter.configuration)
		ensure
			result_attached: Result /= Void
		end

	is_lp_linear_solvable_model_correct: BOOLEAN
			-- Is the generated linearly solvable model of correct format?
			-- This is introduced because for the moment, the we only generated models
			-- for lpsolver in a simple form. This means that there are cases where the model cannot
			-- be handled by lpsolve while it can be handled by SMT based solver.		

	context_representation (a_state: HASH_TABLE [STRING, STRING]): STRING is
			-- Context representation for `tried_context'
		require
			a_state_attached: a_state /= Void
		local
			l_context_queries: like constraining_queries_from_access_patterns
			l_queries: DS_ARRAYED_LIST [STRING]
			l_sorter: DS_QUICK_SORTER [STRING]
		do
			l_context_queries := constraining_queries_from_access_patterns (linear_solvable_preconditions)
			create l_queries.make_from_linear (l_context_queries)
			create l_sorter.make (agent_based_string_equality_tester)
			l_sorter.sort (l_queries)
			create Result.make (64)
			from
				l_queries.start
			until
				l_queries.after
			loop
				a_state.search (l_queries.item_for_iteration)
				if a_state.found then
					Result.append (a_state.found_item)
				else
					Result.append_character ('_')
				end
				if not l_queries.is_last then
					Result.append_character (',')
				end
				l_queries.forth
			end
		ensure
			result_attached: Result /= Void
		end

	agent_based_string_equality_tester: AGENT_BASED_EQUALITY_TESTER [STRING] is
			-- Equality tester for string
		do
			create Result.make (agent (a, b: STRING): BOOLEAN do Result := a ~ b end)
		end

;note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
