note
	description: "Equality tester for {EPA_FUNCTION_ARGUMENT_VALUE_MAP}"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_FUNCTION_ARGUMENT_VALUE_MAP_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [EPA_FUNCTION_ARGUMENT_VALUE_MAP]
		redefine
			test
		end

feature -- Status report

	test (v, u: EPA_FUNCTION_ARGUMENT_VALUE_MAP): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result := v.arguments.is_equal (u.arguments) and then function_equality_tester_internal.test (v.value, u.value)
			end
		end

feature{NONE} -- Implementation

	function_equality_tester_internal: EPA_FUNCTION_EQUALITY_TESTER
			-- Equality tester for {CI_FUNCTION}
		once
			create Result
		end

end
