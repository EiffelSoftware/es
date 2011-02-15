note
	description: "Summary description for {EPA_SHARED_PROGRAM_STATE_EXPRESSION_EQUALITY_TESTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_SHARED_PROGRAM_STATE_EXPRESSION_EQUALITY_TESTER

inherit
	ANY
		undefine
			is_equal,
			copy
		end

feature -- Shared equality testers

	breakpoint_specific_equality_tester: KL_EQUALITY_TESTER [AFX_PROGRAM_STATE_EXPRESSION]
			-- Equality tester that compares expressions based on their breakpoint indexes.
		once
			create {AGENT_BASED_EQUALITY_TESTER [AFX_PROGRAM_STATE_EXPRESSION]} Result.make (
						agent (a_exp1, a_exp2: AFX_PROGRAM_STATE_EXPRESSION): BOOLEAN
							do
								if a_exp1 = a_exp2 then
									Result := True
								elseif a_exp1 = Void or a_exp2 = Void then
									Result := false
								else
									Result := a_exp1.text ~ a_exp2.text and then a_exp1.breakpoint_slot = a_exp2.breakpoint_slot
								end
							end)
		ensure
			result_attached: Result /= Void
		end

	breakpoint_unspecific_equality_tester: KL_EQUALITY_TESTER [AFX_PROGRAM_STATE_EXPRESSION]
			-- Equality tester that doesn't compare expressions based on their breakpoint indexes.
		once
			create {AGENT_BASED_EQUALITY_TESTER [AFX_PROGRAM_STATE_EXPRESSION]} Result.make (
						agent (a_exp1, a_exp2: AFX_PROGRAM_STATE_EXPRESSION): BOOLEAN
							do
								if a_exp1 = a_exp2 then
									Result := True
								elseif a_exp1 = Void or a_exp2 = Void then
									Result := false
								else
									Result := a_exp1.text ~ a_exp2.text
								end
							end)
		ensure
			result_attached: Result /= Void
		end

--feature{NONE} -- Cache

--	breakpoint_specific_equality_tester_cache: like breakpoint_specific_equality_tester
--			-- Cache for `breakpoint_specific_equality_tester'.

--	breakpoint_unspecific_equality_tester_cache: like breakpoint_unspecific_equality_tester
--			-- Cache for `breakpoint_unspecific_equality_tester'.

end
