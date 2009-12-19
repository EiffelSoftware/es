note
	description: "Summary description for {AFX_BEHAVIOR_FEATURE_SELECTOR_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_BEHAVIOR_FEATURE_SELECTOR_I

feature -- Operation

	is_suitable (a_class: CLASS_C; a_feature: FEATURE_I; a_context_class: CLASS_C): BOOLEAN
			-- Is `a_feature' from `a_class' suitable to be used in a fix in `a_context_class'?
		deferred
		end

end
