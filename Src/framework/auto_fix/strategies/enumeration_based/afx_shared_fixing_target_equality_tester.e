note
	description: "Summary description for {AFX_SHARED_FIXING_TARGET_EQUALITY_TESTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_SHARED_FIXING_TARGET_EQUALITY_TESTER

inherit
	ANY
		undefine
			is_equal,
			copy
		end

feature -- Shared equality testers

	tester_based_on_expressions_and_bp_index: KL_EQUALITY_TESTER [AFX_FIXING_TARGET]
			-- Equality tester that compares fixing targets based on their set of expressions and the bp index.
		once
				create {AGENT_BASED_EQUALITY_TESTER [AFX_FIXING_TARGET]} Result.make (
						agent (a_target1, a_target2: AFX_FIXING_TARGET): BOOLEAN
							do
								if a_target1 = a_target2 then
									Result := True
								elseif a_target1 = Void or a_target2 = Void then
									Result := False
								else
									Result := a_target1.expressions ~ a_target2.expressions and then a_target1.bp_index = a_target2.bp_index
								end
							end)
		end

--feature{NONE} -- Cache

--	tester_based_on_expressions_and_bp_index_cache: like tester_based_on_expressions_and_bp_index
--			-- Cache for `tester_based_on_expressions_and_bp_index'.

end
