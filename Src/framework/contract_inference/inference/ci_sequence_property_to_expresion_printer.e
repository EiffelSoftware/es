note
	description: "Printer to output sequence-based contracts into a more readable format"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_SEQUENCE_PROPERTY_TO_EXPRESION_PRINTER

inherit
	EPA_UTILITY

	EPA_SHARED_EQUALITY_TESTERS

	CI_SEQUENCE_OPERATOR_NAMES

	INTERNAL_COMPILER_STRING_EXPORTER

	EPA_STRING_UTILITY

	SHARED_TYPES

feature -- Access

	last_expressions: DS_HASH_SET [EPA_EXPRESSION]
		-- Expressions output by last `generate'

feature -- Basic operations

	generate (a_assertion: STRING; a_inferrer: like inferrer)
			-- Print `a_assertion' into a more readable format and
			-- store result in `last_expressions'.
		do
			create last_expressions.make (10)
			last_expressions.set_equality_tester (expression_equality_tester)
			inferrer := a_inferrer
			feature_ := inferrer.feature_under_test
			class_ := inferrer.class_under_test

				-- Detect the type of sequence property
			processed_element_count := 0
			if a_assertion.has_substring (sequence_is_prefix_of_bin_operator) then
				generate_for_is_prefix_of (a_assertion)
			end
		end

feature{NONE} -- Implementation

	feature_: FEATURE_I
			-- Feature whose contracts are to be printed

	class_: CLASS_C
			-- Class where `feature_' is viewed

	inferrer: CI_SEQUENCE_PROPERTY_INFERRER
			-- Sequence property inferrer

	processed_element_count: INTEGER
			-- Number of process elements

	left_hand_sides: LINKED_LIST [STRING]
			-- Components on the left hand side of |=|

	right_hand_side: STRING
			-- Components on the right hand side of |=|

feature{NONE} -- Implementation

	generate_for_is_empty (a_assertion: STRING)
			-- Generate `last_expressions' from `a_assertion'.
		require
			a_assertion.has_substring (sequence_is_empty_un_operator)
		do
			if attached {UN_FREE_AS} ast_from_expression_text (a_assertion) as l_empty_un then

			end
		end

	generate_for_is_prefix_of (a_assertion: STRING)
			-- Generate `last_expressios' from `a_assertion'.
		require
			a_assertion.has_substring (sequence_is_prefix_of_bin_operator)
		local
			l_left, l_right: STRING
			l_parts: LIST [STRING]
		do
			create left_hand_sides.make
			l_parts := string_slices (a_assertion, sequence_is_prefix_of_bin_operator)
			from
				l_parts.start
			until
				l_parts.after
			loop
				l_parts.item.left_adjust
				l_parts.item.right_adjust
				if l_parts.item.item (1) = '(' then
					l_parts.item.remove_head (1)
					l_parts.item.remove_tail (1)
				end
				l_parts.forth
			end
		end

	item_function (a_signature: CI_SEQUENCE_SIGNATURE; a_pre_state: BOOLEAN; a_index: STRING): EPA_FUNCTION
			-- Function to access the `a_index'-th element in the sequence specified by `a_signature'
			-- `a_pre_state' indicates if the access is found pre-state or post-state.
		local
			l_body: STRING
		do
			create l_body.make (32)
			if a_pre_state then
				l_body.append (once "old ")
			end
			l_body.append (operand_name_index_with_feature (feature_, class_).item (a_signature.target_variable_index).twin)
			if not a_signature.is_special then
				l_body.append_character ('.')
				l_body.append (a_signature.function_name)
				l_body.append_character (' ')
				l_body.append_character ('(')
				l_body.append (a_index.out)
				l_body.append_character (')')
			end
		end

	lower_bound_function (a_signature: CI_SEQUENCE_SIGNATURE; a_pre_state: BOOLEAN): EPA_FUNCTION
			-- Function to access the lower bound of the sequence with `a_signature'
			-- `a_pre_state' indicates if the access is found pre-state or post-state.
		do
			Result := bound_function (a_signature, True, a_pre_state)
		end

	upper_bound_function (a_signature: CI_SEQUENCE_SIGNATURE; a_pre_state: BOOLEAN): EPA_FUNCTION
			-- Function to access the upper bound of the sequence with `a_signature'
			-- `a_pre_state' indicates if the access is found pre-state or post-state.
		do
			Result := bound_function (a_signature, False, a_pre_state)
		end

	bound_function (a_signature: CI_SEQUENCE_SIGNATURE; a_lower_bound: BOOLEAN; a_pre_state: BOOLEAN): EPA_FUNCTION
			-- Function to access the lower bound of the sequence with `a_signature' if `a_lower_bound' is True,
			-- otherwise, upper bound.
			-- `a_pre_state' indicates if the access is found pre-state or post-state.
		require
			not_a_signature_is_special: not a_signature.is_special
		local
			l_body: STRING
			l_bound: detachable STRING
			l_expr: EPA_AST_EXPRESSION
		do
			if a_lower_bound then
				l_bound := a_signature.lower_bound_expression
			else
				l_bound := a_signature.upper_bound_expression
			end
			check l_bound /= Void end
			if l_bound.is_integer then
				l_body.append (l_bound)
			else
				l_body.append ("(")
				l_body.append (operand_name_index_with_feature (feature_, class_).item (a_signature.target_variable_index))
				l_body.append (".")
				l_body.append (l_bound)
				l_body.append (")")
				if a_pre_state then
					l_body.prepend ("old (")
					l_body.append (")")
				end
			end
			create l_expr.make_with_text (class_, feature_, l_body, class_)
			create Result.make_from_expression (l_expr)
		end

	signature_from_tuple (a_tuple: TUPLE_AS): CI_SEQUENCE_SIGNATURE
			-- Sequence signature from `a_tuple'
		local
			l_opd_types: like resolved_operand_types_with_feature
		do
			check a_tuple.expressions.count = 2 end
			check
				attached {INTEGER_AS} a_tuple.expressions.first as l_integer and then
				attached {STRING_AS} a_tuple.expressions.last as l_string
			then
				l_opd_types := resolved_operand_types_with_feature (feature_, class_, class_.constraint_actual_type)
				create Result.make (l_integer.integer_32_value, l_string.value, l_opd_types.item (l_integer.integer_32_value).associated_class.feature_named (l_string.value).type, "1", "1")
			end
		end

feature{NONE} -- Process



end
