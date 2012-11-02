note
	description: "Processor to process the run time data delivered by the debugger."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_PROCESSOR

inherit
	EPA_UTILITY
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (
		a_pre_state_breakpoints: like pre_state_breakpoints;
		a_post_state_breakpoints: like post_state_breakpoints;
		a_expression_evaluation_plan: like expression_evaluation_plan
	)
			-- Initialize processor.
		require
			a_pre_state_breakpoints_not_void: a_pre_state_breakpoints /= Void
			a_post_state_breakpoints_not_void: a_post_state_breakpoints /= Void
			a_expression_evaluation_plan_not_void: a_expression_evaluation_plan /= Void
		do
			pre_state_breakpoints := a_pre_state_breakpoints
			post_state_breakpoints := a_post_state_breakpoints
			expression_evaluation_plan := a_expression_evaluation_plan
		ensure
			pre_state_breakpoints_set: pre_state_breakpoints = a_pre_state_breakpoints
			post_state_breakpoints_set: post_state_breakpoints = a_post_state_breakpoints
			expression_evaluation_plan_set:
				expression_evaluation_plan = a_expression_evaluation_plan
		end

feature -- Access

	last_transitions: LINKED_LIST [EPA_EXPRESSION_VALUE_TRANSITION]
			-- Last processed transitions of the last processed
			-- pre-state and post-state pair.

	pre_state_breakpoints: DS_HASH_SET [INTEGER]
			-- Breakpoints which serve as pre-state breakpoints.

	post_state_breakpoints: DS_HASH_TABLE [DS_HASH_SET [INTEGER], INTEGER]
			-- Breakpoints which serve as post-state breakpoints.
			-- Keys are pre-state breakpoints.
			-- Values are (possibly multiple) post-state breakpoints.

	expression_evaluation_plan: DS_HASH_TABLE [DS_HASH_SET [INTEGER], EPA_EXPRESSION]
			-- Expression evaluation plan specifying the program locations at which an expression
			-- is evaluated before and after the execution of a program location.
			-- Keys are expressions.
			-- Values are program locations.

feature -- Basic operations

	process (a_breakpoint: BREAKPOINT; a_state: EPA_STATE)
			-- Process `a_breakpoint' and `a_state' to extract transitions and make them available
			-- in `last_transitions'.
		require
			a_breakpoint_not_void: a_breakpoint /= Void
			a_state_not_void: a_state /= Void
		local
			l_pre_state_breakpoint, l_post_state_breakpoint: INTEGER
			l_transition: EPA_EXPRESSION_VALUE_TRANSITION
			l_expression: EPA_EXPRESSION
			l_equation: EPA_EQUATION
			l_pre_state, l_post_state: EPA_STATE
		do
			create last_transitions.make

			-- `a_state' is the current state.
			current_state := [a_breakpoint.breakable_line_number, a_state]

			-- Use `previous_state' and `current_state' to extract transitions.
			if
				previous_state /= Void
			then
				l_pre_state_breakpoint := previous_state.breakpoint
				l_post_state_breakpoint := current_state.breakpoint

				-- Extract transitions if `l_pre_state_breakpoint' and `l_post_state_breakpoint'
				-- are a valid pre-state breakpoint and post-state breakpoint pair.
				if
					is_valid_pre_and_post_state_breakpoint_pair (
						l_pre_state_breakpoint,
						l_post_state_breakpoint
					)
				then
					l_pre_state := previous_state.state
					l_post_state := current_state.state

					from
						l_pre_state.start
					until
						l_pre_state.after
					loop
						l_equation := l_pre_state.item_for_iteration
						l_expression := l_equation.expression

						-- Only take into account expressions which should be evaluated at current
						-- pre-state breakpoint.
						if
							expression_evaluation_plan.item (l_expression).has (
								l_pre_state_breakpoint
							)
						then
							create l_transition.make (
								l_expression,
								l_pre_state_breakpoint,
								l_equation.value,
								l_post_state_breakpoint,
								l_post_state.item_with_expression (l_expression).value
							)

							last_transitions.extend (l_transition)
						end

						l_pre_state.forth
					end
				end
			end

			-- Assign `current_state' to `previous_state' so that it can be used with the next
			-- processed state.
			previous_state := current_state
		end

feature {NONE} -- Implementation

	previous_state: TUPLE [breakpoint: INTEGER; state: EPA_STATE]
			-- Previously processed state.

	current_state: TUPLE [breakpoint: INTEGER; state: EPA_STATE]
			-- Currently processed state.

feature {NONE} -- Implementation

	is_valid_pre_and_post_state_breakpoint_pair (
		a_pre_state_breakpoint: INTEGER;
		a_post_state_breakpoint: INTEGER
	): BOOLEAN
			-- Is `a_pre_state_breakpoint' and `a_post_state_bp_slot' a valid pre-state breakpoint
			-- and post-state breakpoint pair?
		require
			a_pre_state_breakpoint_valid: a_pre_state_breakpoint >= 1
			a_post_state_breakpoint_valid: a_post_state_breakpoint >= 1
		do
			Result :=
				pre_state_breakpoints.has (a_pre_state_breakpoint) and then
				post_state_breakpoints.item (a_pre_state_breakpoint).has (a_post_state_breakpoint)
		ensure
			Result_set: Result =
				pre_state_breakpoints.has (a_pre_state_breakpoint) and then
				post_state_breakpoints.item (a_pre_state_breakpoint).has (a_post_state_breakpoint)
		end

end
