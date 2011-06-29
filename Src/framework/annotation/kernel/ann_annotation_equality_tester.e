note
	description: "Equality tester for annotation"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ANN_ANNOTATION_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [ANN_ANNOTATION]
		redefine
			test
		end

feature -- Status report

	test (v, u: ANN_ANNOTATION): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result := v.debug_output ~ v.debug_output
			end
		end
end
