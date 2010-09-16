note
	description: "Class to access to relationships between expressions"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXPRESSION_RELATION

inherit
	EPA_SHARED_EQUALITY_TESTERS

	EPA_UTILITY

	EPA_CONTRACT_EXTRACTOR

feature -- Access

	relevant_expressions (a_expr: EPA_EXPRESSION; a_context: ETR_CONTEXT): DS_HASH_SET [EPA_EXPRESSION]
			-- Set of expressions that are relevant with `a_expr' in `a_context'
			-- `a_context' indicates in which scope the relevance relation is calculated.
			-- Relevance is defined as follows:
			-- If `a_expr' and another expression, `b_expr', are used in the same larger expression, `a_expr' and `b_expr' are relevant.
			-- For example, in the expression "price + tax", sub-expression "price" and "tax" are relevant, because
			-- they are used in the larger expression "price + tax".			
			-- Note: Recalculate result every time, no cache is maintained. So if this feature is used frequently,
			-- please do the caching somewhere else.
		do
		ensure
			good_result: Result /= Void
			equality_tester_set: Result.equality_tester = expression_equality_tester
		end

	dependent_expressions (a_expr: EPA_EXPRESSION; a_context: ETR_CONTEXT): DS_HASH_SET [EPA_EXPRESSION]
			-- Set of expressions that `a_expr' dependents on in `a_context'
			-- `a_context' indicates in which scope the relevance relation is calculated.
			-- Depencency is defined as follows:
			-- If `a_expr' appears as a left-hand value of an assignment and another expression, `b_expr', appears in the right-hand expression
			-- of the same assignment, then `a_expr' is dependent on `b_expr'.
			-- For example, in assignment "total := price + tax", "total" is dependent on both "price" and "tax'.
			-- Note: Recalculate result every time, no cache is maintained. So if this feature is used frequently,
			-- please do the caching somewhere else.		
		do
		ensure
			good_result: Result /= Void
			equality_tester_set: Result.equality_tester = expression_equality_tester
		end

feature -- Status report

	is_expression_relevant (a_expr: EPA_EXPRESSION; b_expr: EPA_EXPRESSION; a_context: ETR_CONTEXT): BOOLEAN
			-- Is `a_expr' and `b_expr' relevant?
			-- `a_context' indicates in which scope the relevance relation is calculated.
			-- Relevance is defined as follows:
			-- If `a_expr' and `b_expr' are used in the same larger expression, `a_expr' and `b_expr' are relevant.
			-- For example, in the expression "price + tax", sub-expression "price" and "tax" are relevant, because
			-- they are used in the larger expression "price + tax".			
			-- Note: Recalculate result every time, no cache is maintained. So if this feature is used frequently,
			-- please do the caching somewhere else.
		do
		end

	is_expression_dependant (a_expr: EPA_EXPRESSION; b_expr: EPA_EXPRESSION; a_context: ETR_CONTEXT): BOOLEAN
			-- Is `a_expr' dependent on `b_expr'?
			-- `a_context' indicates in which scope the relevance relation is calculated.
			-- Depencency is defined as follows:
			-- If `a_expr' appears as a left-hand value of an assignment and `b_expr' appears in the right-hand expression
			-- of the same assignment, then `a_expr' is dependent on `b_expr'.
			-- For example, in assignment "total := price + tax", "total" is dependent on both "price" and "tax'.
			-- Note: Recalculate result every time, no cache is maintained. So if this feature is used frequently,
			-- please do the caching somewhere else.		
		do
		end

	demo_code
			--
		local
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_feat_ast: AST_EIFFEL
			l_invariants, l_preconditions: LINKED_LIST [EPA_EXPRESSION]
		do
			l_class := first_class_starts_with_name ("LINKED_LIST")
			l_feature := l_class.feature_named ("extend")
			l_feat_ast := l_feature.e_feature.ast

			l_preconditions := precondition_of_feature (l_feature, l_class)
			l_invariants := invariant_of_class (l_class)
		end

end
