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

	make (a_src, a_dest: EPA_EXPRESSION)
			-- Initialization.
		do
			src_expr := a_src
			dest_expr := a_dest
		end

feature -- Access

	src_expr: EPA_EXPRESSION
			-- Source expression to be changed.

	dest_expr: EPA_EXPRESSION
			-- Destination expression, to which `src_expression' will be changed.

end
