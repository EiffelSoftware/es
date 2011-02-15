note
	description: "Equality tester for {EXT_SNIPPET} objects"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_SNIPPET_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [EXT_SNIPPET]
		redefine
			test
		end

feature -- Status report

	test (v, u: EXT_SNIPPET): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result :=
					v.operands ~ u.operands and then
					v.content ~ u.content
			end
		end

end
