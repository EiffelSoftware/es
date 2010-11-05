note
	description: "Summary description for {SSA_EXPR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SSA_EXPR

inherit
	SSA_SHARED

feature
	as_code: STRING
		deferred
		end

	ssa_prefix: STRING
		do
			Result := "ssatemp_" + get_count.out
		end

	replacements: LIST [SSA_REPLACEMENT]
		deferred
		end
end
