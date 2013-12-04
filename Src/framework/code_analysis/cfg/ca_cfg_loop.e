note
	description: "Summary description for {CA_CFG_LOOP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_CFG_LOOP

inherit
	CA_CFG_BASIC_BLOCK

create
	make_with_stop_condition,
	make_complete

feature {NONE} -- Initialization

	make_with_stop_condition (a_condition: EXPR_AS)
		do
			initialize
			create out_edges.make_filled (2)
			create in_edges.make_filled (1)
			stop_condition := a_condition
		end

	make_complete (a_condition: EXPR_AS; a_label: INTEGER)
		do
			make_with_stop_condition (a_condition)
			label := a_label
		end

feature -- Properties

	stop_condition: detachable EXPR_AS

	loop_branch: CA_CFG_BASIC_BLOCK
		do
			Result := out_edges.at (1)
		end

	exit_branch: CA_CFG_BASIC_BLOCK
		do
			Result := out_edges.at (2)
		end

	loop_in: CA_CFG_BASIC_BLOCK
		do
			Result := in_edges.at (1)
		end

	set_loop_branch (a_bb: CA_CFG_BASIC_BLOCK)
		do
			out_edges.put_i_th (a_bb, 1)
		end

	set_exit_branch (a_bb: CA_CFG_BASIC_BLOCK)
		do
			out_edges.put_i_th (a_bb, 2)
		end

	set_loop_in (a_in: CA_CFG_BASIC_BLOCK)
		do
			in_edges.put_i_th (a_in, 1)
		end


feature -- Visitor

	process (a_it: CA_CFG_ITERATOR)
		do

		end

invariant
	out_edges.count = 2
	in_edges.count >= 1
end
