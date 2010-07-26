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

	CI_SEQUENCE_OPERATOR_NAMES

	EPA_ACCESS_AGENT_UTILITY

feature -- Basic operations

	infer (a_data: like data)
			-- Infer contracts from `a_data', which is transition data collected from
			-- executed test cases.	
		local
			l_cursor: DS_HASH_SET_CURSOR [STRING]
		do
			logger.put_line_with_time_at_info_level ("Start analyzing sequence-based frame properties.")
			data := a_data
			setup_data_structures
			calculate_sequences
			calculate_integer_queries
			check_sequence_consistency
			if is_sequence_consistent then
				generate_is_empty_properties

				generate_boolean_binary_properties (
					signature_set (True, False, True, False),
					signature_set (False, False, True, False),
					<<sequence_is_equal_bin_operator>>, False)

				generate_boolean_binary_properties (
					signature_set (True, False, True, False),
					signature_set (False, False, True, False),
					<<sequence_is_prefix_of_bin_operator>>, True)

				generate_binary_properties (
					signature_set (True, True, True, True),
					signature_set (True, True, True, True),
					signature_set (False, False, True, False),
					<<sequence_concatenation_bin_operator>>, True)

				generate_2_sequences_and_1_integer_properties

				generate_3_sequences_and_1_integer_properties

				log_properties ("Built property candidates:", properties)

					-- Validate property candidates.
				validate_properties
				log_properties ("Valid sequenced-based properties:", properties)

				create last_preconditions.make (10)
				last_preconditions.set_equality_tester (expression_equality_tester)
				create last_postconditions.make (10)
				last_postconditions.set_equality_tester (expression_equality_tester)
				setup_last_contracts
			end
		end

feature -- Access

	pre_state_sequences: DS_HASH_TABLE [DS_HASH_TABLE [CI_SEQUENCE [EPA_EXPRESSION_VALUE], CI_SEQUENCE_SIGNATURE], CI_TEST_CASE_TRANSITION_INFO]
			-- Sequences from pre-state
			-- Key of the hash table is test case, becuase from each test case, we can build a set of sequences.
			-- The elements of the hash set is sequences.

	post_state_sequences: DS_HASH_TABLE [DS_HASH_TABLE [CI_SEQUENCE [EPA_EXPRESSION_VALUE], CI_SEQUENCE_SIGNATURE], CI_TEST_CASE_TRANSITION_INFO]
			-- Sequences from post-state
			-- Key of the hash table is test case, becuase from each test case, we can build a set of sequences.
			-- The elements of the hash set is sequences.

	sequences: DS_HASH_TABLE [HASH_TABLE [DS_HASH_TABLE [CI_SEQUENCE [EPA_EXPRESSION_VALUE], CI_SEQUENCE_SIGNATURE], BOOLEAN], CI_TEST_CASE_TRANSITION_INFO]
			-- Table of sequences from `transition_data'
			-- Key of the outer table is test case, value is a table of sequences built from that test case, with pre-state and post-state
			-- sequences stored in one set.
			-- Key of the inner table is a boolean indicating if pre-state or post-state, value is a set of sequences in that state.

	sequences_as_state (a_tc_info: CI_TEST_CASE_TRANSITION_INFO; a_pre_state: BOOLEAN): EPA_STATE
			-- State represention for `pre_state_sequences' in the context of `a_tc_info'.
			-- `a_pre_state' indicate if sequences are from pre- or post-state.
		local
			l_sequences: DS_HASH_TABLE_CURSOR [CI_SEQUENCE [EPA_EXPRESSION_VALUE], CI_SEQUENCE_SIGNATURE]
			l_expr: EPA_AST_EXPRESSION
			l_value: EPA_ANY_VALUE
			l_class: CLASS_C
			l_feature: FEATURE_I
		do
			l_class := a_tc_info.transition.context.class_
			l_feature := a_tc_info.transition.context.feature_
			create Result.make (10, l_class, l_feature)
			from
				l_sequences := sequences.item (a_tc_info).item (a_pre_state).new_cursor
				l_sequences.start
			until
				l_sequences.after
			loop
				create l_value.make (l_sequences.item)
				create l_expr.make_with_text (l_class, l_feature, l_sequences.key.out, l_class)
				Result.force_last (create {EPA_EQUATION}.make (l_expr, l_value))
				l_sequences.forth
			end
		end

	pre_state_signatures: DS_HASH_SET [CI_SEQUENCE_SIGNATURE]
			-- Sequence signatures in pre-state

	post_state_signatures: DS_HASH_SET [CI_SEQUENCE_SIGNATURE]
			-- Sequence signatures in post-state

	signatures: HASH_TABLE [DS_HASH_SET [CI_SEQUENCE_SIGNATURE], BOOLEAN]
			-- Sequence signatures
			-- Key is a boolean indicating pre- and post-state
			-- Value is the set of sequence signatures in that state

	pre_state_properties: DS_HASH_SET [STRING]
			-- Inferred properties in pre-state

	post_state_properties: DS_HASH_SET [STRING]
			-- Inferred properties in post-state

	properties: HASH_TABLE [DS_HASH_SET [STRING], BOOLEAN]
			-- Inferred properties
			-- Key is a boolean indicating pre- or post-state
			-- Value is a set of properties inferred in that state.

	non_special_pre_state_signatures: like pre_state_signatures
			-- Non-special sequence signatures in pre-state
			-- Note: new calculation per invocation.
		do
			create Result.make (10)
			Result.set_equality_tester (ci_sequence_signature_equality_tester)
			pre_state_signatures.do_if (
				agent Result.force_last,
				agent (a_sig: CI_SEQUENCE_SIGNATURE): BOOLEAN do Result := not a_sig.is_special end)
		end

	non_special_post_state_signatures: like pre_state_signatures
			-- Non-special sequence signatures in post-state
			-- Note: new calculation per invocation.
		do
			create Result.make (10)
			Result.set_equality_tester (ci_sequence_signature_equality_tester)
			post_state_signatures.do_if (
				agent Result.force_last,
				agent (a_sig: CI_SEQUENCE_SIGNATURE): BOOLEAN do Result := not a_sig.is_special end)
		end

feature -- Status report

	is_sequence_consistent: BOOLEAN
			-- Is sequences in `pre_state_sequences'/`post_state_sequences' consistent across all test cases?

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

			create pre_state_properties.make (50)
			pre_state_properties.set_equality_tester (string_equality_tester)
			create post_state_properties.make (50)
			post_state_properties.set_equality_tester (string_equality_tester)
			create properties.make (2)
			properties.put (pre_state_properties, True)
			properties.put (post_state_properties, False)

			create pre_state_signatures.make (10)
			pre_state_signatures.set_equality_tester (ci_sequence_signature_equality_tester)
			create post_state_signatures.make (10)
			post_state_signatures.set_equality_tester (ci_sequence_signature_equality_tester)
			create signatures.make (2)
			signatures.put (pre_state_signatures, True)
			signatures.put (post_state_signatures, False)

			create evaluator
		end

	calculate_sequences
			-- Calculate `pre_state_sequences', `post_state_sequences' and `sequences'
			-- from `transition_data'.
		local
			l_cursor: like sequences.new_cursor
		do
			across transition_data as l_transition loop
				log_message (once "Analyzing sequences for test case: " + l_transition.item.test_case_info.test_case_class.name_in_upper, True, True)
				calculate_sequences_from_test_case (l_transition.item, True)
				calculate_sequences_from_test_case (l_transition.item, False)
			end

				-- Setup `pre_state_sequences' and `post_state_sequences'.
			from
				l_cursor := sequences.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				pre_state_sequences.force (l_cursor.item.item (True), l_cursor.key)
				post_state_sequences.force (l_cursor.item.item (False), l_cursor.key)
				l_cursor.forth
			end
		end

	calculate_sequences_from_test_case (a_tc_info: CI_TEST_CASE_TRANSITION_INFO; a_pre_state: BOOLEAN)
			-- Calculate sequences from `a_tc_info' and store results in `sequences'.
		local
			l_funcs_cur: DS_HASH_SET_CURSOR [CI_FUNCTION_WITH_INTEGER_DOMAIN]
			l_sequence: like sequence_from_integer_bounded_function
			l_seq_set: DS_HASH_TABLE [CI_SEQUENCE [EPA_EXPRESSION_VALUE], CI_SEQUENCE_SIGNATURE]
			l_sequences: detachable like sequences
			l_operand_types: like resolved_operand_types_with_feature
			l_sequence_type: TYPE_A
			l_opd_types: DS_HASH_TABLE_CURSOR [TYPE_A, INTEGER]
			l_opd_type: TYPE_A
			l_opd_sequence: CI_SEQUENCE [EPA_EXPRESSION_VALUE]
			l_evaluator: like evaluator
			l_var_name: STRING
			l_opd_value: LINKED_LIST [EPA_EXPRESSION_VALUE]
			l_seq_tbl: HASH_TABLE [DS_HASH_TABLE [CI_SEQUENCE [EPA_EXPRESSION_VALUE], CI_SEQUENCE_SIGNATURE], BOOLEAN]
			l_in_state: STRING
		do
			if a_pre_state then
				l_in_state := " in pre-state."
			else
				l_in_state := " in post-state."
			end
			l_operand_types := resolved_operand_types_with_feature (feature_under_test, class_under_test, class_under_test.constraint_actual_type)
			l_evaluator := evaluator
			l_evaluator.set_transition_context (a_tc_info)
			l_sequences := sequences
			from
				l_funcs_cur := a_tc_info.integer_bounded_functions [a_pre_state].new_cursor
				l_funcs_cur.start
			until
				l_funcs_cur.after
			loop
				l_sequences.search (a_tc_info)
				if l_sequences.found then
					l_seq_set := l_sequences.found_item.item (a_pre_state)
				else
					create l_seq_tbl.make (2)
					create l_seq_set.make (5)
					l_seq_set.set_equality_tester (ci_sequence_equality_tester)
					l_seq_tbl.put (l_seq_set, True)
					create l_seq_set.make (5)
					l_seq_set.set_equality_tester (ci_sequence_equality_tester)
					l_seq_tbl.put (l_seq_set, False)
					l_sequences.force_last (l_seq_tbl, a_tc_info)
					l_seq_set := l_seq_tbl.item (a_pre_state)
				end
					-- Construct the sequence.
				l_sequence := sequence_from_integer_bounded_function (l_funcs_cur.item, a_tc_info, a_pre_state)
				if l_sequence /= Void and then not l_seq_set.has (l_sequence.signature) then
					log_message (once "%T Found sequence: " + text_of_sequence (l_sequence) + l_in_state, False, True)
					l_seq_set.force_last (l_sequence, l_sequence.signature)

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
								l_evaluator.evaluate_string (once "old " + l_var_name)
							else
								l_evaluator.evaluate_string (l_var_name)
							end
							if not l_evaluator.has_error then
								create l_opd_value.make
								l_opd_value.extend (l_evaluator.last_value)
								create l_opd_sequence.make (l_opd_value, l_var_name, ti_current, l_opd_type, a_tc_info.transition.context, "", l_opd_types.key, Void, Void)
									-- Found a new single element sequence made from an operand variable.
								if not l_seq_set.has (l_opd_sequence.signature) then
									log_message (once "%T Found sequence: " + text_of_sequence (l_opd_sequence) + l_in_state, False, True)
									l_seq_set.force_last (l_opd_sequence, l_opd_sequence.signature)
								end
							end
						end
						l_opd_types.forth
					end
				end
				l_funcs_cur.forth
			end
		end

	check_sequence_consistency
			-- Check if sequences in `pre_state_sequences'/`post_state_sequences' are consistent across all test cases.
			-- Consistency means that all the test cases contains sequences with the same signature.
			-- Make result available in `is_sequence_consistent'.
			-- If the sequences are consistent, setup `pre_state_signatures' and `post_state_signatures'.
		local
			l_tc_info: CI_TEST_CASE_TRANSITION_INFO
			l_pre_signatures: LINKED_LIST [DS_HASH_SET [CI_SEQUENCE_SIGNATURE]]
			l_post_signatures: LINKED_LIST [DS_HASH_SET [CI_SEQUENCE_SIGNATURE]]
			l_pre_state: BOOLEAN
			l_test_cases: like sequences.new_cursor
			l_signatures: LINKED_LIST [DS_HASH_SET [CI_SEQUENCE_SIGNATURE]]
			l_sig_set: DS_HASH_SET [CI_SEQUENCE_SIGNATURE]
			l_pre_first_sigs: DS_HASH_SET [CI_SEQUENCE_SIGNATURE]
			l_post_first_sigs: DS_HASH_SET [CI_SEQUENCE_SIGNATURE]
		do
			is_sequence_consistent := False

			create l_pre_signatures.make
			create l_post_signatures.make

				-- Iterate over pre- and post-state.
			across <<True, False>> as l_states loop
				l_pre_state := l_states.item
				if l_pre_state then
					l_signatures := l_pre_signatures
				else
					l_signatures := l_post_signatures
				end

					-- Iterate through all test cases and collect sequence signatures in each test case,
					-- for both pre-state sequences and post-state sequences.
				from
					l_test_cases := sequences.new_cursor
					l_test_cases.start
				until
					l_test_cases.after
				loop
						-- Collect sequence signatures.
					create l_sig_set.make (10)
					l_sig_set.set_equality_tester (ci_sequence_signature_equality_tester)
					l_sig_set.append_last (l_test_cases.item.item (l_pre_state).keys)

					l_signatures.extend (l_sig_set)
					l_test_cases.forth
				end
			end

				-- Check if the sequences across all test cases are consistent.
			if not l_pre_signatures.is_empty and not l_post_signatures.is_empty then
				l_pre_first_sigs := l_pre_signatures.first
				l_post_first_sigs := l_post_signatures.first
				is_sequence_consistent :=
					across l_pre_signatures as l_pre_sigs all l_pre_sigs.item.is_equal (l_pre_first_sigs) end and
					across l_post_signatures as l_post_sigs all l_post_sigs.item.is_equal (l_post_first_sigs) end
				if is_sequence_consistent then
					logger.put_line_with_time_at_info_level ("Found sequences are consistent across all test cases.")

						-- Setup `pre_state_signatures' and `post_state_signatures'.
					pre_state_signatures.append_last (l_pre_first_sigs)
					post_state_signatures.append_last (l_post_first_sigs)
				else
					logger.put_line_with_time_at_info_level ("Found sequences are NOT consistent.")
				end
			end
		end

	calculate_integer_queries
			-- Calculate integer queries from current test cases and
			-- store result in `integer_queries'.
		local
			l_gen: like argumentless_integer_query_generator
		do
			create integer_queries.make (5)
			integer_queries.set_equality_tester (ci_integer_query_equality_tester)

				-- Generate argument-less integer queries.
			l_gen := argumentless_integer_query_generator
			l_gen.generate (class_under_test, feature_under_test)
			across l_gen.accesses as l_accesses loop
				integer_queries.force_last (integer_query_from_access (l_accesses.item, feature_under_test, class_under_test))
			end
		end

	generate_is_empty_properties
			-- Generate sequence is empty properties.
		local
			l_sigs: DS_HASH_SET_CURSOR [CI_SEQUENCE_SIGNATURE]
			l_property: STRING
			l_signature: CI_SEQUENCE_SIGNATURE
			l_properties: like post_state_properties
		do
			create l_properties.make (10)
			l_properties.set_equality_tester (string_equality_tester)

			from
					-- We only generate for post-state sequences.
				l_sigs := non_special_post_state_signatures.new_cursor
				l_sigs.start
			until
				l_sigs.after
			loop
				l_signature := l_sigs.item
				create l_property.make (64)

				l_property.append (sequence_is_empty_un_operator)
				l_property.append (ti_space)
				l_property.append (signature_in_property (l_signature, False))
				l_properties.force_last (l_property)
				l_sigs.forth
			end
			post_state_properties.append_last (l_properties)
		end

	generate_binary_properties (a_left_sequences, a_right_sequences, a_result_sequences: LINKED_LIST [TUPLE [signature: CI_SEQUENCE_SIGNATURE; pre_state: BOOLEAN]]; a_operators: ITERABLE [STRING]; a_communitive: BOOLEAN)
		local
			l_sequences: LINKED_LIST [TUPLE [lefts: LINKED_LIST [TUPLE [signature: CI_SEQUENCE_SIGNATURE; pre_state: BOOLEAN]]; rights: LINKED_LIST [TUPLE [signature: CI_SEQUENCE_SIGNATURE; pre_state: BOOLEAN]]]]
			l_lefts, l_rights: LINKED_LIST [TUPLE [signature: CI_SEQUENCE_SIGNATURE; pre_state: BOOLEAN]]
			l_left, l_right: TUPLE [signature: CI_SEQUENCE_SIGNATURE; pre_state: BOOLEAN]
			l_property: STRING
			l_properties: like post_state_properties
		do
			create l_properties.make (10)
			l_properties.set_equality_tester (string_equality_tester)

				-- Setup left and right sequence operators depending if `a_operators' are communitive or not.
			create l_sequences.make
			l_sequences.extend ([a_left_sequences, a_right_sequences])
			if a_communitive then
				l_sequences.extend ([a_right_sequences, a_left_sequences])
			end

			across l_sequences as l_seqs loop
				l_lefts := l_seqs.item.lefts
				l_rights := l_seqs.item.rights

					-- For left hand side sequences `l_lefts' and right hand side sequences `l_rights',
					-- iterate through all operators in `a_operators'.
				across a_operators as l_operators loop
					across l_lefts as l_left_seqs loop
						across l_rights as  l_right_seqs loop
							l_left := l_left_seqs.item
							l_right := l_right_seqs.item
							if l_left /~ l_right then
									-- Iterate through all resulting sequences.
								across a_result_sequences as l_rlt_seqs loop
									create l_property.make (64)
									l_property.append_character ('(')
									l_property.append (signature_in_property (l_left.signature, l_left.pre_state))
									l_property.append (ti_space)
									l_property.append (l_operators.item)
									l_property.append (ti_space)
									l_property.append (signature_in_property (l_right.signature, l_right.pre_state))
									l_property.append_character (')')
									l_property.append (ti_space)
									l_property.append (sequence_is_equal_bin_operator)
									l_property.append (ti_space)
									l_property.append (signature_in_property (l_rlt_seqs.item.signature, l_rlt_seqs.item.pre_state))
									l_properties.force_last (l_property)
								end
							end
						end
					end
				end
			end
			post_state_properties.append_last (l_properties)
		end

	generate_boolean_binary_properties (a_left_sequences, a_right_sequences: LINKED_LIST [TUPLE [signature: CI_SEQUENCE_SIGNATURE; pre_state: BOOLEAN]]; a_operators: ITERABLE [STRING]; a_communitive: BOOLEAN)
			-- Generate sequence properties by connecting two sequences from `a_left_sequences' and `a_right_sequences' respectively
			-- using a binary operator in `a_operators'. `a_communitive' indicates if operators in `a_operators' are communitive or not.
			-- It not, we try to connect two sequences both way.
		local
			l_sequences: LINKED_LIST [TUPLE [lefts: LINKED_LIST [TUPLE [signature: CI_SEQUENCE_SIGNATURE; pre_state: BOOLEAN]]; rights: LINKED_LIST [TUPLE [signature: CI_SEQUENCE_SIGNATURE; pre_state: BOOLEAN]]]]
			l_lefts, l_rights: LINKED_LIST [TUPLE [signature: CI_SEQUENCE_SIGNATURE; pre_state: BOOLEAN]]
			l_left, l_right: TUPLE [signature: CI_SEQUENCE_SIGNATURE; pre_state: BOOLEAN]
			l_property: STRING
			l_properties: like post_state_properties
		do
			create l_properties.make (10)
			l_properties.set_equality_tester (string_equality_tester)

				-- Setup left and right sequence operators depending if `a_operators' are communitive or not.
			create l_sequences.make
			l_sequences.extend ([a_left_sequences, a_right_sequences])
			if a_communitive then
				l_sequences.extend ([a_right_sequences, a_left_sequences])
			end

			across l_sequences as l_seqs loop
				l_lefts := l_seqs.item.lefts
				l_rights := l_seqs.item.rights

					-- For left hand side sequences `l_lefts' and right hand side sequences `l_rights',
					-- iterate through all operators in `a_operators'.
				across a_operators as l_operators loop
					across l_lefts as l_left_seqs loop
						across l_rights as  l_right_seqs loop
							l_left := l_left_seqs.item
							l_right := l_right_seqs.item
							if l_left /~ l_right then
								create l_property.make (64)
								l_property.append (signature_in_property (l_left.signature, l_left.pre_state))
								l_property.append (ti_space)
								l_property.append (l_operators.item)
								l_property.append (ti_space)
								l_property.append (signature_in_property (l_right.signature, l_right.pre_state))
								l_properties.force_last (l_property)
							end
						end
					end
				end
			end
			post_state_properties.append_last (l_properties)
		end

	generate_2_sequences_and_1_integer_properties
			-- Generate sequence properties mentioning two sequences and one integer.
			-- Store results in `properties'.
		local
			l_pre_sigs: like signature_set
			l_post_sigs: like signature_set
			l_pre_sig_cursor: like signature_set.new_cursor
			l_post_sig_cursor: like signature_set.new_cursor
			l_first_sig, l_second_sig: TUPLE [signature: CI_SEQUENCE_SIGNATURE; pre_state: BOOLEAN]
			l_integer: CI_INTEGER_QUERY
			l_integers: DS_HASH_SET_CURSOR [CI_INTEGER_QUERY]
			l_property: STRING
			l_properties: like post_state_properties
		do
			create l_properties.make (10)
			l_properties.set_equality_tester (string_equality_tester)

			l_pre_sigs := signature_set (True, True, False, False)
			l_post_sigs := signature_set (False, False, True, False)

			if
				not l_pre_sigs.is_empty and then
				not l_post_sigs.is_empty and then
				not integer_queries.is_empty
			then
					-- Iterate through all supported binary operators.
				across <<sequence_head_bin_operator, sequence_tail_bin_operator>> as l_operators loop
						-- Iterate through the first set of signatures.
					from
						l_pre_sig_cursor := l_pre_sigs.new_cursor
						l_pre_sig_cursor.start
					until
						l_pre_sig_cursor.after
					loop
						l_first_sig := l_pre_sig_cursor.item
							-- Iterate through the second set of signatures.
						from
							l_post_sig_cursor := l_post_sigs.new_cursor
							l_post_sig_cursor.start
						until
							l_post_sig_cursor.after
						loop
							l_second_sig := l_post_sig_cursor.item
								-- Iterate through all found integer queries.
							from
								l_integers := integer_queries.new_cursor
								l_integers.start
							until
								l_integers.after
							loop
								l_integer := l_integers.item
								l_properties.force_last (sequence2_integer_property1 (l_first_sig, l_second_sig, l_integer, sequence_head_bin_operator))
								l_properties.force_last (sequence2_integer_property2 (l_first_sig, l_second_sig, l_integer))
								l_properties.force_last (sequence2_integer_property3 (l_first_sig, l_second_sig, l_integer))
								l_properties.force_last (sequence2_integer_property4 (l_first_sig, l_second_sig, l_integer))
								l_integers.forth
							end
							l_post_sig_cursor.forth
						end
						l_pre_sig_cursor.forth
					end
				end
			end

			post_state_properties.append_last (l_properties)
		end

	generate_3_sequences_and_1_integer_properties
			-- Generate sequence properties mentioning three sequences and one integer.
			-- Store results in `properties'.
		local
			l_pre1_sigs: like signature_set
			l_pre2_sigs: like signature_set
			l_post_sigs: like signature_set
			l_pre1_sig_cursor: like signature_set.new_cursor
			l_pre2_sig_cursor: like signature_set.new_cursor
			l_post_sig_cursor: like signature_set.new_cursor
			l_first_sig, l_second_sig, l_third_sig: TUPLE [signature: CI_SEQUENCE_SIGNATURE; pre_state: BOOLEAN]
			l_integer: CI_INTEGER_QUERY
			l_integers: DS_HASH_SET_CURSOR [CI_INTEGER_QUERY]
			l_property: STRING
			l_properties: like post_state_properties
		do
			create l_properties.make (10)
			l_properties.set_equality_tester (string_equality_tester)

			l_pre1_sigs := signature_set (True, True, False, False)
			l_pre2_sigs := signature_set (True, True, False, False)
			l_post_sigs := signature_set (False, False, True, False)

			if
				not l_pre1_sigs.is_empty and then
				not l_pre2_sigs.is_empty and then
				not l_post_sigs.is_empty and then
				not integer_queries.is_empty
			then
					-- Iterate through all supported binary operators.
				across <<sequence_head_bin_operator, sequence_tail_bin_operator>> as l_operators loop
						-- Iterate through the first set of signatures.
					from
						l_pre1_sig_cursor := l_pre1_sigs.new_cursor
						l_pre1_sig_cursor.start
					until
						l_pre1_sig_cursor.after
					loop
						l_first_sig := l_pre1_sig_cursor.item
						from
							l_pre2_sig_cursor := l_pre2_sigs.new_cursor
							l_pre2_sig_cursor.start
						until
							l_pre2_sig_cursor.after
						loop
							l_second_sig := l_pre2_sig_cursor.item
								-- Iterate through the second set of signatures.
							from
								l_post_sig_cursor := l_post_sigs.new_cursor
								l_post_sig_cursor.start
							until
								l_post_sig_cursor.after
							loop
								l_third_sig := l_post_sig_cursor.item
									-- Iterate through all found integer queries.
								from
									l_integers := integer_queries.new_cursor
									l_integers.start
								until
									l_integers.after
								loop
									l_integer := l_integers.item
									l_properties.force_last (sequence3_integer_property1 (l_first_sig, l_second_sig, l_third_sig, l_integer))
									l_properties.force_last (sequence3_integer_property2 (l_first_sig, l_second_sig, l_third_sig, l_integer))
									l_properties.force_last (sequence3_integer_property3 (l_first_sig, l_second_sig, l_third_sig, l_integer))

									l_integers.forth
								end
								l_post_sig_cursor.forth
							end
							l_pre2_sig_cursor.forth
						end

						l_pre1_sig_cursor.forth
					end
				end
			end

			post_state_properties.append_last (l_properties)
		end

	validate_properties
			-- Validate `properties in test cases from `transition_data'.
			-- Only keep valid ones in `properties'.
		local
			l_tc: CI_TEST_CASE_TRANSITION_INFO
			l_signature: STRING
			l_evaluator: CI_EXPRESSION_EVALUATOR
			l_pre_state: BOOLEAN
			l_pcursor: DS_HASH_SET_CURSOR [STRING]
			l_properties: DS_HASH_SET [STRING]
			l_property: STRING
			l_is_valid: BOOLEAN
			l_tc_cursor: CURSOR
			l_test_cases: like transition_data
		do
			logger.put_line_with_time ("Start validating frame properties.")

			l_test_cases := transition_data
			l_evaluator := evaluator

				-- Iterate through both pre-state and post-state.
			across <<True, False>> as l_states loop
				l_pre_state := l_states.item
				l_properties := properties.item (l_pre_state)
					-- Iterate through all properties in `l_pre_state'.
				from
					l_pcursor := l_properties.new_cursor
					l_pcursor.start
				until
					l_pcursor.after
				loop
					l_property := l_pcursor.item
					log_message (once "  Start validating property: " + l_property, False, True)
					l_is_valid := True
						-- Iterate through all test cases to validate `l_property'.
					l_tc_cursor := l_test_cases.cursor
					from
						l_test_cases.start
					until
						l_test_cases.after or else not l_is_valid
					loop
						l_tc := l_test_cases.item_for_iteration
						log_message (once "    In test case: " + l_tc.test_case_info.test_case_class.name_in_upper, False, True)
						l_evaluator.set_transition_context (l_tc)
						l_evaluator.set_extra_pre_state_values (sequences_as_state (l_tc, True))
						l_evaluator.set_extra_post_state_values (sequences_as_state (l_tc, False))
						l_evaluator.evaluate_string (resolved_property (l_property, l_tc))
						l_is_valid := not l_evaluator.has_error and then l_evaluator.last_value.is_boolean and then l_evaluator.last_value.as_boolean.is_true

							-- Logging.
						logger.put_string (once "%T%T")
						logger.put_string (l_property)
						logger.put_string (once " == ")
						if l_evaluator.has_error then
							logger.put_line (l_evaluator.error_reason)
						else
							logger.put_line (l_evaluator.last_value.out)
						end
						l_test_cases.forth
					end
					l_test_cases.go_to (l_tc_cursor)

						-- Remove a property if it is detected to be invalid.
					if not l_is_valid then
						l_properties.remove (l_pcursor.item)
					else
						l_pcursor.forth
					end
				end
			end
		end

feature{NONE} -- Implementation/Logging

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

	log_properties (a_message: STRING; a_properties: like properties)
			-- Log `a_properties' with preceding message `a_message'.
		local
			l_cursor: DS_HASH_SET_CURSOR [STRING]
		do
			logger.put_line_with_time (a_message)

			across <<True, False>>  as l_states loop

				if l_states.item then
					logger.put_line_with_time ("Valid sequence-based properties in pre-states:")
				else
					logger.put_line_with_time ("Valid sequence-based properties in post-states:")
				end
				from
					l_cursor := a_properties.item (l_states.item).new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					logger.put_line ("    " + l_cursor.item)
					l_cursor.forth
				end
			end
		end

feature{NONE} -- Implementation

	evaluator: CI_EXPRESSION_EVALUATOR
			-- Expression evaluator

	text_of_sequence (a_sequence: CI_SEQUENCE [EPA_EXPRESSION_VALUE]): STRING
			-- Text of `a_sequence'
		do
			create Result.make (64)
			Result.append (a_sequence.out)
		end

	signature_set (a_pre_state_normal, a_pre_state_special, a_post_state_normal, a_post_state_special: BOOLEAN): LINKED_LIST [TUPLE [signature: CI_SEQUENCE_SIGNATURE; pre_state: BOOLEAN]]
			-- Set of signatures.
			-- `a_pre_state_normal' indicates if normal signatures from pre-state will be included in resulting set.
			-- `a_pre_state_special' indicates if special signatures from pre-state will be included in resulting set.
			-- `a_post_state_normal' indicates if normal signatures from post-state will be included in resulting set.
			-- `a_post_state_special' indicates if special signatures from post-state will be included in resulting set.
		local
			l_tuple: TUPLE [signature: CI_SEQUENCE_SIGNATURE; pre_state: BOOLEAN]
			l_cursor: DS_HASH_SET_CURSOR [CI_SEQUENCE_SIGNATURE]
			l_pre_state: BOOLEAN
			l_flg_tbl: HASH_TABLE [TUPLE [normal_included: BOOLEAN; special_included: BOOLEAN], BOOLEAN]
			l_flags: TUPLE [normal_included: BOOLEAN; special_included: BOOLEAN]
			l_signature: CI_SEQUENCE_SIGNATURE
		do
			create l_flg_tbl.make (2)
			l_flg_tbl.put ([a_pre_state_normal, a_pre_state_special], True)
			l_flg_tbl.put ([a_post_state_normal, a_post_state_special], False)

			create Result.make
			across <<True, False>> as l_states loop
				l_pre_state := l_states.item
				l_flags := l_flg_tbl.item (l_pre_state)
				from
					l_cursor := signatures.item (l_pre_state).new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					l_signature := l_cursor.item
					if l_signature.is_special then
						if l_flags.special_included then
							l_tuple := [l_signature, l_pre_state]
							l_tuple.compare_objects
							Result.extend (l_tuple)
						end
					else
						if l_flags.normal_included then
							l_tuple := [l_signature, l_pre_state]
							l_tuple.compare_objects
							Result.extend (l_tuple)
						end
					end
					l_cursor.forth
				end
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
			l_count_expression: STRING
			l_transition: SEM_TRANSITION
			l_target_variable_name: STRING
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
			l_evaluator.set_transition_context (a_tc_info)
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
				l_evaluator.evaluate_string (l_expr_text)
				l_has_error := l_evaluator.has_error
				if not l_has_error then
					l_values.extend (l_evaluator.last_value)
				else
					log_message (once "%T" + l_evaluator.error_reason, False, True)
				end
				i := i + 1
			end
			if not l_has_error then
				l_target_variable_name := a_function.target_variable_name
				create l_count_expression.make (64)
				l_count_expression.append_character ('(')
				if not a_function.upper_bound_expression.is_integer then
					l_count_expression.append (l_target_variable_name)
					l_count_expression.append_character ('.')
				end
				l_count_expression.append (a_function.upper_bound_expression)

				l_count_expression.append (once ") - (")

				if not a_function.lower_bound_expression.is_integer then
					l_count_expression.append (l_target_variable_name)
					l_count_expression.append_character ('.')
				end
				l_count_expression.append (a_function.lower_bound_expression)
				l_count_expression.append_character (')')

				l_transition := a_tc_info.transition
				create Result.make_from_function (a_function, l_count_expression, l_values, l_transition.variable_position_by_name (l_target_variable_name), a_function.lower_bound_expression, a_function.upper_bound_expression)
			end
		end

	signature_in_property (a_signature: CI_SEQUENCE_SIGNATURE; a_pre_state: BOOLEAN): STRING
			-- Signature output for `a_signature' in `a_pre_state'
			-- The output is used in built sequence-based frame properties.
		do
			create Result.make (64)
			if a_pre_state then
				Result.append_character ('(')
				Result.append (ti_old_keyword)
				Result.append (ti_space)
				Result.append (once " [")
			else
				Result.append_character ('[')
			end

			Result.append (a_signature.target_variable_index.out)
			Result.append (once ", %"")
			Result.append (a_signature.function_name)
			Result.append (once "%"]")
			if a_pre_state then
				Result.append_character (')')
			end
		end

	resolved_property (a_property: STRING; a_test_case: CI_TEST_CASE_TRANSITION_INFO): STRING
			-- Property from `a_property' will place holders resolved in `a_test_case'
		local
			l_replacements: HASH_TABLE [STRING, STRING]
			l_int_queries: like integer_queries.new_cursor
			l_old_str: STRING
			l_new_str: STRING
			l_target_variable_index: INTEGER
			l_is_argument: BOOLEAN
			l_dot_index: INTEGER
			l_feature_name: STRING
			l_query: CI_INTEGER_QUERY
			l_target_variable: EPA_EXPRESSION
		do
			Result := a_property.twin
			if not integer_queries.is_empty then
					-- Setup replacements.
				create l_replacements.make (integer_queries.count)
				l_replacements.compare_objects
				from
					l_int_queries := integer_queries.new_cursor
					l_int_queries.start
				until
					l_int_queries.after
				loop
					l_query := l_int_queries.item
					l_old_str := l_query.out
					l_target_variable := a_test_case.transition.reversed_variable_position.item (l_query.target_operand_index)
					create l_new_str.make (32)
					l_new_str.append (once "(old ")
					l_new_str.append (l_target_variable.text)
					if not l_query.is_target_integer_query then
						l_new_str.append_character ('.')
						l_new_str.append (l_query.final_feature_name (l_target_variable.type))
					end
					l_new_str.append_character (')')
					l_replacements.put (l_new_str, l_old_str)
					l_int_queries.forth
				end

					-- Perform replacments.
				across l_replacements as l_replaces loop
					Result.replace_substring_all (l_replaces.key, l_replaces.item)
				end
			end
		end

	argumentless_integer_query_generator: EPA_NESTED_EXPRESSION_GENERATOR
			-- Generator to return feature that satisfy all the following criteria:
			-- * argument-less integer queries
			-- * no precondition for those queries
		do
			create Result.make
			Result.expression_veto_agents.wipe_out
			Result.set_final_expression_veto_agent (integer_expression_veto_agent)
			Result.expression_veto_agents.force (
				ored_agents (
					<<current_expression_veto_agent,
					  argument_expression_veto_agent>>), 1)

			Result.expression_veto_agents.force (
				anded_agents (
					<<feature_not_from_any_veto_agent,
					  feature_with_few_arguments_veto_agent (0),
				      nested_not_on_basic_veto_agent,
				      integer_expression_veto_agent>>), 2)
		end

	integer_queries: DS_HASH_SET [CI_INTEGER_QUERY]
			-- Integer queries used to infer properties mentioning integers

	integer_query_from_access (a_access: EPA_ACCESS; a_feature: FEATURE_I; a_class: CLASS_C): CI_INTEGER_QUERY
			-- Integer query from `a_access'
			-- `a_access' is derived from `a_feature' viewed in `a_class'.
		local
			l_static_type: TYPE_A
			l_target_operand_index: INTEGER
		do
			if attached {EPA_ACCESS_ARGUMENT} a_access as l_argument then
				create Result.make (l_argument.index, integer_type, Void)

			elseif attached {EPA_ACCESS_NESTED} a_access as l_nested then
				if l_nested.left.is_current then
					l_target_operand_index := 0
				elseif attached {EPA_ACCESS_ARGUMENT} l_nested.left as l_argument then
					l_target_operand_index := l_argument.index
				end
				l_static_type := resolved_operand_types_with_feature (feature_under_test, class_under_test, class_under_test.constraint_actual_type).item (l_target_operand_index)
				create Result.make (l_target_operand_index, l_static_type, l_nested.right.text)
			end
		end

	sequence2_integer_property1 (a_first_signature, a_second_signature: TUPLE [signature: CI_SEQUENCE_SIGNATURE; pre_state: BOOLEAN]; a_integer: CI_INTEGER_QUERY; a_operator_name: STRING): STRING
			-- Generate sequence-based properties which mentions two sequences and an intger.
		do
				-- Template:
				-- (s1 |head| i) |=| s2
				-- (s1 |tail| i) |=| s2
			create Result.make (64)
			Result.append_character ('(')
			Result.append (signature_in_property (a_first_signature.signature, a_first_signature.pre_state))
			Result.append (ti_space)
			Result.append (a_operator_name)
			Result.append (ti_space)
			Result.append (a_integer.out)
			Result.append (once ") ")
			Result.append (sequence_is_equal_bin_operator)
			Result.append (ti_space)
			Result.append (signature_in_property (a_second_signature.signature, a_second_signature.pre_state))
		end

	sequence2_integer_property2 (a_first_signature, a_second_signature: TUPLE [signature: CI_SEQUENCE_SIGNATURE; pre_state: BOOLEAN]; a_integer: CI_INTEGER_QUERY): STRING
			-- Generate sequence-based properties which mentions two sequences and an intger.
		do
				-- Template:
				-- (s1 |head| (i-1)) |+| (s1 |tail| (i + 1)) |=| s2
				-- For LINKED_LIST.remove.
			create Result.make (64)
			Result.append_character ('(')
			Result.append (signature_in_property (a_first_signature.signature, a_first_signature.pre_state))
			Result.append (ti_space)
			Result.append (sequence_head_bin_operator)
			Result.append (ti_space)
			Result.append ("(")
			Result.append (a_integer.out)
			Result.append (once " - 1)) ")
			Result.append (sequence_concatenation_bin_operator)
			Result.append (ti_space)
			Result.append_character ('(')
			Result.append (signature_in_property (a_first_signature.signature, a_first_signature.pre_state))
			Result.append (ti_space)
			Result.append (sequence_tail_bin_operator)
			Result.append (once " (")
			Result.append (a_integer.out)
			Result.append (once " + 1))")
			Result.append (ti_space)
			Result.append (sequence_is_equal_bin_operator)
			Result.append (ti_space)
			Result.append (signature_in_property (a_second_signature.signature, a_second_signature.pre_state))
		end

	sequence2_integer_property3 (a_first_signature, a_second_signature: TUPLE [signature: CI_SEQUENCE_SIGNATURE; pre_state: BOOLEAN]; a_integer: CI_INTEGER_QUERY): STRING
			-- Generate sequence-based properties which mentions two sequences and an intger.
		do
				-- Template:
				-- (s1 |head| (i-2)) |+| (s1 |tail| i) |=| s2
				-- For LINKED_LIST.remove_left.
			create Result.make (64)
			Result.append_character ('(')
			Result.append (signature_in_property (a_first_signature.signature, a_first_signature.pre_state))
			Result.append (ti_space)
			Result.append (sequence_head_bin_operator)
			Result.append (ti_space)
			Result.append ("(")
			Result.append (a_integer.out)
			Result.append (once " - 2)) ")
			Result.append (sequence_concatenation_bin_operator)
			Result.append (ti_space)
			Result.append_character ('(')
			Result.append (signature_in_property (a_first_signature.signature, a_first_signature.pre_state))
			Result.append (ti_space)
			Result.append (sequence_tail_bin_operator)
			Result.append (ti_space)
			Result.append (a_integer.out)
			Result.append (once ")")
			Result.append (ti_space)
			Result.append (sequence_is_equal_bin_operator)
			Result.append (ti_space)
			Result.append (signature_in_property (a_second_signature.signature, a_second_signature.pre_state))
		end

	sequence2_integer_property4 (a_first_signature, a_second_signature: TUPLE [signature: CI_SEQUENCE_SIGNATURE; pre_state: BOOLEAN]; a_integer: CI_INTEGER_QUERY): STRING
			-- Generate sequence-based properties which mentions two sequences and an intger.
		do
				-- Template:
				-- (s1 |head| i) |+| (s1 |tail| (i + 2)) |=| s2
				-- For LINKED_LIST.remove_right.
			create Result.make (64)
			Result.append_character ('(')
			Result.append (signature_in_property (a_first_signature.signature, a_first_signature.pre_state))
			Result.append (ti_space)
			Result.append (sequence_head_bin_operator)
			Result.append (ti_space)
			Result.append (a_integer.out)
			Result.append (once ") ")
			Result.append (sequence_concatenation_bin_operator)
			Result.append (ti_space)
			Result.append_character ('(')
			Result.append (signature_in_property (a_first_signature.signature, a_first_signature.pre_state))
			Result.append (ti_space)
			Result.append (sequence_tail_bin_operator)
			Result.append (ti_space)
			Result.append (once "(")
			Result.append (a_integer.out)
			Result.append (once " + 2))")
			Result.append (ti_space)
			Result.append (sequence_is_equal_bin_operator)
			Result.append (ti_space)
			Result.append (signature_in_property (a_second_signature.signature, a_second_signature.pre_state))
		end

	sequence3_integer_property1 (a_first_signature, a_second_signature, a_third_signature: TUPLE [signature: CI_SEQUENCE_SIGNATURE; pre_state: BOOLEAN]; a_integer: CI_INTEGER_QUERY): STRING
			-- Generate sequence-based properties which mentions 3 sequences and an intger.
		do
				-- Template:
				-- (s1 |head| (i-1)) |+| [s2] |+| (s1 |tail| (i+1)) |=| s3
				-- For LINKED_LIST.put_i_th
			create Result.make (64)
			Result.append_character ('(')
			Result.append (signature_in_property (a_first_signature.signature, a_first_signature.pre_state))
			Result.append (ti_space)
			Result.append (sequence_head_bin_operator)
			Result.append (ti_space)
			Result.append_character ('(')
			Result.append (a_integer.out)
			Result.append (once " - 1)) ")
			Result.append (sequence_concatenation_bin_operator)
			Result.append (ti_space)
			Result.append (signature_in_property (a_second_signature.signature, a_second_signature.pre_state))
			Result.append (ti_space)
			Result.append (sequence_concatenation_bin_operator)
			Result.append (ti_space)
			Result.append_character ('(')
			Result.append (signature_in_property (a_first_signature.signature, a_first_signature.pre_state))
			Result.append (ti_space)
			Result.append (sequence_tail_bin_operator)
			Result.append (ti_space)
			Result.append (once "(")
			Result.append (a_integer.out)
			Result.append (once " + 1))")
			Result.append (ti_space)
			Result.append (sequence_is_equal_bin_operator)
			Result.append (ti_space)
			Result.append (signature_in_property (a_third_signature.signature, a_third_signature.pre_state))
		end

	sequence3_integer_property2 (a_first_signature, a_second_signature, a_third_signature: TUPLE [signature: CI_SEQUENCE_SIGNATURE; pre_state: BOOLEAN]; a_integer: CI_INTEGER_QUERY): STRING
			-- Generate sequence-based properties which mentions 3 sequences and an intger.
		do
				-- Template:
				-- (s1 |head| (i-1)) |+| [s2] |+| (s1 |tail| i) |=| s3
				-- For LINKED_LIST.put_left
			create Result.make (64)
			Result.append_character ('(')
			Result.append (signature_in_property (a_first_signature.signature, a_first_signature.pre_state))
			Result.append (ti_space)
			Result.append (sequence_head_bin_operator)
			Result.append (ti_space)
			Result.append_character ('(')
			Result.append (a_integer.out)
			Result.append (once " - 1)) ")
			Result.append (sequence_concatenation_bin_operator)
			Result.append (ti_space)
			Result.append (signature_in_property (a_second_signature.signature, a_second_signature.pre_state))
			Result.append (ti_space)
			Result.append (sequence_concatenation_bin_operator)
			Result.append (ti_space)
			Result.append_character ('(')
			Result.append (signature_in_property (a_first_signature.signature, a_first_signature.pre_state))
			Result.append (ti_space)
			Result.append (sequence_tail_bin_operator)
			Result.append (ti_space)
			Result.append (a_integer.out)
			Result.append (once ")")
			Result.append (ti_space)
			Result.append (sequence_is_equal_bin_operator)
			Result.append (ti_space)
			Result.append (signature_in_property (a_third_signature.signature, a_third_signature.pre_state))
		end

	sequence3_integer_property3 (a_first_signature, a_second_signature, a_third_signature: TUPLE [signature: CI_SEQUENCE_SIGNATURE; pre_state: BOOLEAN]; a_integer: CI_INTEGER_QUERY): STRING
			-- Generate sequence-based properties which mentions 3 sequences and an intger.
		do
				-- Template:
				-- (s1 |head| i) |+| [s2] |+| (s1 |tail| (i + 1)) |=| s3
				-- For LINKED_LIST.put_right
			create Result.make (64)
			Result.append_character ('(')
			Result.append (signature_in_property (a_first_signature.signature, a_first_signature.pre_state))
			Result.append (ti_space)
			Result.append (sequence_head_bin_operator)
			Result.append (ti_space)
			Result.append (a_integer.out)
			Result.append (once ") ")
			Result.append (sequence_concatenation_bin_operator)
			Result.append (ti_space)
			Result.append (signature_in_property (a_second_signature.signature, a_second_signature.pre_state))
			Result.append (ti_space)
			Result.append (sequence_concatenation_bin_operator)
			Result.append (ti_space)
			Result.append_character ('(')
			Result.append (signature_in_property (a_first_signature.signature, a_first_signature.pre_state))
			Result.append (ti_space)
			Result.append (sequence_tail_bin_operator)
			Result.append (ti_space)
			Result.append (once "(")
			Result.append (a_integer.out)
			Result.append (once " + 1))")
			Result.append (ti_space)
			Result.append (sequence_is_equal_bin_operator)
			Result.append (ti_space)
			Result.append (signature_in_property (a_third_signature.signature, a_third_signature.pre_state))
		end

end
