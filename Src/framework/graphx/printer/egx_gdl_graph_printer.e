indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision: 5 $"

deferred class
	EGX_GDL_GRAPH_PRINTER [N -> HASHABLE, L]

inherit
	EGX_GRAPH_PRINTER [N, L]

feature -- Print

	print_graph (a_graph: EGX_GENERAL_GRAPH [N, L]) is
			-- Print `a_graph' (to some output).
		local
			l_visitor: EGX_GRAPH_DFS_VISITOR [N, L]
			l_visitor_status: EGX_GRAPH_UNORDERED_VISITOR_NODE_STATUS [N, L]
			l_printing: like last_printing
		do
			create last_printing.make (4096)
			last_printing.append ("graph: {%N")
			last_printing.append ("display_edge_labels: yes%N")

			node_index := 0
			create l_visitor.make
			create l_visitor_status
			l_visitor.set_visited_node_status (l_visitor_status)
			l_visitor.set_graph (a_graph)
			l_visitor.first_visit_node_actions.extend (agent first_visit_action (?, ?, ?, ?, last_printing))
			l_visitor.ignore_visited_node_actions.extend (agent ignore_visit_action (?, ?, ?, last_printing))
			l_visitor.prepare_visit
			l_visitor.visit_all

			last_printing.append ("}%N")
		ensure then
			last_printing_attached: last_printing /= Void
		end

feature -- Printing result

	last_printing: STRING
			-- Printed string from the last `print_graph'

feature -- Access

	node_text_action: FUNCTION [ANY, TUPLE [a_node: N], TUPLE [a_title: STRING; a_label: STRING]]
			-- Action to get title and label of `a_node'.
			-- If Void, default title of `a_node' is its index number (the number of nodes that have been visited before `a_node'),
			-- and default label will bit `a_node'.`out'.

	edge_text_action: FUNCTION [ANY, TUPLE [a_edge: L], STRING]
			-- Action to get label from `a_edge'.
			-- If Void, default label of `a_edge' will be `a_edge'.`out' if `a_edge' is not Void, otherwise, label will be an empty string.

feature -- Setting

	set_node_text_action (a_action: like node_text_action) is
			-- Set `node_text_action' with `a_action'.
		do
			node_text_action := a_action
			if node_text_action = Void then
				actual_node_text_action := agent default_node_text_action
			else
				actual_node_text_action := node_text_action
			end
		ensure
			node_text_action_set: node_text_action = a_action
		end

	set_edge_text_action (a_action: like edge_text_action) is
			-- Set `edge_text_action' with `a_action'.
		do
			edge_text_action := a_action
			if edge_text_action = Void then
				actual_edge_text_action := agent default_edge_text_action
			else
				actual_edge_text_action := edge_text_action
			end
		ensure
			edge_text_action_set: edge_text_action = a_action
		end

feature{NONE} -- Implementation/Style

	actual_node_text_action: like node_text_action
			-- Implementation of `node_text_action'

	actual_edge_text_action: like edge_text_action
			-- Implementation of `edge_Text_action'

	default_node_text_action (a_node: N): TUPLE [a_title: STRING; a_label: STRING] is
			-- Default text action for `a_node'
		require
			a_node_attached: a_node /= Void
		do
			Result := [node_index.out, a_node.out]
		ensure
			result_attached: Result /= Void
		end

	default_edge_text_action (a_edge: L): STRING is
			-- Default text for `a_edge'
		do
			if a_edge /= Void then
				Result := a_edge.out
			else
				create Result.make_empty
			end
		ensure
			result_attached: Result /= Void
		end

	node_index: INTEGER
			-- Recored node index during graph visiting

feature{NONE} -- Implementation/Visiting

	first_visit_action (a_start_node: N; a_end_node: N; a_edge: L; a_new_start: BOOLEAN; a_buffer: like last_printing) is
			-- Action to be performed when `a_end_node' is visited for the first time
		require
			a_end_node_attached: a_end_node /= Void
			a_buffer_attached: a_buffer /= Void
		deferred
		ensure
			node_index_changed: node_index /= old node_index
		end

	ignore_visit_action (a_start_node: N; a_end_node: N; a_edge: L; a_buffer: like last_printing) is
			-- Action to be performed when `a_end_node' is visited for the first time
		require
			a_start_node_attached: a_start_node /= Void
			a_end_node_attached: a_end_node /= Void
			a_buffer_attached: a_buffer /= Void
		deferred
		end

feature{NONE} -- Implemenation/Drawing

	draw_node (a_title: STRING; a_label: STRING; a_style: EGX_GDL_GRAPH_STYLE; a_buffer: STRING) is
			-- Draw a node with title `a_title' and label `a_labe' into `a_buffer' using style `a_style'.
		require
			a_title_attached: a_title /= Void
			a_label_attached: a_label /= Void
			a_style_attached: a_style /= Void
			a_buffer_attached: a_buffer /= Void
		do
				-- Draw node title.
			a_buffer.append ("%Tnode: { ")
			a_buffer.append ("title: %"")
			a_buffer.append (a_title)
			a_buffer.append ("%" ")

				-- Draw node label.
			a_buffer.append ("label: %"")
			a_buffer.append (a_label)
			a_buffer.append ("%" ")

				-- Draw node color.
			a_buffer.append ("color: ")
			a_buffer.append (a_style.node_color)
			a_buffer.append (" ")

				-- Draw border color.
			a_buffer.append ("bordercolor: ")
			a_buffer.append (a_style.border_color)
			a_buffer.append (" ")

			a_buffer.append (" }%N")
		end

	draw_edge (a_label: STRING; a_source_title: STRING; a_target_title: STRING; a_style: EGX_GDL_GRAPH_STYLE; a_buffer: STRING) is
			-- Draw edge labeled with `a_label' if not Void.
			-- `a_source_title' is title of the starting node of that edge, `a_target_title' is title of the end node of that edge.
			-- `a_style' is the style used to draw current edge.
			-- The drawing will be stored in `a_buffer'.
		require
			a_source_title_attached: a_source_title /= Void
			a_target_title_attached: a_target_title /= Void
			a_style_attached: a_style /= Void
			a_buffer_attached: a_buffer /= Void
		do
				-- Draw edge.
			a_buffer.append ("%Tedge: { ")

				-- Draw source.
			a_buffer.append ("source: %"")
			a_buffer.append (a_source_title)
			a_buffer.append ("%" ")

				-- Draw target.
			a_buffer.append ("target: %"")
			a_buffer.append (a_target_title)
			a_buffer.append ("%" ")

			if a_label /= Void then
				a_buffer.append ("label: %"")
				a_buffer.append (a_label)
				a_buffer.append ("%" ")
			end

				-- Draw line style.
			a_buffer.append ("linestyle: ")
			a_buffer.append (a_style.line_style)
			a_buffer.append (" ")

				-- Draw line thickness.
			a_buffer.append ("thickness: ")
			a_buffer.append (a_style.line_thickness)
			a_buffer.append (" ")

				-- Draw line color.
			a_buffer.append ("color: ")
			a_buffer.append (a_style.line_color)
			a_buffer.append (" ")

			a_buffer.append ("}%N")
		end

invariant
	actual_node_text_action_attached: actual_node_text_action /= Void
	actual_edge_text_action_attached: actual_edge_text_action /= Void

end
