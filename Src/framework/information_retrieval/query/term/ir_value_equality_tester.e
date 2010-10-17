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
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				if v.same_type (u) then
					Result := v.item ~ u.item
				end
			end
		end

end
