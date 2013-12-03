note
	description: "Summary description for {CA_CFG_INSPECT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_CFG_INSPECT

inherit
	CA_CFG_BASIC_BLOCK

create
	make_complete

feature {NONE} -- Initialization

	make_complete (a_expr: EXPR_AS; a_intervals: detachable LIST [EIFFEL_LIST [INTERVAL_AS]]; a_has_else: BOOLEAN; a_label: INTEGER)
		do
			initialize
			has_else := a_has_else
			if attached a_intervals then
				n_when_branches := a_intervals.count
			end
			if a_has_else then
				create out_edges.make_filled (n_when_branches + 1)
			else
				create out_edges.make_filled (n_when_branches)
			end
			create intervals.make_filled (n_when_branches)
			across a_intervals as l_intervals loop
				intervals.put_i_th (l_intervals.item, l_intervals.cursor_index)
			end
			expression := a_expr
			label := a_label
		end

feature -- Properties

	expression: EXPR_AS

	intervals: detachable ARRAYED_LIST [EIFFEL_LIST [INTERVAL_AS]]

	when_branches: detachable LIST [CA_CFG_BASIC_BLOCK]
		do
			if n_when_branches > 0 then
				out_edges.start
				if has_else then
					Result := out_edges.duplicate (n_when_branches)
				else
					Result := out_edges
				end
			else
				Result := Void
			end
		end

	else_branch: detachable CA_CFG_BASIC_BLOCK
		do
			if has_else then
				Result := out_edges.at (n_when_branches + 1)
			else
				Result := Void
			end
		end

	n_when_branches: INTEGER

	has_else: BOOLEAN

	set_when_branch (a_bb: CA_CFG_BASIC_BLOCK; a_index: INTEGER)
		require
			valid_index: (a_index >= 1) and (a_index <= n_when_branches)
		do
			out_edges.put_i_th (a_bb, a_index)
		end

	set_else_branch (a_bb: CA_CFG_BASIC_BLOCK)
		require
			has_else
		do
			out_edges.put_i_th (a_bb, n_when_branches + 1)
		end

feature -- Visitor

	process (a_it: CA_CFG_ITERATOR)
		do

		end

invariant
	has_else implies (out_edges.count = 1 + n_when_branches)
	(not has_else) implies (out_edges.count = n_when_branches)
end
