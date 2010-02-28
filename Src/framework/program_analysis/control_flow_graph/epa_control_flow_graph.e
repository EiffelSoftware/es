note
	description: "Summary description for {EPA_CONTROL_FLOW_GRAPH}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_CONTROL_FLOW_GRAPH

inherit
	EGX_GENERAL_GRAPH [EPA_BASIC_BLOCK, EPA_CFG_EDGE]
		rename
			make as graph_make
		end

	EPA_UTILITY

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
			graph_make (20)
			set_node_equality_tester (agent (a_node, b_node: EPA_BASIC_BLOCK): BOOLEAN do Result := a_node ~ b_node end)
		end

feature -- Access

	start_node: detachable EPA_BASIC_BLOCK
			-- Start node of Current CFG

	end_node: detachable EPA_BASIC_BLOCK
			-- End node of Current CFG

	node_text (a_node: EPA_BASIC_BLOCK): TUPLE [title: STRING; label: STRING]
			-- Text information for `a_node'
		local
			l_title: STRING
			l_label: STRING
			l_cursor: CURSOR
			l_asts: LIST [AST_EIFFEL]
			l_str: STRING
		do
			l_asts := a_node.asts
			l_cursor := l_asts.cursor
			create l_label.make (128)
			from
				l_asts.start
			until
				l_asts.after
			loop
				l_str := text_from_ast (l_asts.item_for_iteration)
				l_str.replace_substring_all ("%N", "\n")
				l_str.replace_substring_all ("%R", "")
				l_label.append (l_str)
				l_asts.forth
			end
			if not l_label.is_empty and then l_label.item (l_label.count) = '%N' then
				l_label.remove_tail (1)
			end
			l_title := a_node.id.out
			Result := [l_title, l_label]
		end

	edge_text (a_edge: EPA_CFG_EDGE): STRING
			-- Text information for `a_edge'.
		do
			if a_edge.is_true_branch then
				Result := "True"
			elseif a_edge.is_false_branch then
				Result := "False"
			else
				Result := ""
			end
		end

feature -- Setting

	set_start_node (a_node: like start_node)
			-- Set `start_node' with `a_node'.
		do
			start_node := a_node
		ensure
			start_node_set: start_node = a_node
		end

	set_end_node (a_node: like end_node)
			-- Set `end_node' with `a_node'.
		do
			end_node := a_node
		ensure
			end_node_set: end_node = a_node
		end

end
