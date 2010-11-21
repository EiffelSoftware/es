note
	description: "Objects that represents true-branch edges in CFG"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_TRUE_CFG_EDGE

inherit
	EPA_CFG_EDGE
		redefine
			is_true_branch
		end

create
	make

feature -- Status report

	is_true_branch: BOOLEAN = True
			-- Is Current an true-branch edge?

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := (True).out
		end

end
