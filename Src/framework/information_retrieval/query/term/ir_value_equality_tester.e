note
	description: "Equality tester for {IR_VALUE}"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IR_VALUE_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [IR_VALUE]
		redefine
			test
		end

feature -- Status report

	test (v, u: IR_VALUE): BOOLEAN
		do
			Result := v ~ u
		end

end
