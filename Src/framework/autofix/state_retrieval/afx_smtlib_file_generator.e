note
	description: "Summary description for {AFX_SMTLIB_FILE_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SMTLIB_FILE_GENERATOR

inherit
	AFX_SOLVER_FILE_GENERATOR

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

	generate_formula (a_formula: AFX_SOLVER_EXPR)
			-- Generate `a_formula' into `last_content'.
		do
			last_content.append (":formula (not (%N")
			last_content.append (a_formula.expression)
			last_content.append ("%N)))")
		end

	generate_formulae_internal (a_formulae: LIST [AFX_SOLVER_EXPR])
			-- Generate `a_formulae' into `last_content'.
		do
			fixme ("Support multiple formulae in SMTLIB.")
		end


end
