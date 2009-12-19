note
	description: "Summary description for {AFX_QUERY_MODEL_STATE_EQUALITY_TESTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_QUERY_MODEL_STATE_EQUALITY_TESTER

inherit
    KL_EQUALITY_TESTER [AFX_QUERY_MODEL_STATE]
    	redefine
    		test
    	end

create
    default_create

feature -- Equality

	test (u, v: AFX_QUERY_MODEL_STATE): BOOLEAN
			-- <Precursor>
		do
			if u = v then
			    Result := True
			elseif u = Void or v = Void then
			    Result := False
			elseif u.count = v.count and then u.hash_code = v.hash_code then
			    Result := True
			    from
			    	u.start
			    	v.start
			    until
			        u.after or not Result
			    loop
			        Result := state_equality_tester.test (u.item_for_iteration, v.item_for_iteration)
			        u.forth
			        v.forth
			    end
			end
		end

feature{NONE} --Implementation

	state_equality_tester: AFX_STATE_EQUALITY_TESTER
			-- State equality tester.
		once
		    create Result
		end

end
