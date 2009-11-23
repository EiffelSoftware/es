note
	description: "Summary description for {AFX_BPL_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BPL_GENERATOR

inherit
	AFX_SOLVER_FILE_GENERATOR

feature -- Access

	implied_expression (a_left: AFX_SOLVER_EXPR; a_right: AFX_SOLVER_EXPR): AFX_SOLVER_EXPR
			-- Solver expression for the implication: `a_left' implies `a_right'
		local
			l_content: STRING
		do
			create l_content.make (512)
			l_content.append (once "(")
			l_content.append (a_left.expression)
			l_content.append (once ") ==> (")
			l_content.append (a_right.expression)
			l_content.append (once ")")
			Result := new_solver_expression_from_string (l_content)
		end

	connected_expression (a_exprs: LIST [AFX_SOLVER_EXPR]; a_operator: STRING): AFX_SOLVER_EXPR
			-- Solver expressions from `a_exprs', connected by `a_operator'
		local
			l_content: STRING
			l_cursor: CURSOR
			l_operator: STRING
		do
			if a_operator.is_case_insensitive_equal ("and") then
				l_operator := "&&"
			elseif a_operator.is_case_insensitive_equal ("or") then
				l_operator := "||"
			else
				check False end
			end
			create l_content.make (512)
			l_content.append (once "(")
			from
				a_exprs.start
			until
				a_exprs.after
			loop
				l_content.append (once " (")
				l_content.append (a_exprs.item_for_iteration.expression)
				l_content.append (once ") ")
				if a_exprs.index < a_exprs.count then
					l_content.append (l_operator)
				end
				a_exprs.forth
			end
			l_content.append (once ")")
			Result := new_solver_expression_from_string (l_content)
		end

feature{NONE} -- Implementation

	generate_header
			-- Generate header in `last_content'.
		do
			last_content.append ("type ref;%N")
		end

	generate_formulae_internal (a_formulae: LIST [AFX_SOLVER_EXPR])
			-- Generate `a_formulae' into `last_content'.
		do
			from
				a_formulae.start
			until
				a_formulae.after
			loop
				generate_formula_with_name (a_formulae.item_for_iteration, "afx_formula_" + a_formulae.index.out)
				a_formulae.forth
			end
		end

	generate_formula_with_name (a_formula: AFX_SOLVER_EXPR; a_procedure_name: STRING)
			-- Generate `a_formula' into `last_content'.
		do
			last_content.append (once "procedure ")
			last_content.append (a_procedure_name)
			last_content.append ("();%N")

			last_content.append (once "implementation ")
			last_content.append (a_procedure_name)
			last_content.append ("() {%N")
			last_content.append ("%Tassert ")
			last_content.append (a_formula.expression)
			last_content.append (";%N}%N%N")
		end

	generate_formula (a_formula: AFX_SOLVER_EXPR)
			-- Generate `a_formula' into `last_content'.
		local
			l_list: LINKED_LIST [AFX_SOLVER_EXPR]
		do
			create l_list.make
			l_list.extend (a_formula)
			generate_formulae_internal (l_list)
		end
end
