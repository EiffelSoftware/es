note
	description: "Summary description for {AFX_PROGRAM_STATE_SKELETON_BUILDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_DERIVED_STATE_SKELETON_BUILDER

inherit

	ANY

	AFX_SHARED_SESSION

feature -- Access

	last_derived_skeleton: EPA_STATE_SKELETON
			-- Derived state skeleton from last build.

feature -- Basic operation

	build_skeleton (a_feature_with_context: EPA_FEATURE_WITH_CONTEXT_CLASS; a_base_expressions: EPA_HASH_SET [EPA_AST_EXPRESSION])
			-- Build a derived state skeleton based on `a_base_expressions' from `a_feature_with_context'.
			-- Put the result skeleton in `last_derived_skeleton'.
		require
			base_expressions_not_empty: a_base_expressions /= Void and then not a_base_expressions.is_empty
		local
			l_boolean_expressions, l_integer_expressions, l_reference_expressions: EPA_HASH_SET [EPA_AST_EXPRESSION]
			l_boolean_count, l_integer_count, l_reference_count: INTEGER
		do
			feature_with_context := a_feature_with_context
			create last_derived_skeleton.make_basic (a_feature_with_context.context_class, a_feature_with_context.feature_, a_base_expressions.count + 1)

			l_boolean_expressions := boolean_expressions (a_base_expressions)
			l_boolean_count := l_boolean_expressions.count
			l_integer_expressions := integer_expressions (a_base_expressions)
			l_integer_count := l_integer_expressions.count
			l_reference_expressions := reference_expressions (a_base_expressions)
			l_reference_count := l_reference_expressions.count

			last_derived_skeleton.resize (l_boolean_count * 2 + 3 * l_integer_count * (l_integer_count + 1) + 1)
			last_derived_skeleton.merge (skeleton_based_on_booleans (l_boolean_expressions))
			last_derived_skeleton.merge (skeleton_based_on_integers (l_integer_expressions))
		end

	reset_builder
			-- Reset builder.
		do
			last_derived_skeleton := Void
		end

feature{NONE} -- Access

	feature_with_context: EPA_FEATURE_WITH_CONTEXT_CLASS
			-- Feature with context, for which the skeleton is built.

	context_feature: FEATURE_I
			-- Context feature for current build.
		do
			Result := feature_with_context.feature_
		end

	context_class: CLASS_C
			-- Context class for current build.
		do
			Result := feature_with_context.context_class
		end

	written_class: CLASS_C
			-- Written class for current build.
		do
			Result := feature_with_context.written_class
		end

feature{NONE} -- Expressions of different types

	integer_expressions (a_expressions: EPA_HASH_SET [EPA_AST_EXPRESSION]): EPA_HASH_SET [EPA_AST_EXPRESSION]
			-- Expressions of type {INTEGER} from `a_expressions'.
		require
			expressions_attached: a_expressions /= VOid
		local
			l_exp: EPA_AST_EXPRESSION
		do
			create Result.make_equal (a_expressions.count + 1)

			from a_expressions.start
			until a_expressions.after
			loop
				l_exp := a_expressions.item_for_iteration

				if l_exp.type.is_integer then
					Result.force (l_exp)
				end

				a_expressions.forth
			end
		end

	boolean_expressions (a_expressions: EPA_HASH_SET [EPA_AST_EXPRESSION]): EPA_HASH_SET [EPA_AST_EXPRESSION]
			-- Expressions of type {BOOLEAN} from `a_expressions'.
		require
			expressions_attached: a_expressions /= VOid
		local
			l_exp: EPA_AST_EXPRESSION
		do
			create Result.make_equal (a_expressions.count + 1)

			from a_expressions.start
			until a_expressions.after
			loop
				l_exp := a_expressions.item_for_iteration

				if l_exp.type.is_boolean then
					Result.force (l_exp)
				end

				a_expressions.forth
			end
		end

	reference_expressions (a_expressions: EPA_HASH_SET [EPA_AST_EXPRESSION]):EPA_HASH_SET [EPA_AST_EXPRESSION]
			-- Expressions returning references from `a_expressions'.
		require
			expressions_attached: a_expressions /= VOid
		local
			l_exp: EPA_AST_EXPRESSION
			l_type: TYPE_A
		do
			create Result.make_equal (a_expressions.count + 1)

			from a_expressions.start
			until a_expressions.after
			loop
				l_exp := a_expressions.item_for_iteration
				l_type := l_exp.type
				if not l_type.is_void and then not l_type.is_basic then
					Result.force (l_exp)
				end
				a_expressions.forth
			end
		end

feature{NONE} -- Program state aspects

	skeleton_based_on_references (a_expressions: EPA_HASH_SET [EPA_AST_EXPRESSION]): EPA_STATE_SKELETON
			-- Derived state skeleton based on boolean expressions from `a_expressions'.
			-- For the moment, the `Result' skeleton includes equality testing, i.e. = and /=, between references and "Void".
		require
			expressions_attached: a_expressions /= Void
		local
			l_combinations: LINKED_LIST [EPA_HASH_SET [EPA_AST_EXPRESSION]]
			l_comb: EPA_HASH_SET [EPA_AST_EXPRESSION]
			l_left, l_right: EPA_AST_EXPRESSION
			l_context_class, l_written_class: CLASS_C
			l_context_feature: FEATURE_I
			l_aspect: AFX_PROGRAM_STATE_ASPECT_REFERENCE_COMPARISON

			l_exp: EPA_AST_EXPRESSION
			l_eq_void, l_neq_void: AFX_PROGRAM_STATE_ASPECT_VOID_CHECK
		do
			if a_expressions.count < 2 then
				create Result.make_basic (context_class, context_feature, 1)
			else
				l_combinations := a_expressions.combinations (2)
				create Result.make_basic (context_class, context_feature, l_combinations.count * 2 + 1)
				l_context_class := context_class
				l_written_class := written_class
				l_context_feature := context_feature
				from l_combinations.start
				until l_combinations.after
				loop
					l_comb := l_combinations.item_for_iteration
					check l_comb.count = 2 end

					l_left := l_comb.first
					l_right := l_comb.last
					create l_aspect.make_comparison (l_context_class, l_context_feature, l_written_class, l_left, l_right, {AFX_PROGRAM_STATE_ASPECT_REFERENCE_COMPARISON}.operator_reference_eq)
					Result.force (l_aspect)
					create l_aspect.make_comparison (l_context_class, l_context_feature, l_written_class, l_left, l_right, {AFX_PROGRAM_STATE_ASPECT_REFERENCE_COMPARISON}.operator_reference_ne)
					Result.force (l_aspect)

					l_combinations.forth
				end
			end
			from a_expressions.start
			until a_expressions.after
			loop
				l_exp := a_expressions.item_for_iteration

				create l_eq_void.make_void_check (context_class, context_feature, written_class,
						l_exp, {AFX_PROGRAM_STATE_ASPECT_VOID_CHECK}.Operator_void_check_equal)
				Result.force (l_eq_void)

				create l_neq_void.make_void_check (context_class, context_feature, written_class,
						l_exp, {AFX_PROGRAM_STATE_ASPECT_VOID_CHECK}.Operator_void_check_not_equal)
				Result.force (l_neq_void)

				a_expressions.forth
			end
		end

	skeleton_based_on_booleans (a_booleans: EPA_HASH_SET [EPA_AST_EXPRESSION]): EPA_STATE_SKELETON
			-- Derived state skeleton based on boolean expressions from `a_expressions'.
			-- For the moment, the `Result' skeleton include both the aspects from `a_expression',
			--		and the negated ones.
		require
			expressions_attached: a_booleans /= VOid
		local
			l_exp: EPA_AST_EXPRESSION
			l_combinations: LINKED_LIST [EPA_HASH_SET [EPA_AST_EXPRESSION]]
		do
			create Result.make_basic (context_class, context_feature, a_booleans.count * 2 + 1)
			a_booleans.do_all (
				agent (a_expr: EPA_AST_EXPRESSION; a_skeleton: EPA_STATE_SKELETON)
					local
						l_aspect, l_aspect_neg: AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION
					do
						create l_aspect.make_boolean_relation (context_class, context_feature, written_class, a_expr, Void, {AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION}.Operator_boolean_null)
						a_skeleton.force (l_aspect)
						create l_aspect_neg.make_boolean_relation (context_class, context_feature, written_class, a_expr, Void, {AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION}.Operator_boolean_negation)
						a_skeleton.force (l_aspect_neg)
					end (?, Result)
			)
			l_combinations := a_booleans.combinations (2)
			l_combinations.do_all (
				agent (a_comb: EPA_HASH_SET [EPA_AST_EXPRESSION]; a_skeleton: EPA_STATE_SKELETON)
					local
						l_left, l_right: EPA_AST_EXPRESSION
						l_neg_left, l_neg_right, l_or: AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION
					do
						l_left := a_comb.first
						l_right:= a_comb.last
						create l_neg_left.make_boolean_relation (context_class, context_feature, written_class, l_left, Void, {AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION}.Operator_boolean_negation)
						create l_neg_right.make_boolean_relation(context_class, context_feature, written_class, l_right,Void, {AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION}.Operator_boolean_negation)

						create l_or.make_boolean_relation(context_class, context_feature, written_class, l_left, l_right, {AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION}.Operator_boolean_or_else)
						a_skeleton.force (l_or)
						create l_or.make_boolean_relation(context_class, context_feature, written_class, l_left, l_neg_right, {AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION}.Operator_boolean_or_else)
						a_skeleton.force (l_or)
						create l_or.make_boolean_relation(context_class, context_feature, written_class, l_neg_left, l_right, {AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION}.Operator_boolean_or_else)
						a_skeleton.force (l_or)
						create l_or.make_boolean_relation(context_class, context_feature, written_class, l_neg_left, l_neg_right, {AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION}.Operator_boolean_or_else)
						a_skeleton.force (l_or)
					end (?, Result)
			)
		end

	skeleton_based_on_integers (a_integers: EPA_HASH_SET [EPA_AST_EXPRESSION]): EPA_STATE_SKELETON
			-- Derived state skeleton based on integer expressions from `a_expressions'.
			-- The result skeleton includes both comparisons between expressions and constant 0,
			--		and comparison between expressions themselves.
		local
			l_count: INTEGER
			l_zero: EPA_AST_EXPRESSION
			l_combinations: LINKED_LIST [EPA_HASH_SET [EPA_AST_EXPRESSION]]
		do
			l_count := a_integers.count
			create Result.make_basic (context_class, context_feature, 3 * l_count * (l_count + 1) )
			create l_zero.make_with_text (context_class, context_feature, "0", written_class)
			a_integers.do_all (
				agent (a_expr, a_zero: EPA_AST_EXPRESSION; a_skeleton: EPA_STATE_SKELETON)
					local
						l_aspect: AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON
					do
						create l_aspect.make_comparison (context_class, context_feature, written_class, a_expr, a_zero, {AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON}.Operator_integer_eq)
						a_skeleton.force (l_aspect)
						create l_aspect.make_comparison (context_class, context_feature, written_class, a_expr, a_zero, {AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON}.Operator_integer_gt)
						a_skeleton.force (l_aspect)
						create l_aspect.make_comparison (context_class, context_feature, written_class, a_expr, a_zero, {AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON}.Operator_integer_ge)
						a_skeleton.force (l_aspect)
						create l_aspect.make_comparison (context_class, context_feature, written_class, a_expr, a_zero, {AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON}.Operator_integer_lt)
						a_skeleton.force (l_aspect)
						create l_aspect.make_comparison (context_class, context_feature, written_class, a_expr, a_zero, {AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON}.Operator_integer_le)
						a_skeleton.force (l_aspect)
					end (?, l_zero, Result)
			)
			l_combinations := a_integers.combinations (2)
			l_combinations.do_all (
				agent (a_comb: EPA_HASH_SET [EPA_AST_EXPRESSION]; a_skeleton: EPA_STATE_SKELETON)
					local
						l_aspect: AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON
					do
						create l_aspect.make_comparison (context_class, context_feature, written_class, a_comb.first, a_comb.last, {AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON}.Operator_integer_eq)
						a_skeleton.force (l_aspect)
						create l_aspect.make_comparison (context_class, context_feature, written_class, a_comb.first, a_comb.last, {AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON}.Operator_integer_gt)
						a_skeleton.force (l_aspect)
						create l_aspect.make_comparison (context_class, context_feature, written_class, a_comb.first, a_comb.last, {AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON}.Operator_integer_ge)
						a_skeleton.force (l_aspect)
						create l_aspect.make_comparison (context_class, context_feature, written_class, a_comb.first, a_comb.last, {AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON}.Operator_integer_lt)
						a_skeleton.force (l_aspect)
						create l_aspect.make_comparison (context_class, context_feature, written_class, a_comb.first, a_comb.last, {AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON}.Operator_integer_le)
						a_skeleton.force (l_aspect)
					end (?, Result)
			)
		end

end
