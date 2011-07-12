note
	description: "Summary description for {EXT_HOLE_MERGER}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EXT_HOLE_MERGER

inherit
	EXT_AST_REWRITER [EIFFEL_LIST [INSTRUCTION_AS]]

feature -- Access

	last_holes_added: HASH_TABLE [EXT_HOLE, STRING]
			-- Holes added due to merging by last `rewrite'.

	last_holes_removed: HASH_TABLE [EXT_HOLE, STRING]
			-- Holes removed due to merging by last `rewrite'.

feature {NONE} -- Implementation

	initialize_hole_context
			-- Initializes `last_holes' and `last_holes_by_location'.
		do
			create last_holes_added.make (10)
			last_holes_added.compare_objects

			create last_holes_removed.make (10)
			last_holes_removed.compare_objects
		end

end
