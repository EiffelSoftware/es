note
	description: "Summary description for {EPA_SOLVER_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_SOLVER_UTILITY

inherit
	EPA_SOLVER_FACTORY

feature -- Access

	solver_expression (a_expr: EPA_EXPRESSION): EPA_SOLVER_EXPR
			-- Solver expression from `a_expr'
		local
			l_resolved: TUPLE [resolved_str: STRING; mentioned_classes: DS_HASH_SET [EPA_CLASS_WITH_PREFIX]]
			l_shared_theory: EPA_SHARED_CLASS_THEORY
			l_raw_text: STRING
		do
			create l_shared_theory
			l_shared_theory.solver_expression_generator.initialize_for_generation
			l_shared_theory.solver_expression_generator.generate_expression (a_expr.ast, a_expr.class_, a_expr.written_class, a_expr.feature_)
			l_raw_text := l_shared_theory.solver_expression_generator.last_statements.first
			l_resolved := l_shared_theory.resolved_smt_statement (l_raw_text, create {EPA_CLASS_WITH_PREFIX}.make (a_expr.class_, ""))
			Result := new_solver_expression_from_string (l_resolved.resolved_str)
		end

	expression_as_state_skeleton (a_expr: EPA_EXPRESSION): EPA_STATE_SKELETON
			-- State skeleton including `a_expr'
		require
			a_expr_is_predicate: a_expr.is_predicate
		local
			l_exprs: LINKED_LIST [EPA_EXPRESSION]
		do
			create l_exprs.make
			l_exprs.extend (a_expr)

			create Result.make_with_expressions (a_expr.class_, a_expr.feature_, l_exprs)
		end

end
