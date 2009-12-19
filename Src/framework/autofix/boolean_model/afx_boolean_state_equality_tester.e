note
	description: "Summary description for {AFX_BOOLEAN_STATE_EQUALITY_TESTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BOOLEAN_STATE_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [AFX_BOOLEAN_STATE]
		redefine test end

create
	default_create

feature -- Equality

	test (u, v: detachable AFX_BOOLEAN_STATE): BOOLEAN
			-- <Precursor>
		do
			if u = v then
				Result := True
			elseif u = Void or v = Void then
				Result := False
			elseif attached u as l_u and then attached v as l_v then
			    if l_u.is_chaos or l_v.is_chaos then
    			    Result := False
    			elseif l_u.hash_code = l_v.hash_code
    					and then l_u.boolean_state_outline = l_v.boolean_state_outline then
    						-- share the same boolean state outline (and therefore also the same boolean outline extractor)
    				Result := l_u.properties_false.is_equal (l_v.properties_false)
    						and then l_u.properties_true.is_equal (l_v.properties_false)
    			end
    		else
    		    check False end
    		end
		end


end
