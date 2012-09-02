note
	description: "Summary description for {EPA_VALUE_TRANSITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_VALUE_TRANSITION

create
	make

feature {NONE} -- Initialization

	make (a_pre_state_bp: like pre_state_bp; a_pre_state_value: like pre_state_value; a_post_state_bp: like post_state_bp; a_post_state_value: like post_state_value)
			--
		require
			a_pre_state_bp_valid: a_pre_state_bp >= 1
			a_post_state_bp_valid: a_post_state_bp >= 1
			a_pre_state_value_not_void: a_pre_state_value /= Void
			a_post_state_value_not_void: a_post_state_value /= Void
		do
			pre_state_bp := a_pre_state_bp
			pre_state_value := a_pre_state_value
			post_state_bp := a_post_state_bp
			post_state_value := a_post_state_value
		ensure
			pre_state_bp_set: pre_state_bp = a_pre_state_bp
			pre_state_value_set: pre_state_value = a_pre_state_value
			post_state_bp_set: post_state_bp = a_post_state_bp
			post_state_value_set: post_state_value = a_post_state_value
		end

feature -- Access

	pre_state_bp: INTEGER
			--

	post_state_bp: INTEGER
			--

	pre_state_value: EPA_EXPRESSION_VALUE
			--

	post_state_value: EPA_EXPRESSION_VALUE
			--

end
