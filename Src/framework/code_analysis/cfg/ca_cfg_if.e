note
	description: "Summary description for {CA_CFG_IF}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_CFG_IF

inherit
	CA_CFG_BASIC_BLOCK

create
	make_with_condition,
	make_complete

feature {NONE} -- Initialization

	make_with_condition (a_condition: EXPR_AS)
		do
			initialize
			out_edges.resize (2)
			condition := a_condition
		end

	make_complete (a_condition: EXPR_AS; a_label: INTEGER)
		do
			make_with_condition (a_condition)
			label := a_label
		end

feature -- Properties

	condition: EXPR_AS

	true_branch: CA_CFG_BASIC_BLOCK
		do
			Result := out_edges.at (1)
		end

	false_branch: CA_CFG_BASIC_BLOCK
		do
			Result := out_edges.at (2)
		end

	set_true_branch (a_bb: CA_CFG_BASIC_BLOCK)
		do
			out_edges.put_i_th (a_bb, 1)
		end

	set_false_branch (a_bb: CA_CFG_BASIC_BLOCK)
		do
			out_edges.put_i_th (a_bb, 2)
		end

feature -- Visitor

	process (a_it: CA_CFG_ITERATOR)
		do
			a_it.bb_process_if (Current)
		end

invariant
	out_edges.count = 2
end
