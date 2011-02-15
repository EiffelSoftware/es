note
	description: "Summary description for {AFX_STATE_CHANGE_REQUIREMENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_STATE_CHANGE_REQUIREMENT

create
	make

feature -- Initialization

	make (a_src, a_dest: AFX_PROGRAM_STATE_EXPRESSION; a_target: AFX_FIXING_TARGET)
			-- Initialization.
		do
			src_expr := a_src
			dest_expr := a_dest
			fixing_target := a_target
		end

feature -- Access

	src_expr: AFX_PROGRAM_STATE_EXPRESSION
			-- Source expression to be changed.

	dest_expr: AFX_PROGRAM_STATE_EXPRESSION
			-- Destination expression, to which `src_expression' will be changed.

	fixing_target: AFX_FIXING_TARGET
			-- Related fixing target.

end
