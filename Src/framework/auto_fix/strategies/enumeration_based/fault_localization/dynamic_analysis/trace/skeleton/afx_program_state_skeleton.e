note
	description: "Summary description for {AFX_PROGRAM_STATE_SKELETON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_STATE_SKELETON

inherit
	DS_HASH_TABLE [AFX_PROGRAM_STATE_ASPECT, STRING]
		redefine
			default_capacity
		end

create
	make_skeleton_breakpoint_unspecific

feature -- Basic operation

	merge (a_skeleton: like Current)
			-- Merge `a_skeleton' into `Current'.
		require
			skeleton_attached: a_skeleton /= Void
		local
		do
			from a_skeleton.start
			until a_skeleton.after
			loop
				force (a_skeleton.item_for_iteration, a_skeleton.key_for_iteration)

				a_skeleton.forth
			end
		end

feature{NONE} -- Initialization

	make_skeleton_breakpoint_unspecific (a_capacity: INTEGER)
			-- Initialization.
		do
			make_equal (a_capacity)
		end

feature -- Basic operation

	instantiation_in (a_state: EPA_STATE): EPA_STATE
			-- Instance of current program state skeleton in `a_state'.
			-- The result state contains one evaluation of each aspect from the skeleton,
			--		and the evaluation is based on `a_state'.
		require
			state_attached: a_state /= Void
		local
			l_aspect: AFX_PROGRAM_STATE_ASPECT
			l_value: EPA_EXPRESSION_VALUE
			l_equation: EPA_EQUATION
		do
			create Result.make (count, a_state.class_, a_state.feature_)

			from start
			until after
			loop
				l_aspect := item_for_iteration

				l_aspect.evaluate (a_state)
				l_value := l_aspect.last_value
				if not l_value.is_nonsensical then
					create l_equation.make (l_aspect, l_value)
					Result.force (l_equation)
				end

				forth
			end
		end

feature -- Constant

	Default_capacity: INTEGER = 100
			-- <Precursor>

end
