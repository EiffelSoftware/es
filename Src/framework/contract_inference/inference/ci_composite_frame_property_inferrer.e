note
	description: "[
		Inferrer to infer composite frame properties, such as
		forall o. old l.has (o) and s.has (o) implies Result.has (o)
				]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_COMPOSITE_FRAME_PROPERTY_INFERRER

inherit
	CI_INFERRER

feature -- Basic operations

	infer (a_data: LINKED_LIST [CI_TEST_CASE_TRANSITION_INFO])
			-- Infer contracts from `a_data', which is transition data collected from
			-- executed test cases.
		do
			transition_data := a_data
			setup_data_structures

			logger.put_line_with_time ("Start inferring composite frame properties.")
			find_suitable_functions
		end

feature{NONE} -- Implementation

	base_functions: like suitable_functions
			-- Functions that are used as building blocks of more complicated frame properties.
			-- Those functions are from pre-state valuations.

	base_signatures: DS_HASH_SET [CI_SINGLE_ARG_FUNCTION_SIGNATURE]
			-- Set of signatures of functions in `base_functions'

	pre_functions_by_signature: DS_HASH_TABLE [like base_functions, CI_SINGLE_ARG_FUNCTION_SIGNATURE]
			-- Set of functions grouped by signature in pre-state.
			-- Key is signature, value is a set of functions with the same signature.

	post_functions_by_signature: DS_HASH_TABLE [like base_functions, CI_SINGLE_ARG_FUNCTION_SIGNATURE]
			-- Set of functions grouped by signature in post-state.
			-- Key is signature, value is a set of functions with the same signature.

	functions_by_signature: HASH_TABLE [like pre_functions_by_signature, BOOLEAN]
			-- Table of functions by signature
			-- Key is a boolean indicating pre-state or post-state, value is a table from signature to functions.
			-- See `pre_functions_by_signature' and `post_functions_by_signature' for details.

feature{NONE} -- Implementation

	is_function_with_multiple_argument_valuations (a_function: EPA_FUNCTION; a_valuations: EPA_FUNCTION_VALUATIONS; a_target_variable_index: INTEGER; a_transition: SEM_TRANSITION): BOOLEAN
			-- Does `a_function' has multiple argument valuations in the context of `a_transition'?
			-- `a_function' is assumed to be a qualified call, the target object has index `a_target_variable_index'.
			-- The valuations to check are from `a_valuations'.
			-- For example, `a_function' can be "v_2.has", if in `a_valuations', there are:
			-- v_2.has (v_1), v_2.has (v_3), then "v_2.has" is considered to have multiple argument valuations.
		local
			l_func_valuations: EPA_FUNCTION_VALUATIONS
		do
				-- We are only interested in boolean queries with one argument,
				-- together with the target, the arity of that function
				-- should be 2.		
			if
				a_function.arity = 2 and then 						 -- Function should have one argument.
				not a_function.argument_type (1).is_integer			 -- Function argument shoult not of type integer, because we handle integer argument differently.
			then
				l_func_valuations := a_valuations.projected (1, value_set_for_variable (a_transition.reversed_variable_position.item (a_target_variable_index).text, a_transition))
				if l_func_valuations.map.count > 1 then
					Result := True
				end
			end
		end

	is_function_with_same_signature (a_function: EPA_FUNCTION; a_valuations: EPA_FUNCTION_VALUATIONS; a_target_variable_index: INTEGER; a_transition: SEM_TRANSITION; a_signature: CI_SINGLE_ARG_FUNCTION_SIGNATURE): BOOLEAN
			-- Does `a_function' have the same signature as `a_signature'?
		local
			l_func_valuations: EPA_FUNCTION_VALUATIONS
			l_signature: CI_SINGLE_ARG_FUNCTION_SIGNATURE
		do
				-- We are only interested in boolean queries with one argument,
				-- together with the target, the arity of that function
				-- should be 2.		
			if a_function.arity = 2 then
				l_signature := signature_of_single_argument_function (a_function, a_target_variable_index)
				if l_signature /= Void then
					Result := ci_single_arg_function_signature_equality_tester.test (l_signature, a_signature)
				end
			end
		end

feature{NONE} -- Implementation

	find_suitable_functions
			-- Find functions that are suitable as building blocks of more complicated frame properties,
			-- Store result in `base_functions'.
		local
			l_cursor: DS_HASH_SET_CURSOR [TUPLE [function: EPA_FUNCTION; target_variable_index: INTEGER_32]]
			l_signature: CI_SINGLE_ARG_FUNCTION_SIGNATURE
			l_sig_cursor: like base_signatures.new_cursor
			l_state_functions, l_pre_functions, l_post_functions: DS_HASH_TABLE [like base_functions, CI_SINGLE_ARG_FUNCTION_SIGNATURE]
			l_pre_state: BOOLEAN
			l_functions: like base_functions
			l_function: EPA_FUNCTION
		do
			base_functions := suitable_functions (True, agent is_function_with_multiple_argument_valuations)
			create base_signatures.make (base_functions.count)
			base_signatures.set_equality_tester (ci_single_arg_function_signature_equality_tester)

				-- Group `base_functions' according to their signature.
			from
				l_cursor := base_functions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_signature := signature_of_single_argument_function (l_cursor.item.function, l_cursor.item.target_variable_index)
				if l_signature /= Void then
					base_signatures.force_last (l_signature)
				end
				l_cursor.forth
			end

				-- Logging.
			logger.push_fine_level
			logger.put_line (once "Found the following base functions:")
			from
				l_cursor := base_functions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				logger.put_line (
					once "%T" +
					l_cursor.item.function.debug_output +
					once ", signature: " +
					signature_of_single_argument_function (l_cursor.item.function, l_cursor.item.target_variable_index).debug_output +
					once ", target operand index = " + l_cursor.item.target_variable_index.out)
				l_cursor.forth
			end
			logger.put_line (once "")
			logger.pop_level

				-- Collect functiosn in pre- and post-state valuations, which have the same signature as those
				-- in `base_functions'.
			create l_pre_functions.make (10)
			l_pre_functions.set_key_equality_tester (ci_single_arg_function_signature_equality_tester)
			create l_post_functions.make (10)
			l_post_functions.set_key_equality_tester (ci_single_arg_function_signature_equality_tester)
			create functions_by_signature.make (2)
			functions_by_signature.put (l_pre_functions, True)
			functions_by_signature.put (l_post_functions, False)

				-- Iterate through all signatures.
			from
				l_sig_cursor := base_signatures.new_cursor
				l_sig_cursor.start
			until
				l_sig_cursor.after
			loop
				l_signature := l_sig_cursor.item
				l_pre_state := True
					-- Iterate through pre- and post-state.
				across <<True, false>> as l_func_cursor loop
					l_pre_state := l_func_cursor.item
					l_state_functions := functions_by_signature.item (l_pre_state)
					l_state_functions.search (l_signature)
					if l_state_functions.found then
						l_functions := l_state_functions.found_item
					else
						create l_functions.make (10)
						l_functions.set_equality_tester (function_candidate_equality_tester)
						l_state_functions.force_last (l_functions, l_signature)
					end
						-- For each signature and each state, get the set of functions of the same signature in that state.
					l_functions.append_last (suitable_functions (l_pre_state, agent is_function_with_same_signature (?, ?, ?, ?, l_signature)))
				end
				l_sig_cursor.forth
			end

				-- Logging.
			logger.put_line ("Found the following functions, grouped by signature:")
			across <<True, False>> as l_func_cursor loop
				l_pre_state := l_func_cursor.item
				l_state_functions := functions_by_signature.item (l_pre_state)
				if l_pre_state then
					logger.put_line ("   In pre-state:")
				else
					logger.put_line ("    In post-state:")
				end
				from
					l_sig_cursor := base_signatures.new_cursor
					l_sig_cursor.start
				until
					l_sig_cursor.after
				loop
					l_functions := l_state_functions.item (l_sig_cursor.item)
					if l_functions /= Void then
						logger.put_line (once "        Signature:" + l_sig_cursor.item.debug_output)
						from
							l_cursor := l_functions.new_cursor
							l_cursor.start
						until
							l_cursor.after
						loop
							logger.put_line (once "          " + l_cursor.item.function.body + ", target operand index = " + l_cursor.item.target_variable_index.out)
							l_cursor.forth
						end
					end
					l_sig_cursor.forth
				end
			end
		end

	signature_of_single_argument_function (a_function: EPA_FUNCTION; a_target_variable_index: INTEGER): detachable CI_SINGLE_ARG_FUNCTION_SIGNATURE
			-- Signature of single argument function `a_function'
			-- `a_function' is assumed to be a qualified call, so its arity should be 2, the first one is the target.
		require
			a_function.arity = 2
		local
			l_target_type: TYPE_A
			l_arg_type: TYPE_A
			l_result_type: TYPE_A
			l_feature_name: STRING
			l_dot_index: INTEGER
			l_lparan_index: INTEGER
			l_feature: FEATURE_I
		do
			l_target_type := operand_types_with_feature (feature_under_test, class_under_test).item (a_target_variable_index)
			l_target_type := actual_type_from_formal_type (l_target_type, class_under_test)
			l_target_type := l_target_type.instantiation_in (class_under_test.actual_type, class_under_test.class_id)

			l_dot_index := a_function.body.index_of ('.', 1)
			l_lparan_index := a_function.body.index_of ('(', l_dot_index + 1)
			l_feature_name := a_function.body.substring (l_dot_index + 1, l_lparan_index - 1)
			l_feature := l_target_type.associated_class.feature_named (l_feature_name)
			if l_feature /= Void then
				l_arg_type := l_feature.arguments.i_th (1).actual_type
				l_arg_type := actual_type_from_formal_type (l_arg_type, l_target_type.associated_class)
				l_arg_type := l_arg_type.instantiation_in (l_target_type, l_target_type.associated_class.class_id)


				l_result_type := l_feature.type.actual_type
				l_result_type := actual_type_from_formal_type (l_result_type, l_target_type.associated_class)
				l_result_type := l_result_type.instantiation_in (l_target_type, l_target_type.associated_class.class_id)
				create Result.make (l_arg_type, l_result_type)
			else
				Result := Void
			end
		end

end
