note
	description: "Summary description for {EPA_FALSE_CFG_EDGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_FALSE_CFG_EDGE

inherit
	EPA_CFG_EDGE
		redefine
			is_false_branch
		end

create
	make

feature -- Status report

	is_false_branch: BOOLEAN = True
			-- Is Current an false-branch edge?
			
end
