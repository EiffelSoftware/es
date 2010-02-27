note
	description: "Summary description for {EPA_THEORY_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_THEORY_UTILITY

feature -- Equality tester

	class_with_prefix_equality_tester: AGENT_BASED_EQUALITY_TESTER [EPA_CLASS_WITH_PREFIX] is
			-- Equality test for predicate access pattern
		do
			create Result.make (agent (a, b: EPA_CLASS_WITH_PREFIX): BOOLEAN do Result := a.is_equal (b) end)
		end

end
