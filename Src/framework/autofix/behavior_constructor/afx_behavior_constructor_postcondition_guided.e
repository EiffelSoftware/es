note
	description: "Summary description for {AFX_BEHAVIOR_CONSTRUCTOR_POSTCONDITION_GUIDED}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BEHAVIOR_CONSTRUCTOR_POSTCONDITION_GUIDED

inherit
	AFX_BEHAVIOR_CONSTRUCTOR_I

    AFX_SHARED_BOOLEAN_MODEL_STATE_TRANSITION_SUMMARY_MANAGER

create
    make

feature -- initialize

	make (a_config: like config)
			-- initialize
		require
		    config_good: a_config.is_good
		do
			config := a_config
			create {AFX_BEHAVIOR_FEATURE_SELECTOR}criteria
			create satisfactory_behaviors.make_default
		end

feature -- access

	config: AFX_BEHAVIOR_CONSTRUCTOR_CONFIG
			-- <Precursor>

	criteria: AFX_BEHAVIOR_FEATURE_SELECTOR_I
			-- <Precursor>

	satisfactory_behaviors: DS_ARRAYED_LIST [AFX_BEHAVIOR_STATE]
			-- <Precursor>

feature -- operation

	construct_behavior
			-- <Precursor>
		local
		do

		end
end
