note
	description: "State of a class"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_STATE_SKELETON

inherit
	DS_HASH_SET [AFX_EXPRESSION]

	AUT_OBJECT_STATE_REQUEST_UTILITY
		undefine
			is_equal,
			copy
		end

	SHARED_WORKBENCH
		undefine
			is_equal,
			copy
		end

	AFX_SHARED_SMTLIB_GENERATOR
		undefine
			is_equal,
			copy
		end

create
	make_with_basic_argumentless_query,
	make_with_accesses,
	make_with_expressions,
	make_basic

convert
	linear_representation: {LINEAR [AFX_EXPRESSION]}

feature{NONE} -- Initialization

	make_with_basic_argumentless_query (a_class: CLASS_C)
			-- Initialize Current with argumentless
			-- qureies of basic types in `a_class'.
		local
			l_queries: LIST [FEATURE_I]
			l_item: AFX_AST_EXPRESSION
		do
			l_queries := supported_queries_of_type (a_class.actual_type)
			make_basic (class_, Void, l_queries.count)
			from
				l_queries.start
			until
				l_queries.after
			loop
				create l_item.make_with_text (a_class, l_queries.item_for_iteration, l_queries.item_for_iteration.feature_name, a_class)
				force_last (l_item)
				l_queries.forth
			end
		end

	make_with_accesses (a_class: like class_; a_feature: like feature_; a_accesses: LIST [AFX_ACCESS])
			-- Initialize Current with `a_accesses'.
		local
			l_cursor: CURSOR
			l_expr: AFX_EXPRESSION
		do
			make_basic (a_class, a_feature, a_accesses.count)

			l_cursor := a_accesses.cursor
			from
				a_accesses.start
			until
				a_accesses.after
			loop
				l_expr := a_accesses.item_for_iteration.expression
				force_last (l_expr)
				a_accesses.forth
			end
			a_accesses.go_to (l_cursor)
		end

	make_with_expressions (a_class: like class_; a_feature: like feature_; a_expressions: LIST [AFX_EXPRESSION])
			-- Initialize current with `a_expressions'.
		do
			make_basic (a_class, a_feature, a_expressions.count)
			a_expressions.do_all (agent force_last)
		end

	make_basic (a_class: like class_; a_feature: like feature_; a_count: INTEGER)
			-- Initialize Current.
		do
			set_class (a_class)
			set_feature (a_feature)
			set_equality_tester (create {AFX_EXPRESSION_EQUALITY_TESTER})
			make (a_count)
		end

feature -- Access

	class_: CLASS_C
			-- Class whose state Current presents

	feature_: detachable FEATURE_I
			-- Feature whose state Curernt presents
			-- If Void, it means that Current presents the state
			-- for `class_', not for a particular feature.

feature -- Status report

	is_for_class: BOOLEAN
			-- Does current represent state of a class?
		do
			Result := feature_ = Void
		ensure
			good_result: Result = feature_ = Void
		end

	is_for_feature: BOOLEAN
			-- Does current represent state of a feature?
		do
			Result := feature_ /= Void
		ensure
			good_result: Result = (feature_ /= Void)
		end

feature -- Access

	smtlib_expressions: DS_HASH_TABLE [AFX_SMTLIB_EXPR, AFX_EXPRESSION]
			-- Table of SMTLIB representation for items in Current skeleton
			-- Key is items in Current, value is its SMTLIB representation.
		do
			if smtlib_expressions_cache = Void then
				calculate_smtlib_expressions
			end
			Result := smtlib_expressions_cache
		end

	theory: AFX_THEORY
			-- SMTLIB theory for current skeleton needed for reasoning about `smtlib_expressions'
		do
			if theory_cache = Void then
				calculate_smtlib_expressions
			end
			Result := theory_cache
		end

	simplified: like Current
			-- Simplified version of Current
		local
			l_simplifer: AFX_STATE_SKELETON_SIMPLIFIER
		do
			create l_simplifer
			l_simplifer.simplify (Current)
			Result := l_simplifer.last_skeleton
		end

	linear_representation: LINEAR [AFX_EXPRESSION]
			-- List representation of Current
		local
			l_list: LINKED_LIST [AFX_EXPRESSION]
		do
			create l_list.make
			do_all (agent l_list.extend)
			Result := l_list
		end

	slices (n: INTEGER): LINKED_LIST [AFX_STATE_SKELETON]
			-- Split current skeleton into `n' approximately equally large slices
			-- and return those slices.
		require
			n_positive: n > 0
		local
			l_slice_size: INTEGER
			i, j: INTEGER
			l_cursor: DS_HASH_SET_CURSOR [AFX_EXPRESSION]
			l_cur_slice: LINKED_LIST [AFX_EXPRESSION]
		do
			l_slice_size := count // n
			from
				create l_cur_slice.make
				l_cursor := new_cursor
				l_cursor.start
				i := 0
				j := 1
			until
				l_cursor.after
			loop
				l_cur_slice.extend (l_cursor.item)
				i := i + 1
				if i = l_slice_size and then j < n then
					Result.extend (create{like Current}.make_with_expressions (class_, feature_, l_cur_slice))
					create l_cur_slice.make
					i := 0
					j := j + 1
				end
				l_cursor.forth
			end
		ensure
			good_result: Result.count = n
		end

	minimal_premises (a_predicate: AFX_EXPRESSION): detachable like Current
			-- The minimal subset of Current which implies `a_predicate'
			-- If no such subset is found, return Void.
		require
			a_predicate_valid: a_predicate.is_predicate
		do
			Result := minimal_premises_with_context (a_predicate, Void)
		ensure
			good_result: Result /= Void implies Result.count <= count
		end

	minimal_premises_with_context (a_predicate: AFX_EXPRESSION; a_context: detachable like Current): detachable like Current
			-- The minimal subset of Current which, when accompanied with `a_context,
			-- implies `a_predicate': Result ^ a_context -> a_predicate
			-- If no such subset is found, return Void.
		require
			a_predicate_valid: a_predicate.is_predicate
		local
			l_simplifier: AFX_STATE_SKELETON_SIMPLIFIER
		do
			create l_simplifier
			l_simplifier.minimize_premises (Current, a_predicate, a_context)
			Result := l_simplifier.last_skeleton
		ensure
			good_result: Result /= Void implies Result.count <= count
		end

feature -- Status report

	implication alias "implies" (other: like Current): BOOLEAN
			-- Does Current implies `other'?
			-- `theory' in Current and `other' will be used to support the reasoning.
		do
			smtlib_generator.generate_for_implied_checking (linear_representation, other.linear_representation, theory + other.theory)
			Result := z3_launcher.is_unsat (smtlib_generator.last_smtlib)
		end

feature -- Setting

	set_class (a_class: like class_)
			-- Set `class_' with `a_class'.
		do
			class_ := a_class
		ensure
			class_set: class_ = a_class
		end

	set_feature (a_feature: like feature_)
			-- Set `feature_' with `a_feature'.
		do
			feature_ := a_feature
		ensure
			feature_set: feature_ = a_feature
		end

feature{NONE} -- Implementation

	smtlib_expressions_cache: detachable like smtlib_expressions
			-- Cache for `smtlib_expressions'

	theory_cache: detachable like theory
			-- Cache for `theory'

	calculate_smtlib_expressions
			-- Calculate `smtlib_expressions'.
		local
			l_data: TUPLE [exprs: DS_HASH_TABLE [AFX_SMTLIB_EXPR, AFX_EXPRESSION]; theory: AFX_THEORY]
		do
			l_data := (create {AFX_SHARED_CLASS_THEORY}).expressions_with_theory (linear_representation, class_, feature_)
			smtlib_expressions_cache := l_data.exprs
			theory_cache := l_data.theory
		end

invariant
	all_predicates: for_all (agent (a_expr: AFX_EXPRESSION): BOOLEAN do Result := a_expr.is_predicate end)

end
