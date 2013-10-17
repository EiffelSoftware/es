note
	description: "Summary description for {CI_INFER_CONTRACT_CMD_EXT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_INFER_CONTRACT_CMD_EXT

inherit
	CI_INFER_CONTRACT_CMD
		redefine
			execute,
			launch_debugger
		end

	REFACTORING_HELPER

creation
	make

feature

	execute
			-- <Precursor>
		local
			l_class_name, l_feature_name, l_key: STRING
			l_contracts: TUPLE [pre: ARRAYED_SET [STRING]; post: ARRAYED_SET [STRING]]
			l_pre_clauses, l_post_clauses: ARRAYED_SET [STRING]
			l_violated_expression: EPA_EXPRESSION
			l_violated_expression_text: STRING
		do
			class_ := first_class_starts_with_name (config.class_name)
			feature_ := class_.feature_named (config.feature_name_for_test_cases.first)
			context_type := class_.constraint_actual_type

			build_project
			disable_feature_contracts
			freeze_and_c_compile_project

				-- Since the test cases were derived from the contract-free version of the code,
				-- we collect the exception conditions after the contracts have been removed.
			collect_exception_condition
			add_exception_condition_to_feature_contracts

			log_manager.push_level ({ELOG_LOG_MANAGER}.debug_level)
			if number_passing_tests > 0 then
				log_manager.put_line_with_time (msg_contract_inference_started)

					-- Infer invariants from passing tests.
				infer_contracts_from_passing_tests
				log_final_contracts (last_contracts_from_passing_tests, last_sequence_based_contracts_from_passing_tests)

					-- Check the validity of programmer written contracts.
				check_written_contract_clauses (True)
				log_contract_clauses (last_valid_written_precondition_clauses, mark_starting_valid_written_preconditions, mark_ending_valid_written_preconditions)
				log_contract_clauses (last_invalid_written_precondition_clauses, mark_starting_invalid_written_preconditions, mark_ending_invalid_written_preconditions)
				check_written_contract_clauses (False)
				log_contract_clauses (last_valid_written_postcondition_clauses, mark_starting_valid_written_postconditions, mark_ending_valid_written_postconditions)
				log_contract_clauses (last_invalid_written_postcondition_clauses, mark_starting_invalid_written_postconditions, mark_ending_invalid_written_postconditions)
			else
				log_manager.put_line (mark_no_passing_tests_available)
			end

			if number_failing_tests > 0 then
					-- Use the failing tests to further filter out the invalid invariant clause (combinations)
				collect_entry_states_from_failing_tests
				compute_candidate_preconditions
				log_candidate_extra_precondition_clauses

				log_manager.put_line_with_time (msg_contract_inference_ended)
			end

			if log_file /= Void and then log_file.is_open_write then
				log_file.close
			end
			log_manager.pop_level
		end

feature -- Access

	number_passing_tests: INTEGER
			-- Number of passing test cases actually used for fixing.

	number_failing_tests: INTEGER
			-- Number of failing test cases actually used for fixing.

	last_valid_written_precondition_clauses: DS_HASH_SET [EPA_EXPRESSION]
			-- Set of programmer written precondition clauses that are valid across all passing tests.

	last_invalid_written_precondition_clauses: DS_HASH_SET [EPA_EXPRESSION]
			-- Set of programmer written precondition clauses that are invalid in some passing tests.

	last_candidate_extra_precondition_clauses: DS_ARRAYED_LIST [DS_HASH_SET [EPA_EXPRESSION]]
			-- Sets of candidate extra precondition clauses for `class_'.`feature_'.
			-- Each set could be used together with `last_valid_written_precondition_clauses' to form
			--		a complete candidate precondition.

	last_valid_written_postcondition_clauses: DS_HASH_SET [EPA_EXPRESSION]
			-- Set of programmer written postcondition clauses that are valid across all passing tests.

	last_invalid_written_postcondition_clauses: DS_HASH_SET [EPA_EXPRESSION]
			-- Set of programmer written postcondition clauses that are invalid in some passing tests.

	set_last_valid_written_contract_clauses (a_is_pre: BOOLEAN; a_clauses: DS_HASH_SET [EPA_EXPRESSION])
			--
		do
			if a_is_pre then
				last_valid_written_precondition_clauses := a_clauses
			else
				last_valid_written_postcondition_clauses := a_clauses
			end
		end

	set_last_invalid_written_contract_clauses (a_is_pre: BOOLEAN; a_clauses: DS_HASH_SET [EPA_EXPRESSION])
			--
		do
			if a_is_pre then
				last_invalid_written_precondition_clauses := a_clauses
			else
				last_invalid_written_postcondition_clauses := a_clauses
			end
		end

	exception_trace: STRING
			-- Trace of the exception.

	exception_signature: AFX_EXCEPTION_SIGNATURE
			--

feature{NONE} -- Access

	last_contracts_from_passing_tests: like last_contracts
			-- Contracts inferred from passing tests.

	last_sequence_based_contracts_from_passing_tests: like last_sequence_based_contracts
			-- Sequence based contracts inferred from passing tests.

	entry_states_from_failing_tests: HASH_TABLE [TUPLE [true_exprs, false_exprs: DS_HASH_SET [EPA_EXPRESSION]], CI_TEST_CASE_TRANSITION_INFO]
			-- Program states at feature entry in failing tests.
			-- test_case --> [set_of_expressions_value_true, set_of_expressions_value_false]

feature{NONE} -- Implementation

	collect_exception_condition
			--
		local
			l_explainer: EPA_EXCEPTION_TRACE_EXPLAINER
			l_summary: EPA_EXCEPTION_TRACE_SUMMARY
			l_exception_code: INTEGER
			l_exception_signature: AFX_EXCEPTION_SIGNATURE
		do
			if exception_trace /= Void and then not exception_trace.is_empty then
				create l_explainer
				l_explainer.explain (exception_trace)
				if l_explainer.was_successful then
					l_summary := l_explainer.last_explanation
					l_exception_code := l_summary.exception_code
					if l_exception_code = {EXCEP_CONST}.void_call_target then
						create {AFX_VOID_CALL_TARGET_VIOLATION_SIGNATURE} l_exception_signature.make (
								l_summary.failing_assertion_tag, 				-- l_exception_tag,
								l_summary.failing_context_class, 				-- l_current_class,
								l_summary.failing_feature, 						-- l_current_feature,
								l_summary.failing_position_breakpoint_index, 	-- l_current_breakpoint,
								1 												-- l_current_breakpoint_nested
							)
					elseif l_exception_code = {EXCEP_CONST}.precondition then
						create {AFX_PRECONDITION_VIOLATION_SIGNATURE} l_exception_signature.make (
								l_summary.failing_context_class, 				-- l_current_class,
								l_summary.failing_feature, 						-- l_current_feature,
								l_summary.failing_position_breakpoint_index, 	-- l_current_breakpoint,
								l_summary.recipient_context_class, 				-- l_previous_class,
								l_summary.recipient_feature, 					-- l_previous_feature,
								l_summary.recipient_breakpoint_index, 			-- l_previous_breakpoint,
								1 												-- l_previous_breakpoint_nested
							)
					elseif l_exception_code = {EXCEP_CONST}.postcondition then
						create {AFX_POSTCONDITION_VIOLATION_SIGNATURE} l_exception_signature.make (
								l_summary.failing_context_class, 				-- l_current_class,
								l_summary.failing_feature, 						-- l_current_feature,
								l_summary.failing_position_breakpoint_index 	-- l_current_breakpoint
							)
					elseif l_exception_code = {EXCEP_CONST}.class_invariant then
						create {AFX_INVARIANT_VIOLATION_SIGNATURE} l_exception_signature.make (
								l_summary.failing_assertion_tag, 				-- l_exception_tag,
								l_summary.recipient_context_class,				-- l_previous_class,
								l_summary.recipient_feature  					-- l_previous_feature
							)
					elseif l_exception_code = {EXCEP_CONST}.check_instruction then
						create {AFX_CHECK_VIOLATION_SIGNATURE} l_exception_signature.make (
								l_summary.failing_context_class, 				-- l_current_class,
								l_summary.failing_feature, 						-- l_current_feature,
								l_summary.failing_position_breakpoint_index		-- l_current_breakpoint
							)
					end
					exception_signature := l_exception_signature
				end
			end
		end

	add_exception_condition_to_feature_contracts
			--
		local
			l_class_name, l_feature_name, l_key: STRING
			l_contracts: TUPLE [pre: ARRAYED_SET [STRING]; post: ARRAYED_SET [STRING]]
			l_pre_clauses, l_post_clauses: ARRAYED_SET [STRING]
			l_violated_expression: EPA_EXPRESSION
			l_violated_expression_text: STRING
		do
				-- Add the exception condition expression from `exception_signature' to `feature_contracts'.
			if exception_signature /= Void and then exception_signature.exception_condition_in_recipient /= Void then
				l_violated_expression_text := exception_signature.exception_condition_in_recipient.text

				l_class_name := exception_signature.recipient_class.name_in_upper
				l_feature_name := exception_signature.recipient_feature.feature_name
				l_key := l_class_name.as_upper + "." + l_feature_name.as_lower
				if not feature_contracts.has (l_key) then
					create l_pre_clauses.make (10)
					create l_post_clauses.make (10)
					feature_contracts.force ([l_pre_clauses, l_post_clauses], l_key)
				else
					l_contracts := feature_contracts.item (l_key)
					l_pre_clauses := l_contracts.pre
					l_post_clauses := l_contracts.post
				end
				l_pre_clauses.extend (l_violated_expression_text.twin)
				l_post_clauses.extend (l_violated_expression_text.twin)
			end

		end

	disable_feature_contracts
			-- Disable the contracts of the feature under inference.
			-- Store the contract expressions in `feature_contracts'.
		local
			l_class_name, l_feature_name: STRING
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_contract_extractor: EPA_CONTRACT_EXTRACTOR
			l_pre_exprs, l_post_exprs: LINKED_LIST [EPA_EXPRESSION]
			l_expr_text: STRING
			l_pre_texts, l_post_texts: ARRAYED_SET [STRING]

			l_feature_contract_remover: AUT_FEATURE_CONTRACT_REMOVER
			l_names: LIST [STRING_8]
		do
			if config.should_disable_contracts then
				l_class_name := config.class_name
				l_feature_name := config.feature_name_for_test_cases.first

				l_class := first_class_starts_with_name (l_class_name)
				if l_class /= Void then
					l_feature := l_class.feature_named (l_feature_name)
				end

				if l_feature /= Void then
						-- Store the contract expressions
					create l_contract_extractor
					l_pre_exprs := l_contract_extractor.precondition_of_feature (l_feature, l_class)
					l_post_exprs:= l_contract_extractor.postcondition_of_feature (l_feature, l_class)
					pre_condition_exprs := l_pre_exprs
					post_condition_exprs:= l_post_exprs
					create l_pre_texts.make (l_pre_exprs.count + 1)
					create l_post_texts.make (l_post_exprs.count + 1)
					across l_pre_exprs  as l_pre_cursor  loop l_pre_texts.extend  (l_pre_cursor.item.text)  end
					across l_post_exprs as l_post_cursor loop l_post_texts.extend (l_post_cursor.item.text) end
					feature_contracts.force ([l_pre_texts, l_post_texts], l_class_name.as_upper + "." + l_feature_name.as_lower)

						-- Remove the contracts
					create l_feature_contract_remover
					l_feature_contract_remover.remove_contracts (l_class, l_feature)
				end
			end
		end

	pre_condition_exprs, post_condition_exprs: LINKED_LIST [EPA_EXPRESSION]
			-- Pre- and post condition expressions extracted from the feature under fix.
			-- These conditions are removed from the code for contract inference.

	build_project
			-- Using available test cases to build the project for fixing.
		local
			l_build_command: CI_BUILD_TEST_CASE_APP_CMD_EXT
		do
			check config.should_build_project end
			create l_build_command.make (config)
			l_build_command.execute (False)
			exception_trace := l_build_command.exception_trace

			number_passing_tests := l_build_command.number_passing_tests
			number_failing_tests := l_build_command.number_failing_tests
		end

	freeze_and_c_compile_project
			-- Create new root class.
		do
			Eiffel_project.quick_melt (True, True, True)
			Eiffel_project.freeze
			Eiffel_project.call_finish_freezing_and_wait (True)
		end

	infer_contracts_from_passing_tests
			-- Infer contracts using passing tests.
		local
		do
			log_manager.put_line_with_time (msg_contract_inference_from_passings_started)
			setup_inferrers
			initialize_data_structure
			set_exercising_passing_tests (True)

			log_manager.put_line_with_time (msg_test_case_execution_started)
			debug_project
			infer_contracts
			log_manager.put_line_with_time (msg_contract_inference_from_passings_ended)

			last_contracts_from_passing_tests := last_contracts
			last_sequence_based_contracts_from_passing_tests := last_sequence_based_contracts
		end

	launch_debugger
			-- <Precursor>
		local
			l_cmd: STRING
		do
			if is_exercising_passing_tests then
				l_cmd := feature_.feature_name.as_lower + " " + {CI_BUILD_TEST_CASE_APP_CMD_EXT}.Test_case_category_passing
			else
				l_cmd := feature_.feature_name.as_lower + " " + {CI_BUILD_TEST_CASE_APP_CMD_EXT}.Test_case_category_failing
			end
			start_debugger (debugger_manager, l_cmd, config.working_directory, {EXEC_MODES}.run, False)
		end

	collect_entry_states_from_failing_tests
			-- Collect program states at feature entry from failing tests.
		local
			l_entry_states: like entry_states_from_failing_tests
			l_test: CI_TEST_CASE_TRANSITION_INFO
			l_new_true_exprs, l_new_false_exprs: DS_HASH_SET [EPA_EXPRESSION]
			l_old_true_exprs, l_old_false_exprs: DS_HASH_SET [EPA_EXPRESSION]
		do
			log_manager.put_line_with_time (msg_contract_inference_from_failings_started)
			if number_failing_tests > 0 then
				setup_inferrers_for_collecting_entry_states
				initialize_data_structure

				log_manager.put_line_with_time (msg_test_case_execution_started)
				set_exercising_passing_tests (False)
				debug_project

					-- Collect entry states from transition data
				create entry_states_from_failing_tests.make_equal (1)
				if not transition_data.is_empty then
					setup_data
					entry_states_from_failing_tests.accommodate (data.transitions.count + 1)
					across inferrers as l_inferrers loop
						l_entry_states := l_inferrers.item.program_states_at_entry (data, last_contracts_from_passing_tests.item (True))
						across l_entry_states as l_states loop
							l_test := l_states.key
							l_new_true_exprs := l_states.item.true_exprs
							l_new_false_exprs := l_states.item.false_exprs

							if entry_states_from_failing_tests.has (l_test) then
								l_old_true_exprs := entry_states_from_failing_tests.item (l_test).true_exprs
								l_old_false_exprs:= entry_states_from_failing_tests.item (l_test).false_exprs
							else
								create l_old_true_exprs.make_equal (10)
								create l_old_false_exprs.make_equal (10)
								entry_states_from_failing_tests.put ([l_old_true_exprs, l_old_false_exprs], l_test)
							end
							l_old_true_exprs.merge (l_new_true_exprs)
							l_old_false_exprs.merge (l_new_false_exprs)
						end
					end
				end
			else
				create entry_states_from_failing_tests.make_equal (1)
			end
			log_manager.put_line_with_time (msg_contract_inference_from_failings_ended)
		end

	setup_inferrers_for_collecting_entry_states
			-- Setup `inferrers'.
		local
			l_simple_inferrer: CI_SIMPLE_FRAME_CONTRACT_INFERRER
			l_sequence_inferrer: CI_SEQUENCE_PROPERTY_INFERRER
			l_composite_frame_inferrer: CI_COMPOSITE_FRAME_PROPERTY_INFERRER
			l_daikon_inferrer: CI_DAIKON_INFERRER
			l_dnf_inferrer: CI_DNF_INFERRER
			l_implication_inferrer: CI_IMPLICATION_INFERRER
			l_linear_inferrer: CI_LINEAR_REGRESSION_INFERRER
			l_simple_equality_inferrer: CI_SIMPLE_EQUALITY_INFERRER
			l_dummy_inferrer: CI_DUMMY_INFERRER
			l_constant_change_inferrer: CI_CONSTANT_CHANGE_INFERRER
			l_semantic_search_inferrer: CI_SEMANTIC_SEARCH_DATA_COLLECTOR_INFERRER
			l_solr_inferrer: CI_SOLR_INFERRER
			l_sql_inferrer: CI_SQL_INFERRER
		do
			create inferrers.make (20)

			if config.is_dnf_property_enabled and then number_passing_tests > 0 then
				create l_dnf_inferrer
				l_dnf_inferrer.set_config (config)
				l_dnf_inferrer.set_logger (log_manager)
				inferrers.extend (l_dnf_inferrer)
			end

			if config.is_simple_equality_property_enabled then
				create l_simple_equality_inferrer
				l_simple_equality_inferrer.set_config (config)
				l_simple_equality_inferrer.set_logger (log_manager)
				inferrers.extend (l_simple_equality_inferrer)
			end
		end

feature{NONE} -- Log

	log_candidate_extra_precondition_clauses
		local
			l_list_clauses: like last_candidate_extra_precondition_clauses
			l_exps: DS_HASH_SET [EPA_EXPRESSION]
			l_maximum_nbr, l_index: INTEGER_32
		do
			if number_failing_tests > 0 then
				log_manager.put_line (mark_starting_extra_preconditions)
				l_list_clauses := last_candidate_extra_precondition_clauses
				l_maximum_nbr := config.max_precondition_proposals
				from
					l_index := 0
					l_list_clauses.start
				until
					l_list_clauses.after or else l_index >= l_maximum_nbr
				loop
					l_exps := l_list_clauses.item_for_iteration
					log_contract_clauses (l_exps, mark_information_prefix + "#" + l_index.out, "")
					l_index := l_index + 1
					l_list_clauses.forth
				end
				log_manager.put_line (mark_ending_extra_preconditions)
			else
				log_manager.put_line (mark_no_failing_tests_available)
				log_manager.put_line (mark_information_prefix + "Use invariants inferred from passing test cases or 'True' as the precondition.")
			end
		end

	log_contract_clauses (a_clauses: DS_HASH_SET [EPA_EXPRESSION]; a_prologue, a_epilogue: STRING)
			--
		local
		do
			log_manager.put_line (a_prologue)
			from a_clauses.start
			until a_clauses.after
			loop
				log_manager.put_line (a_clauses.item_for_iteration.text)
				a_clauses.forth
			end
			log_manager.put_line (a_epilogue)
		end

	check_written_contract_clauses (a_is_pre: BOOLEAN)
			-- Check written contract clauses against the inferred invariants across passing tests.
			-- Update `last_valid_written_precondition_clauses' and `last_invalid_written_precondition_clauses'.
			--		as well as `last_valid_written_postcondition_clauses' and `last_invalid_written_postcondition_clauses'.
		local
			l_written_exps: LINKED_LIST [EPA_EXPRESSION]
			l_valid_written_exps, l_invalid_written_exps, l_inferred_exps: DS_HASH_SET [EPA_EXPRESSION]
			l_inferred_exps_map: HASH_TABLE [EPA_EXPRESSION, STRING]
			l_text, l_simplified_text, l_uuid: STRING
			l_exp: EPA_EXPRESSION
		do
			if config.should_check_existing_contracts then
				fixme ("Here we removed 'Current.', '(', and ')' from inferred and written contracts to avoid incorrect mismatch.")
				fixme ("A rewriter should be provided to do this in a safer way.")

					-- Inferred contracts
				l_inferred_exps := last_contracts_from_passing_tests.item (a_is_pre)
				create l_inferred_exps_map.make_equal (l_inferred_exps.count)
				from l_inferred_exps.start until l_inferred_exps.after loop
					l_text := l_inferred_exps.item_for_iteration.text.twin
					l_text.replace_substring_all ("Current.", "")
					l_text.replace_substring_all ("(", "")
					l_text.replace_substring_all (")", "")
					l_inferred_exps_map.force (l_inferred_exps.item_for_iteration, l_text)
					l_inferred_exps.forth
				end

					-- Expressions from programmers
					-- Implicit precondition is regarded as "True"
				if a_is_pre then
					l_written_exps := pre_condition_exprs
				else
					l_written_exps := post_condition_exprs
				end

					-- Compute the sets of valid as well as invalid programmer-written expressions
				create l_valid_written_exps.make_equal (l_written_exps.count)
				create l_invalid_written_exps.make_equal (l_written_exps.count)
				from l_written_exps.start until l_written_exps.after loop
					l_exp := l_written_exps.item_for_iteration
					l_simplified_text := l_exp.text.twin
					l_simplified_text.replace_substring_all ("Current.", "")
					l_simplified_text.replace_substring_all ("(", "")
					l_simplified_text.replace_substring_all (")", "")
					if l_simplified_text.as_lower.same_string ("true") or l_inferred_exps_map.has (l_simplified_text) then
						l_valid_written_exps.force (l_exp)
					else
						l_invalid_written_exps.force (l_exp)
					end
					l_written_exps.forth
				end
				set_last_valid_written_contract_clauses (a_is_pre, l_valid_written_exps)
				set_last_invalid_written_contract_clauses (a_is_pre, l_invalid_written_exps)
			else
				set_last_valid_written_contract_clauses (a_is_pre, create {DS_HASH_SET [EPA_EXPRESSION]}.make_equal (1))
				set_last_invalid_written_contract_clauses (a_is_pre, create {DS_HASH_SET [EPA_EXPRESSION]}.make_equal (1))
			end
		end

	failing_tests_satisfying_valid_written_clauses: TUPLE[certain_satisfactions, possible_satisfactions: like entry_states_from_failing_tests]
			-- Compute set of failing inputs satisfing `last_valid_written_precondition_clauses'.
			-- Empty `last_valid_written_precondition_clauses' means True, and all runs satisfy True.
		local
			l_valid_written_precondition_clauses: like last_valid_written_precondition_clauses
			l_expr: EPA_EXPRESSION
			l_certain_satisfactions, l_possible_satisfactions: like entry_states_from_failing_tests
			l_tests_to_remove: ARRAYED_LIST [CI_TEST_CASE_TRANSITION_INFO]
			l_true_exprs, l_false_exprs: DS_HASH_SET [EPA_EXPRESSION]
		do
			if last_valid_written_precondition_clauses = Void then
					-- No Passing tests.
				l_certain_satisfactions := entry_states_from_failing_tests.twin
				l_possible_satisfactions:= entry_states_from_failing_tests.twin
			else	-- Passing tests exist.
					-- Remove 'True' condition.
				create l_valid_written_precondition_clauses.make (last_valid_written_precondition_clauses.count + 1)
				last_valid_written_precondition_clauses.do_if (agent l_valid_written_precondition_clauses.force_last,
					agent (a_expr: EPA_EXPRESSION): BOOLEAN do Result := not a_expr.text.as_lower.same_string_general ("true") end)

				if l_valid_written_precondition_clauses.is_empty then
					l_certain_satisfactions := entry_states_from_failing_tests.twin
					l_possible_satisfactions:= entry_states_from_failing_tests.twin
				else
					create l_certain_satisfactions.make_equal (entry_states_from_failing_tests.count)
					create l_possible_satisfactions.make_equal (entry_states_from_failing_tests.count)
					across entry_states_from_failing_tests as l_input_cursor loop
						l_true_exprs := l_input_cursor.item.true_exprs
						l_false_exprs := l_input_cursor.item.false_exprs

						if l_valid_written_precondition_clauses.intersection (l_false_exprs).is_empty then
							l_possible_satisfactions.force (l_input_cursor.item, l_input_cursor.key)
						end
						if l_valid_written_precondition_clauses.is_subset (l_true_exprs) then
							l_certain_satisfactions.force (l_input_cursor.item, l_input_cursor.key)
						end
					end
				end
			end

			Result := [l_certain_satisfactions, l_possible_satisfactions]
		end

	compute_candidate_preconditions
			-- Compute candidate preconditions for `class_'.`feature_'.
			-- Make them available in `last_candidate_preconditions'.
			--
			-- Candidate preconditions should allow all the passing runs,
			-- 		therefore the candidate expressions should be in the set of inferred precondition clauses;
			--			candidate expressions := valid written precondition clauses + extra candidate expressions
			--		where written precondition clauses inside the set of inferred are valid.
			-- Candidate preconditions should also reject all the failing runs,
			--		therefore extra candidate expressions should reject all the failing runs
			--		that the valid written precondition clauses do not reject.
		local
			l_failing_inputs: TUPLE[certain_satisfactions, possible_satisfactions: like entry_states_from_failing_tests]
			l_certain_satisfactions, l_possible_satisfactions, l_inputs_to_reject: like entry_states_from_failing_tests
			l_inferred_exps: DS_HASH_SET [EPA_EXPRESSION]
			l_candidate_exp_domain: EPA_HASH_SET [EPA_EXPRESSION]
			l_uuid: STRING
			l_failing_states_from_uuid: HASH_TABLE [TUPLE [true_exprs, false_exprs: DS_HASH_SET [EPA_EXPRESSION]], STRING]
			l_exp_to_rejected_uuids: HASH_TABLE [DS_HASH_SET[STRING], EPA_EXPRESSION]
			l_uuids: DS_HASH_SET[STRING]
			l_equality_tester: AGENT_BASED_EQUALITY_TESTER [DS_HASH_SET [EPA_EXPRESSION]]
			l_sorter: DS_QUICK_SORTER [DS_HASH_SET [EPA_EXPRESSION]]
			l_true_exprs, l_false_exprs: DS_HASH_SET [EPA_EXPRESSION]
		do
				-- Domain for the rest precondition expressions.
			if last_contracts_from_passing_tests /= Void then
					-- When there are passing tests, the rest precondition expressions should come from inferred preconditions.
				l_inferred_exps:= last_contracts_from_passing_tests.item (True)
				create l_candidate_exp_domain.make_equal (l_inferred_exps.count + 1)
				l_candidate_exp_domain.append (l_inferred_exps.subtraction (last_valid_written_precondition_clauses))
			else
					-- When there are no passing tests, use the false-valued expressions from a failing test.
				create l_candidate_exp_domain.make_equal (1024)
				if entry_states_from_failing_tests /= Void and then not entry_states_from_failing_tests.is_empty then
					entry_states_from_failing_tests.start
					l_false_exprs := entry_states_from_failing_tests.item_for_iteration.false_exprs
					l_candidate_exp_domain.merge (l_false_exprs)
				end
			end

			create last_candidate_extra_precondition_clauses.make (1)
			if not entry_states_from_failing_tests.is_empty then
				l_failing_inputs := failing_tests_satisfying_valid_written_clauses
				l_certain_satisfactions := l_failing_inputs.certain_satisfactions
				l_possible_satisfactions:= l_failing_inputs.possible_satisfactions

				if config.should_explicitly_reject_failing_tests then
					l_inputs_to_reject := l_possible_satisfactions
				else
					l_inputs_to_reject := l_certain_satisfactions
				end

				if l_inputs_to_reject.is_empty then
						-- Do nothing
					log_manager.put_line (Mark_all_failing_tests_rejected)
				else
						-- Use UUIDs to represent tests.
					create l_failing_states_from_uuid.make_equal (l_inputs_to_reject.count + 1)
					create l_uuids.make_equal (l_inputs_to_reject.count + 1)
					across l_inputs_to_reject as l_input_cursor loop
						l_uuid := l_input_cursor.key.test_case_info.uuid
						l_failing_states_from_uuid.force (l_input_cursor.item, l_uuid)
						l_uuids.force (l_uuid)
					end
					l_exp_to_rejected_uuids := expression_to_rejected_uuids (l_candidate_exp_domain, l_failing_states_from_uuid)

					last_candidate_extra_precondition_clauses := expression_combinations_rejecting_all (l_exp_to_rejected_uuids, l_uuids)
						-- Candidate extra-preconditions ordered by the number of tests (UUIDs) they reject.
					create l_equality_tester.make (agent is_preferrable (?, ?, l_exp_to_rejected_uuids))
					create l_sorter.make (l_equality_tester)
					l_sorter.sort (last_candidate_extra_precondition_clauses)

				end
			end
		end

	candidate_expression_combinations (a_exprs: EPA_HASH_SET[EPA_EXPRESSION]): LINKED_LIST [EPA_HASH_SET [EPA_EXPRESSION]]
			-- Candidate combinations of expressions from `a_exprs', up to length `config.max_precondition_clauses'.
		local
			l_nbr_clauses, l_max_nbr_clauses: INTEGER
		do
			l_max_nbr_clauses := config.max_precondition_clauses
			Result := a_exprs.combinations (1)
			from l_nbr_clauses := 2
			until l_nbr_clauses > l_max_nbr_clauses
			loop
				Result.append (a_exprs.combinations (l_nbr_clauses))
				l_nbr_clauses := l_nbr_clauses + 1
			end
		end

	expression_combinations_rejecting_all (a_map: HASH_TABLE [DS_HASH_SET[STRING], EPA_EXPRESSION]; a_uuids: DS_HASH_SET[STRING])
				: like last_candidate_extra_precondition_clauses
			-- Combinations of expressions from the keys of `a_map', such that they reject all tests with `a_uuids'.
			-- `a_map' mapps expressions to the set of uuids they reject.
		local
			l_exprs_array: ARRAY [EPA_EXPRESSION]
			l_exprs_set: EPA_HASH_SET [EPA_EXPRESSION]
			l_combinations: LINKED_LIST [EPA_HASH_SET [EPA_EXPRESSION]]
			l_exp_combination: EPA_HASH_SET [EPA_EXPRESSION]
			l_exp_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_rejected_uuids: DS_HASH_SET [STRING]
			l_total_number_uuids: INTEGER
			l_is_super_set, l_is_contradictory: BOOLEAN
			l_unnegated_texts: DS_HASH_SET [STRING]
			l_text: STRING
		do
			l_total_number_uuids := a_uuids.count

				-- Generate combinations of expressions from `a_map.key'.
			l_exprs_array := a_map.current_keys
			create l_exprs_set.make_equal (l_exprs_array.count)
			l_exprs_array.do_all (agent l_exprs_set.force)
			l_combinations := candidate_expression_combinations (l_exprs_set)

				-- Select candidate extra-preconditions that reject all UUIDs into `Result'.
			create Result.make (l_combinations.count // 3 + 1)
			across l_combinations as l_comb_cursor loop
				l_exp_combination := l_comb_cursor.item

					-- Check the combination doesn't contain conflicting expressions
				create l_unnegated_texts.make_equal (l_exp_combination.count)
				l_is_contradictory := False
				from
					l_exp_cursor := l_exp_combination.new_cursor
					l_exp_cursor.start
				until
					l_exp_cursor.after or else l_is_contradictory
				loop
					l_text := l_exp_cursor.item.text
					if not l_text.starts_with ("not (") then
						l_text := "not (" + l_text + ")"
					end
					l_is_contradictory := l_unnegated_texts.has (l_text)
					l_unnegated_texts.force (l_text)
					l_exp_cursor.forth
				end

					-- Check the combination if none of its subsets suffices for rejecting all the failing tests.
				from
					l_is_super_set := False
					Result.start
				until
					Result.after or else l_is_super_set
				loop
					l_is_super_set := Result.item_for_iteration.is_subset (l_exp_combination)
					Result.forth
				end

					-- Keep only the combinations that reject all failing tests.
				if not l_is_super_set then
					create l_rejected_uuids.make (l_total_number_uuids)
					from
						l_exp_cursor := l_exp_combination.new_cursor
						l_exp_cursor.start
					until
						l_exp_cursor.after
					loop
						l_rejected_uuids.merge (a_map.item (l_exp_cursor.item))

						l_exp_cursor.forth
					end

					if l_rejected_uuids.count = l_total_number_uuids then
						Result.force_last (l_exp_combination)
					end
				end
			end
		end

	expression_to_rejected_uuids (a_exprs: DS_HASH_SET[EPA_EXPRESSION]; a_failing_states_from_uuid: HASH_TABLE [TUPLE [true_exprs, false_exprs: DS_HASH_SET [EPA_EXPRESSION]], STRING])
				: HASH_TABLE [DS_HASH_SET[STRING], EPA_EXPRESSION]
			-- Table from expressions from `a_exprs' to set of uuids, whose input states,
			-- according to `a_failing_inputs', do not satisfy the expression.
			--
			-- Expressions that don't reject any failing input have NO entry in the result table.
		local
			l_exp_to_remove: EPA_HASH_SET [EPA_EXPRESSION]
			l_total_number_uuids: INTEGER
			l_exp_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_exp, l_neg_exp: EPA_EXPRESSION
			l_text: STRING
			l_rejected_uuids, l_rejected_uuids_by_negation: DS_HASH_SET[STRING]
			l_nest_level, l_index, l_count: INTEGER
			l_valid: BOOLEAN
			l_creator: EPA_AST_EXPRESSION_SAFE_CREATOR
		do
				-- Map candidate expressions to the set of runs (UUIDs) they reject.
				-- Remove candidates that reject no failing runs.
				-- Note: All candidate expressions have values in all runs, either True or False.
			create Result.make_equal (a_exprs.count + 1)
			create l_exp_to_remove.make_equal (a_exprs.count + 1)
			from
				l_exp_cursor := a_exprs.new_cursor
				l_exp_cursor.start
			until
				l_exp_cursor.after
			loop
				l_exp := l_exp_cursor.item

				create l_rejected_uuids.make_equal (a_failing_states_from_uuid.count + 1)
				across a_failing_states_from_uuid as l_state_cursor loop
					if l_state_cursor.item.false_exprs.has(l_exp) then
						l_rejected_uuids.force (l_state_cursor.key)
					end
				end

				if l_rejected_uuids.is_empty then
					l_exp_to_remove.force (l_exp)
				else
					Result.force (l_rejected_uuids, l_exp)
				end

				l_exp_cursor.forth
			end
		end

	is_preferrable (a_exps1, a_exps2: DS_HASH_SET[EPA_EXPRESSION]; a_exp_to_rejections: HASH_TABLE [DS_HASH_SET[STRING], EPA_EXPRESSION]): BOOLEAN
			-- Is `a_exps1' more preferrable than `a_exps2', in rejecting all UUIDs?
			-- A set of expressions is more preferrable is the overlap between the sets of their rejections is smaller.
		local
			l_nbr_rejects1, l_nbr_rejects2: INTEGER
			l_length1, l_length2: INTEGER
		do
			if a_exps1.count = a_exps2.count then
				l_nbr_rejects1 := total_number_rejections (a_exps1, a_exp_to_rejections)
				l_nbr_rejects2 := total_number_rejections (a_exps2, a_exp_to_rejections)
				if l_nbr_rejects1 = l_nbr_rejects2 then
					l_length1 := text_length (a_exps1)
					l_length2 := text_length (a_exps2)
					Result := l_length1 <= l_length2
				else
					Result := l_nbr_rejects1 = l_nbr_rejects2
				end
			else
				Result := a_exps1.count < a_exps2.count
			end
		end

	total_number_rejections (a_exps: DS_HASH_SET[EPA_EXPRESSION]; a_exp_to_rejections: HASH_TABLE [DS_HASH_SET[STRING], EPA_EXPRESSION]): INTEGER
			-- Total number of rejections by `a_exps'.
			-- Rejection of a UUID by multiple expressions are counted multiple times.
		do
			from a_exps.start
			until a_exps.after
			loop
				Result := Result + a_exp_to_rejections.item (a_exps.item_for_iteration).count
				a_exps.forth
			end
		end

	text_length (a_exps: DS_HASH_SET[EPA_EXPRESSION]): INTEGER
		do
			from a_exps.start
			until a_exps.after
			loop
				Result := Result + a_exps.item_for_iteration.text.count
				a_exps.forth
			end
		end

feature -- Output marks

	Mark_starting_interesting_info: STRING = ">>>>>>>>>>>>>>>>>>>>>>>>> Starting interesting area"
	Mark_ending_interesting_info:   STRING = ">>>>>>>>>>>>>>>>>>>>>>>>> Ending interesting area"

		-- Precondition related
		-- 		Valid written clauses
	Mark_starting_valid_written_preconditions: STRING = ">>>>>>>>>>>>>>>>>>>>>>>>> Starting valid written preconditions"
	Mark_ending_valid_written_preconditions: STRING = ">>>>>>>>>>>>>>>>>>>>>>>>> Ending valid written preconditions"
		-- 		Invalid written clauses
	Mark_starting_invalid_written_preconditions: STRING = ">>>>>>>>>>>>>>>>>>>>>>>>> Starting invalid written preconditions"
	Mark_ending_invalid_written_preconditions: STRING = ">>>>>>>>>>>>>>>>>>>>>>>>> Ending invalid written preconditions"
		-- 		Inferred extra clauses
	Mark_starting_extra_preconditions: STRING = ">>>>>>>>>>>>>>>>>>>>>>>>> Starting extra preconditions"
	Mark_ending_extra_preconditions: STRING = ">>>>>>>>>>>>>>>>>>>>>>>>> Ending extra preconditions"

		-- Postcondition related
		-- 		Valid written clauses
	Mark_starting_valid_written_postconditions: STRING = ">>>>>>>>>>>>>>>>>>>>>>>>> Starting valid written postconditions"
	Mark_ending_valid_written_postconditions: STRING = ">>>>>>>>>>>>>>>>>>>>>>>>> Ending valid written postconditions"
		-- 		Invalid written clauses
	Mark_starting_invalid_written_postconditions: STRING = ">>>>>>>>>>>>>>>>>>>>>>>>> Starting invalid written postconditions"
	Mark_ending_invalid_written_postconditions: STRING = ">>>>>>>>>>>>>>>>>>>>>>>>> Ending invalid written postconditions"

	Mark_no_passing_tests_available: STRING = ">>>>>>>>>>>>>>>>>>>>>>>>> No passing tests available."
	Mark_no_failing_tests_available: STRING = ">>>>>>>>>>>>>>>>>>>>>>>>> No failing tests available."
	Mark_all_failing_tests_rejected: STRING = ">>>>>>>>>>>>>>>>>>>>>>>>> All failing tests rejected."

	Mark_information_prefix: STRING = ">>>>>>>>>>>>>>>>>>>>>>>>> :"

end


