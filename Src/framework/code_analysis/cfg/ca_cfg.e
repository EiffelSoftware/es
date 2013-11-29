note
	description: "Represents a Control Flow Graph implemented as a doubly linked graph."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_CFG

create {CA_CFG_BUILDER}
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create start_node.make
			create end_node.make
		end

feature -- Properties

	start_node, end_node: CA_CFG_SKIP

end
