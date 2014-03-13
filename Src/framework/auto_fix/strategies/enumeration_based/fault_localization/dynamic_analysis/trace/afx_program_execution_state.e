note
	description: "Summary description for {AFX_PROGRAM_EXECUTION_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_EXECUTION_STATE

inherit
	ANY
		redefine out end

create
	make_with_state_and_location

feature -- Initialization

	make_with_state_and_location (a_state: EPA_STATE; a_location: AFX_PROGRAM_LOCATION)
			-- Initialization.
		do
			set_state (a_state)
			set_location (a_location)
		end

feature -- Access

	state: EPA_STATE assign set_state
			-- State.

	location: AFX_PROGRAM_LOCATION assign set_location
			-- Location in the program where the state is observed.

feature -- Derived state

	derived_state (a_map: DS_HASH_TABLE [AFX_FEATURE_TO_MONITOR, STRING]; a_use_aspect: BOOLEAN): AFX_PROGRAM_EXECUTION_STATE
			-- Derived state from the Current, based on `a_derived_skeleton'.
		require
			a_map /= Void
		local
			l_qualified_feature_name: STRING
			l_feature: AFX_FEATURE_TO_MONITOR
			l_skeletons_at_breakpoints: DS_HASH_TABLE [EPA_STATE_SKELETON, INTEGER_32]
			l_bpt: INTEGER

			l_skeleton: EPA_STATE_SKELETON
			l_state: EPA_STATE
			l_creator: EPA_AST_EXPRESSION_SAFE_CREATOR
			l_exp: EPA_AST_EXPRESSION
			l_equation: EPA_EQUATION
		do
			l_qualified_feature_name := state.class_.name_in_upper + "." + state.feature_.feature_name_32
			l_bpt := location.breakpoint_index

				-- Skeleton for the breakpoint of the state
			check a_map.has (l_qualified_feature_name) end
			l_feature := a_map.item (l_qualified_feature_name)
			l_skeletons_at_breakpoints := l_feature.skeletons_at_breakpoints
			check l_skeletons_at_breakpoints.has (l_bpt) end
			l_skeleton := l_skeletons_at_breakpoints.item (l_bpt)

			from
				create l_state.make (state.count, state.class_, state.feature_)
				l_skeleton.start
			until
				l_skeleton.after
			loop
				if attached {AFX_PROGRAM_STATE_ASPECT} l_skeleton.item_for_iteration as lv_aspect then
					lv_aspect.evaluate (state)
					if a_use_aspect then
						create l_equation.make (lv_aspect, lv_aspect.last_value)
						l_state.force (l_equation)
					else
						l_exp := l_creator.safe_create_with_expression (lv_aspect)
						if l_exp /= Void then
							create l_equation.make (l_exp, lv_aspect.last_value)
							l_state.force (l_equation)
						end
					end

				end
				l_skeleton.forth
			end
			create Result.make_with_state_and_location (l_state, location)
		end

feature -- Statistic

	statistics: AFX_EXECUTION_TRACE_STATISTICS
			-- Statistic from current execution state.
		local
			l_location: AFX_PROGRAM_LOCATION
			l_set: EPA_HASH_SET [AFX_FIXING_TARGET]
			l_target: AFX_FIXING_TARGET
			l_equation: EPA_EQUATION
			l_value: EPA_EXPRESSION_VALUE
		do
			if statistics_cache = Void then
				l_location := location

				create l_set.make_equal (state.count + 1)

				create statistics_cache.make_trace_unspecific (1)
				statistics_cache.force (l_set, l_location)

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
							create l_target.make (lt_expression, l_location.breakpoint_index, 1.0)
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

	set_location (a_location: AFX_PROGRAM_LOCATION)
			-- Set `location'.
		do
			location := a_location
			reset_statistics
		end

feature

	out: STRING
		local
		do
			Result := location.out + "%N" + state.debug_output
		end

feature{NONE} -- Cache

	statistics_cache: like statistics
			-- Cache for `statistics'.

invariant
	state_attached: state /= Void
	location_attached: location /= Void

end
