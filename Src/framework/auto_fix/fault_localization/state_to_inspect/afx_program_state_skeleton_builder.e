note
	description: "Summary description for {AFX_PROGRAM_STATE_SKELETON_BUILDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_STATE_SKELETON_BUILDER

inherit

	ANY
	
	AFX_SHARED_SESSION

feature -- Access

	current_expressions_monitored: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION] assign set_current_expressions_monitored
			-- Current expressions monitored, based on which `last_built_skeleton' is built.

	last_built_skeleton: AFX_PROGRAM_STATE_SKELETON
			-- Program state skeleton from last `build_skeleton'.
		do
			if last_built_skeleton_cache = Void then
				create last_built_skeleton_cache.make_skeleton_breakpoint_unspecific (10)
			end
			Result := last_built_skeleton_cache
		end

feature -- Basic operation

	build_skeleton (a_expressions_monitored: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION])
			-- Build a program state skeleton based on a set of expressions monitored, i.e. `a_expressions_monitored',
			--		and make the result skeleton available in `last_built_skeleton'.
		require
			expressions_attached: a_expressions_monitored /= Void
		local
			l_boolean_expressions, l_integer_expressions: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			l_boolean_count, l_integer_count: INTEGER
		do
			set_current_expressions_monitored (a_expressions_monitored)

			if not a_expressions_monitored.is_empty then
				l_boolean_expressions := boolean_expressions (a_expressions_monitored)
				l_boolean_count := l_boolean_expressions.count
				l_integer_expressions := integer_expressions (a_expressions_monitored)
				l_integer_count := l_integer_expressions.count

				last_built_skeleton.resize (l_boolean_count * 2 + 3 * l_integer_count * (l_integer_count + 1))
				last_built_skeleton.append (skeleton_based_on_booleans (l_boolean_expressions))
				last_built_skeleton.append (skeleton_based_on_integers (l_integer_expressions))
			else
				-- No expression monitored, do nothing.
			end
		end

	reset_builder
			-- Reset builder.
		do
			last_built_skeleton_cache := Void
		end

feature{NONE} -- Selecting expressions based on types

	integer_expressions (a_expressions: like current_expressions_monitored): like current_expressions_monitored
			-- All expressions of type {INTEGER} from `a_expressions'.
			-- Other information about expressions like `text' or `breakpoint_slot' is not considered in the process.
		require
			expressions_attached: a_expressions /= VOid
		local
			l_exp: AFX_PROGRAM_STATE_EXPRESSION
			l_type: TYPE_A
			l_expressions: like current_expressions_monitored
		do
			create l_expressions.make_equal (a_expressions.count + 1)

			from a_expressions.start
			until a_expressions.after
			loop
				l_exp := a_expressions.item_for_iteration
				l_type := l_exp.type
				if l_type.is_integer then
					l_expressions.force (l_exp)
				end

				a_expressions.forth
			end

			Result := l_expressions
		end

	boolean_expressions (a_expressions: like current_expressions_monitored): like current_expressions_monitored
			-- All expressions of type {BOOLEAN} from `a_expressions', and their negations.
			-- Other information about expressions like `text' or `breakpoint_slot' is not considered in the process.
		require
			expressions_attached: a_expressions /= VOid
		local
			l_exp, l_neg_exp: AFX_PROGRAM_STATE_EXPRESSION
			l_expressions: like current_expressions_monitored
		do
			create l_expressions.make_equal (a_expressions.count + 1)

			from a_expressions.start
			until a_expressions.after
			loop
				l_exp := a_expressions.item_for_iteration

				if l_exp.type.is_boolean then
					l_expressions.force (l_exp)
				end

				a_expressions.forth
			end

			Result := l_expressions
		end

--	-- Since we only monitor expressions of types {INTEGER} or {BOOLEAN}, no reference expressions
--	--		need to be considered.
--	reference_expressions (a_expressions: like current_expressions_monitored):like current_expressions_monitored
--			-- All expressions returning references from `a_expressions'.
--			-- Other information about expressions like `text' or `breakpoint_slot' is not considered in the process.
--		require
--			expressions_attached: a_expressions /= VOid
--		local
--			l_exp: EPA_PROGRAM_STATE_EXPRESSION
--			l_type: TYPE_A
--		do
--			create Result.make_equal (a_expressions.count + 1)

--			from a_expressions.start
--			until a_expressions.after
--			loop
--				l_exp := a_expressions.item_for_iteration
--				l_type := l_exp.type
--				if not l_type.is_formal and then not l_type.is_void and then not l_type.is_basic then
--					Result.force (l_exp)
--				end
--				a_expressions.forth
--			end

--			Result := Result
--		end

feature{NONE} -- Program state aspects

	skeleton_based_on_booleans (a_expressions: like current_expressions_monitored): AFX_PROGRAM_STATE_SKELETON
			-- Program state skeleton based on boolean expressions from `a_expressions'.
			-- For the moment, the `Result' skeleton include both the aspects from `a_expression',
			--		and the negated ones.
		require
			expressions_attached: a_expressions /= VOid
		local
			l_exp: AFX_PROGRAM_STATE_EXPRESSION
			l_aspect, l_aspect_neg: AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION
		do
			create Result.make_skeleton_breakpoint_unspecific (a_expressions.count * 2 + 1)

			from a_expressions.start
			until a_expressions.after
			loop
				l_exp := a_expressions.item_for_iteration
				check of_type_boolean: l_exp.type.is_boolean end

				create l_aspect.make_boolean_relation (l_exp.context_class, l_exp.feature_, l_exp.written_class, 0,
						l_exp, Void, {AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION}.Operator_boolean_null)
				l_aspect.adopt_originate_expression (l_exp)
				Result.force (l_aspect)

				create l_aspect_neg.make_boolean_relation (l_exp.context_class, l_exp.feature_, l_exp.written_class, 0,
						l_exp, Void, {AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION}.Operator_boolean_negation)
				l_aspect_neg.adopt_originate_expression (l_exp)
				Result.force (l_aspect_neg)

				a_expressions.forth
			end
		end

	skeleton_based_on_integers (a_expressions: like current_expressions_monitored): AFX_PROGRAM_STATE_SKELETON
			-- Program state skeleton based on integer expressions from `a_expressions'.
			-- The result skeleton includes both comparisons between expressions and constant 0,
			--		and comparison between expressions themselves.
		require
			expressions_attached: a_expressions /= Void
		local
			l_count: INTEGER
			l_aspect, l_aspect_neg: AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION
		do
			l_count := a_expressions.count

			create Result.make_skeleton_breakpoint_unspecific (3 * l_count * (l_count + 1) )
			Result.append (skeleton_comparing_expressions_with_constants (a_expressions))
			Result.append (skeleton_comparing_expressions (a_expressions))
		end

	skeleton_comparing_expressions_with_constants (a_expressions: like current_expressions_monitored): AFX_PROGRAM_STATE_SKELETON
			-- Program state skeleton comparing expressions from `a_expressions' with constant 0.
		require
			expressions_attached: a_expressions /= Void
		local
			l_exp, l_zero: AFX_PROGRAM_STATE_EXPRESSION
			l_skeleton: AFX_PROGRAM_STATE_SKELETON
			l_aspect: AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON
		do
			create Result.make_skeleton_breakpoint_unspecific (a_expressions.count * 5 + 1)

			from a_expressions.start
			until a_expressions.after
			loop
				l_exp := a_expressions.item_for_iteration
				check integer_expression: l_exp.is_integer end

				if l_zero = Void then
					create l_zero.make_with_text (l_exp.context_class, l_exp.feature_, "0", l_exp.written_class, 0)
				end

				Result.append (skeleton_comparing_two_integers (l_exp, l_zero))

				a_expressions.forth
			end
		end

	skeleton_comparing_expressions (a_expressions: like current_expressions_monitored): AFX_PROGRAM_STATE_SKELETON
			-- Program state skeleton comparing integer expressions from `a_expressions'.
		require
			expressions_attached: a_expressions /= Void
		local
			l_combinations: LINKED_LIST [like current_expressions_monitored]
			l_comb: like current_expressions_monitored
			l_left, l_right: AFX_PROGRAM_STATE_EXPRESSION
			l_context_class, l_written_class: CLASS_C
			l_context_feature: FEATURE_I
			l_aspect: AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON
		do
			if a_expressions.count < 2 then
				create Result.make_skeleton_breakpoint_unspecific (1)
			else
				l_combinations := a_expressions.combinations (2)
				create Result.make_skeleton_breakpoint_unspecific (l_combinations.count * 6 + 1)

				from l_combinations.start
				until l_combinations.after
				loop
					l_comb := l_combinations.item_for_iteration
					check l_comb.count = 2 end

					l_left := l_comb.first
					l_right := l_comb.last
					Result.append (skeleton_comparing_two_integers (l_left, l_right))

					l_combinations.forth
				end
			end

		end

	skeleton_comparing_two_integers (a_left, a_right: AFX_PROGRAM_STATE_EXPRESSION): AFX_PROGRAM_STATE_SKELETON
			-- Program state skeleton comparing two integer expressions.
		require
			integer_expressions: (a_left /= Void and then a_left.is_integer) and then (a_right /= Void and then a_right.is_integer)
		local
			l_context_class, l_written_class: CLASS_C
			l_context_feature: FEATURE_I
			l_aspect: AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON
		do
			create Result.make_skeleton_breakpoint_unspecific (6)

			l_context_class := a_left.context_class
			l_written_class := a_left.written_class
			l_context_feature := a_left.feature_

			create l_aspect.make_comparison (l_context_class, l_context_feature, l_written_class, 0, a_left, a_right, {AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON}.Operator_integer_eq)
			l_aspect.adopt_originate_expression (a_left)
			l_aspect.adopt_originate_expression (a_right)
			Result.force (l_aspect)

			create l_aspect.make_comparison (l_context_class, l_context_feature, l_written_class, 0, a_left, a_right, {AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON}.Operator_integer_ne)
			l_aspect.adopt_originate_expression (a_left)
			l_aspect.adopt_originate_expression (a_right)
			Result.force (l_aspect)

			create l_aspect.make_comparison (l_context_class, l_context_feature, l_written_class, 0, a_left, a_right, {AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON}.Operator_integer_gt)
			l_aspect.adopt_originate_expression (a_left)
			l_aspect.adopt_originate_expression (a_right)
			Result.force (l_aspect)

			create l_aspect.make_comparison (l_context_class, l_context_feature, l_written_class, 0, a_left, a_right, {AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON}.Operator_integer_ge)
			l_aspect.adopt_originate_expression (a_left)
			l_aspect.adopt_originate_expression (a_right)
			Result.force (l_aspect)

			create l_aspect.make_comparison (l_context_class, l_context_feature, l_written_class, 0, a_left, a_right, {AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON}.Operator_integer_lt)
			l_aspect.adopt_originate_expression (a_left)
			l_aspect.adopt_originate_expression (a_right)
			Result.force (l_aspect)

			create l_aspect.make_comparison (l_context_class, l_context_feature, l_written_class, 0, a_left, a_right, {AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON}.Operator_integer_le)
			l_aspect.adopt_originate_expression (a_left)
			l_aspect.adopt_originate_expression (a_right)
			Result.force (l_aspect)
		end


feature -- Status set

	set_current_expressions_monitored (a_expressions_monitored: like current_expressions_monitored)
			-- Set `current_expressions_monitored'.
		do
			current_expressions_monitored := a_expressions_monitored

			reset_builder
		end

feature{NONE} -- Cache

	last_built_skeleton_cache: like last_built_skeleton
			-- Cache for `last_built_skeleton'.

end
