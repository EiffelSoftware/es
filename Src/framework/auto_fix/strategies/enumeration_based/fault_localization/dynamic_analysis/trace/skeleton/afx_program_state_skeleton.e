note
	description: "Summary description for {AFX_PROGRAM_STATE_SKELETON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_STATE_SKELETON

inherit
	EPA_HASH_SET [AFX_PROGRAM_STATE_ASPECT]
		redefine
			default_capacity
		end

create
	make_skeleton_breakpoint_unspecific, make_skeleton_breakpoint_specific

feature{NONE} -- Initialization

	make_skeleton_breakpoint_unspecific (a_capacity: INTEGER)
			-- Initialization.
		do
			make (a_capacity)
			set_equality_tester (Breakpoint_unspecific_equality_tester)
		end

	make_skeleton_breakpoint_specific (a_capacity: INTEGER)
			-- Initialization.
		do
			make (a_capacity)
			set_equality_tester (Breakpoint_specific_equality_tester)
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

	Breakpoint_specific_equality_tester: KL_EQUALITY_TESTER [AFX_PROGRAM_STATE_ASPECT]
			-- Shared equality tester.
		once
			create {AGENT_BASED_EQUALITY_TESTER [AFX_PROGRAM_STATE_ASPECT]} Result.make (
						agent (a_exp1, a_exp2: AFX_PROGRAM_STATE_ASPECT): BOOLEAN
							do
								if a_exp1 = a_exp2 then
									Result := True
								elseif a_exp1 = Void or a_exp2 = Void then
									Result := false
								else
									Result := a_exp1.text ~ a_exp2.text and then a_exp1.breakpoint_slot = a_exp2.breakpoint_slot
								end
							end)
		end

	Breakpoint_unspecific_equality_tester: KL_EQUALITY_TESTER [AFX_PROGRAM_STATE_ASPECT]
			-- Shared equality tester.
		once
			create {AGENT_BASED_EQUALITY_TESTER [AFX_PROGRAM_STATE_ASPECT]} Result.make (
						agent (a_exp1, a_exp2: AFX_PROGRAM_STATE_ASPECT): BOOLEAN
							do
								if a_exp1 = a_exp2 then
									Result := True
								elseif a_exp1 = Void or a_exp2 = Void then
									Result := false
								else
									Result := a_exp1.text ~ a_exp2.text
								end
							end)
		end


end
