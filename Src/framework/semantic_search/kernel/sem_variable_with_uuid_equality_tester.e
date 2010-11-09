note
	description: "Equality tester for {SEM_VARIABLE_WITH_UUID} objects"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_VARIABLE_WITH_UUID_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [SEM_VARIABLE_WITH_UUID]
		redefine
			test
		end

feature -- Status report

	test (v, u: SEM_VARIABLE_WITH_UUID): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result :=
					v.variable ~ u.variable and then
					v.uuid ~ u.uuid
			end
		end

end
