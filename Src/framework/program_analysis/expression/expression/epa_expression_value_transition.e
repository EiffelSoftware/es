note
	description: "Summary description for {EPA_EXPRESSION_VALUE_TRANSITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXPRESSION_VALUE_TRANSITION

create
	make

feature -- Creation procedure

	make (a_expr: like expression; a_pre_bp: like pre_state_bp; a_post_bp: like post_state_bp; a_pre_value: like pre_state_value; a_post_value: like post_state_value)
			--
		do
			expression := a_expr
			pre_state_bp := a_pre_bp
			post_state_bp := a_post_bp
			pre_state_value := a_pre_value
			post_state_value := a_post_value
		end

feature -- Access

	expression: EPA_EXPRESSION
			--

	pre_state_bp: INTEGER
			--

	post_state_bp: INTEGER
			--

	pre_state_value: EPA_EXPRESSION_VALUE
			--

	post_state_value: EPA_EXPRESSION_VALUE
			--

end
