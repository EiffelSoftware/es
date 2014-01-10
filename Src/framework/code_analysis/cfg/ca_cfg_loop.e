note
	description: "Represents a loop block in the CFG."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_CFG_LOOP

inherit
	CA_CFG_BASIC_BLOCK

create
	make

feature {NONE} -- Initialization

	make (a_loop: LOOP_AS; a_label: INTEGER)
			-- Initializes `Current' with AST node `a_loop' and label `a_label'.
		do
			initialize
			create out_edges.make_filled (2)
			create in_edges.make_filled (1)
			ast := a_loop
			stop_condition := a_loop.stop
			label := a_label
		end

feature -- Properties

	stop_condition: detachable EXPR_AS
			-- The stop condition of the loop.

	ast: LOOP_AS
			-- The AST node associated with `Current'.

	loop_branch: CA_CFG_BASIC_BLOCK
			-- The branch that is executed when the loop continues
			-- to iterate.
		do
			Result := out_edges.at (1)
		end

	exit_branch: CA_CFG_BASIC_BLOCK
			-- The branch that is executed when the loop is exited.
		do
			Result := out_edges.at (2)
		end

	loop_in: CA_CFG_BASIC_BLOCK
			-- The edge from the end of the loop to `Current'.
		do
			Result := in_edges.at (1)
		end

	set_loop_branch (a_bb: CA_CFG_BASIC_BLOCK)
			-- Sets the branch that is executed when the loop continues
			-- to iterate.
		do
			out_edges.put_i_th (a_bb, 1)
		end

	set_exit_branch (a_bb: CA_CFG_BASIC_BLOCK)
			-- Sets the branch that is executed when the loop is exited.
		do
			out_edges.put_i_th (a_bb, 2)
		end

	set_loop_in (a_in: CA_CFG_BASIC_BLOCK)
			-- Set the edge from the end of the loop to `Current'.
		do
			in_edges.put_i_th (a_in, 1)
		end

invariant
	out_edges.count = 2
	in_edges.count >= 1
end
