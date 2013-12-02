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

	make (a_label: INTEGER)
		do
			initialize
			label := a_label
		end

feature -- Visitor

	process (a_it: CA_CFG_ITERATOR)
		do

		end


end
