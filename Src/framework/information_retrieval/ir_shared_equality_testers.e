note
	description: "Shared equality testers for information retrieval library"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IR_SHARED_EQUALITY_TESTERS

feature -- Equality testers

	ir_value_equality_tester: IR_VALUE_EQUALITY_TESTER
			-- Equality tester for term values
		once
			create Result
		end

	ir_term_equality_tester: IR_TERM_EQUALITY_TESTER
			-- Equality tester for terms
		once
			create Result
		end

	ir_field_equality_tester: IR_FIELD_EQUALITY_TESTER
			-- Equality tester for fields
		once
			create Result
		end

end
