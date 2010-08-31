note
	description: "Summary description for {AFX_PROGRAM_STATE_EXTENSION_WITH_INTEGRAL_RELATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_STATE_EXTENDER_FOR_INTEGRAL_RELATIONS

inherit
	KL_SHARED_STRING_EQUALITY_TESTER

create
	make

feature -- Initialization

	make (a_config: AFX_CONFIG)
			-- Initialization.
		do
			config := a_config

			if config.is_combining_integral_expressions_in_breakpoint then
				-- Use the expression combination strategy that works only within the scopes of breakpoint indexes.
				set_expression_combination_strategy (expression_combination_strategy_within_breakpoint)
			else
				check config.is_combining_integral_expressions_in_feature end
				-- Use a more permissive expression combination strategy, which tries to combine expressions from all over the feature.
				set_expression_combination_strategy (expression_combination_strategy_within_feature)
			end
		end

feature -- Access

	config: AFX_CONFIG
			-- AutoFix configuration.

	original_skeleton: detachable DS_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION] assign set_original
			-- Original program state skeleton.

	extended_skeleton: attached DS_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION]
			-- Extended program state skeleton with relational expressions based on integer values.
		require
			original_skeleton_attached: original_skeleton /= Void
		do
			if extended_skeleton_cache = Void then
				create extended_skeleton_cache.make_equal (1)
			end

			Result := extended_skeleton_cache
		ensure
			result_attached: Result /= Void
		end

	expression_combination_strategy: AFX_INTEGRAL_EXPRESSION_COMBINATION_STRATEGY assign set_expression_combination_strategy
			-- Strategy that decides how to combine integral expressions to make relationals.
		do
			if expression_combination_strategy_cache = Void then
				expression_combination_strategy_cache := expression_combination_strategy_within_breakpoint
			end
			Result := expression_combination_strategy_cache
		end

feature -- Basic operation

	compute_extension
			-- Compute the extended state skeleton on the basis of `original_skeleton'.
			-- Make the extended skeleton available in `extended_skeleton'.
		require
			original_skeleton_not_empty: original_skeleton /= Void and then not original_skeleton.is_empty
		local
			l_original: like original_skeleton
			l_extended: like extended_skeleton
			l_expressions: DS_HASH_TABLE [DS_HASH_SET [INTEGER], STRING]
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_extension: like relational_expressions_in_integrals
		do
			l_original := original_skeleton

			-- The extended skeleton contains all expressions from the original one.
			l_extended := l_original.twin

			-- Build other expressions based on integral ones.
			l_class := l_original.first.class_
			l_feature := l_original.first.feature_
			l_expressions := integral_expressions

--			-- Extend the original skeleton with comparison against 0, e.g. 'exp1 ? 0' (where ? could be >, =, or <)
--			if l_expressions.count > 0 then
--				l_extension := sign_test_expressions (l_class, l_feature, l_expressions)
--				l_extended.append (l_extension)
--			end

			-- Extend the original skeleton with relational expressions in integrals,
			--		i.e. expressions like 'exp1 > exp2' (where ? could be >, =, or <).
			if l_expressions.count > 1 then
				l_extension := relational_expressions_in_integrals (l_class, l_feature, l_expressions)
				l_extended.append (l_extension)
			end

			extended_skeleton_cache := l_extended
		ensure
			extended_skeleton_cache_attached: extended_skeleton_cache /= Void
		end

feature -- Status set

	set_original (a_state_skeleton: attached DS_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION])
			-- Set `original_skeleton'.
		require
			skeleton_attached: a_state_skeleton /= Void
			-- All expressions in `a_state_skeleton' should have the same attributes `class_' and `feature_'.
			expressions_from_same_context: True
		do
			original_skeleton := a_state_skeleton
			extended_skeleton_cache := Void
		ensure
			original_skeleton_attached: original_skeleton /= Void
			extended_skeleton_reset: extended_skeleton_cache = Void
		end

	set_expression_combination_strategy (a_strategy: AFX_INTEGRAL_EXPRESSION_COMBINATION_STRATEGY)
			-- Set `expression_combination_strategy'.
		require
			strategy_attached: a_strategy /= Void
		do
			expression_combination_strategy_cache := a_strategy
		end

feature{NONE} -- Cache

	extended_skeleton_cache: detachable like extended_skeleton
			-- Cache for `extended_skeleton'.

	expression_combination_strategy_cache: like expression_combination_strategy
			-- Cache for `expression_combination_strategy'.

feature{NONE} -- Constant

	expression_combination_strategy_within_breakpoint: AFX_INTEGRAL_EXPRESSION_COMBINATION_WITHIN_BREAKPOINT
			-- Expression combination strategy within breakpoint.
		once
			create Result
		end

	expression_combination_strategy_within_feature: AFX_INTEGRAL_EXPRESSION_COMBINATION_WITHIN_FEATURE
			-- Expression combination strategy within feature.
		once
			create Result
		end

feature{NONE} -- Implementation

	integral_expressions: DS_HASH_TABLE [DS_HASH_SET [INTEGER], STRING]
			-- All expressions of type {INTEGER} from `original_skeleton'.
			--
			-- Key: string representation of an expression.
			-- Val: breakpoint indexes where expressions with the same text appear.
		require
			original_skeleton_not_empty: not original_skeleton.is_empty
		local
			l_original: like original_skeleton
			l_expressions: DS_HASH_TABLE [DS_HASH_SET [INTEGER], STRING]
			l_exp: EPA_PROGRAM_STATE_EXPRESSION
			l_text: STRING
			l_type: TYPE_A
			l_index: INTEGER
			l_set: DS_HASH_SET [INTEGER]
		do
			l_original := original_skeleton

			create l_expressions.make (l_original.count)
			l_expressions.set_key_equality_tester (Case_insensitive_string_equality_tester)

			from l_original.start
			until l_original.after
			loop
				l_exp := l_original.item_for_iteration
				l_text := l_exp.text
				l_type := l_exp.type
				l_index := l_exp.breakpoint_slot

				-- Collect only expressions of integral type.
				if l_type.is_integer then
					if l_expressions.has (l_text) then
						l_set := l_expressions.item (l_text)
						l_set.force (l_index)
					else
						create l_set.make_default
						l_set.force (l_index)
						l_expressions.force (l_set, l_text)
					end
				end

				l_original.forth
			end

			Result := l_expressions
		end

--	sign_test_expressions (a_class: CLASS_C; a_feature: FEATURE_I; a_integrals: DS_HASH_TABLE [DS_HASH_SET [INTEGER], STRING]): DS_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION]
--			-- New expressions that test the signs of integral expressions.
--			-- For each integral expression 'exp', new expressions like 'exp > 0', 'exp = 0', and 'exp < 0'.
--		require
--			integrals_not_empty: not a_integrals.is_empty
--		local
--			l_int: STRING
--			l_index_set: DS_HASH_SET [INTEGER]
--			l_index: INTEGER
--			l_exp: EPA_PROGRAM_STATE_EXPRESSION
--		do
--			create Result.make_equal (a_integrals.count * 3)

--			from a_integrals.start
--			until a_integrals.after
--			loop
--				l_int := a_integrals.key_for_iteration
--				l_index_set := a_integrals.item_for_iteration

--				from l_index_set.start
--				until l_index_set.after
--				loop
--					l_index := l_index_set.item_for_iteration

--					create l_exp.make_with_text (a_class, a_feature, "(" + l_int + ") > 0", a_feature.written_class)
--					l_exp.set_breakpoint_slot (l_index)
--					Result.force_last (l_exp)

--					create l_exp.make_with_text (a_class, a_feature, "(" + l_int + ") = 0", a_feature.written_class)
--					l_exp.set_breakpoint_slot (l_index)
--					Result.force_last (l_exp)

--					create l_exp.make_with_text (a_class, a_feature, "(" + l_int + ") < 0", a_feature.written_class)
--					l_exp.set_breakpoint_slot (l_index)
--					Result.force_last (l_exp)

--					l_index_set.forth
--				end

--				a_integrals.forth
--			end
--		ensure
--			result_not_empty: result /= Void and then not result.is_empty
--		end

	relational_expressions_in_integrals (a_class: CLASS_C; a_feature: FEATURE_I; a_integrals: DS_HASH_TABLE [DS_HASH_SET [INTEGER], STRING]): DS_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION]
			-- Relational expression between integrals from `a_integrals', in the context of `a_class'.`a_feautre'.
		require
			more_than_one_integral: a_integrals.count > 1
		local
			l_exp_set, l_comb: EPA_HASH_SET [STRING]
			l_combinations: LINKED_LIST [EPA_HASH_SET [STRING]]
			l_combinations_with_index: DS_LINEAR [TUPLE [op1: STRING; op2: STRING; idx: INTEGER]]

			l_text1, l_text2: STRING
			l_index_range1, l_index_range2, l_index_range_in_common: DS_HASH_SET [INTEGER]
			l_index: INTEGER
		do
			-- Set of all integral expression texts.
			create l_exp_set.make (a_integrals.count)
			l_exp_set.set_equality_tester (case_insensitive_string_equality_tester)
			l_exp_set.append (a_integrals.keys)

			-- 2-combinations of all integral expressions.
			l_combinations := l_exp_set.combinations (2)

			-- Combinations taking into account the breakpoint indexes.
			l_combinations_with_index := expression_combination_strategy.combinations_with_indexes (a_class, a_feature, a_integrals, l_combinations)

			Result := relationals_from_combinations_with_index (a_class, a_feature, l_combinations_with_index)

		end

	relationals_from_combinations_with_index (a_class: CLASS_C; a_feature: FEATURE_I; a_combinations:  DS_LINEAR [TUPLE [op1: STRING; op2: STRING; idx: INTEGER]]): DS_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION]
			-- Set of relational expressions based on the possible combinations of integral expressions and the breakpoint indexes.
			-- At each breakpoint index, the two integral expressions are compared using '>', '<', and '='.
			-- The new expressions are interpreted in the context of `a_class'.`a_feature'.
		local
			l_exp: EPA_PROGRAM_STATE_EXPRESSION
			l_part1, l_part2: STRING
			l_relationals: DS_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION]
			l_tuple: TUPLE [op1: STRING; op2: STRING; idx: INTEGER]
		do
			create l_relationals.make_equal (a_combinations.count * 3 + 1)

			from a_combinations.start
			until a_combinations.after
			loop
				l_tuple := a_combinations.item_for_iteration

				l_part1 := "(" + l_tuple.op1 + ")"
				l_part2 := "(" + l_tuple.op2 + ")"

				create l_exp.make_with_text (a_class, a_feature, l_part1 + " > " + l_part2, a_feature.written_class)
				l_exp.set_breakpoint_slot (l_tuple.idx)
				l_relationals.force (l_exp)

				create l_exp.make_with_text (a_class, a_feature, l_part1 + " < " + l_part2, a_feature.written_class)
				l_exp.set_breakpoint_slot (l_tuple.idx)
				l_relationals.force (l_exp)

				create l_exp.make_with_text (a_class, a_feature, l_part1 + " = " + l_part2, a_feature.written_class)
				l_exp.set_breakpoint_slot (l_tuple.idx)
				l_relationals.force (l_exp)

				a_combinations.forth
			end

			Result := l_relationals
		end

end
