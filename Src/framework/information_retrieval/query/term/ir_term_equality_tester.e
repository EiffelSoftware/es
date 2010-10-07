note
	description: "Summary description for {IR_TERM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IR_TERM_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [IR_TERM]
		redefine
			test
		end

	IR_SHARED_EQUALITY_TESTERS

feature -- Status report

	test (v, u: IR_TERM): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result :=
					ir_field_equality_tester.test (v.field, u.field) and then
					v.occurrence = u.occurrence
			end
		end

end
