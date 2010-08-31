note
	description: "Summary description for {AFX_PROGRAM_STATE_EXPRESSION_EQUALITY_TESTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_PROGRAM_STATE_EXPRESSION_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [EPA_PROGRAM_STATE_EXPRESSION]
		redefine
			test
		end

create
	default_create

feature -- Equality

	test (u, v: EPA_PROGRAM_STATE_EXPRESSION): BOOLEAN
			-- Are `v' and `u' considered equal?
			-- (Use '~' by default.)
		do
			if u = v then
				Result := True
			elseif u = Void or v = Void then
				Result := False
			else
				Result := u ~ v 
			end
		end

end
