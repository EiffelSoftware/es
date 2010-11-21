note
	description: "Summary description for {EPA_SEQUENTIAL_CFG_EDGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_SEQUENTIAL_CFG_EDGE

inherit
	EPA_CFG_EDGE
		redefine
			is_seqential_branch
		end

create
	make

feature -- Status report

	is_seqential_branch: BOOLEAN = True
			-- Is Current a sequential edge?

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := ""
		end

end
