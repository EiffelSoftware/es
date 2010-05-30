note
	description: "Summary description for {AFX_SHARED_BEHAVIOR_FEATURE_SELECTOR_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SHARED_BEHAVIOR_FEATURE_SELECTOR_FACTORY

create
    default_create

feature -- Shared selectors

	behavior_feature_selector: AFX_BEHAVIOR_FEATURE_SELECTOR
			-- Shared behavior feature selector.
		once
		    create Result
		end
end
