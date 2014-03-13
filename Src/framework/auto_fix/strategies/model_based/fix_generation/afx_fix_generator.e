note
	description: "Summary description for {AFX_FIX_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_FIX_GENERATOR

inherit
	AFX_SHARED_SESSION

feature -- Access

	fixes: DS_ARRAYED_LIST [AFX_CODE_FIX_TO_FAULT]
			-- Fixes that are derived from `fix_skeletons'

feature -- Basic operations

	generate
			-- Generate fixes for `exception_signature' and store them in `fix_skeletons'.
		deferred
		end

end
