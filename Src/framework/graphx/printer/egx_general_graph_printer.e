note
	description: "Summary description for {EGX_GENERAL_GRAPH_PRINTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EGX_GENERAL_GRAPH_PRINTER [N -> HASHABLE, L]

inherit
	EGX_GDL_GRAPH_PRINTER [N, L]

	EGX_SHARED_GDL_GRAPH_PRINTER_STYLES

create
	make

feature{NONE} -- Initialization

	make (a_node_text_agent: like node_text_action; a_edge_text_agent: like edge_text_action) is
			-- Initialize Current.
		do
			set_node_text_action (a_node_text_agent)
			set_edge_text_action (a_edge_text_agent)
			edge_style_agent := agent (a_edge: L): EGX_GDL_GRAPH_STYLE do Result := default_style end
		end

feature -- Actions

	edge_style_agent: FUNCTION [ANY, TUPLE [a_edge: L], EGX_GDL_GRAPH_STYLE]
			-- Agent to return the style of `a_edge'

feature -- Status report

	is_ready: BOOLEAN is
			-- Is Current ready to print?
		do
			Result := True
		end

feature{NONE} -- Implementation/Text

	node_text (a_node: N): TUPLE [title: STRING; label: STRING] is
			-- Text for `a_node'
		require
			a_node_attached: a_node /= Void
		do
			Result := node_text_action.item ([a_node])
		ensure
			result_attached: Result /= Void
		end

	edge_text (a_edge: L): STRING is
			-- Text for `a_edge'
		require
			a_edge_attached: a_edge /= Void
		do
			Result := edge_text_action.item ([a_edge])
		ensure
			result_attached: Result /= Void
		end

feature{NONE} -- Implementation/Visiting

	edge_style (a_edge: L): EGX_GDL_GRAPH_STYLE is
			-- Style to draw `a_edge'
		require
			a_edge_attached: a_edge /= Void
		do
			Result := edge_style_agent.item ([a_edge])
		ensure
			result_attached: Result /= Void
		end


	first_visit_action (a_start_node: N; a_end_node: N; a_edge: L; a_new_start: BOOLEAN; a_buffer: like last_printing) is
			-- Action to be performed when `a_end_node' is visited for the first time
		local
			l_start_node_text: TUPLE [title: STRING; label: STRING]
			l_end_node_text: TUPLE [title: STRING; label: STRING]
			l_edge_text: STRING
		do
			node_index := node_index + 1

				-- Draw `a_end_node'.
			l_end_node_text := actual_node_text_action.item ([a_end_node])
			draw_node (l_end_node_text.title, l_end_node_text.label, default_style, a_buffer)

				-- Draw edge connecting `a_start_node' and `a_end_node'.
			if not a_new_start then
				l_start_node_text := node_text (a_start_node)
				l_edge_text := edge_text (a_edge).twin
				draw_edge (
					l_edge_text,
					l_start_node_text.title,
					l_end_node_text.title,
					edge_style (a_edge),
					a_buffer)
			end
		end

	ignore_visit_action (a_start_node: N; a_end_node: N; a_edge: L; a_buffer: like last_printing) is
			-- Action to be performed when `a_end_node' is visited for the first time
		local
			l_start_node_text: TUPLE [title: STRING; label: STRING]
			l_end_node_text: TUPLE [title: STRING; label: STRING]
			l_edge_text: STRING
		do
			l_start_node_text := node_text (a_start_node)
			l_end_node_text := node_text (a_end_node)
			l_edge_text := edge_text (a_edge).twin

			draw_edge (
				l_edge_text,
				node_text (a_start_node).title,
				node_text (a_end_node).title,
				edge_style (a_edge),
				a_buffer)
		end


end

