note
	description: "Summary description for {AFX_FIX_RANKING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_RANKING

feature -- Access

	relevant_instructions: INTEGER
			-- Number of relevant instructions in a fix
			-- Small is better.

	scope_levels: INTEGER
			-- Distance from the fix to the failing point
			-- Small is better.

	fix_skeleton_complexity: INTEGER
			-- Complexity level of the fix skeleton
			-- For example, afore fix skeleton is simpler than wrapping fix skeleton
			-- Small is better.

	snippet_complexity: INTEGER
			-- Snippet complexity
			-- Small is better.

	impact_on_passing_test_cases: DOUBLE
			-- Impact of the fix on passing test cases.
			-- This value measures how much the post state of passing test cases
			-- changes after applying the fix.
			-- The smaller the value, the better

	score: DOUBLE
			-- Final ranking for a fix.
			-- Small is better.
		do
			Result := scope_levels * 1.0 + relevant_instructions * 0.75 + fix_skeleton_complexity * 0.5 + snippet_complexity * 0.25
		end

feature -- Setting

	set_relevant_instructions (i: INTEGER)
			-- Set `relevant_instructions' with `i'.
		do
			relevant_instructions := i
		ensure
			relevant_instructions_set: relevant_instructions = i
		end

	set_scope_levels (d: INTEGER)
			-- Set `scope_levels' with `d'.
		do
			scope_levels := d
		ensure
			failing_point_distance_set: scope_levels = d
		end

	set_fix_skeleton_complexity (c: INTEGER)
			-- Set `fix_skeleton_complexity' with `c'.
		do
			fix_skeleton_complexity := c
		ensure
			fix_skeleton_complexity_set: fix_skeleton_complexity = c
		end

	set_snippet_complexity (c: INTEGER)
			-- Set `snippet_complexity' with `c'.
		do
			snippet_complexity := c
		end

	set_impact_on_passing_test_cases (v: DOUBLE)
			-- Set `impact_on_passing_test_cases' with `v'.
		do
			impact_on_passing_test_cases := v
		ensure
			impact_on_passing_test_cases_set: impact_on_passing_test_cases = v
		end

end
