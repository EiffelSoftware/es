note
	description: "Class that represents a scope for a quantified variable"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CI_QUANTIFIED_SCOPE

feature -- Access

	scope (a_context: CI_TRANSITION_INFO): DS_HASH_SET [EPA_FUNCTION]
			-- Values in current scope
		deferred
		end

feature -- Status report

	is_pre_state: BOOLEAN
			-- Is current scope defined over pre-state valuations?

	is_post_state: BOOLEAN
			-- Is current scope defined over post-state valuations?
		do
			Result := not is_pre_state
		end

feature -- Setting

	set_is_pre_state (b: BOOLEAN)
			-- Set `is_pre_state' with `b'.
		do
			is_pre_state := b
		ensure
			is_pre_state_set: is_pre_state = b
		end

	set_is_post_state (b: BOOLEAN)
			-- Set `is_post_state' with `b'.
		do
			is_pre_state := not b
		ensure
			is_post_state_set: is_post_state = b
		end

end
