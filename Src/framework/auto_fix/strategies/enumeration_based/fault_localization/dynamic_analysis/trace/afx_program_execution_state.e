note
	description: "Summary description for {AFX_PROGRAM_EXECUTION_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_EXECUTION_STATE

create
	make_with_state_and_bp_index

feature -- Initialization

	make_with_state_and_bp_index (a_state: EPA_STATE; a_index: INTEGER)
			-- Initialization.
		do
			set_state (a_state)
			set_breakpoint_slot_index (a_index)
		end

feature -- Access

	state: EPA_STATE assign set_state
			-- State.

	breakpoint_slot_index: INTEGER assign set_breakpoint_slot_index
			-- Breakpoint slot index where the state is observed.

feature -- Derived state

	derived_state (a_derived_skeleton: EPA_STATE_SKELETON): AFX_PROGRAM_EXECUTION_STATE
			-- Derived state from the Current, based on `a_derived_skeleton'.
		require
			skeleton_attached: a_derived_skeleton /= Void
		local
			l_state: EPA_STATE
			l_equation: EPA_EQUATION
		do
			from
				create l_state.make (state.count, state.class_, state.feature_)
				a_derived_skeleton.start
			until
				a_derived_skeleton.after
			loop
				if attached {AFX_PROGRAM_STATE_ASPECT} a_derived_skeleton.item_for_iteration as lv_aspect then
					lv_aspect.evaluate (state)
					create l_equation.make (lv_aspect, lv_aspect.last_value)
					l_state.force (l_equation)
				end
				a_derived_skeleton.forth
			end
			create Result.make_with_state_and_bp_index (l_state, breakpoint_slot_index)
		end

feature -- Statistic

	statistics: AFX_EXECUTION_TRACE_STATISTICS
			-- Statistic from current execution state.
		local
			l_bp_index: INTEGER
			l_set: EPA_HASH_SET [AFX_FIXING_TARGET]
			l_target: AFX_FIXING_TARGET
			l_equation: EPA_EQUATION
			l_value: EPA_EXPRESSION_VALUE
		do
			if statistics_cache = Void then
				l_bp_index := breakpoint_slot_index

				create l_set.make_equal (state.count + 1)

				create statistics_cache.make_trace_unspecific (1)
				statistics_cache.force (l_set, l_bp_index)

				from
					state.start
				until
					state.after
				loop
					l_equation := state.item_for_iteration

					check attached {EPA_EXPRESSION} l_equation.expression as lt_expression then
							-- Update statistics if, and only if, the value is "True".
						l_value := l_equation.value
						if l_value.is_boolean and then l_value.as_boolean.item then
							create l_target.make (lt_expression, l_bp_index, 1.0)
							l_set.force (l_target)
						end
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

feature{NONE} -- Cache

	statistics_cache: like statistics
			-- Cache for `statistics'.

invariant
	state_attached: state /= Void
	valid_index: breakpoint_slot_index > 0 and then breakpoint_slot_index <= state.feature_.number_of_breakpoint_slots

end
