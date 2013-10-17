note
	description: "Summary description for {AFX_TEST_CASE_MONITOR_FOR_FIXING_CONTRACTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_TEST_CASE_MONITOR_FOR_FIXING_CONTRACTS

inherit

	AFX_TRACE_COLLECTOR
		redefine
			on_application_exception,
			on_breakpoint_hit_in_test_case
		end

	INTERNAL_COMPILER_STRING_EXPORTER

create
	make

feature{NONE} -- Initialization

	make
			-- Initialization.
		do
			make_general
		end

feature -- Callbacks

	on_breakpoint_hit_in_test_case (a_class: CLASS_C; a_feature: FEATURE_I; a_breakpoint: BREAKPOINT; a_state: EPA_STATE)
			-- <Precursor>
		local
			l_current_program_location_context: EPA_FEATURE_WITH_CONTEXT_CLASS
		do
			l_current_program_location_context := current_program_location_context
			test_case_execution_event_listeners.do_all (agent {AFX_TEST_CASE_EXECUTION_EVENT_LISTENER}.on_breakpoint_hit (test_case_info, a_state, create {AFX_PROGRAM_LOCATION}.make (l_current_program_location_context, a_breakpoint.breakable_line_number)))
			event_actions.notify_on_break_point_hit (test_case_info, a_breakpoint.breakable_line_number)
		end

	on_application_exception (a_dm: DEBUGGER_MANAGER)
			-- Action on application exception.
		do
			if not is_in_mode_monitor then
					-- Corresponds to the execution of the first test case, which is used to reproduce the fault.
				analyze_exception (a_dm)
				initialize_features_on_stack
				register_program_state_monitoring

				entry_breakpoint_manager.toggle_breakpoints (True)
			else
				if is_inside_test_case then
						-- During monitoring, mark the trace as from a FAILED execution.
					trace_repository.current_trace.set_status_as_failing
				end
			end
		end

feature -- Access

	features_on_stack: DS_ARRAYED_LIST [AFX_FEATURE_TO_MONITOR]
		do
			if features_on_stack_cache = Void then
				initialize_features_on_stack
			end
			Result := features_on_stack_cache
		end

	contract_expressions_for_features: DS_HASH_TABLE [TUPLE [pre, post: EPA_HASH_SET [EPA_AST_EXPRESSION]], AFX_FEATURE_TO_MONITOR]
		do
			if contract_expressions_for_features_cache = Void then
				create contract_expressions_for_features_cache.make_equal (20)
			end
			Result := contract_expressions_for_features_cache
		end

	feature_contracts: DS_HASH_TABLE [TUPLE[pre, post: EPA_HASH_SET[EPA_AST_EXPRESSION]], AFX_FEATURE_TO_MONITOR]
			-- Cached contracts of features.
			-- Key: CLASS_NAME.feature_name
			-- Val: tuple of string sets, each string represents a contract clause.
		do
			if feature_contracts_cache = Void then
				create feature_contracts_cache.make_equal (2)
			end
			Result := feature_contracts_cache
		end

feature{NONE} -- Implementation

	register_program_state_monitoring
			-- <Precursor>
		local
			l_features_on_stack: like features_on_stack
			l_feature_to_monitor: AFX_FEATURE_TO_MONITOR
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_contract_expressions: TUPLE [pre, post: EPA_HASH_SET [EPA_AST_EXPRESSION]]
			l_expressions: LINKED_LIST [EPA_AST_EXPRESSION]
			l_state_skeleton: EPA_STATE_SKELETON
			l_manager: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
			l_contract_extractor: EPA_CONTRACT_EXTRACTOR
			l_nbr_postconditions, l_total_breakpoints: INTEGER
		do
			l_features_on_stack := features_on_stack
			create l_contract_extractor
			from
				l_features_on_stack.start
			until
				l_features_on_stack.after
			loop
				l_feature_to_monitor := l_features_on_stack.item_for_iteration

				l_class := l_feature_to_monitor.context_class
				l_feature := l_feature_to_monitor.feature_
				l_total_breakpoints := l_feature.e_feature.number_of_breakpoint_slots
				l_nbr_postconditions := l_contract_extractor.postcondition_of_feature (l_feature, l_class).count

				l_contract_expressions := expressions_for_contracts (l_feature_to_monitor)
				create l_expressions.make
				l_contract_expressions.post.do_all (agent l_expressions.force)

				create l_manager.make (l_class, l_feature)
				l_manager.set_breakpoint_with_expression_and_action (1,
																	 l_contract_expressions.pre, agent on_breakpoint_hit_in_test_case (l_class, l_feature, ?, ?))
				l_manager.set_breakpoint_with_expression_and_action (l_total_breakpoints - l_nbr_postconditions + 1,
																	 l_contract_expressions.post, agent on_breakpoint_hit_in_test_case (l_class, l_feature, ?, ?))
				monitored_breakpoint_managers.force_last (l_manager)

				l_features_on_stack.forth
			end
		end

	initialize_features_on_stack
		local
			l_stack: EIFFEL_CALL_STACK
			l_stack_element, l_test_element: CALL_STACK_ELEMENT
			l_stack_elements: DS_ARRAYED_LIST [CALL_STACK_ELEMENT]
			i: INTEGER_32
			l_test_element_depth: INTEGER_32
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_feature_on_stack: AFX_FEATURE_TO_MONITOR
			l_done: BOOLEAN
			l_observed_features: EPA_HASH_SET [STRING]
			l_observed_feature_name: STRING
		do
			create features_on_stack_cache.make_equal (50)
			l_stack := debugger_manager.application_status.current_call_stack
			from
				i := 1
				create l_stack_elements.make (l_stack.count + 1)
				create l_observed_features.make_equal (l_stack.count + 1)
			until i > l_stack.count or else l_test_element /= Void or else l_done
			loop
				l_stack_element := l_stack.i_th (i)
				if l_stack_element.routine_name.same_string_general ("generated_test_1") then
					l_done := True
				else
					l_class := first_class_starts_with_name (l_stack_element.class_name)
					if l_class /= Void then
						l_feature := l_class.feature_named (l_stack_element.routine_name)
						if l_feature /= Void then
							l_observed_feature_name := l_class.name_in_upper + "." + l_feature.feature_name_32
							if not l_observed_features.has (l_observed_feature_name) then
								l_observed_features.force (l_observed_feature_name)
								create l_feature_on_stack.make (l_feature, l_class)
								features_on_stack_cache.force_last (l_feature_on_stack)
							end
						end
					end
					l_stack_elements.force_last (l_stack_element)
				end
				i := i + 1
			end
		end

feature -- Setter

	set_contract_expressions_for_features (a_exprs: like contract_expressions_for_features)
		do
			contract_expressions_for_features_cache := a_exprs
		end

feature -- Expressions to monitor

	expressions_for_contracts (a_feature: AFX_FEATURE_TO_MONITOR): TUPLE [pre, post: EPA_HASH_SET [EPA_AST_EXPRESSION]]
			-- Set of expressions that could appear in the pre-/postcondition of `a_feature'.
		local
			l_arguments: DS_HASH_TABLE [TYPE_A, STRING]
			l_operand_names: DS_LINKED_LIST[STRING]
			l_expression, l_failing_precondition_in_recipient: EPA_AST_EXPRESSION
			l_expressions, l_precondition_expressions, l_postcondition_expressions, l_post_contracts, l_pre_contracts, l_all_contracts: EPA_HASH_SET[EPA_AST_EXPRESSION]
			l_expressions_to_extend: EPA_HASH_SET [EPA_AST_EXPRESSION]
			l_constructor: AFX_BASIC_TYPE_EXPRESSION_CONSTRUCTOR
			l_exp_creator: EPA_AST_EXPRESSION_SAFE_CREATOR
			l_sub_expressions_from_contracts: TUPLE[pre, post: DS_HASH_SET [EPA_AST_EXPRESSION]]
			l_is_creation_procedure: BOOLEAN
			l_extra_precondition_expressions: DS_ARRAYED_LIST[EPA_AST_EXPRESSION]
		do
			if not contract_expressions_for_features.has (a_feature) then
					-- (Sub)Expressions from existing contracts that can be used in constructing the new postcondition.
				create l_post_contracts.make_equal (100)
				l_sub_expressions_from_contracts := sub_expressions_from_contracts (a_feature)
				l_post_contracts.merge (l_sub_expressions_from_contracts.pre)
				l_post_contracts.merge (l_sub_expressions_from_contracts.post)
					-- Expressions also suitable for precondition
				create l_pre_contracts.make_equal (l_post_contracts.count + 1)
				from l_post_contracts.start
				until l_post_contracts.after
				loop
					l_expression := l_post_contracts.item_for_iteration
					if not l_expression.text.has_substring ("Result") and then not l_expression.text.has_substring ("old ") then
						l_pre_contracts.force (l_expression)
					end
					l_post_contracts.forth
				end

					-- Precondition expressions derived form operands.
				create l_expressions_to_extend.make_equal (20)
				l_arguments := arguments_from_feature (a_feature.feature_, a_feature.context_class)
				l_arguments.remove ("Result")
				from l_arguments.start
				until l_arguments.after
				loop
					l_expression := l_exp_creator.safe_create_with_text (a_feature.context_class, a_feature.feature_, l_arguments.key_for_iteration, a_feature.written_class)
					if attached l_expression then
						l_expressions_to_extend.force (l_expression)
					end
					l_arguments.forth
				end
				l_is_creation_procedure := a_feature.context_class.valid_creation_procedure_32 (a_feature.feature_.feature_name_32)
				if not l_is_creation_procedure then
					l_expressions_to_extend.force (l_exp_creator.safe_create_with_text (a_feature.context_class, a_feature.feature_, "Current", a_feature.written_class))
				end
				l_precondition_expressions := derived_expressions (a_feature, l_expressions_to_extend, l_pre_contracts)
				l_precondition_expressions.append (expressions_capturing_argument_relations (a_feature))
--				l_extra_precondition_expressions := extra_precondition_expressions (a_feature)
--				if not l_is_creation_procedure then
--					l_precondition_expressions.append (l_extra_precondition_expressions)
--				end

					-- 'Current' is always referrable in the postcondition.
				l_expressions_to_extend.force (l_exp_creator.safe_create_with_text (a_feature.context_class, a_feature.feature_, "Current", a_feature.written_class))
				if a_feature.feature_.has_return_value then
					l_expressions_to_extend.force (l_exp_creator.safe_create_with_text (a_feature.context_class, a_feature.feature_, "Result", a_feature.written_class))
				end
				l_postcondition_expressions := derived_expressions (a_feature, l_expressions_to_extend, l_post_contracts)
				l_postcondition_expressions.append (expressions_capturing_argument_relations (a_feature))
				l_postcondition_expressions.append (variant_postconditions)
--				if not l_is_creation_procedure then
--					l_postcondition_expressions.append (l_extra_precondition_expressions)
--				end

					-- Include also the violated condition if feature_under_test is the exception recipient.
				if session.exception_signature.is_precondition_violation and then a_feature ~ features_on_stack.item (2) and then attached session.exception_signature.exception_condition_in_recipient as lt_failing_condition then
					l_precondition_expressions.force (lt_failing_condition)
					l_postcondition_expressions.force (lt_failing_condition)
				end
				contract_expressions_for_features.force ( [l_precondition_expressions, l_postcondition_expressions], a_feature)
			end

			Result := contract_expressions_for_features.item (a_feature)
		end

	sub_expressions_from_contracts (a_feature: AFX_FEATURE_TO_MONITOR): TUPLE [pre, post: DS_HASH_SET [EPA_AST_EXPRESSION]]
			-- Set of expressions and their sub-expressions from the interface contracts of `a_feature'.
			-- If `a_precondition', the expressions are from the feature precondition; otherwise from feature postcondition.
		local
			l_exps, l_all_exprs, l_pre_exprs, l_post_exprs: EPA_HASH_SET [EPA_AST_EXPRESSION]
			l_pre_contracts, l_post_contracts: EPA_HASH_SET [EPA_AST_EXPRESSION]
			l_exprs_as_string: ARRAYED_SET [STRING]
			l_expr_creator: EPA_AST_EXPRESSION_SAFE_CREATOR
			l_expr: EPA_AST_EXPRESSION
			l_cursor: DS_HASH_SET_CURSOR [EPA_AST_EXPRESSION]
			l_feat: EPA_FEATURE_WITH_CONTEXT_CLASS
			l_contract_extractor: EPA_CONTRACT_EXTRACTOR
			l_sub_expression_collector: EPA_SUB_EXPRESSION_COLLECTOR
		do
			create l_contract_extractor
			across <<True, False>> as lt_pre loop
				create l_exps.make_equal (20)
				create l_all_exprs.make_equal (l_exps.count * 2 + 1)
				if lt_pre.item then
					l_contract_extractor.precondition_of_feature (a_feature.feature_, a_feature.context_class).do_all (agent l_exps.put_last)
					l_pre_exprs := l_all_exprs
					l_pre_contracts := l_exps
				else
					l_contract_extractor.postcondition_of_feature (a_feature.feature_, a_feature.context_class).do_all (agent l_exps.put_last)
					l_post_exprs := l_all_exprs
					l_post_contracts := l_exps
				end
					-- Collect sub expressions from contracts.
				create l_sub_expression_collector
				from
					l_cursor := l_exps.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					l_sub_expression_collector.collect_from_ast (a_feature, l_cursor.item.ast)
					l_all_exprs.append (l_sub_expression_collector.last_sub_expressions)

					l_cursor.forth
				end
			end
			feature_contracts.force ([l_pre_contracts, l_post_contracts], a_feature)
			Result := [l_pre_exprs, l_post_exprs]
		end

	extra_precondition_expressions (a_feature: AFX_FEATURE_TO_MONITOR): DS_ARRAYED_LIST [EPA_AST_EXPRESSION]
		local
			l_feature_table: FEATURE_TABLE
			l_features: DS_ARRAYED_LIST [FEATURE_I]
			l_next_feature: FEATURE_I
			l_arguments: DS_HASH_TABLE [TYPE_A, STRING]
			l_type, l_feature_type: TYPE_A
			l_feature_name: STRING
			l_arg_name: STRING
			l_feature_call: EPA_AST_EXPRESSION
			l_exp_creator: EPA_AST_EXPRESSION_SAFE_CREATOR
		do
			create Result.make_equal (20)

			from
				l_feature_table := a_feature.context_class.feature_table
				l_feature_table.start
				create l_features.make (l_feature_table.count + 1)
			until
				l_feature_table.after
			loop
				l_next_feature := l_feature_table.item_for_iteration
				l_feature_type := l_next_feature.type
				l_feature_name := l_next_feature.feature_name_32

				if
					l_next_feature.argument_count = 1	-- Single argument
					and then l_next_feature.arguments.first.is_integer		-- Integer argument
					and then l_next_feature.is_exported_for (system.any_class.compiled_representation)	-- Public
					and then (l_feature_type /= Void and then l_feature_type.is_boolean)  	-- BOOLEAN type query
					and then not l_next_feature.is_obsolete	-- Not obsolete
					and then not l_next_feature.is_once		-- Not once
				then
					l_features.put_last (l_next_feature)
				end

				l_feature_table.forth
			end

			if not l_features.is_empty then
				l_arguments := arguments_from_feature (a_feature.feature_, a_feature.context_class)
				l_arguments.remove ("Result")
				from l_arguments.start
				until l_arguments.after
				loop
					if l_arguments.item_for_iteration.is_integer then
						l_arg_name := l_arguments.key_for_iteration
						from l_features.start
						until l_features.after
						loop
							if attached l_exp_creator.safe_create_with_text (a_feature.context_class, a_feature.feature_, l_features.item_for_iteration.feature_name_32 + " (" + l_arg_name + ")", a_feature.written_class) as lt_feature_call then
								Result.force_last (lt_feature_call)
							end
							l_features.forth
						end
					end
					l_arguments.forth
				end
			end
		end

	variant_postconditions: EPA_HASH_SET [EPA_AST_EXPRESSION]
		local
			l_failing_condition, l_expression, l_new_condition: EPA_AST_EXPRESSION
			l_failing_condition_text, l_text, l_new_condition_text: STRING
			l_sub_expression_collector: EPA_SUB_EXPRESSION_COLLECTOR
			l_sub_expressions: EPA_HASH_SET [EPA_AST_EXPRESSION]
			l_expression_cursor: DS_HASH_SET_CURSOR [EPA_AST_EXPRESSION]
			l_start_index, l_end_index: INTEGER
			l_expression_creator: EPA_AST_EXPRESSION_SAFE_CREATOR
		do
			create Result.make_equal (10)
			if session.exception_signature.is_postcondition_violation then
				l_failing_condition := session.exception_signature.exception_condition_in_recipient
				l_failing_condition_text := l_failing_condition.text
				create l_sub_expression_collector
				l_sub_expression_collector.collect_from_expression_text (session.exception_recipient_feature, l_failing_condition_text)
				l_sub_expressions := l_sub_expression_collector.last_sub_expressions
				from
					l_expression_cursor := l_sub_expressions.new_cursor
					l_expression_cursor.start
				until
					l_expression_cursor.after
				loop
					l_expression := l_expression_cursor.item
					l_text := l_expression.text

					l_start_index := l_failing_condition_text.substring_index (l_text, 1)
					if l_start_index > 0 and then not l_text.has_substring ("old ") then
						if l_start_index < 4 or else l_failing_condition_text.substring (l_start_index - 4, l_start_index) /~ "old " then
							l_new_condition_text := l_failing_condition_text.twin
							l_new_condition_text.replace_substring ("old " + l_text, l_start_index, l_start_index + l_text.count - 1)
							l_new_condition := l_expression_creator.safe_create_with_text (l_failing_condition.class_, l_failing_condition.feature_, l_new_condition_text, l_failing_condition.written_class)
							if attached l_new_condition then
								Result.force (l_new_condition)
							end
						end
					end

					l_expression_cursor.forth
				end
			end
		end

	expressions_capturing_argument_relations (a_feature: AFX_FEATURE_TO_MONITOR): EPA_HASH_SET [EPA_AST_EXPRESSION]
			--
		local
			l_interesting_features: DS_ARRAYED_LIST[FEATURE_I]
			l_arguments: DS_HASH_TABLE [TYPE_A, STRING]
			l_argument_expressions: DS_HASH_TABLE [EPA_AST_EXPRESSION, STRING]
			l_feature_cursor: DS_ARRAYED_LIST_CURSOR [FEATURE_I]
			l_argument_cursor: DS_HASH_TABLE_CURSOR [EPA_AST_EXPRESSION, STRING]
			l_expression, l_feature_call_expression: EPA_AST_EXPRESSION

			l_ref_name, l_arg_name: STRING
			l_ref_type, l_arg_type: TYPE_A
			l_exp_creator: EPA_AST_EXPRESSION_SAFE_CREATOR
		do
			create Result.make_equal (20)
			l_interesting_features := queries_with_single_integer_argument (a_feature.context_class)

			l_arguments := arguments_from_feature (a_feature.feature_, a_feature.context_class)
			from
				create l_argument_expressions.make_equal (l_arguments.count + 1)
				l_arguments.start
			until
				l_arguments.after
			loop
				l_expression := l_exp_creator.safe_create_with_text (a_feature.context_class, a_feature.feature_, l_arguments.key_for_iteration, a_feature.written_class)
				if attached l_expression and then l_expression.type.is_integer then
					l_argument_expressions.force (l_expression, l_arguments.key_for_iteration)
				end
				l_arguments.forth
			end

			from
				l_feature_cursor := l_interesting_features.new_cursor
				l_feature_cursor.start
			until
				l_feature_cursor.after
			loop
				from
					l_argument_cursor := l_argument_expressions.new_cursor
					l_argument_cursor.start
				until
					l_argument_cursor.after
				loop
					l_expression := l_exp_creator.safe_create_with_text (a_feature.context_class, a_feature.feature_, l_feature_cursor.item.feature_name_32 + "(" + l_argument_cursor.key + ")", a_feature.written_class)
					if l_expression /= Void then
						Result.force (l_expression)
					end

					l_argument_cursor.forth
				end

				l_feature_cursor.forth
			end
		end

	queries_with_single_integer_argument (a_class: CLASS_C): DS_ARRAYED_LIST[FEATURE_I]
			-- List of interface argumentless queries of `a_class'.
		require
			class_attached: a_class /= Void
		local
			l_string_class, l_super_class: CLASS_C
			l_feature_table: FEATURE_TABLE
			l_next_feature: FEATURE_I
			l_feature_type: TYPE_A
			l_feature_name: STRING
		do
				-- Interface argumentless queries.			
			from
				l_feature_table := a_class.feature_table
				create Result.make (l_feature_table.count + 1)
				l_feature_table.start
			until
				l_feature_table.after
			loop
				l_next_feature := l_feature_table.item_for_iteration
				l_feature_type := l_next_feature.type
				l_feature_name := l_next_feature.feature_name_32

				if
					l_next_feature.argument_count = 1
					and then l_next_feature.arguments.i_th (1).actual_type.is_integer
					and then l_next_feature.is_exported_for (system.any_class.compiled_representation)	-- Public
					and then (l_feature_type /= Void and then l_feature_type.is_boolean)  	-- BOOLEAN type query
					and then not l_next_feature.is_obsolete	-- Not obsolete
					and then not l_next_feature.is_once		-- Not once
					and then system.any_class.compiled_representation.feature_of_rout_id_set (l_next_feature.rout_id_set) = Void -- Query not inherited from ANY
				then
					Result.put_last (l_next_feature)
				end

				l_feature_table.forth
			end
		end

	derived_expressions (a_feature: EPA_FEATURE_WITH_CONTEXT_CLASS; a_expressions_to_extend, a_expressions_to_use: EPA_HASH_SET [EPA_AST_EXPRESSION]): EPA_HASH_SET[EPA_AST_EXPRESSION]
			-- Set of derived expressions from `a_expression_texts', in the context of `a_feature'.
		local
			l_component_expressions: EPA_HASH_SET [EPA_AST_EXPRESSION]
			l_boolean_expressions, l_integer_expressions: EPA_HASH_SET [EPA_AST_EXPRESSION]

			l_expression: EPA_AST_EXPRESSION
			l_expressions, l_precondition_expressions, l_postcondition_expressions: EPA_HASH_SET[EPA_AST_EXPRESSION]
			l_constructor: AFX_BASIC_TYPE_EXPRESSION_CONSTRUCTOR
		do
			create Result.make_equal (256)
			Basic_type_expression_constructor.construct_from (a_expressions_to_extend)
			l_component_expressions := Basic_type_expression_constructor.last_constructed_expressions.union (a_expressions_to_use)
			Result := l_component_expressions
		end

feature -- Once

	Basic_type_expression_constructor: AFX_BASIC_TYPE_EXPRESSION_CONSTRUCTOR
			-- Shared object to construct basic type expressions.
		once
			create Result
		end

feature -- Cache

	contract_expressions_for_features_cache: like contract_expressions_for_features

	features_on_stack_cache: like features_on_stack

	feature_contracts_cache: like feature_contracts

end
