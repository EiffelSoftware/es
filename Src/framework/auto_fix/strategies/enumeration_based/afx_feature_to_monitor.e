note
	description: "Summary description for {AFX_EXCEPTION_RECIPIENT_FEATURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FEATURE_TO_MONITOR

inherit
	EPA_FEATURE_WITH_CONTEXT_CLASS

create
	make,
	make_from_feature_with_context_class

feature -- Initialization

	make_from_feature_with_context_class (a_feature: EPA_FEATURE_WITH_CONTEXT_CLASS)
		do
			make (a_feature.feature_, a_feature.context_class)
		end

feature -- Scope of monitoring

	should_monitor_body: BOOLEAN assign set_monitor_body
			-- Should the execution of feature body be monitored?

	should_monitor_contracts: BOOLEAN assign set_monitor_contracts
			-- Should the contracts of feature be monitored?

	set_monitor_body (a_flag: BOOLEAN)
		do
			should_monitor_body := a_flag
		end

	set_monitor_contracts (a_flag: BOOLEAN)
		do
			should_monitor_contracts := a_flag
		end

feature -- Extra expressions to monitor.

	extra_expressions: DS_ARRAYED_LIST [EPA_EXPRESSION]
			-- Extra expressions to consider during monitoring.
		do
			if extra_expressions_cache = Void then
				create extra_expressions_cache.make_equal (10)
			end
			Result := extra_expressions_cache
		end

	add_extra_expressions (a_expressions: DS_LIST [EPA_EXPRESSION])
			-- Add `a_expressions' into `extra_expressions'.
		require
			a_expressions /= Void
		do
			extra_expressions.append_last (a_expressions)
		end

feature{NONE}

	extra_expressions_cache: like extra_expressions
			-- Cache for `extra_expressions'.

feature -- Expressions to monitor at breakpoints

	expressions_to_monitor_at_breakpoints: DS_HASH_TABLE [EPA_HASH_SET [EPA_EXPRESSION], INTEGER]
			-- Map from breakpoints to the set of expressions to be monitored at the breakpoints.
		do
			if expressions_to_monitor_at_breakpoints_cache = Void then
				initialize_expressions_to_monitor_at_breakpoints
			end
			Result := expressions_to_monitor_at_breakpoints_cache
		end

	skeletons_at_breakpoints: DS_HASH_TABLE [EPA_STATE_SKELETON, INTEGER]
			-- Map from breakpoints to the skeletons at the breakpoints.
		do
			if skeletons_at_breakpoints_cache = Void then
				initialize_expressions_to_monitor_at_breakpoints
			end
			Result := skeletons_at_breakpoints_cache
		end

	initialize_expressions_to_monitor_at_breakpoints
			--
		local
			l_pre, l_body_start, l_body_end, l_post: INTEGER
			l_body_expressions, l_pre_expressions, l_post_expressions, l_expressions: EPA_HASH_SET [EPA_EXPRESSION]
			l_body_skeleton, l_pre_skeleton, l_post_skeleton, l_skeleton: EPA_STATE_SKELETON
			l_expressions_to_monitor_at_entry_and_exit: TUPLE[pre, post: EPA_HASH_SET [EPA_EXPRESSION]]
			l_derived_state_skeleton_at_entry_and_exit: TUPLE[pre, post: EPA_STATE_SKELETON]
		do
			create expressions_to_monitor_at_breakpoints_cache.make_equal (last_breakpoint_in_body * 2)
			create skeletons_at_breakpoints_cache.make_equal (last_breakpoint_in_body * 2)

				-- Expressions and skeletons we may need.
			if should_monitor_body then
				l_body_expressions := expressions_to_monitor_in_body
				l_body_skeleton := derived_state_skeleton_from_expressions (l_body_expressions)
			end
			if should_monitor_contracts then
				l_expressions_to_monitor_at_entry_and_exit := expressions_to_monitor_at_entry_and_exit
				l_derived_state_skeleton_at_entry_and_exit := derived_state_skeleton_at_entry_and_exit
			end

				-- Merge the set of expressions if the body breakpoints overlap with pre/post condition breakpoints.
			if should_monitor_body and then not should_monitor_contracts then
				across first_breakpoint_in_body |..| last_breakpoint_in_body as lt_bpt loop
					expressions_to_monitor_at_breakpoints_cache.force (l_body_expressions, lt_bpt.item)
					skeletons_at_breakpoints_cache.force (l_body_skeleton, lt_bpt.item)
				end
			elseif not should_monitor_body and then should_monitor_contracts then
				expressions_to_monitor_at_breakpoints_cache.force (l_expressions_to_monitor_at_entry_and_exit.pre, breakpoint_to_evaluate_precondition)
				skeletons_at_breakpoints_cache.force (l_derived_state_skeleton_at_entry_and_exit.pre, breakpoint_to_evaluate_precondition)
				expressions_to_monitor_at_breakpoints_cache.force (l_expressions_to_monitor_at_entry_and_exit.post, breakpoint_to_evaluate_postcondition)
				skeletons_at_breakpoints_cache.force (l_derived_state_skeleton_at_entry_and_exit.post, breakpoint_to_evaluate_postcondition)
			elseif should_monitor_body and then should_monitor_contracts then
				l_pre := breakpoint_to_evaluate_precondition
				l_post:= breakpoint_to_evaluate_postcondition
				l_body_start := first_breakpoint_in_body
				l_body_end := last_breakpoint_in_body

				if l_pre = l_body_start then
					l_expressions := l_body_expressions.union (l_expressions_to_monitor_at_entry_and_exit.pre)
					l_body_start := l_body_start + 1
				else
					l_expressions := l_expressions_to_monitor_at_entry_and_exit.pre
				end
				l_skeleton := derived_state_skeleton_from_expressions (l_expressions)
				expressions_to_monitor_at_breakpoints_cache.force (l_expressions, l_pre)
				skeletons_at_breakpoints_cache.force (l_skeleton, l_pre)

				if l_post = l_body_end then
					l_expressions := l_body_expressions.union (l_expressions_to_monitor_at_entry_and_exit.post)
					l_body_end := l_body_end - 1
				else
					l_expressions := l_expressions_to_monitor_at_entry_and_exit.post
				end
				l_skeleton := derived_state_skeleton_from_expressions (l_expressions)
				expressions_to_monitor_at_breakpoints_cache.force (l_expressions, l_post)
				skeletons_at_breakpoints_cache.force (l_skeleton, l_post)

				across l_body_start |..| l_body_end as lt_bpt loop
					expressions_to_monitor_at_breakpoints_cache.force (l_body_expressions, lt_bpt.item)
					skeletons_at_breakpoints_cache.force (l_body_skeleton, lt_bpt.item)
				end
			end
		end

feature{NONE} -- Expressions to monitor at breakpoints (Cache)

	expressions_to_monitor_at_breakpoints_cache: DS_HASH_TABLE [EPA_HASH_SET [EPA_EXPRESSION], INTEGER]
			-- Cache for `expressions_to_monitor_at_breakpoints'.

	skeletons_at_breakpoints_cache: DS_HASH_TABLE [EPA_STATE_SKELETON, INTEGER]
			-- Cache for `skeletons_at_breakpoints'.

feature -- Contracts

	contracts: TUPLE[pre, post: EPA_HASH_SET [EPA_EXPRESSION]]
			-- Pre- and postcondition clauses of the feature.
		local
			l_clauses: LINKED_LIST [EPA_EXPRESSION]
			l_pre, l_post, l_exps: EPA_HASH_SET [EPA_EXPRESSION]
			l_contract_extractor: EPA_CONTRACT_EXTRACTOR
		do
			if contracts_cache = Void then
				create l_contract_extractor
				across <<True, False>> as lt_pre loop
					create l_exps.make_equal (20)
					if lt_pre.item then
						l_clauses := l_contract_extractor.precondition_of_feature (feature_, context_class)
						l_pre := l_exps
					else
						l_clauses := l_contract_extractor.postcondition_of_feature (feature_, context_class)
						l_post := l_exps
					end
					across l_clauses as lt_clause_cursor loop
						l_exps.force (create {AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION}.make_boolean_relation (context_class, feature_, written_class, lt_clause_cursor.item, Void, {AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION}.operator_boolean_null))
					end
				end
				contracts_cache := [l_pre, l_post]
			end

			Result := contracts_cache
		end

feature{NONE}

	contracts_cache: TUPLE[pre, post: EPA_HASH_SET [EPA_EXPRESSION]]
			-- Cache for `contracts'.

feature -- Monitoring body execution

	expressions_to_monitor_in_body: EPA_HASH_SET [EPA_EXPRESSION]
			-- Expressions to monitor during execution of the feature body.
		local
			l_list_cursor: DS_ARRAYED_LIST_CURSOR [EPA_EXPRESSION]
			l_base_expressions, l_expressions_to_monitor: EPA_HASH_SET [EPA_EXPRESSION]
			l_constructor: AFX_BASIC_TYPE_EXPRESSION_CONSTRUCTOR
			l_rank: AFX_EXPR_RANK
		do
			if expressions_to_monitor_in_body_cache = Void then
				create expressions_to_monitor_in_body_cache.make_equal (30)

					-- Basic expressions.
				create l_base_expressions.make_equal (1)
				Sub_expression_collector_from_feature.collect_from_feature (Current)
				l_base_expressions.merge (Sub_expression_collector_from_feature.last_sub_expressions)
				sub_expression_collector_from_expression.collect_from_expressions (Current, extra_expressions)
				l_base_expressions.merge (Sub_expression_collector_from_expression.last_sub_expressions)

--					-- Exception condition
--				if session.exception_from_execution.is_precondition_violation
--						and then Current.qualified_feature_name ~ session.exception_from_execution.recipient_feature_with_context.qualified_feature_name
--						and then attached session.exception_from_execution.exception_condition_in_recipient as lt_failing_condition
--				then
--					l_base_expressions.force (lt_failing_condition)
--				end

					-- Expressions to monitor based on the basic expressions.
				create l_constructor
				l_constructor.construct_from (l_base_expressions)
				expressions_to_monitor_in_body_cache := l_constructor.last_constructed_expressions
			end
			Result := expressions_to_monitor_in_body_cache
		ensure
			result_attached: Result /= Void
		end

	state_skeleton_in_body: EPA_STATE_SKELETON
			-- State skeleton based on `expressions_to_monitor_in_body'.
		local
			l_expr_list: ARRAYED_LIST [EPA_EXPRESSION]
			l_expressions_to_monitor: like expressions_to_monitor_in_body
		do
			if state_skeleton_in_body_cache = Void then
				create l_expr_list.make (expressions_to_monitor_in_body.count + 1)
				expressions_to_monitor_in_body.do_all (agent l_expr_list.force)
				create state_skeleton_in_body_cache.make_with_expressions (context_class, feature_, l_expr_list)
			end
			Result := state_skeleton_in_body_cache
		end

	derived_state_skeleton_in_body: EPA_STATE_SKELETON
			-- State skeleton for the feature, derived from `expressions_to_monitor_in_body'.
		do
			if derived_state_skeleton_in_body_cache = Void then
				derived_state_skeleton_in_body_cache := derived_state_skeleton_from_expressions (expressions_to_monitor_in_body.twin)
			end
			Result := derived_state_skeleton_in_body_cache
		end

feature{NONE}

	expressions_to_monitor_in_body_cache: EPA_HASH_SET [EPA_EXPRESSION]
			-- Cache for `expressions_to_monitor'.

	state_skeleton_in_body_cache: EPA_STATE_SKELETON
			-- Cache for `state_skeleton'.

	derived_state_skeleton_in_body_cache: EPA_STATE_SKELETON
			-- Cache for `derived_state_skeleton'.

feature -- Monitoring entry & exit states

	expressions_to_monitor_at_entry_and_exit: TUPLE[pre, post: EPA_HASH_SET [EPA_EXPRESSION]]
			-- Expressions to monitor at the entry of feature.
		local
			l_all_contracts: EPA_HASH_SET [EPA_EXPRESSION]
			l_base_expressions: EPA_HASH_SET [EPA_EXPRESSION]
			l_expression: EPA_EXPRESSION
			l_expressions, l_precondition_expressions, l_postcondition_expressions, l_post_contracts, l_pre_contracts: EPA_HASH_SET[EPA_EXPRESSION]
			l_expressions_to_extend: EPA_HASH_SET [EPA_EXPRESSION]
			l_expressions_capturing_argument_relations: EPA_HASH_SET [EPA_EXPRESSION]
			l_exp_creator: EPA_AST_EXPRESSION_SAFE_CREATOR
			l_is_creation_procedure: BOOLEAN
			l_arguments: DS_HASH_TABLE [TYPE_A, STRING]
		do
			if expressions_to_monitor_at_entry_and_exit_cache = Void then
					-- (Sub)Expressions from existing contracts that can be used in constructing the new postcondition.
				create l_all_contracts.make_equal (10)
				l_all_contracts.merge (contracts.pre)
				l_all_contracts.merge (contracts.post)
				l_all_contracts.append (extra_expressions)
				sub_expression_collector_from_expression.collect_from_expressions (Current, l_all_contracts)
				l_post_contracts := sub_expression_collector_from_expression.last_sub_expressions

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

					-- Precondition expressions derived from operands.
				create l_expressions_to_extend.make_equal (20)
				l_arguments := arguments_from_feature (feature_, context_class)
				l_arguments.remove ("Result")
				from l_arguments.start
				until l_arguments.after
				loop
					l_expression := l_exp_creator.safe_create_with_text (context_class, feature_, l_arguments.key_for_iteration, written_class)
					if attached l_expression then
						l_expressions_to_extend.force (l_expression)
					end
					l_arguments.forth
				end
				l_is_creation_procedure := context_class.valid_creation_procedure_32 (feature_.feature_name_32)
				if not l_is_creation_procedure and then attached l_exp_creator.safe_create_with_text (context_class, feature_, "Current", written_class) as lt_expr then
					l_expressions_to_extend.force (lt_expr)
				end
				l_precondition_expressions := derived_expressions (l_expressions_to_extend)
				l_precondition_expressions.append (l_pre_contracts)
				l_expressions_capturing_argument_relations := expressions_capturing_argument_relations
				l_precondition_expressions.append (l_expressions_capturing_argument_relations)

					-- 'Current' is always referrable in the postcondition.
				if attached l_exp_creator.safe_create_with_text (context_class, feature_, "Current", written_class) as lt_expr then
					l_expressions_to_extend.force (lt_expr)
				end
				if feature_.has_return_value and then attached l_exp_creator.safe_create_with_text (context_class, feature_, "Result", written_class) as lt_expr then
					l_expressions_to_extend.force (lt_expr)
				end
				l_postcondition_expressions := derived_expressions (l_expressions_to_extend)
				l_postcondition_expressions.append (l_post_contracts)
				l_postcondition_expressions.append (l_expressions_capturing_argument_relations)
--??			l_postcondition_expressions.append (variant_postconditions)

--					-- Include also the violated condition if feature_under_test is the exception recipient.
--				if session.exception_from_execution.is_precondition_violation
--						and then Current.qualified_feature_name ~ session.exception_from_execution.recipient_feature_with_context.qualified_feature_name
--						and then attached session.exception_from_execution.exception_condition_in_recipient as lt_failing_condition
--				then
--					l_precondition_expressions.force (lt_failing_condition)
--					l_postcondition_expressions.force (lt_failing_condition)
--				end

				expressions_to_monitor_at_entry_and_exit_cache := [l_precondition_expressions, l_postcondition_expressions]
			end
			Result := expressions_to_monitor_at_entry_and_exit_cache
		ensure
			result_attached: Result.pre /= Void and then Result.post /= Void
		end

	derived_state_skeleton_at_entry_and_exit: TUPLE[pre, post: EPA_STATE_SKELETON]
			-- State skeletons for the feature, derived from `expressions_to_monitor_at_entry_and_exit'.
		local
			l_expressions: TUPLE[pre, post: EPA_HASH_SET [EPA_EXPRESSION]]
		do
			if derived_state_skeleton_at_entry_and_exit_cache = Void then
				derived_state_skeleton_at_entry_and_exit_cache := [
						derived_state_skeleton_from_expressions (expressions_to_monitor_at_entry_and_exit.pre.twin),
						derived_state_skeleton_from_expressions (expressions_to_monitor_at_entry_and_exit.post.twin)]
			end
			Result := derived_state_skeleton_at_entry_and_exit_cache
		ensure
			result_attached: Result.pre /= Void and then Result.post /= Void
		end

feature{NONE} -- Monitoring pre-state

	expressions_to_monitor_at_entry_and_exit_cache: TUPLE[pre, post: EPA_HASH_SET [EPA_EXPRESSION]]
			-- Cache for `expressions_to_monitor_at_entry_and_exit'.

	derived_state_skeleton_at_entry_and_exit_cache: TUPLE[pre, post: EPA_STATE_SKELETON]
			-- Cache for `derived_state_skeleton_at_entry_and_exit'.

feature{NONE} -- Implementation

	derived_state_skeleton_from_expressions (a_expressions: EPA_HASH_SET [EPA_EXPRESSION]): EPA_STATE_SKELETON
			-- State skeleton derived from `a_expressions'.
		require
			a_expressions /= Void
		local
			l_builder: AFX_DERIVED_STATE_SKELETON_BUILDER
		do
			create l_builder
			l_builder.build_skeleton (Current, a_expressions)
			Result := l_builder.last_derived_skeleton
		end

	expressions_capturing_argument_relations: EPA_HASH_SET [EPA_EXPRESSION]
			-- Boolean expressions in the form of "f (x)", where 'f' is a public feature from 'context_class',
			--		and 'x' is an integer argument of 'feature_'.
		local
			l_interesting_features: DS_ARRAYED_LIST[FEATURE_I]
			l_arguments: DS_HASH_TABLE [TYPE_A, STRING]
			l_argument_expressions: DS_HASH_TABLE [EPA_EXPRESSION, STRING]
			l_feature_cursor: DS_ARRAYED_LIST_CURSOR [FEATURE_I]
			l_argument_cursor: DS_HASH_TABLE_CURSOR [EPA_EXPRESSION, STRING]
			l_expression, l_feature_call_expression: EPA_EXPRESSION

			l_ref_name, l_arg_name: STRING
			l_ref_type, l_arg_type: TYPE_A
			l_exp_creator: EPA_AST_EXPRESSION_SAFE_CREATOR
		do
			create Result.make_equal (20)
			l_interesting_features := boolean_queries_with_single_integer_argument

			l_arguments := arguments_from_feature (feature_, context_class)
			from
				create l_argument_expressions.make_equal (l_arguments.count + 1)
				l_arguments.start
			until
				l_arguments.after
			loop
				l_expression := l_exp_creator.safe_create_with_text (context_class, feature_, l_arguments.key_for_iteration, written_class)
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
					l_expression := l_exp_creator.safe_create_with_text (context_class, feature_, l_feature_cursor.item.feature_name_32 + "(" + l_argument_cursor.key + ")", written_class)
					if l_expression /= Void then
						Result.force (l_expression)
					end

					l_argument_cursor.forth
				end

				l_feature_cursor.forth
			end
		end

	boolean_queries_with_single_integer_argument: DS_ARRAYED_LIST[FEATURE_I]
			-- List of interface argumentless boolean queries of `a_class'.
		local
			l_string_class, l_super_class: CLASS_C
			l_feature_table: FEATURE_TABLE
			l_next_feature: FEATURE_I
			l_feature_type: TYPE_A
			l_feature_name: STRING
		do
				-- Interface argumentless queries.			
			from
				l_feature_table := context_class.feature_table
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

	derived_expressions (a_expressions_to_extend: EPA_HASH_SET [EPA_EXPRESSION]): EPA_HASH_SET[EPA_EXPRESSION]
			-- Set of derived expressions from `a_expression_texts', in the context of `a_feature'.
		do
			Basic_type_expression_constructor.construct_from (a_expressions_to_extend)
			Result := Basic_type_expression_constructor.last_constructed_expressions.twin
		end

feature{NONE} -- Shared collectors

	Sub_expression_collector_from_expression: EPA_SUB_EXPRESSION_COLLECTOR
			-- Sub-expression collector.
		once
			create Result
			Result.set_should_collect_arguments (False)
			Result.set_should_collect_current (False)
			Result.set_should_collect_result (False)
		end

	Sub_expression_collector_from_feature: EPA_SUB_EXPRESSION_COLLECTOR
			-- Sub-expression collector.
		once
			create Result
			Result.set_should_collect_arguments (True)
			Result.set_should_collect_current (True)
			Result.set_should_collect_result (True)
		end

	Basic_type_expression_constructor: AFX_BASIC_TYPE_EXPRESSION_CONSTRUCTOR
			-- Shared object to construct basic type expressions.
		once
			create Result
		end

end
