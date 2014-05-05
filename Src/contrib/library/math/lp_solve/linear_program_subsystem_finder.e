note
	description: "Finds a feasible subsystem of an unfeasible linear program."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LINEAR_PROGRAM_SUBSYSTEM_FINDER

create
	make_with_program

feature {NONE} -- Initialization

	make_with_program (a_program: LINEAR_PROGRAM)
		require
			program_not_void: a_program /= Void
		do
			linear_program := a_program
		end

feature -- Process Operations

	find
			-- Find a subset of the given set of constraints for
			-- which the linear program becomes feasible.
		local
			l_variables_count: INTEGER
			l_elastic_variables_count: INTEGER
			l_terms: LINKED_LIST [TERM]
			l_constraints: HASH_TABLE [CONSTRAINT, VARIABLE]
			l_variable: VARIABLE
			l_iis_constraints: LINKED_LIST [CONSTRAINT]
		do
			l_variables_count := linear_program.variables.count
			create l_constraints.make (5)
			create l_iis_constraints.make

				-- Make all constraints elastic by adding
				-- nonnegative elastic variables
			across linear_program.constraints as constraint loop
				create l_terms.make
				l_terms.append (constraint.item.left_hand_side)

				inspect constraint.item.sign
				when {LINEAR_PROGRAM}.constraint_sign_equal then
						-- Add two elastic variables (one positive and one negative)
					l_terms.extend (term_with_coefficient (1))
						-- Map the elastic variable to the current constraint
					l_constraints[linear_program.variables.last] := constraint.item
					l_terms.extend (term_with_coefficient (-1))
				when {LINEAR_PROGRAM}.constraint_sign_greater_than_or_equal then
						-- Add positive elastic variable
					l_terms.extend (term_with_coefficient (1))
				else
						-- Add negative elastic variable
					l_terms.extend (term_with_coefficient (-1))
				end
				constraint.item.left_hand_side := l_terms

					-- Map the elastic variable to the current constraint
				l_constraints[linear_program.variables.last] := constraint.item
			end
			l_elastic_variables_count := linear_program.variables.count - l_variables_count

			update_object_function
				-- Solve the model and remove elastic variables > 0
				-- (enforce the constraints) until the model is infeasible.
			from linear_program.solve
			until is_infeasible -- or too many iterations
			loop
				from linear_program.variables.go_i_th (l_variables_count + 1)
				until linear_program.variables.after
				loop
						-- Remove nonnegative elastic variables.
						-- The constraint to which this variable corresponds
						-- must be inserted in the IIS set.
					l_variable := linear_program.variables.item
					if l_variable.value > 0 then
						l_iis_constraints.extend (l_constraints[l_variable])
						l_variable.remove
					else
						linear_program.variables.forth
					end
				end
					-- Update the objective function and solve the program again
				update_object_function
				linear_program.solve
			end
				-- Debug
--			print ("IIS of constraints: ")
--			across l_iis_constraints as constraint loop print (constraint.item.index.out + ", ") end
--			print ("%N%N")

				-- Remove constraints that are not part of the IIS
			across linear_program.constraints as constraint loop
				if not l_iis_constraints.has (constraint.item) then
					constraint.item.remove
				end
			end
				-- Now run deletion filter on the IIS
			apply_deletion_filter

				-- Delete the elastic variables
			from linear_program.variables.go_i_th (l_variables_count + 1)
			until linear_program.variables.after
			loop
				linear_program.variables.item.remove
			end
		end

feature {NONE} -- Process Operations

	apply_deletion_filter
			-- Find one IIS on a set of infeasible contraints.
		local
			l_constraints: LINKED_LIST [CONSTRAINT]
		do
			create l_constraints.make
			l_constraints.append (linear_program.constraints)

			from l_constraints.start
			until l_constraints.after
			loop
					-- Temporarily drop the constraint
				l_constraints.item.remove
					-- Solve the program
				linear_program.solve
				if not is_infeasible then
						-- Insert the constraint again
					l_constraints.item.reinstate
				end
					-- Otherwise drop the constraint permanently and go on
				l_constraints.forth
			end
		end

feature {NONE} -- Implementation

	linear_program: LINEAR_PROGRAM

	is_infeasible: BOOLEAN
		do
			Result := linear_program.last_result = {LINEAR_PROGRAM}.result_type_infeasible
		end

	term_with_coefficient (a_coefficient: DOUBLE): TERM
		local
			l_variable: VARIABLE
		do
			create l_variable.make_with_program (linear_program)
			create Result.make (l_variable, a_coefficient)
		end

	update_object_function
			-- Set the new objective function taking into consideration
			-- the elastic variables.
		local
			l_terms: LINKED_LIST [TERM]
			l_term: TERM
		do
			create l_terms.make

			across linear_program.variables as variable loop
				create l_term.make (variable.item, 1)
				l_terms.extend (l_term)
			end

			linear_program.object_function := l_terms
		end

end
