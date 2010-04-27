note
	description: "An item in a state"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_EXPRESSION

inherit
	SHARED_TYPES

	DEBUG_OUTPUT

	HASHABLE

	REFACTORING_HELPER

	EPA_UTILITY

	EPA_TYPE_UTILITY

	SHARED_TEXT_ITEMS

feature -- Access

	feature_: detachable FEATURE_I
			-- Feature returning to which current expression belongs

	class_: CLASS_C
			-- Context class of `feature_'

	context_class: like class_
			-- Context class
		do
			Result := class_
		end

	text: STRING
			-- Expression text of current item
		deferred
		end

	text_in_context (a_context_class: CLASS_C): STRING
			-- Text viewed from `a_context_class',
			-- with all kinds of renaming resolved
		local
			l_class_ctxt: ETR_CLASS_CONTEXT
			l_src_ctxt: ETR_CONTEXT
			l_dest_ctxt: ETR_CONTEXT
			l_trans: ETR_TRANSFORMABLE
		do
			if attached{FEATURE_I} feature_ as l_feature then
				create l_class_ctxt.make (written_class)
				create {ETR_FEATURE_CONTEXT} l_src_ctxt.make (l_feature, l_class_ctxt)

				create l_class_ctxt.make (a_context_class)
				create {ETR_FEATURE_CONTEXT} l_dest_ctxt.make (a_context_class.feature_of_rout_id_set (l_feature.rout_id_set), l_class_ctxt)
			else
				create {ETR_CLASS_CONTEXT} l_src_ctxt.make (written_class)
				create {ETR_CLASS_CONTEXT} l_dest_ctxt.make (a_context_class)
			end

			create l_trans.make (ast, l_src_ctxt, True)
			Result := text_from_ast (l_trans.as_in_other_context (l_dest_ctxt).to_ast)
		ensure
			result_attached: Result /= Void
		end

	type: detachable TYPE_A
			-- Type of current state
			-- Should be a deanchered and resolved generic type.
		deferred
		end

	resolved_type: like type
			-- Resolved type for `type'.
			-- Should be the same as type if `type' is also resolved.
		do
			Result := resolved_type_in_context (type, context_class)
		end

	ast: EXPR_AS
			-- AST node for `text'
		require
			is_ast_available: is_ast_available
		deferred
		end

	written_class: CLASS_C
			-- Class where `ast' is written

	tag: detachable STRING
			-- Tag for current expression
			-- For example, an assertion can be associated with a tag

feature --Logic operations

	anded alias "and" (other: like Current): like Current
			-- Anded expression with `other': Current and other
		require
			current_is_predicate: is_predicate
			other_is_predicate: other.is_predicate
			same_context: has_same_context (other)
		do
			create {EPA_AST_EXPRESSION} Result.make_with_text (class_, feature_, "(" + text + ") and (" + other.text + ")", written_class)
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
			create {EPA_AST_EXPRESSION} Result.make_with_text (class_, feature_, "(" + text + ") or (" + other.text + ")", written_class)
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
			create {EPA_AST_EXPRESSION} Result.make_with_text (class_, feature_, "not (" + text + ")", written_class)
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
			create {EPA_AST_EXPRESSION} Result.make_with_text (class_, feature_, "(" + text + ") implies (" + other.text + ")", written_class)
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

	is_true_expression: BOOLEAN
			-- Does current expression represent "True"?
		do
		end

	is_false_expression: BOOLEAN
			-- Does current expression represent "False"?
		do
		end

	is_boolean: BOOLEAN
			-- Is Current expression of boolean type?
		do
			Result := type.is_boolean
		end

	is_integer: BOOLEAN
			-- Is Current expression of integer type?
		do
			Result := type.is_integer
		end

	is_reference: BOOLEAN
			-- Is Current expression of reference type?
		do
			Result := type.is_reference
		end

	is_result: BOOLEAN
			-- Does current expression "Result"?
		do
			Result := text.is_case_insensitive_equal (ti_result)
		end

	is_attribute: BOOLEAN
			-- Does current expression represent an attribute in `class_'?
		do
			if attached {FEATURE_I} class_.feature_named (text) as l_feat then
				Result := l_feat.is_attribute
			end
		end

	is_argument: BOOLEAN
			-- Does current expression represent a formal argument in `feature_'?
		do
			if attached {FEATURE_I} feature_ as l_feat then
				Result := arguments_of_feature (l_feat).has (text)
			end
		end

	is_local: BOOLEAN
			-- Does current expression represent a local in `feature_'?
		do
			if attached {FEATURE_I} feature_ as l_feat then
				Result := local_names_of_feature (l_feat).has (text)
			end
		end

	is_current: BOOLEAN
			-- Does current expressoin represent "Current"?
		do
			Result := text.is_case_insensitive_equal (ti_current)
		end

	is_require_else: BOOLEAN
			-- Is current expression from a require else clause?
			-- Default: False

	is_feature_set: BOOLEAN
			-- Is `feature_' set?
		do
			Result := attached {FEATURE_I} feature_
		end

	is_quantified: BOOLEAN
			-- Is Current expression quantified, either universal or existential?
		do
		end

	is_universal_quantified: BOOLEAN
			-- Is Current expression universally quantified?
		do
		end

	is_existential_quantified: BOOLEAN
			-- Is Current expression existentially quantified?
		do
		end

	has_old_inside_access: BOOLEAN
			-- Does any feature access subexpression contain an old expression?
			-- For example, this query returns True for expression "has (old item)",
			-- and returns False for expression "occurrences(v) = (old occurrences(v)) + 1".
			-- Becaues the first expression has a subexpression, "old item", which is an
			-- old expression and a subexpression inside a feature access expression "has".
			-- For the second expression, "old occurrences(v)" is an old expression,
			-- but it is not an subexpression inside a feature access expression.
		do
			check False end
			fixme ("Implement. 2.3.2010 Jasonw")
		end

	is_ast_available: BOOLEAN
			-- Is `ast' available?
		do
			Result := True
		end

	is_integer_constant: BOOLEAN
			-- Is Current an integer constant?
		do
			Result := text.is_integer
		end

	is_boolean_constant: BOOLEAN
			-- Is Current a boolean constant?
		do
			Result := text.is_boolean
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

	set_is_require_else (b: BOOLEAN) is
			-- Set `is_require_else' with `b'.
		do
			is_require_else := b
		ensure
			is_require_else_set: is_require_else = b
		end

	set_tag (a_tag: like tag)
			-- Set `tag' with `a_tag'.
			-- Make a new copy from `a_tag'.
		do
			if a_tag = Void then
				tag := "noname"
			else
				tag := a_tag.twin
			end
		end

feature -- Visitor/Process

	process (a_visitor: EPA_EXPRESSION_VISITOR)
			-- Process Current using `a_visitor'.
		deferred
		end

end
