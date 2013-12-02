note
	description: "Summary description for {CA_CFG_BASIC_BLOCK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CA_CFG_BASIC_BLOCK

inherit
	HASHABLE

feature {NONE} -- Initialization

	initialize
		local
			l_to_be_deleted: CA_CFG_BUILDER
		do
			create in_edges.make (0)
			create out_edges.make (0)
		end

feature -- Edges

	in_edges, out_edges: ARRAYED_LIST [CA_CFG_BASIC_BLOCK]

	add_in_edge (a_edge: CA_CFG_BASIC_BLOCK)
		do
			in_edges.extend (a_edge)
		end

	add_out_edge (a_edge: CA_CFG_BASIC_BLOCK)
		do
			out_edges.extend (a_edge)
		end

	wipe_out_in_edges
		do
			in_edges.wipe_out
		end

	wipe_out_out_edges
		do
			out_edges.wipe_out
		end

feature -- Properties

	label: INTEGER

	set_label (a_label: INTEGER)
		do
			label := a_label
		end

	hash_code: INTEGER
		do
			Result := label.abs
		end

feature -- Visitor

	process (a_it: CA_CFG_ITERATOR)
		deferred
		end

end
