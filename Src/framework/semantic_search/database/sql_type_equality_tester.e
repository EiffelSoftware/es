note
	description: "Equality tester for {SQL_TYPE}"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SQL_TYPE_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [SQL_TYPE]
		redefine
			test
		end

feature -- Status report

	test (v, u: SQL_TYPE): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result :=
					v.hash_code = u.hash_code and then
					v.name ~ u.name
			end
		end


end
