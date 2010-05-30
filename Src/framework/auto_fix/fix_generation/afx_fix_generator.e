note
	description: "Summary description for {AFX_FIX_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_FIX_GENERATOR

feature -- Access

	exception_spot: AFX_EXCEPTION_SPOT
			-- Exception spot containing information
			-- of the failure

	fix_skeletons: LINKED_LIST [AFX_FIX_SKELETON]
			-- Fixes generated for `exception_spot' by
			-- the last `generate'.

	fixes: LINKED_LIST [AFX_FIX]
			-- Fixes that are derived from `fix_skeletons'

feature -- Basic operations

	generate
			-- Generate fixes for `exception_spot' and
			-- store result in `fix_skeletons'.
		deferred
		end

end
