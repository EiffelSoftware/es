note
	description: "Summary description for {AFX_CALL_BASED_REQUEST_EQUALITY_TESTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_CALL_BASED_REQUEST_EQUALITY_TESTER

inherit
    KL_EQUALITY_TESTER [AUT_CALL_BASED_REQUEST]
    	redefine test end

	REFACTORING_HELPER
		undefine
			copy,
			is_equal
		end

create
    default_create

feature -- status report

	test (u, v: AUT_CALL_BASED_REQUEST): BOOLEAN
			-- test if `u' and `v' are considered to be equal
		do
		    if u = v then
		        Result := True
		    elseif u = Void or v = Void then
		        Result := False
		    elseif u.target_type ~ v.target_type and then u.feature_to_call.feature_id = v.feature_to_call.feature_id then
		        fixme ("AFX_CALL_BASED_REQUEST_EQUALITY_TESTER: check which of = and ~ should be used.")
	            Result := True
		    end
		end

end
