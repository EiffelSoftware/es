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

end
