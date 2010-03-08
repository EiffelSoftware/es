indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision: 1 $"

class
	EGX_EQUALITY_TESTER [N]

feature -- Access

	equality_tester: FUNCTION [ANY, TUPLE [N, N], BOOLEAN]
			-- Node equality tester;
			-- A void equality tester means that `='
			-- will be used as comparison criterion.

	actual_equality_tester: like equality_tester is
			-- Actual equality tester
			-- If `equality_tester' is attached, return value is `equality_tester',
			-- otherwise return value is agent to `reference_equality_tester'.
		do
			Result := equality_tester
			if Result = Void then
				Result := agent reference_equality_tester
			end
		ensure
			result_attached: Result /= Void
		end

feature -- Status report

	is_equality_tester_settable: BOOLEAN
			-- Is `equality_tester' settable?
		do
		end

feature -- Setting

	set_equality_tester (a_tester: like equality_tester) is
			-- Set `equality_tester' with `a_tester'.
		require
			is_settable: is_equality_tester_settable
		do
			equality_tester := a_tester
		ensure
			equality_tester_set: equality_tester = a_tester
		end

feature{NONE} -- Implementation

	reference_equality_tester (u, v: N): BOOLEAN is
			-- Equality tester using `='
		do
			Result := u = v
		ensure
			good_result: Result = (u = v)
		end

end
