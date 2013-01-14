note
	description: "Summary description for {}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_STRING_EQALITY_TESTER

inherit
	KL_EQUALITY_TESTER [STRING]
		redefine
			test
		end

create
	default_create

feature -- Status report

	test (v, u: STRING): BOOLEAN
			-- <Precursor>
		do
			if v = u then
				Result := True
			elseif v = Void or else u = Void then
				Result := False
			else
				Result := u.same_string (v)
			end
		end

end
