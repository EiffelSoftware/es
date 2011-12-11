note
	description: "Summary description for {EPA_STATE_TRANSITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_STATE_CHANGE

feature -- Access

	pre_state: DS_HASH_TABLE [EPA_EXPRESSION_VALUE, STRING]
			--

	post_state: DS_HASH_TABLE [EPA_EXPRESSION_VALUE, STRING]
			--

	pre_state_bp_slot: INTEGER
			--

	post_state_bp_slot: INTEGER
			--

feature -- Element change

	set_pre_state (a_pre_state: like pre_state)
			--
		require
			a_pre_state_not_void: a_pre_state /= Void
		do
			pre_state := a_pre_state
		ensure
			pre_state_set: pre_state = a_pre_state
		end

	set_post_state (a_post_state: like post_state)
			--
		require
			a_post_state_not_void: a_post_state /= Void
		do
			post_state := a_post_state
		ensure
			post_state_set: post_state = a_post_state
		end

	set_pre_state_bp_slot (a_pre_state_bp_slot: like pre_state_bp_slot)
			--
		require
			a_pre_state_bp_slot_valid: a_pre_state_bp_slot >= 1
		do
			pre_state_bp_slot := a_pre_state_bp_slot
		ensure
			pre_state_bp_slot: pre_state_bp_slot = a_pre_state_bp_slot
		end

	set_post_state_bp_slot (a_post_state_bp_slot: like post_state_bp_slot)
			--
		require
			a_post_state_bp_slot_valid: a_post_state_bp_slot >= 1
		do
			post_state_bp_slot := a_post_state_bp_slot
		ensure
			post_state_bp_slot_set: post_state_bp_slot = a_post_state_bp_slot
		end

end
