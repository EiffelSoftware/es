note
	description: "Summary description for {AFX_FIX_BY_SUBSTITUTION_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_BY_SUBSTITUTION_GENERATOR

inherit
	AFX_FIXING_OPERATION_CONSTANT

	AFX_SHARED_SESSION

	SHARED_WORKBENCH

create
	default_create

feature -- Access

	last_substitution: EPA_HASH_SET [AFX_FIXING_OPERATION]
			-- Substitutions from last generation.
		do
			if last_substitution_cache = Void then
				create last_substitution_cache.make_equal (10)
			end
			Result := last_substitution_cache
		end

feature -- Basic operation

	generate_substitution (a_target: AFX_FIXING_TARGET; a_instr: AFX_AST_STRUCTURE_NODE)
			-- Generate substitutions regarding `a_target'.
			-- Make the result operations available in last_substitution.
		require
			target_attached: a_target /= Void
		local
		do
		end

feature{NONE} -- Cache

	last_substitution_cache: like last_substitution
			-- Cache for last_substitution.

end
