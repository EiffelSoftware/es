note
	description: "Summary description for {AFX_FIX_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_FIX_GENERATOR

inherit
	AFX_SHARED_SESSION

	AFX_SHARED_DYNAMIC_ANALYSIS_REPORT

feature -- Access

	fix_skeletons: LINKED_LIST [AFX_FIX_SKELETON]
			-- Fixes generated for `exception_spot' by
			-- the last `generate'.

	fixes: DS_LINKED_LIST [AFX_FIX]
			-- Fixes that are derived from `fix_skeletons'

feature -- Basic operations

	generate
			-- Generate fixes for `exception_signature' and store them in `fix_skeletons'.
		deferred
		end

end
