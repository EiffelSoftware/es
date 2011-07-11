note
	description: "Equality tester for annotation"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ANN_ANNOTATION_EQUALITY_TESTER [G -> ANN_ANNOTATION]

inherit
	KL_EQUALITY_TESTER [G]
		redefine
			test
		end

feature -- Status report

	test (v, u: G): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result :=
					v.generating_type ~ u.generating_type and then
					v.debug_output ~ u.debug_output
			end
		end
end
