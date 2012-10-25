note
	description: "Summary description for {EPA_EXPRESSION_VALUE_TRANSITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXPRESSION_VALUE_TRANSITION

create
	make

feature {NONE} -- Initialization

	make (
		a_expression: like expression;
		a_pre_state_breakpoint: like pre_state_breakpoint;
		a_pre_state_value: like pre_state_value;
		a_post_state_breakpoint: like post_state_breakpoint;
		a_post_state_value: like post_state_value
	)
			--
		require
			a_expression_not_void: a_expression /= Void
			a_pre_state_breakpoint_valid: a_pre_state_breakpoint >= 1
			a_pre_state_value_not_void: a_pre_state_value /= Void
			a_post_state_breakpoint_valid: a_post_state_breakpoint >= 1
			a_post_state_value_not_void: a_post_state_value /= Void
		do
			expression := a_expression
			pre_state_breakpoint := a_pre_state_breakpoint
			pre_state_value := a_pre_state_value
			post_state_breakpoint := a_post_state_breakpoint
			post_state_value := a_post_state_value
		ensure
			expression_set: expression = a_expression
			pre_state_breakpoint_set: pre_state_breakpoint = a_pre_state_breakpoint
			pre_state_value_set: pre_state_value = a_pre_state_value
			post_state_bp_set: post_state_breakpoint = a_post_state_breakpoint
			post_state_value_set: post_state_value = a_post_state_value
		end

feature -- Access

	expression: EPA_EXPRESSION
			--

	pre_state_breakpoint: INTEGER
			--

	pre_state_value: EPA_EXPRESSION_VALUE
			--

	post_state_breakpoint: INTEGER
			--

	post_state_value: EPA_EXPRESSION_VALUE
			--

end
