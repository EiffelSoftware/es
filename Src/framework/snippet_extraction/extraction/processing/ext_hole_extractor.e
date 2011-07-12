note
	description: "Class to extract holes from ASTs."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EXT_HOLE_EXTRACTOR

inherit
	REFACTORING_HELPER

feature -- Access

	last_holes: HASH_TABLE [EXT_HOLE, STRING]
			-- Holes extracted by last `extract'.

	last_holes_by_location: HASH_TABLE [EXT_HOLE, AST_PATH]
			-- Location information of `last_holes'.	

feature -- Basic operations

	extract (a_ast: AST_EIFFEL)
			-- Extract annotations from `a_ast' and
			-- make results available in `last_holes'.
		deferred
		end

feature {NONE} -- Implementation

	initialize_hole_context
			-- Initializes `last_holes' and `last_holes_by_location'.
		do
			create last_holes.make (10)
			last_holes.compare_objects

			create last_holes_by_location.make (10)
			last_holes_by_location.compare_objects
		end

	add_hole (a_hole: EXT_HOLE; a_location: AST_PATH)
			-- Add a hole and record `a_location' for rewriting.
		require
			attached a_hole
			attached a_location
		do
			last_holes.extend (a_hole, a_hole.hole_name)
			last_holes_by_location.extend (a_hole, a_location)
		end

end
