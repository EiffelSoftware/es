note
	description: "Summary description for {AFX_STATE_DISTANCE_CALCULATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_STATE_DISTANCE_CALCULATOR

inherit
	AFX_UTILITY

feature -- Access

	distance (a_state1: EPA_STATE; a_state2: EPA_STATE): INTEGER
			-- Distance between `a_state1' and `a_state2'
			-- Algorithm:
			-- 1. Only consider the common predicate intersection between `a_state1' and `a_state2'.
			-- 2. Calculate the number of predicates in those two states that have different values
		require
			a_state1_attached: a_state1 /= Void
			a_state2_attached: a_state2 /= Void
--			same_class_context: a_state1.class_ ~ a_state2.class_
--			same_feature_context: a_state1.feature_ ~ a_state2.feature_
		local
			s1, s2: EPA_STATE
			l_common_skeleton: AFX_STATE_SKELETON
			l_equation1, l_equation2: EPA_EQUATION
		do
			l_common_skeleton := skeleton_from_state (a_state1).intersection (skeleton_from_state (a_state2))
			s1 := state_projected_by_skeleton (a_state1, l_common_skeleton)
			s2 := state_projected_by_skeleton (a_state2, l_common_skeleton)
			Result := s1.count - s1.intersection (s2).count
		end

end
