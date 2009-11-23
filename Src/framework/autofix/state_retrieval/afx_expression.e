note
	description: "An item in a state"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_EXPRESSION

inherit
	SHARED_TYPES

	DEBUG_OUTPUT

	HASHABLE

	REFACTORING_HELPER

	AFX_SOLVER_FACTORY

feature -- Access

	feature_: FEATURE_I
			-- Feature returning the integer

	class_: CLASS_C
			-- Context lass of `feature_'

	text: STRING
			-- Expression text of current item
		deferred
		end

	type: detachable TYPE_A
			-- Type of current state
			-- Should be a deanchered and resolved generic type.
		deferred
		end

	ast: EXPR_AS
			-- AST node for `text'
		deferred
		end

	written_class: CLASS_C
			-- Class where `ast' is written

	as_solver_expression: AFX_SOLVER_EXPR
			-- SMTLIB expression for Current.
		local
			l_resolved: TUPLE [resolved_str: STRING; mentioned_classes: DS_HASH_SET [AFX_CLASS_WITH_PREFIX]]
			l_shared_theory: AFX_SHARED_CLASS_THEORY
			l_raw_text: STRING
		do
			create l_shared_theory
			l_shared_theory.smtlib_generator.initialize_for_generation
			l_shared_theory.smtlib_generator.generate_expression (ast, class_, written_class, feature_)
			l_raw_text := l_shared_theory.smtlib_generator.last_statements.first
			l_resolved := l_shared_theory.resolved_smt_statement (l_raw_text, create {AFX_CLASS_WITH_PREFIX}.make (class_, ""))
			Result := new_solver_expression_from_string (l_resolved.resolved_str)
		end

	as_skeleton: AFX_STATE_SKELETON
			-- Skeleton representation for Current
		require
			is_predicate: is_predicate
		local
			l_exprs: LINKED_LIST [AFX_EXPRESSION]
		do
			create l_exprs.make
			l_exprs.extend (Current)

			create Result.make_with_expressions (class_, feature_, l_exprs)
		end

	equation (a_value: AFX_EXPRESSION_VALUE): AFX_EQUATION
			-- Equation with current as expression and `a_value' as value.
		do
			create Result.make (Current, a_value)
		end

	equation_with_random_value: AFX_EQUATION
			-- Equation with current as expression, with a randomly
			-- assigned value.
		local
			l_value: AFX_EXPRESSION_VALUE
		do
			if type.is_boolean then
				create {AFX_RANDOM_BOOLEAN_VALUE} l_value.make
			elseif type.is_integer then
				create {AFX_RANDOM_INTEGER_VALUE} l_value.make
			else
				check not_supported_yet: False end
				to_implement ("Implement random value for other types.")
			end

			Result := equation (l_value)
		ensure
			value_is_random: Result.value.is_random
		end

feature -- Status report

	is_valid: BOOLEAN
			-- Is current item valid?
			-- Note: If at some point, current state item is not evaluable,
			-- then it is_valid is False.
		deferred
		end

	is_predicate: BOOLEAN
			-- Is Current a predicate?
		do
			Result := type.is_boolean
		ensure
			good_result: Result = type.is_boolean
		end

feature -- Setting

	set_feature (a_feature: like feature_)
			-- Set `feature_' with `a_feature'.
		do
			feature_ := a_feature
		ensure
			feature_set: feature_ = a_feature
		end

	set_class (a_class: like class_)
			-- Set `class_' with `a_class'.
		do
			class_ := a_class
		ensure
			class_set: class_ = a_class
		end

	set_written_class (a_written_class: like written_class)
			-- Set `written_class_' with `a_written_class'.
		do
			written_class := a_written_class
		ensure
			written_class_set: written_class = a_written_class
		end

end
