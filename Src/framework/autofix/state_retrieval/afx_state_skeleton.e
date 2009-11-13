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
			l_simplifer: AFX_STATE_SIMPLIFIER
		do
			create l_simplifer
			l_simplifer.simplify (Current)
			Result := l_simplifer.last_state
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

feature -- Status report

	implication alias "implies" (other: like Current): BOOLEAN
			-- Does Current implies `other'?
			-- The `theory' will be used to support the reasoning.
		local
			l_skeleton: AFX_STATE_SKELETON
			l_other_skeleton: AFX_STATE_SKELETON
		do
			smtlib_generator.generate_for_implied_checking (linear_representation, other.linear_representation, theory)
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

end
