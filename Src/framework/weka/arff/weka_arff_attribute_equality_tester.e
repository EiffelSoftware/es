note
	description: "Equality tester for {WEKA_ARFF_ATTRIBUTE}"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEKA_ARFF_ATTRIBUTE_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [WEKA_ARFF_ATTRIBUTE]
		redefine
			test
		end

feature -- Status report

	test (v, u: WEKA_ARFF_ATTRIBUTE): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result := v.same_type (u) and then v.name ~ u.name
			end
		end


end
