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

	scope_levels: INTEGER
			-- Distance from the fix to the failing point

	fix_skeleton_complexity: INTEGER
			-- Complexity level of the fix skeleton
			-- For example, afore fix skeleton is simpler than wrapping fix skeleton

	snippet_complexity: INTEGER
			-- Snippet complexity

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

end
