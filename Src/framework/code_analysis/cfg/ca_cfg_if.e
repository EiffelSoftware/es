note
	description: "Represents an If block in the CFG."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_CFG_IF

inherit
	CA_CFG_BASIC_BLOCK

create
	make_complete

feature {NONE} -- Initialization

	make_complete (a_condition: EXPR_AS; a_label: INTEGER)
			-- Initializes `Current' with if condition `a_condition' and label
			-- `a_label'.
		do
			initialize
			create out_edges.make_filled (2)
			condition := a_condition
			label := a_label
		end

feature -- Properties

	condition: EXPR_AS
			-- The if condition.

	true_branch: CA_CFG_BASIC_BLOCK
			-- The node of the "true" edge.
		do
			Result := out_edges.at (1)
		end

	false_branch: CA_CFG_BASIC_BLOCK
			-- The node of the "false" edge.
		do
			Result := out_edges.at (2)
		end

	set_true_branch (a_bb: CA_CFG_BASIC_BLOCK)
			-- Sets the node of the "true" edge to `a_bb'.
		do
			out_edges.put_i_th (a_bb, 1)
		end

	set_false_branch (a_bb: CA_CFG_BASIC_BLOCK)
			-- Sets the node of the "false" edge to `a_bb'.
		do
			out_edges.put_i_th (a_bb, 2)
		end

invariant
	out_edges.count = 2 -- The "true" and the "false" edge.
end
