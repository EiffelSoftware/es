note
	description: "Summary description for {AFX_SMTLIB_FILE_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SMTLIB_FILE_GENERATOR

inherit
	AFX_SOLVER_FILE_GENERATOR

	AFX_SOLVER_FACTORY

feature -- Basic operations

	generate (a_formula: AFX_SOLVER_EXPR; a_theory: AFX_THEORY)
			-- Generate solver file to check `a_formula' in `a_theory'.
			-- Store result in `last_content'.
		do
			create last_content.make (2048)
			generate_header
			generate_theory (a_theory)
			generate_formula (a_formula)
		end

	generate_for_implied_checking (a_exprs1: LINEAR [AFX_EXPRESSION]; a_exprs2: LINEAR [AFX_EXPRESSION]; a_theory: AFX_THEORY)
			-- Generate file to check if `a_expr2' can be implied from `a_exprs1' in the context of `a_theory'.
			-- Store result in `last_content'.
		local
			l_exprs1: LINKED_LIST [AFX_SOLVER_EXPR]
			l_exprs2: LINKED_LIST [AFX_SOLVER_EXPR]
		do
			l_exprs1 := expressions_to_solver_expressions (a_exprs1)
			l_exprs2 := expressions_to_solver_expressions (a_exprs2)

			generate (implied_expression (connected_expression (l_exprs1, "and"), connected_expression (l_exprs2, "and")), a_theory)
		end

feature -- Access

	implied_expression (a_left: AFX_SOLVER_EXPR; a_right: AFX_SOLVER_EXPR): AFX_SOLVER_EXPR
			-- SMTLIB expression for the implication: `a_left' implies `a_right'
		local
			l_content: STRING
		do
			create l_content.make (512)
			l_content.append (once "(implies (")
			l_content.append (a_left.expression)
			l_content.append (once ") (")
			l_content.append (a_right.expression)
			l_content.append (once "))")
			Result := new_solver_expression_from_string (l_content)
		end

	connected_expression (a_exprs: LIST [AFX_SOLVER_EXPR]; a_operator: STRING): AFX_SOLVER_EXPR
			-- SMTLIB expressions from `a_exprs', connected by `a_operator'
		local
			l_content: STRING
			l_cursor: CURSOR
		do
			create l_content.make (512)
			l_content.append (once "(")
			l_content.append (a_operator)
			l_content.append_character (' ')

			from
				a_exprs.start
			until
				a_exprs.after
			loop
				l_content.append (once "%N(")
				l_content.append (a_exprs.item_for_iteration.expression)
				l_content.append (once ")")
				a_exprs.forth
			end
			l_content.append (once ")%N")
			Result := new_solver_expression_from_string (l_content)
		end

feature{NONE} -- Implementation

	generate_header
			-- Generate header in `last_content'.
		do
			last_content.append ("[
(benchmark example
:status unsat
:logic QF_UFLIA

			]")
		end

	generate_theory (a_theory: AFX_THEORY)
			-- Generate `a_theory' into `last_content'.
		do
			a_theory.functions.do_all (agent append_line)
			a_theory.axioms.do_all (agent append_line)
		end

	generate_formula (a_formula: AFX_SOLVER_EXPR)
			-- Generate `a_formula' into `last_content'.
		do
			last_content.append (":formula (not (%N")
			last_content.append (a_formula.expression)
			last_content.append ("%N)))")
		end

	append_line (a_content: AFX_SOLVER_EXPR)
			-- Append `a_content' into `last_content' in its own line.
		do
			last_content.append (a_content.expression)
			last_content.append_character ('%N')
		end

end
