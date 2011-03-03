note
	description: "Summary description for {EPA_SOLVER_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_SOLVER_UTILITY

inherit
	EPA_SOLVER_FACTORY

	EPA_SHARED_CLASS_THEORY

	EPA_SHARED_EQUALITY_TESTERS

	EPA_UTILITY

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

feature -- Validity checking

	tautologies_in_feature_context (a_class: CLASS_C; a_feature: FEATURE_I; a_candidates: DS_HASH_SET [EPA_EXPRESSION]): DS_HASH_SET [EPA_EXPRESSION]
			-- Set of invariants from `a_candidates' which are tautologies (with respect to class invariants in `a_class' and
			-- written preconditions of `a_feature'
		local
			l_exprs: LINKED_LIST [EPA_EXPRESSION]
			l_theory: EPA_THEORY
			l_valid_exprs: LINKED_LIST [EPA_EXPRESSION]
			l_state: EPA_STATE
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_true_value: EPA_BOOLEAN_VALUE
			l_candidates: LINKED_LIST [EPA_EXPRESSION]
			l_new_theory: EPA_THEORY
			l_processed: like class_with_prefix_set
			l_feat_selector: EPA_SIMPLE_SAME_FEATURE_COLLECTOR
		do
			l_processed := class_with_prefix_set
			create l_candidates.make
			a_candidates.do_all (agent l_candidates.extend)
			create l_state.make (a_candidates.count, a_class, a_feature)
			from
				create l_true_value.make (True)
				l_cursor := a_candidates.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_state.force_last (equation_with_value (l_cursor.item, l_true_value))
				l_cursor.forth
			end
			l_state.force_last (equation_with_value (
				create {EPA_AST_EXPRESSION}.make_with_text (a_class, a_feature, "Current.out = Current.out", a_class),
				l_true_value))
			l_theory := skeleton_from_state (l_state).theory.cloned_object
			solver_expression_generator.initialize_for_generation
			solver_expression_generator.generate_precondition_axioms (a_class, a_feature)
			solver_expression_generator.generate_same_query_axioms (a_class)
			solver_expression_generator.generate_extra_query_postconditions_as_axioms (a_class)
			create l_new_theory.make (a_class)
			solver_expression_generator.last_statements.do_all (agent l_new_theory.extend_axiom_with_string)
			resolved_class_theory_internal (create {EPA_CLASS_WITH_PREFIX}.make (a_class, ""), l_theory, l_processed, l_new_theory)
			resolved_class_theory_internal (create {EPA_CLASS_WITH_PREFIX}.make (a_class, "Current."), l_theory, l_processed, l_new_theory)

			l_valid_exprs := solver_launcher.valid_expressions (l_candidates, l_theory)
			create Result.make (10)
			Result.set_equality_tester (expression_equality_tester)
			across l_valid_exprs as l_exps loop
				Result.force_last (l_exps.item)
			end
		end

end
