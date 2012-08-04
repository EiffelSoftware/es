note
	description: "Summary description for {DPA_PROCESSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_PROCESSOR

inherit
	EPA_UTILITY

create
	make

feature {NONE} -- Implementation

	make (a_program_locations: like pre_state_breakpoints; a_post_state_map: like post_state_map; a_debugger_manager: like debugger_manager)
			-- Initialize current.
		require
			a_program_locations_not_void: a_program_locations /= Void
			a_post_state_map_not_void: a_post_state_map /= Void
			a_debugger_manager_not_void: a_debugger_manager /= Void
		do
			pre_state_breakpoints := a_program_locations
			post_state_map := a_post_state_map
			debugger_manager := a_debugger_manager
		ensure
			program_locations_set: pre_state_breakpoints = a_program_locations
			post_state_map_set: post_state_map = a_post_state_map
			debugger_manager_set: debugger_manager = a_debugger_manager
		end

feature -- Access

	last_analysis_order_pairs: LINKED_LIST [TUPLE [pre_state_bp_slot: INTEGER; post_state_bp_slot: INTEGER]]
			-- List of pre-state / post-state breakpoint pairs in the order they were analyzed.
			-- Note: The analysis order is not the same as the execution order which is complete
			-- whilst the analysis order only contains the hit pre-state / post-state breakpoints.

	last_transitions: LINKED_LIST [EPA_EXPRESSION_VALUE_TRANSITION]
			-- Expression value transitions of the last processed state.

feature -- Processing

	process (a_bp: BREAKPOINT; a_state: EPA_STATE)
			-- Process `a_bp' and `a_state'. Result is made available in
			-- `last_analysis_order_pairs' and `last_transitions'.
		require
			a_bp_not_void: a_bp /= Void
			a_state_not_void: a_state /= Void
		local
--			l_status: APPLICATION_STATUS
--			l_stack: EIFFEL_CALL_STACK
			l_pre_state_bp, l_post_state_bp: INTEGER
			l_pre_state, l_post_state: HASH_TABLE [EPA_EXPRESSION_VALUE, STRING]
			l_expr_value_transition: EPA_EXPRESSION_VALUE_TRANSITION
			l_expression: STRING
		do
			create last_analysis_order_pairs.make
			create last_transitions.make

--			l_status := debugger_manager.application_status
--			l_status.force_reload_current_call_stack
--			l_stack := l_status.current_call_stack
			current_state := [a_bp.breakable_line_number, a_state]

			if previous_state /= Void then


				l_pre_state_bp := previous_state.breakpoint
				l_post_state_bp := current_state.breakpoint

				if is_valid_pre_post_state_pair (l_pre_state_bp, l_post_state_bp) then
					last_analysis_order_pairs.extend ([l_pre_state_bp, l_post_state_bp])

					l_pre_state := previous_state.state.to_hash_table
					l_post_state := current_state.state.to_hash_table

					across l_pre_state.current_keys as l_expressions loop
						l_expression := l_expressions.item
						check l_pre_state.has (l_expression) and l_post_state.has (l_expression) end
						create l_expr_value_transition.make (previous_state.state.item_with_expression_text (l_expression).expression, l_pre_state_bp, l_pre_state.item (l_expression), l_post_state_bp, l_post_state.item (l_expression))
						last_transitions.extend (l_expr_value_transition)
					end
				end
			end
			previous_state := current_state
		end

	process_and_filter (a_bp: BREAKPOINT; a_state: EPA_STATE)
			-- Process and filter `a_bp' and `a_state'. Expressions of `a_state' at `a_bp' are discarded
			-- if they are not contained in `progm_locs_with_exprs'. Result is made available in
			-- `last_analysis_order_pairs' and `last_transitions'.
		require
			a_bp_not_void: a_bp /= Void
			a_state_not_void: a_state /= Void
		local
--			l_status: APPLICATION_STATUS
--			l_stack: EIFFEL_CALL_STACK
			l_pre_state_bp, l_post_state_bp: INTEGER
			l_pre_state, l_post_state: HASH_TABLE [EPA_EXPRESSION_VALUE, STRING]
			l_expr_value_transition: EPA_EXPRESSION_VALUE_TRANSITION
			l_expression: STRING
		do
			create last_analysis_order_pairs.make
			create last_transitions.make

--			l_status := debugger_manager.application_status
--			l_status.force_reload_current_call_stack
--			l_stack := l_status.current_call_stack
			current_state := [a_bp.breakable_line_number, a_state]

			if previous_state /= Void then
				create last_analysis_order_pairs.make
				create last_transitions.make

				l_pre_state_bp := previous_state.breakpoint
				l_post_state_bp := current_state.breakpoint

				if is_valid_pre_post_state_pair (l_pre_state_bp, l_post_state_bp) then
					last_analysis_order_pairs.extend ([l_pre_state_bp, l_post_state_bp])

					l_pre_state := previous_state.state.to_hash_table
					l_post_state := current_state.state.to_hash_table

					across l_pre_state.current_keys as l_expressions loop
						l_expression := l_expressions.item
						check l_pre_state.has (l_expression) and l_post_state.has (l_expression) end
						if prgm_locs_with_exprs.item (l_pre_state_bp).has (l_expression) then
							create l_expr_value_transition.make (previous_state.state.item_with_expression_text (l_expression).expression, l_pre_state_bp, l_pre_state.item (l_expression), l_post_state_bp, l_post_state.item (l_expression))
							last_transitions.extend (l_expr_value_transition)
						end
					end
				end
			end
			previous_state := current_state
		end

feature -- Setting

	set_prgm_locs_with_exprs (a_prgm_locs_with_exprs: like prgm_locs_with_exprs)
			-- Set `prgm_locs_with_exprs' to `a_prgm_locs_with_exprs'
		require
			a_prgm_locs_with_exprs_not_void: a_prgm_locs_with_exprs /= Void
		do
			prgm_locs_with_exprs := a_prgm_locs_with_exprs
		ensure
			prgm_locs_with_exprs_set: prgm_locs_with_exprs = a_prgm_locs_with_exprs
		end

feature {NONE} -- Implementation

	previous_state: TUPLE [breakpoint: INTEGER; state: EPA_STATE]
			-- Previous processed state.

	current_state: TUPLE [breakpoint: INTEGER; state: EPA_STATE]
			-- Current processed state.

	pre_state_breakpoints: DS_HASH_SET [INTEGER]
			-- Program locations which were analyzed.

	post_state_map: DS_HASH_TABLE [DS_HASH_SET [INTEGER], INTEGER]
			-- Contains the found post-states.
			-- Keys are pre-states and values are (possibly multiple) post-states

	prgm_locs_with_exprs: DS_HASH_TABLE [DS_HASH_SET [STRING], INTEGER]
			-- Program locations where the associated expressions should
			-- be evaluated.

	debugger_manager: DEBUGGER_MANAGER
			-- Manager in charge of debugging operations.

feature {NONE} -- Implementation

	is_valid_pre_post_state_pair (a_pre_state_bp_slot: INTEGER; a_post_state_bp_slot: INTEGER): BOOLEAN
			-- Is `a_pre_state_bp_slot' and `a_post_state_bp_slot' a valid pre-state / post-state pair?
		require
			program_locations_not_void: pre_state_breakpoints /= Void
			post_state_map_not_void: post_state_map /= Void
			valid_bp_slots: a_pre_state_bp_slot >= 1 and a_post_state_bp_slot >= 1
		do
			Result := pre_state_breakpoints.has (a_pre_state_bp_slot) and post_state_map.item (a_pre_state_bp_slot).has (a_post_state_bp_slot)
		end

end
