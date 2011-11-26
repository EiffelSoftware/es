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
		ensure
			config_set: config = a_config
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

feature -- Basic operations

	execute
			-- Execute Current command
		local
			i: INTEGER
			l_bp_mgr: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
			l_monitored_exprs: DS_HASH_SET [EPA_EXPRESSION]
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_expr: EPA_AST_EXPRESSION
			l_var_finder: EPA_INTERESTING_VARIABLE_FINDER
			l_pre_state_finder: EPA_INTERESTING_PRE_STATE_FINDER
			l_post_state_finder: EPA_POST_STATE_FINDER
			l_variables: LINKED_LIST [STRING]
			l_expr_builder: EPA_EXPRESSIONS_TO_EVALUATE_BUILDER
		do
			l_class := config.location.class_
			l_feature := config.location.feature_

			-- Find post-state(s) for all pre-states in `l_feature'.
			create l_post_state_finder.make_with (l_class, l_feature)
			l_post_state_finder.find
			post_state_map := l_post_state_finder.post_state_map

			-- Choose pre-states
			if config.is_all_progm_locs_set then
				-- Use all pre-states
				fixme("This is not a good solution since contracts are taken into account as well. Nov 26, 2011. megg")
				from
					i := 1
				until
					i > l_feature.number_of_breakpoint_slots
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
				create l_pre_state_finder.make_with (l_feature.e_feature.ast)
				l_pre_state_finder.find
				interesting_pre_states := l_pre_state_finder.interesting_pre_states
			end

			-- Setup expressions which are evaluated
			create l_expr_builder.make (l_class, l_feature)
			if config.is_specific_vars_set then
				l_expr_builder.build_from_variables (config.variables)
			elseif config.is_specific_exprs_set or config.is_prgm_locs_with_exprs_set then
				l_expr_builder.build_from_expressions (config.expressions)
			elseif config.is_aut_choice_of_exprs_set then
				l_expr_builder.build_from_ast (l_feature.e_feature.ast)
			end

			l_monitored_exprs := l_expr_builder.expressions_to_evaluate

			-- Remove breakpoints set by previous debugging sessions.
			remove_breakpoint (debugger_manager, config.root_class)

			-- Set up the action for the evaluation of pre- and post-states.
			create interesting_post_states.make_default

			across interesting_pre_states.to_array as l_pre_states loop
				create l_bp_mgr.make (l_class, l_feature)
				l_bp_mgr.set_breakpoint_with_expression_and_action (l_pre_states.item, l_monitored_exprs, agent on_expression_evalauted)
				l_bp_mgr.toggle_breakpoints (True)

				across post_state_map.item (l_pre_states.item).to_array as l_post_states loop
					create l_bp_mgr.make (l_class, l_feature)
					l_bp_mgr.set_breakpoint_with_expression_and_action (l_post_states.item, l_monitored_exprs, agent on_expression_evalauted)
					l_bp_mgr.toggle_breakpoints (True)
					interesting_post_states.force_last (l_post_states.item)
				end
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

	on_expression_evalauted (a_bp: BREAKPOINT; a_state: EPA_STATE)
			-- Action to be performed when expressions are evaluated at breakpoint `a_bp'.
			-- `a_state' is a set of expression evaluations.
		require
			a_bp_not_void: a_bp /= Void
			a_state_not_void: a_state /= Void
		local
			l_bp_slot: INTEGER
			l_state: DS_HASH_SET [EPA_EQUATION]
		do
--			io.put_string ("%N==> " + a_bp.breakable_line_number.out + "%N")
--			io.put_string (a_state.debug_output +"%N")
--			io.put_string ("==>%N")
			l_bp_slot := a_bp.breakable_line_number
			create l_state.make_default

			across a_state.to_array as l_equations loop
				l_state.force_last (l_equations.item)
			end

			-- Add collected run-time data to `pre_states'
			-- if `a_bp' is a pre-state
			if interesting_pre_states.has (l_bp_slot) then
				pre_states.force_last (l_state, l_bp_slot)
			end

			-- Add collected run-time data to `post_states'
			-- if `a_bp' is a post-state
			if interesting_post_states.has (l_bp_slot) then
				post_states.force_last (l_state, l_bp_slot)
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

	interesting_pre_states: DS_HASH_SET [INTEGER]
			-- Contains all interesting pre-states

	interesting_post_states: DS_HASH_SET [INTEGER]
			-- Contains all interesting post-states

	post_state_map: DS_HASH_TABLE [DS_HASH_SET [INTEGER], INTEGER]
			-- Contains the found post-states.
			-- Keys are pre-states and values are (possibly multiple) post-states

end
