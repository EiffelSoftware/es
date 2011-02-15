note
	description: "Summary description for {AFX_QUERY_MODEL_TRANSITION_SELECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_QUERY_MODEL_TRANSITION_SELECTOR

inherit
	AFX_QUERY_MODEL_TRANSITION_SELECTOR_I

create
    default_create

feature -- Status report

	is_suitable (a_transition: AFX_QUERY_MODEL_TRANSITION): BOOLEAN
			-- <Precursor>
		do
		    Result := True
		    if a_transition.source = Void
		    		or else a_transition.destination = Void
		    		or else not a_transition.source.is_good
		    		or else not a_transition.destination.is_good then
		        Result := False
		    end
		end
end
