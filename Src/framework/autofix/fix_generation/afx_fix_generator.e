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

	fixes: LINKED_LIST [AFX_FIX_SKELETON]
			-- Fixes generated for `exception_spot' by
			-- the last `generate'.

feature -- Basic operations

	generate
			-- Generate fixes for `exception_spot' and
			-- store result in `fixes'.
		deferred
		end

end
