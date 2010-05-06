note
	description: "Equality to decide if two {TERM_QUERY} objects are equal"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_TERM_QUERY_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [SEM_TERM_QUERY]
		redefine
			test
		end

feature -- Status report

	test (v, u: SEM_TERM_QUERY): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result := v.text ~ u.text
			end
		end

end
