note
	description: "Equality tester for {SEM_DOCUMENT_FIELD} objects"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_DOCUMENT_FIELD_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [SEM_DOCUMENT_FIELD]
		redefine
			test
		end

feature -- Status report

	test (v, u: SEM_DOCUMENT_FIELD): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				if v.hash_code = u.hash_code then
					Result :=
						v.boost = v.boost and then
						u.name ~ v.name and then
						u.value ~ v.value and then
						u.type ~ v.type
				end
			end
		end

end
