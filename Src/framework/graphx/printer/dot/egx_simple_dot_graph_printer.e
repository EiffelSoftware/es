note
	description: "Simple graph printer for DOT format"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EGX_SIMPLE_DOT_GRAPH_PRINTER [N->HASHABLE, L]

inherit
	EGX_DOT_GRAPH_PRINTER [N, L]

create
	make,
	make_default

feature{NONE} -- Initialization

	make (a_node_label_agent: like node_label_agent; a_edge_label_agent: like edge_label_agent)
			-- Initialize Current.
		do
			set_node_label_agent (a_node_label_agent)
			set_edge_label_agent (a_edge_label_agent)
			set_node_style_agent (Void)
			set_edge_style_agent (Void)
		end

	make_default
			-- Initialize Current.
		do
			make (default_node_label, default_edge_label)
		end

feature -- Last printing

	last_printing: STRING
			-- Last printing by `print_graph'.

feature -- Access

	node_label_agent: detachable FUNCTION [ANY, TUPLE [node: N], STRING]
			-- Agent to retrieve the label of `node'

	edge_label_agent: detachable FUNCTION [ANY, TUPLE [start_node: N; end_node: N; edge: L], STRING]
			-- Agent to retrieve the label of `edge' connecting `start_node' and `end_node'

	node_style_agent: detachable FUNCTION [ANY, TUPLE [node: N], STRING]
			-- Agent to retrieve the drawing style for `node'
			-- If Void, `default_node_style' will be used as default.

	edge_style_agent: detachable FUNCTION [ANY, TUPLE [start_node: N; end_node: N; edge: L], STRING]
			-- Agent to retrieve the drawing style for `edge' connecting `start_node' and `end_node'
			-- If Void, `default_edge_style' will be used as default.

	node_id_agent: detachable FUNCTION [ANY, TUPLE [node: N], INTEGER]
			-- Agent to retrieve an identifier of the DOT node givne `node'
			-- If Void, a default ID assignment scheme is used.

feature -- Status report

	is_ready: BOOLEAN
			-- Is Current ready to print?
		do
			Result := True
		end

feature -- Setting

	set_node_style_agent (a_agent: like node_style_agent)
			-- Set `node_style_agent' with `a_agent'.
		do
			node_style_agent := a_agent
			if a_agent = Void then
				actual_node_style := agent default_node_style
			else
				actual_node_style := a_agent
			end
		end

	set_edge_style_agent (a_agent: like edge_style_agent)
			-- Set `edge_style_agent' with `a_agent'.
		do
			edge_style_agent := a_agent
			if a_agent = Void then
				actual_edge_style := agent default_edge_style
			else
				actual_edge_style := a_agent
			end
		end

	set_node_label_agent (a_agent: like node_label_agent)
			-- Set `node_label_agent' with `a_agent'.
		do
			node_label_agent := a_agent
			if a_agent = Void then
				actual_node_label_agent := default_node_label
			else
				actual_node_label_agent := a_agent
			end
		end

	set_edge_label_agent (a_agent: like edge_label_agent)
			-- Set `edge_label_agent' with `a_agent'.
		do
			edge_label_agent := a_agent
			if a_agent = Void then
				actual_edge_label_agent := default_edge_label
			else
				actual_edge_label_agent := a_agent
			end
		end

	set_node_id_agent (a_agent: like node_id_agent)
			-- Set `node_id_agent' with `a_agent'.
		do
			node_id_agent := a_agent
		ensure
			node_id_agent_set: node_id_agent = a_agent
		end

	save_last_printing_to_file (a_path: STRING)
			-- Safe `last_printing' to file specified by `a_path'.
			-- Always try to create a new file for `a_path'.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_create_read_write (a_path)
			l_file.put_string (last_printing)
			l_file.close
		end

feature -- Print

	print_graph (a_graph: EGX_GENERAL_GRAPH [N, L]) is
			-- Print `a_graph' (to some output).
		local
			l_visitor: EGX_GRAPH_DFS_VISITOR [N, L]
			l_visitor_status: EGX_GRAPH_UNORDERED_VISITOR_NODE_STATUS [N, L]
			l_printing: like last_printing
		do
			create last_printing.make (4096)
			last_printing.append ("digraph G {%N")

			create node_ids.make (a_graph.node_count)
			node_ids.set_key_equality_tester (create {AGENT_BASED_EQUALITY_TESTER [N]}.make (a_graph.actual_node_equality_tester))

			node_index := 0
			create l_visitor.make
			create l_visitor_status
			l_visitor.set_visited_node_status (l_visitor_status)
			l_visitor.set_graph (a_graph)
			l_visitor.first_visit_node_actions.extend (agent first_visit_action)
			l_visitor.ignore_visited_node_actions.extend (agent ignore_visit_action)
			l_visitor.prepare_visit
			l_visitor.visit_all

			last_printing.append ("}%N")
		ensure then
			last_printing_attached: last_printing /= Void
		end

	print_and_save_graph (a_graph: EGX_GENERAL_GRAPH [N, L]; a_path: STRING)
			-- Print `a_graph' into `last_printing' and save `last_printing' into
			-- the file specified by `a_path'.
			-- Always try to create a new file for `a_path'.
		do
			print_graph (a_graph)
			save_last_printing_to_file (a_path)
		end

feature{NONE} -- Implementation/Visiting

	first_visit_action (a_start_node: N; a_end_node: N; a_edge: L; a_new_start: BOOLEAN) is
			-- Action to be performed when `a_end_node' is visited for the first time
		do
			if node_id_agent /= Void then
				node_ids.force_last (node_id_agent.item ([a_end_node]), a_end_node)
			else
				node_index := node_index + 1
				node_ids.force_last (node_index, a_end_node)
			end

				-- Draw `a_end_node'.
			draw_node (a_end_node)

				-- Draw edge connecting `a_start_node' and `a_end_node'.
			if not a_new_start then
				draw_edge (a_start_node, a_end_node, a_edge)
			end
		end

	ignore_visit_action (a_start_node: N; a_end_node: N; a_edge: L) is
			-- Action to be performed when `a_end_node' is visited for the first time
		do
			draw_edge (a_start_node, a_end_node, a_edge)
		end

feature{NONE} -- Implemenation/Drawing

	draw_node (a_node: N)
			-- Draw `a_node'.
		do
			last_printing.append_character ('%T')
			last_printing.append (actual_node_style.item ([a_node]))
			last_printing.append_character (';')
			last_printing.append_character ('%N')
		end

	draw_edge (a_start_node: N; a_end_node: N; a_edge: L)
			-- Draw edge with `a_edge' connecting `a_start_node' and `a_end_node'.
		do
			last_printing.append_character ('%T')
			last_printing.append (actual_edge_style.item ([a_start_node, a_end_node, a_edge]))
			last_printing.append_character (';')
			last_printing.append_character ('%N')
		end

feature{NONE} -- Implementation

	default_node_style (a_node: N): STRING
			-- Style of `a_node'
		local
			l_label: STRING
		do
			create Result.make (64)
			Result.append (node_id (a_node))
			Result.append (once " [shape=box")

				-- Add label of the node.
			Result.append (once ", label=%"")
			l_label := actual_node_label_agent.item ([a_node]).twin
			l_label.replace_substring_all (once "%N", once "\n")
			Result.append (l_label)
			Result.append_character ('%"')

			Result.append_character (']')
		end

	default_edge_style (a_start_node: N; a_end_node: N; a_edge: L): STRING
			-- Style of `a_edge'
		local
			l_edge: STRING
		do
			create Result.make (64)
			Result.append (node_id (a_start_node))
			Result.append (once " -> ")
			Result.append (node_id (a_end_node))

				-- Add label of the edge.
			Result.append (once " [label=%"")
			l_edge := actual_edge_label_agent.item ([a_start_node, a_end_node, a_edge])
			l_edge.replace_substring_all (once "%N", once "\n")
			Result.append (l_edge)
			Result.append_character ('%"')
			Result.append_character (']')
		end

	node_ids: DS_HASH_TABLE [INTEGER, N]
			-- Table of nodes with their IDs.
			-- Key is a node, value is the ID associated with that node

	node_id (a_node: N): STRING
			-- Node Id for `a_node'
		do
			create Result.make (5)
			Result.append_character ('n')
			check node_ids.has (a_node) end
			Result.append (node_ids.item (a_node).out)
		end

feature{NONE} -- Implementation

	actual_node_style: FUNCTION [ANY, TUPLE [node: N], STRING]
			-- Agent to decide drawing style of `node'

	actual_edge_style: FUNCTION [ANY, TUPLE [start_node: N; end_node: N; edge: L], STRING]
			-- Agent to decide drawing style of `edge'

	actual_node_label_agent: FUNCTION [ANY, TUPLE [node: N], STRING]
			-- Agent to decide drawing label of `node'

	actual_edge_label_agent: FUNCTION [ANY, TUPLE [start_node: N; end_node: N; edge: L], STRING]
			-- Agent to decide drawing label of `edge'

	node_index: INTEGER
			-- Recored node index during graph visiting

	default_node_label: like actual_node_label_agent
			-- Default `out' for `a_node'.
		do
			Result :=
				agent (n: N): STRING
					do
						if n = Void then
							Result := "Void"
						else
							Result := n.out
						end
					end

		end

	default_edge_label: like actual_edge_label_agent
			-- Default `out' for `a_obj'.
		do
			Result :=
				agent (sn: N; en: N; l: L): STRING
					do
						if l = Void then
							Result := ""
						else
							Result := l.out
						end
					end
		end

end
