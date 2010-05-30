note
	description: "Summary description for {AFX_STATE_TRANSITION_SUMMARY_EQUALITY_TESTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_STATE_TRANSITION_SUMMARY_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [AFX_STATE_TRANSITION_SUMMARY]
		redefine
			test
		end

create
	default_create

feature -- Equality

	test (u, v: detachable AFX_STATE_TRANSITION_SUMMARY): BOOLEAN
			-- <Precursor>
		do
		    if u = v then
		        Result := True
		    elseif u = Void or v = Void then
		        Result := False
		    elseif attached u as l_u and attached v as l_v then
		        if l_u.hash_code = l_v.hash_code and then l_u.count = l_v.count then
			        Result := True
    		        from
    		            l_u.start
    		            l_v.start
    		        until
    		            l_u.after or not Result
    		        loop
    		            Result := boolean_state_transition_summary_equality_tester.test (l_u.item_for_iteration, l_v.item_for_iteration)
    		            l_u.forth
    		            l_v.forth
    		        end
    		    end
    		else
				check False end
		    end
		end

feature{NONE} -- Implementation

	boolean_state_transition_summary_equality_tester: AFX_BOOLEAN_STATE_TRANSITION_SUMMARY_EQUALITY_TESTER
			-- boolean state transition summary equality tester
		once
		    create Result
		end

end
