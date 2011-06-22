note
	description: "Annotation that represents state information"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ANN_STATE_ANNOTATION

inherit
	ANN_ANNOTATION

feature -- Access

	pre_state: EPA_HASH_SET [EPA_EQUATION]
			-- Annotations in pre-state
		do
			if pre_state_internal = Void then
				create pre_state_internal.make (20)
				pre_state_internal.set_equality_tester (equation_equality_tester)
			end
			Result := pre_state_internal
		end

	post_state: EPA_HASH_SET [EPA_EQUATION]
			-- Annotations in post-state
		do
			if post_state_internal = Void then
				create post_state_internal.make (20)
				post_state_internal.set_equality_tester (equation_equality_tester)
			end
			Result := post_state_internal
		end

feature{NONE} -- Implimentation

	pre_state_internal: like pre_state
			-- Cache for `pre_state'

	post_state_internal: like post_state
			-- Cache for `post_state'

end
