note
	description: "Summary description for {AFX_BOOLEAN_STATE_TRANSITION_SUMMARY_EQUALITY_TESTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BOOLEAN_STATE_TRANSITION_SUMMARY_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [AFX_BOOLEAN_STATE_TRANSITION_SUMMARY]
		redefine
			test
		end

create
	default_create

feature -- Equality

	test (u, v: detachable AFX_BOOLEAN_STATE_TRANSITION_SUMMARY): BOOLEAN
			-- <Precursor>
		do
		    if u = v then
		        Result := True
		    elseif u = Void or v = Void then
		        Result := False
		    elseif attached u as l_u and attached v as l_v then
		        if l_u.hash_code = l_v.hash_code and then l_u.class_ = l_v.class_ and then l_u.boolean_state_outline = l_v.boolean_state_outline
		        		and then l_u.pre_true ~ l_v.pre_true and then l_u.pre_false ~ l_v.pre_false
		        		and then l_u.post_set_true ~ l_v.post_set_true and then l_u.post_set_false ~ l_v.post_set_false
		        		and then l_u.post_unchanged ~ l_v.post_unchanged and then l_u.post_negated ~ l_v.post_negated then
			        Result := True
			    else
			        Result := False
    		    end
    		else
				check False end
		    end
		end

end
