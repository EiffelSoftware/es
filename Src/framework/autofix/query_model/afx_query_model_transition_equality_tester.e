note
	description: "Summary description for {AFX_QUERY_MODEL_TRANSITION_EQUALITY_TESTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_QUERY_MODEL_TRANSITION_EQUALITY_TESTER

inherit
    KL_EQUALITY_TESTER [AFX_QUERY_MODEL_TRANSITION]
    	redefine
    		test
    	end

create
    default_create

feature -- Equality

	test (u, v: AFX_QUERY_MODEL_TRANSITION): BOOLEAN
			-- <Precurosr>
		do
		    if u = v then
		        Result := True
		    elseif u = Void or v = Void then
		        Result := False
		    elseif u.hash_code = v.hash_code then
		        if state_tester.test (u.source, v.source)
		        		and then state_tester.test (u.destination, v.destination)
		        		and then request_tester.test (u.feature_call, v.feature_call) then
		            Result := True
		        end
		    end
		end

feature{NONE} -- Implementation

    state_tester: AFX_QUERY_MODEL_STATE_EQUALITY_TESTER
    		-- State tester.
    	once
    	    create Result
    	end

    request_tester: AFX_CALL_BASED_REQUEST_EQUALITY_TESTER
    		-- Request tester.
    	once
    	    create Result
    	end
end
