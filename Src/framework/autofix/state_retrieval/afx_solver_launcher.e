note
	description: "Summary description for {AFX_SOLVER_LAUNCHER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_SOLVER_LAUNCHER

inherit
	AFX_SOLVER_FACTORY

	REFACTORING_HELPER

feature -- Basic operations

	is_unsat (a_content: STRING): BOOLEAN
			-- Is the SMTLIB content `a_content' unsatisfiable?
		deferred
		end

feature -- Access

	valid_expressions (a_expressions: LINEAR [AFX_EXPRESSION]; a_theory: AFX_THEORY): LIST [AFX_EXPRESSION]
			-- List of valid formulae from `a_expressions' in the context of `a_theory'
		local
			l_generator: like solver_file_generator
			l_list: LINKED_LIST [AFX_SOLVER_EXPR]
			l_expr: AFX_EXPRESSION
		do
			create l_list.make
			from
				a_expressions.start
			until
				a_expressions.after
			loop
				l_expr := a_expressions.item_for_iteration
				if l_expr.is_predicate then
					l_list.extend (a_expressions.item_for_iteration.as_solver_expression)
				end
				a_expressions.forth
			end
			l_generator := solver_file_generator
			l_generator.generate_formulae (l_list, a_theory)
			generate_file (l_generator.last_content)
			fixme("Added code to analyze result.")
			create {LINKED_LIST [AFX_EXPRESSION]} Result.make
		end

feature{NONE} -- Implementation

	generate_file (a_content: STRING)
			-- Generate solver file containing `a_content'.
		deferred
		end

end
