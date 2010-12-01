note
	description: "Summary description for {AFX_PROGRAM_EXECUTION_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_EXECUTION_STATE

inherit

	ANY

	AFX_SHARED_PROGRAM_STATE_EXPRESSION_EQUALITY_TESTER

	AFX_SHARED_SERVER_PROGRAM_STATE_SKELETON

	AFX_SHARED_FIXING_TARGET_EQUALITY_TESTER

create
	make_with_state_and_bp_index

feature -- Initialization

	make_with_state_and_bp_index (a_state: EPA_STATE; a_index: INTEGER)
			-- Initialization.
		do
			set_state (a_state)
			set_breakpoint_slot_index (a_index)
		end

feature -- State mapping

	interpretation: AFX_PROGRAM_EXECUTION_STATE
			-- Interpret the current state using the skeleton associated with the context feature, and return the result state.
		local
			l_skeleton: AFX_PROGRAM_STATE_SKELETON
		do
			l_skeleton := server_program_state_skeleton.skeleton_breakpoint_unspecific (state.class_, state.feature_)
			create Result.make_with_state_and_bp_index (l_skeleton.instantiation_in (state), breakpoint_slot_index)
		end

feature -- Access

	state: EPA_STATE assign set_state
			-- State.

	breakpoint_slot_index: INTEGER assign set_breakpoint_slot_index
			-- Breakpoint slot index where the state is observed.

feature -- Statistic

	statistics: AFX_EXECUTION_TRACE_STATISTICS
			-- Statistic from current execution state.
			-- Only statistics about those expressions of type {EPA_PROGRAM_STATE_EXPRESSION} are collected.
		local
			l_bp_index: INTEGER
			l_set: EPA_HASH_SET [AFX_FIXING_TARGET]
			l_target: AFX_FIXING_TARGET
			l_expr_set: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]

			l_table: DS_HASH_TABLE [REAL, AFX_PROGRAM_STATE_EXPRESSION]
			l_exp: AFX_PROGRAM_STATE_EXPRESSION
			l_equation: EPA_EQUATION
			l_value: EPA_EXPRESSION_VALUE
		do
			if statistics_cache = Void then
				l_bp_index := breakpoint_slot_index

				create l_set.make (state.count + 1)
				l_set.set_equality_tester (tester_based_on_expressions_and_bp_index)

				create statistics_cache.make_trace_unspecific (1)
				statistics_cache.force (l_set, l_bp_index)

				from
					state.start
				until
					state.after
				loop
					l_equation := state.item_for_iteration

					if attached {AFX_PROGRAM_STATE_EXPRESSION} l_equation.expression as lt_expression then
						-- Update statistics if, and only if, the value is "True".
						l_value := l_equation.value
						if l_value.is_boolean and then l_value.as_boolean.item then
							create l_expr_set.make (1)
							l_expr_set.set_equality_tester (breakpoint_unspecific_equality_tester)
							l_expr_set.force (lt_expression)

							create l_target.make (l_expr_set, l_bp_index, 1.0)
							l_set.force (l_target)
						end
					else
						-- Fixme
					end
					state.forth
				end
			end

			Result := statistics_cache
		end

	reset_statistics
			-- Clear the cached statistic information.
		do
			statistics_cache := Void
		end

	statistics_cache: like statistics
			-- Cache for `statistics'.

feature{NONE} -- Status set

	set_state (a_state: EPA_STATE)
			-- Set `state'.
		do
			state := a_state
			reset_statistics
		end

	set_breakpoint_slot_index (a_index: INTEGER)
			-- Set `breakpoint_slot_index'.
		do
			breakpoint_slot_index := a_index
			reset_statistics
		end

invariant
	state_attached: state /= Void
	valid_index: breakpoint_slot_index > 0 and then breakpoint_slot_index <= state.feature_.number_of_breakpoint_slots

end
