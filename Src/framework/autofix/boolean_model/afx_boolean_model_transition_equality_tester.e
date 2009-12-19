note
	description: "Summary description for {AFX_BOOLEAN_MODEL_TRANSITION_EQUALITY_TESTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BOOLEAN_MODEL_TRANSITION_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [AFX_BOOLEAN_MODEL_TRANSITION]
		redefine
			test
		end

create
	default_create

feature -- Equality

	test (u, v: detachable AFX_BOOLEAN_MODEL_TRANSITION): BOOLEAN
			-- <Precursor>
		do
			if u = v then
				Result := True
			elseif u = Void or v = Void then
				Result := False
			elseif attached u as l_u and attached v as l_v then
				if l_u.hash_code = l_v.hash_code
						and then boolean_model_state_equality_tester.test (l_u.boolean_source, l_v.boolean_source)
						and then boolean_model_state_equality_tester.test (l_u.boolean_destination, l_v.boolean_destination)
						and then l_u.query_model_transition.is_about_same_feature (l_v.query_model_transition) then
					Result := True
				end
			else
				check False end
			end
		end

feature {NONE} -- Implementation

	boolean_model_state_equality_tester: AFX_BOOLEAN_MODEL_STATE_EQUALITY_TESTER
			-- Shared boolean model state equality tester.
		once
			create Result
		end

end
