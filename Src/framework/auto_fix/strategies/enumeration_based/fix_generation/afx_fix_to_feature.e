note
	description: "Summary description for {AFX_FIX_TO_FEATURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_FIX_TO_FEATURE

feature -- Access

	context_feature: AFX_FEATURE_TO_MONITOR
			-- Target feature of the fix.

feature{AFX_FIX_TO_FEATURE} -- Set

	set_context_feature (a_feature: like context_feature)
			--
		require
			a_feature /= Void
		do
			context_feature := a_feature
		end

end
