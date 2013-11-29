note
	description: "Summary description for {CA_CFG_SKIP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_CFG_SKIP

inherit
	CA_CFG_BASIC_BLOCK

create
	make

feature {NONE} -- Initialization

	make
		do

		end

feature -- Visitor

	process (a_it: CA_CFG_ITERATOR)
		do
			a_it.bb_process_skip (Current)
		end


end
