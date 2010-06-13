note
	description: "Inferrer to infer sequential frame properties"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_SEQUENCE_PROPERTY_INFERRER

inherit
	CI_INFERRER
		redefine
			setup_data_structures
		end

	EPA_SHARED_MATH

	SHARED_TEXT_ITEMS

feature -- Basic operations

	infer (a_data: LINKED_LIST [CI_TEST_CASE_TRANSITION_INFO])
			-- Infer contracts from `a_data', which is transition data collected from
			-- executed test cases.					
		do
			transition_data := a_data.twin
			setup_data_structures
			calculate_sequences
		end

feature -- Access

	pre_state_sequences: DS_HASH_TABLE [DS_HASH_SET [CI_SEQUENCE [EPA_EXPRESSION_VALUE]], CI_TEST_CASE_TRANSITION_INFO]
			-- Sequences from pre-state
			-- Key of the hash table is test case, becuase from each test case, we can build a set of sequences.
			-- The elements of the hash set is sequences.

	post_state_sequences: DS_HASH_TABLE [DS_HASH_SET [CI_SEQUENCE [EPA_EXPRESSION_VALUE]], CI_TEST_CASE_TRANSITION_INFO]
			-- Sequences from post-state
			-- Key of the hash table is test case, becuase from each test case, we can build a set of sequences.
			-- The elements of the hash set is sequences.

	sequences: DS_HASH_TABLE [DS_HASH_SET [CI_SEQUENCE [EPA_EXPRESSION_VALUE]], CI_TEST_CASE_TRANSITION_INFO]
			-- Table of sequences from `transition_data'
			-- Key is test case, value is a set of sequences built from that test case, with pre-state and post-state
			-- sequences stored in one set.

feature{NONE} -- Implementation

	setup_data_structures
			-- Setup data structures.
		do
			Precursor
			create sequences.make (10)
			sequences.set_key_equality_tester (ci_test_case_transition_info_equality_tester)

			create pre_state_sequences.make (10)
			pre_state_sequences.set_key_equality_tester (ci_test_case_transition_info_equality_tester)

			create post_state_sequences.make (10)
			post_state_sequences.set_key_equality_tester (ci_test_case_transition_info_equality_tester)

			create evaluator
		end

	calculate_sequences
			-- Calculate `pre_state_sequences', `post_state_sequences' and `sequences'
			-- from `transition_data'.
		do
			across transition_data as l_transition loop
				log_message (once "Analyzing sequences for test case: " + l_transition.item.test_case_info.test_case_class.name_in_upper, True, True)
				calculate_sequences_from_test_case (l_transition.item, True)
				calculate_sequences_from_test_case (l_transition.item, False)
			end
		end

	calculate_sequences_from_test_case (a_tc_info: CI_TEST_CASE_TRANSITION_INFO; a_pre_state: BOOLEAN)
			-- Calculate sequences from `a_tc_info' and store results in `sequences'.
		local
			l_funcs_cur: DS_HASH_SET_CURSOR [CI_FUNCTION_WITH_INTEGER_DOMAIN]
			l_sequence: like sequence_from_integer_bounded_function
			l_seq_set: DS_HASH_SET [CI_SEQUENCE [EPA_EXPRESSION_VALUE]]
			l_sequences: detachable like sequences
			l_operand_types: like resolved_operand_types_with_feature
			l_sequence_type: TYPE_A
			l_opd_types: DS_HASH_TABLE_CURSOR [TYPE_A, INTEGER]
			l_opd_type: TYPE_A
			l_opd_sequence: CI_SEQUENCE [EPA_EXPRESSION_VALUE]
			l_evaluator: like evaluator
			l_var_name: STRING
			l_opd_value: LINKED_LIST [EPA_EXPRESSION_VALUE]
		do
			l_operand_types := resolved_operand_types_with_feature (feature_under_test, class_under_test, class_under_test.constraint_actual_type)
			l_evaluator := evaluator
			l_sequences := sequences
			from
				l_funcs_cur := a_tc_info.integer_bounded_functions [a_pre_state].new_cursor
				l_funcs_cur.start
			until
				l_funcs_cur.after
			loop
				l_sequences.search (a_tc_info)
				if l_sequences.found then
					l_seq_set := l_sequences.found_item
				else
					create l_seq_set.make (5)
					l_seq_set.set_equality_tester (ci_sequence_equality_tester)
					l_sequences.force_last (l_seq_set, a_tc_info)
				end
					-- Construct the sequence.
				l_sequence := sequence_from_integer_bounded_function (l_funcs_cur.item, a_tc_info, a_pre_state)
				if l_sequence /= Void and then not l_seq_set.has (l_sequence) then
					log_message (once "%T Found sequence: " + text_of_sequence (l_sequence), False, True)
					l_seq_set.force_last (l_sequence)

						-- Check if some operand of `feature_under_test' can form a single element sequence too.
					l_sequence_type := l_funcs_cur.item.result_type
					from
						l_opd_types := l_operand_types.new_cursor
						l_opd_types.start
					until
						l_opd_types.after
					loop
						l_opd_type := l_opd_types.item
						if l_opd_type.same_type (l_sequence_type) and then l_opd_type.is_equivalent (l_sequence_type) then
							l_var_name := a_tc_info.transition.reversed_variable_position.item (l_opd_types.key).text
							if a_pre_state then
								l_evaluator.evaluate_string (once "old " + l_var_name, a_tc_info)
							else
								l_evaluator.evaluate_string (l_var_name, a_tc_info)
							end
							if not l_evaluator.has_error then
								create l_opd_value.make
								l_opd_value.extend (l_evaluator.last_value)
								create l_opd_sequence.make (l_opd_value, l_var_name, ti_current, a_pre_state, a_tc_info.transition.context)
									-- Found a new single element sequence made from an operand variable.
								if not l_seq_set.has (l_opd_sequence) then
									log_message (once "%T Found sequence: " + text_of_sequence (l_opd_sequence), False, True)
									l_seq_set.force_last (l_opd_sequence)
								end
							end
						end
						l_opd_types.forth
					end
				end
				l_funcs_cur.forth
			end
		end

	text_of_sequence (a_sequence: CI_SEQUENCE [EPA_EXPRESSION_VALUE]): STRING
			-- Text of `a_sequence'
		do
			create Result.make (64)
			Result.append (a_sequence.out)
			if Result.item (1) = '[' then
				Result.prepend (once "    ")
			end
		end

	sequence_from_integer_bounded_function (a_function: CI_FUNCTION_WITH_INTEGER_DOMAIN; a_tc_info: CI_TEST_CASE_TRANSITION_INFO; a_pre_state: BOOLEAN): detachable CI_SEQUENCE [EPA_EXPRESSION_VALUE]
			-- Sequence from `a_function' evaluated in `a_tc_info'.
			-- `a_pre_state' indicates if the evaluation is done in pre- or post- test case execution state.
			-- From `a_function', we can build a sequence containing all the elements in the range of `a_function'.
			-- Those elements are retrieved from the evaluation pool in `a_tc_info' (if `a_pre_state' it is the pre-state evaluations,
			-- otherwise, post-state evaluations).
			-- If there is an problem with any of the element, the result will be Void.
		local
			l_template: STRING
			l_expr_text: STRING
			l_evaluator: like evaluator
			l_expr: AST_EIFFEL
			l_values: LINKED_LIST [EPA_EXPRESSION_VALUE]
			l_has_error: BOOLEAN
			i: INTEGER
			l_upper: INTEGER
			l_sequence: CI_SEQUENCE [EPA_EXPRESSION_VALUE]
		do
				-- Construct expression used to get an element of a sequence.
			create l_template.make (64)
			if a_pre_state then
				l_template.append (ti_old_keyword)
				l_template.append_character (' ')
			end
			l_template.append (a_function.target_variable_name)
			l_template.append_character ('.')
			l_template.append (a_function.function_name)
			l_template.append (once " (")

				-- Iterate through all integers in range to retrieve the corresponding values,
				-- and store those values in `l_values' in the same order.
			l_evaluator := evaluator
			create l_values.make
			from
				i := a_function.lower_bound
				l_upper := a_function.upper_bound
			until
				i > l_upper or else l_has_error
			loop
					-- Construct expression to retrieve an element.					
				create l_expr_text.make (64)
				l_expr_text.append (l_template)
				l_expr_text.append_integer (i)
				l_expr_text.append_character (')')

					-- Evaluate expression.
				l_evaluator.evaluate_string (l_expr_text, a_tc_info)
				l_has_error := l_evaluator.has_error
				if not l_has_error then
					l_values.extend (l_evaluator.last_value)
				else
					log_message (once "%T" + l_evaluator.error_reason, False, True)
				end
				i := i + 1
			end
			if not l_has_error then
				create Result.make_from_function (a_function, a_pre_state, l_values)
			end
		end

feature{NONE} -- Implementation

	evaluator: CI_EXPRESSION_EVALUATOR
			-- Expression evaluator

	log_message (a_message: STRING; a_time: BOOLEAN; a_new_line: BOOLEAN)
			-- Log `a_message' with time if `a_time' is True.
			-- Put a new line into the log if `a_new_line' is True.
		do
			logger.push_level ({EPA_LOG_MANAGER}.fine_level)
			if a_new_line then
				if a_time then
					logger.put_line_with_time (a_message)
				else
					logger.put_line (a_message)
				end
			else
				if a_time then
					logger.put_string_with_time (a_message)
				else
					logger.put_string (a_message)
				end
			end
			logger.pop_level
		end

end
