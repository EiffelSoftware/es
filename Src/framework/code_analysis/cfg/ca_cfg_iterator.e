note
	description: "Summary description for {CA_CFG_ITERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CA_CFG_ITERATOR

feature -- Iteration

	process_cfg (a_cfg: CA_CFG)
		deferred
		end

	visit_edge (a_from, a_to: CA_CFG_BASIC_BLOCK): BOOLEAN
		deferred
		end

end
