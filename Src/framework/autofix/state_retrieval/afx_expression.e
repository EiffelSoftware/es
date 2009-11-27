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
			-- Feature returning to which current expression belongs

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
			l_shared_theory.solver_expression_generator.initialize_for_generation
			l_shared_theory.solver_expression_generator.generate_expression (ast, class_, written_class, feature_)
			l_raw_text := l_shared_theory.solver_expression_generator.last_statements.first
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

feature --Logic operations

	anded alias "and" (other: like Current): like Current
			-- Anded expression with `other': Current and other
		require
			current_is_predicate: is_predicate
			other_is_predicate: other.is_predicate
			same_context: has_same_context (other)
		do
			create {AFX_AST_EXPRESSION} Result.make_with_text (class_, feature_, "(" + text + ") and (" + other.text + ")", written_class)
		ensure
			same_context: has_same_context (Result)
			text_correct: Result.text ~ "(" + text + ") and (" + other.text + ")"
			result_is_predicate: Result.is_predicate
		end

	ored alias "or" (other: like Current): like Current
			-- Ored expression with `other': Current or other
		require
			current_is_predicate: is_predicate
			other_is_predicate: other.is_predicate
			same_context: has_same_context (other)
		do
			create {AFX_AST_EXPRESSION} Result.make_with_text (class_, feature_, "(" + text + ") or (" + other.text + ")", written_class)
		ensure
			same_context: has_same_context (Result)
			text_correct: Result.text ~ "(" + text + ") or (" + other.text + ")"
			result_is_predicate: Result.is_predicate
		end

	negated alias "not": like Current
			-- Negation: not Current
		require
			current_is_predicate: is_predicate
		do
			create {AFX_AST_EXPRESSION} Result.make_with_text (class_, feature_, "not (" + text + ")", written_class)
		ensure
			same_context: has_same_context (Result)
			text_correct: Result.text ~ "not (" + text + ")"
			result_is_predicate: Result.is_predicate
		end

	implication alias "implies" (other: like Current): like Current
			-- Implication expression with `other': Current implies other
		require
			current_is_predicate: is_predicate
			other_is_predicate: other.is_predicate
			same_context: has_same_context (other)
		do
			create {AFX_AST_EXPRESSION} Result.make_with_text (class_, feature_, "(" + text + ") implies (" + other.text + ")", written_class)
		ensure
			same_context: has_same_context (Result)
			text_correct: Result.text ~ "(" + text + ") implies (" + other.text + ")"
			result_is_predicate: Result.is_predicate
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

	has_same_context (other: like Current): BOOLEAN
			-- Does `other' have the same context as Current?
		do
			Result := class_.class_id = other.class_.class_id
			if Result then
				Result :=
					(feature_ = Void implies other.feature_ = Void) and
					(feature_ /= Void implies other.feature_ /= Void)
				if Result and then feature_ /= Void then
					Result := feature_.equiv (other.feature_)
				end
			end
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
