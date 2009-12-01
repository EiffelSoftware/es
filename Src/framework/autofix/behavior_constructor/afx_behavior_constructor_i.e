note
	description: "Summary description for {AFX_BEHAVIOR_CONSTRUCTOR_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_BEHAVIOR_CONSTRUCTOR_I

feature -- access

	config: AFX_BEHAVIOR_CONSTRUCTOR_CONFIG
			-- configuration of constructor
		deferred
		end

	criteria: AFX_BEHAVIOR_FEATURE_SELECTOR_I
			-- feature selection criteria
		deferred
		end

	satisfactory_behaviors: DS_ARRAYED_LIST [AFX_BEHAVIOR_STATE]
			-- satisfactory behaviors found
		deferred
		end

feature -- operation

	construct_behavior
			-- construct behavior to make the transition
		deferred
		end

end
