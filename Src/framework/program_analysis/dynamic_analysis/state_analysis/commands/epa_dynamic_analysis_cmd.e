note
	description: "Command to collect annotations through dynamic means"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_DYNAMIC_ANALYSIS_CMD

inherit
	EPA_COMMAND

	EPA_DEBUGGER_UTILITY

	SHARED_WORKBENCH

	EPA_SHARED_EQUALITY_TESTERS

	EPA_UTILITY

	EPA_CFG_UTILITY

create
	make

feature {NONE} -- Initialization

	make (a_config: like config)
			-- Initialize Current command.
		do
			check is_config_valid (a_config) then
				config := a_config
			end
			class_ := config.location.class_
			feature_ := config.location.feature_
		ensure
			config_set: config = a_config
			class_set: class_ = config.location.class_
			feature_set: feature_ = config.location.feature_
		end

feature -- Access

	pre_states: DS_HASH_TABLE [DS_HASH_SET [EPA_EQUATION], INTEGER]
			-- Collected pre-states.
			-- Keys are breakpoint slots and values are expressions
			-- and its associated values.

	post_states: DS_HASH_TABLE [DS_HASH_SET [EPA_EQUATION], INTEGER]
			-- Collected pre-states.
			-- Keys are breakpoint slots and values are expressions
			-- and its associated values.

	collected_data: LINKED_LIST [DS_HASH_SET [EPA_EQUATION]]
			-- Data collected during dynamic analysis of `feature_'

feature -- Basic operations

	execute
			-- Execute Current command
		do
			-- Find post-state(s) for all pre-states in `l_feature'.
			find_all_post_states

			-- Choose pre-states
			choose_pre_states

			-- Setup expressions which are evaluated
			setup_expressions

			-- Remove breakpoints set by previous debugging sessions.
			remove_breakpoint (debugger_manager, config.root_class)

			-- Set up the action for the evaluation of pre- and post-states.
			create interesting_post_states.make_default

			if not config.is_prgm_locs_with_exprs_set then
				setup_action_for_evaluation
			else
				setup_action_for_evaluation2
			end

			-- Set up the data-structures used for storing the collected
			-- run-time data.
			create pre_states.make_default
			create post_states.make_default

			-- Start program execution in debugger.
			start_debugger (debugger_manager, "", config.working_directory, {EXEC_MODES}.run, False)

			-- Remove the last debugging session.
			remove_debugger_session
		end

feature {NONE} -- Implementation

	on_expression_evaluated (a_bp: BREAKPOINT; a_state: EPA_STATE)
			-- Action to be performed when expressions are evaluated at breakpoint `a_bp'.
			-- `a_state' is a set of expression evaluations.
		require
			a_bp_not_void: a_bp /= Void
			a_state_not_void: a_state /= Void
		local
			l_bp_slot: INTEGER
			l_equations: DS_HASH_SET [EPA_EQUATION]
		do
--			io.put_string ("%N==> " + a_bp.breakable_line_number.out + "%N")
--			io.put_string (a_state.debug_output +"%N")
--			io.put_string ("==>%N")
			l_bp_slot := a_bp.breakable_line_number
			create l_equations.make_default

			across a_state.to_array as l_state loop
				l_equations.force_last (l_state.item)
			end

			-- Add collected run-time data to `pre_states'
			-- if `a_bp' is a pre-state
			if interesting_pre_states.has (l_bp_slot) then
				pre_states.force_last (l_equations, l_bp_slot)
			end

			-- Add collected run-time data to `post_states'
			-- if `a_bp' is a post-state
			if interesting_post_states.has (l_bp_slot) then
				post_states.force_last (l_equations, l_bp_slot)
			end
		end

	on_expression_evaluated2 (a_bp: BREAKPOINT; a_state: EPA_STATE)
			-- Action to be performed when expressions are evaluated at breakpoint `a_bp'.
			-- `a_state' is a set of expression evaluations.
		require
			a_bp_not_void: a_bp /= Void
			a_state_not_void: a_state /= Void
		local
			l_bp_slot: INTEGER
			l_equations: DS_HASH_SET [EPA_EQUATION]
		do
--			io.put_string ("%N==> " + a_bp.breakable_line_number.out + "%N")
--			io.put_string (a_state.debug_output +"%N")
--			io.put_string ("==>%N")
			l_bp_slot := a_bp.breakable_line_number
			create l_equations.make_default

			across a_state.to_array as l_state loop
				l_equations.force_last (l_state.item)
			end

			-- Add collected run-time data to `pre_states'
			-- if `a_bp' is a pre-state
			if interesting_pre_states.has (l_bp_slot) then
				pre_states.force_last (l_equations, l_bp_slot)
			end

			-- Add collected run-time data to `post_states'
			-- if `a_bp' is a post-state
			if interesting_post_states.has (l_bp_slot) then
				post_states.force_last (l_equations, l_bp_slot)
			end
		end

feature {NONE} -- Implemenation

	is_config_valid (a_config: EPA_CONFIG): BOOLEAN
			-- Is `a_config' a valid configuration?
		require
			a_config_not_void: a_config /= Void
		local
			l_prgm_locs_valid, l_exprs_valid: BOOLEAN
		do
			l_prgm_locs_valid := (
				a_config.is_all_progm_locs_set xor
				a_config.is_aut_choice_of_prgm_locs_set xor
				a_config.is_specific_prgm_locs_set)

			l_exprs_valid := (
				a_config.is_aut_choice_of_exprs_set xor
				a_config.is_specific_exprs_set xor
				a_config.is_specific_vars_set)

			Result := (l_prgm_locs_valid and l_exprs_valid) xor a_config.is_prgm_locs_with_exprs_set
		end

feature {NONE} -- Implementation

	find_all_post_states
			-- Find post-state(s) for all pre-states.
		local
			l_post_state_finder: EPA_POST_STATE_FINDER
		do
			create l_post_state_finder.make_with (class_, feature_)
			l_post_state_finder.find
			post_state_map := l_post_state_finder.post_state_map
		end

	choose_pre_states
			-- Choose pre-states
		local
			i: INTEGER
			l_pre_state_finder: EPA_INTERESTING_PRE_STATE_FINDER
		do
			-- Choose pre-states
			if config.is_all_progm_locs_set then
				-- Use all pre-states
				fixme("This is not a good solution since contracts are taken into account as well. Nov 26, 2011. megg")
				from
					i := 1
				until
					i > feature_.number_of_breakpoint_slots
				loop
					interesting_pre_states.force_last (i)
					i := i + 1
				end
			elseif config.is_specific_prgm_locs_set then
				-- Use selected pre-states
				interesting_pre_states := config.specific_prgm_locs
			elseif config.is_prgm_locs_with_exprs_set  then
				across config.prgm_locs_with_exprs.keys.to_array as l_pre_states loop
					interesting_pre_states.force_last (l_pre_states.item)
				end
			elseif config.is_aut_choice_of_prgm_locs_set then
				-- Find and use interesting pre-states in `l_feature'.
				create l_pre_state_finder.make_with (feature_.e_feature.ast)
				l_pre_state_finder.find
				interesting_pre_states := l_pre_state_finder.interesting_pre_states
			end
		end

	setup_expressions
			-- Setup expressions to evaluate
		local
			l_expr_builder: EPA_EXPRESSIONS_TO_EVALUATE_BUILDER
		do
			create l_expr_builder.make (class_, feature_)
			if config.is_specific_vars_set then
				l_expr_builder.build_from_variables (config.variables)
			elseif config.is_specific_exprs_set or config.is_prgm_locs_with_exprs_set then
				l_expr_builder.build_from_expressions (config.expressions)
			elseif config.is_aut_choice_of_exprs_set then
				l_expr_builder.build_from_ast (feature_.e_feature.ast)
			end

			monitored_expressons := l_expr_builder.expressions_to_evaluate
		end

	setup_action_for_evaluation
			-- Setup action for evaluation
		local
			l_bp_mgr: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
		do
			across interesting_pre_states.to_array as l_pre_states loop
				create l_bp_mgr.make (class_, feature_)
				l_bp_mgr.set_breakpoint_with_expression_and_action (l_pre_states.item, monitored_expressons, agent on_expression_evaluated)
				l_bp_mgr.toggle_breakpoints (True)

				across post_state_map.item (l_pre_states.item).to_array as l_post_states loop
					create l_bp_mgr.make (class_, feature_)
					l_bp_mgr.set_breakpoint_with_expression_and_action (l_post_states.item, monitored_expressons, agent on_expression_evaluated)
					l_bp_mgr.toggle_breakpoints (True)
					interesting_post_states.force_last (l_post_states.item)
				end
			end
		end

	setup_action_for_evaluation2
			-- Setup action for evaluation
		local
			l_bp_mgr: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
		do
			across interesting_pre_states.to_array as l_pre_states loop
				create l_bp_mgr.make (class_, feature_)
				l_bp_mgr.set_breakpoint_with_expression_and_action (l_pre_states.item, monitored_expressons, agent on_expression_evaluated2)
				l_bp_mgr.toggle_breakpoints (True)

				across post_state_map.item (l_pre_states.item).to_array as l_post_states loop
					create l_bp_mgr.make (class_, feature_)
					l_bp_mgr.set_breakpoint_with_expression_and_action (l_post_states.item, monitored_expressons, agent on_expression_evaluated2)
					l_bp_mgr.toggle_breakpoints (True)
					interesting_post_states.force_last (l_post_states.item)
				end
			end
		end

feature {NONE} -- Implementation

	class_: CLASS_C
			-- Class containing the feature which will be analyzed.

	feature_: FEATURE_I
			-- Feature which will be analyzed.

	monitored_expressons: DS_HASH_SET [EPA_EXPRESSION]
			-- Expressions which are monitored

	interesting_pre_states: DS_HASH_SET [INTEGER]
			-- Contains all interesting pre-states

	interesting_post_states: DS_HASH_SET [INTEGER]
			-- Contains all interesting post-states

	post_state_map: DS_HASH_TABLE [DS_HASH_SET [INTEGER], INTEGER]
			-- Contains the found post-states.
			-- Keys are pre-states and values are (possibly multiple) post-states

end
