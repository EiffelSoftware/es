note
	description: "Summary description for {EPA_CONTROL_DISTANCE_CALCULATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_CONTROL_DISTANCE_CALCULATOR

inherit
	EGX_GRAPH_DFS_VISITOR [EPA_BASIC_BLOCK, EPA_CFG_EDGE]
		rename
			make as make_visitor
		redefine
			graph,
			visited_node_status
		end

	DEBUG_OUTPUT

	EPA_UTILITY

create
	make

feature -- Initialization

	make
			-- Initialization.
		do
			make_visitor

			-- Use a more specific status class, so that we can start calculation from selected node(s).
			set_visited_node_status (create {EGX_GRAPH_UNORDERED_VISITOR_NODE_STATUS [EPA_BASIC_BLOCK, EPA_CFG_EDGE]})
		end

feature -- Basic operation

	calculate_within_feature (a_context_class: CLASS_C; a_context_feature: FEATURE_I; a_bp_index: INTEGER)
			-- Calculate the control distance from 'a_bp_index' to other breakpoint slots within `a_context_feature'.
			-- The results are available in `last_report'.
		require
			bp_index_valid: a_bp_index > 0
		local
			l_written_class: CLASS_C
			l_ast: AST_EIFFEL
			l_initializer: ETR_BP_SLOT_INITIALIZER
			l_builder: EPA_CFG_BUILDER
			l_graph: EPA_CONTROL_FLOW_GRAPH
			l_file_name: FILE_NAME
		do
			reset_calculator

			-- Cache command arguments.
			context_class := a_context_class
			context_feature := a_context_feature
			reference_bp_index := a_bp_index

			-- Construct feature ast as in 'context_class'.
			l_ast := a_context_feature.e_feature.ast
			l_written_class := context_feature.written_class
			l_ast := ast_in_context_class (l_ast, l_written_class, context_feature, context_class)

			-- Associate breakpoint indexes to ast nodes.
			create l_initializer
			l_initializer.init_with_context (l_ast, context_class)

			-- Process only if `a_context_feature' has a body.
			is_successful := False
			if attached {FEATURE_AS} l_ast as l_feature_as then
				if attached {BODY_AS} l_feature_as.body as l_body then
					if attached {ROUTINE_AS} l_body.content as l_routine then
						if attached {DO_AS} l_routine.routine_body as l_do then
							-- Build control flow graph for the feature body.
							create l_builder
							l_builder.set_is_single_instruction_block (True)
							l_builder.set_next_block_number (context_feature.first_breakpoint_slot_index)
							l_builder.build_from_compound (l_do.compound, context_class, context_feature)
							graph := l_builder.last_control_flow_graph.reversed_graph
--							use_breakpoint_index_as_node_id

debug ("auto_fix")
	-- Print the control flow graph.
	create l_file_name.make_temporary_name
	io.output.put_string ("Printing the control flow graph to:%N%T" + l_file_name + "%N")
	print_graph (l_builder.last_control_flow_graph, l_file_name)
	io.output.put_string ("Done.%N")

	-- Print the reversed control flow graph.
	create l_file_name.make_temporary_name
	io.output.put_string ("Printing the reverse of the control flow graph to:%N%T" + l_file_name + "%N")
	print_graph (graph, l_file_name)
	io.output.put_string ("Done.%N")
end

							if reference_node /= Void then
								-- Set depth_first traversal starting from the `reference_node'.
								visited_node_status.start_nodes.wipe_out
								visited_node_status.start_nodes.force (reference_node)

								-- Add necessary visitor node actions
								first_visit_node_actions.force (agent first_visit_node)
								ignore_visited_node_actions.force (agent visit_node)

								-- Visit the graph to calculate distances.
								visit_all

								is_successful := True
							else
								set_error_message ("Invalid reference breakpoint index.")
							end
						end
					end
				end
			end

			if not is_successful and then (error_message = Void or else error_message.is_empty) then
				set_error_message ("Feature does not have instructions in the body.")
			end
		end

feature -- Access

	last_report: DS_HASH_TABLE [INTEGER, EPA_BASIC_BLOCK]
			-- Report of the control distance values.
			-- Key: blocks from `current_graph'.
			-- Val: control distance from the Key-node to the `reference_node'.
		do
			if last_report_cache = Void then
				create last_report_cache.make (5)
				last_report_cache.set_key_equality_tester (Block_equality_tester)
			end

			Result := last_report_cache
		end

	last_report_concerning_bp_indexes: DS_HASH_TABLE [INTEGER, INTEGER]
			-- An interpretation of `last_report', based only on breakpoint index information.
			-- Key: breakpoint indexes
			-- Val: control distance from the key-bp_index to the reference bp_index.
		do
			if last_report_concerning_bp_indexes_cache = Void then
				create last_report_concerning_bp_indexes_cache.make_equal (last_report.count)
			end
			if last_report_concerning_bp_indexes_cache.count /= last_report.count then
				last_report_concerning_bp_indexes_cache.wipe_out
				last_report.do_all_with_key (
						agent (a_table: DS_HASH_TABLE [INTEGER, INTEGER]; a_dis: INTEGER; a_blk: EPA_BASIC_BLOCK)
							do
								a_table.force (a_dis, a_blk.asts.first.breakpoint_slot)
							end (last_report_concerning_bp_indexes_cache, ?, ?))
			end
			Result := last_report_concerning_bp_indexes_cache
		ensure
			result_has_same_size_as_last_report:
				Result /= Void and then Result.count = last_report.count
		end

	is_successful: BOOLEAN
			-- Is last calculation successful?

	error_message: STRING
			-- Description of the FIRST error after last `reset_error_message'.
		do
			if error_message_cache = Void then
				error_message_cache := ""
			end
			Result := error_message_cache
		end

feature -- Access {EGX_GRAPH_WFS_VISITOR}

	visited_node_status: EGX_GRAPH_UNORDERED_VISITOR_NODE_STATUS [EPA_BASIC_BLOCK, EPA_CFG_EDGE]
			-- <Precursor>

	graph: EPA_CONTROL_FLOW_GRAPH
			-- Graph to visit.

feature -- Debugging

	debug_output: STRING
			-- <Precursor>
		local
			l_report: like last_report
			l_distance: INTEGER
			l_block: EPA_BASIC_BLOCK
			l_line: STRING
		do
			l_report := last_report
			if l_report.is_empty then
				Result := "<<Empty report>>"
			else
				Result := ""
				from l_report.start
				until l_report.after
				loop
					l_block := l_report.key_for_iteration
					l_distance := l_report.item_for_iteration

					l_line := l_distance.out
					l_line.append_string (": ")
					l_line.append_string (l_block.debug_output)
					l_line := string_without_extra_blanks (l_line)

					Result.append (l_line)
					Result.append ("%N")

					l_report.forth
				end
			end
		end

	print_graph (a_graph: like graph; a_file_name: FILE_NAME)
			-- Save `a_graph' into a file with the name `a_file_name', in GDL format.
		local
			l_printer: EGX_SIMPLE_GDL_GRAPH_PRINTER [EPA_BASIC_BLOCK, EPA_CFG_EDGE]
			l_node_text_action: FUNCTION [ANY, TUPLE [a_node: EPA_BASIC_BLOCK], TUPLE [a_title: STRING; a_label: STRING]]
			l_edge_text_action: FUNCTION [ANY, TUPLE [a_edge: EPA_CFG_EDGE], STRING]
			l_graph_string: STRING
			l_file: PLAIN_TEXT_FILE
		do
			-- Prepare graph printer
			l_node_text_action := agent (a_node: EPA_BASIC_BLOCK): TUPLE [title: STRING; label: STRING]
					local
						l_title, l_label: STRING
					do
						l_title := a_node.block_number.out
						-- Based on the fact that there is only one ast in each basic block,
						--		and that there is no auxiliary blocks, in `graph'.
						l_label := text_from_ast (a_node.asts.first)
						Result := [l_title, l_label]
					end
			l_edge_text_action := agent (a_edge: EPA_CFG_EDGE): STRING do Result := "" end
			create l_printer.make (l_node_text_action, l_edge_text_action)

			-- Print control flow graph to file.
			l_printer.print_graph (a_graph)
			l_graph_string := l_printer.last_printing

			-- Save to file.
			create l_file.make_create_read_write (a_file_name)
			l_file.put_string (l_graph_string)
			l_file.close
		end

feature{NONE} -- Agents for visitor

	first_visit_node (a_start: EPA_BASIC_BLOCK; a_end: EPA_BASIC_BLOCK; a_edge: EPA_CFG_EDGE; a_is_new: BOOLEAN)
			-- Visit the node 'a_end' for the first time, by following the edge 'a_edge' from 'a_start'.
			-- 'a_is_new' indicates whether this is the start of a subtree in the graph.
			-- Refer to {EGX_GRAPH_VISITOR}.`first_visit_node_actions'.
		do
			visit_node (a_start, a_end, a_edge)
		end

	visit_node (a_start: EPA_BASIC_BLOCK; a_end: EPA_BASIC_BLOCK; a_edge: EPA_CFG_EDGE)
			-- Visit the node 'a_end', by following the edge 'a_edge' from 'a_start'.
		local
			l_report: like last_report
			l_old_distance, l_new_distance: INTEGER
		do
			l_report := last_report

			if a_end ~ reference_node then
				l_report.force (0, a_end)
			elseif a_edge = Void then
				-- 'a_end' starts a new tree, i.e. it is not reachable from `reference_node'.
				-- Use a large enough value for distance.
				l_report.force (Infinite_distance, a_end)
			else
				-- Reaching an intermediate node.
				check a_start /= Void end
				if l_report.has (a_start) then
					l_new_distance := l_report.item (a_start) + 1

					if l_report.has (a_end) then
						-- Update the minimum distance if a shorter distance has been found.
						if l_report.item (a_end) > l_new_distance then
							l_report.replace (l_new_distance, a_end)
						end
					else
						-- Record the first distance for 'a_end'.
						l_report.force (l_new_distance, a_end)
					end

				end
			end
		end

feature -- Constant access

	Block_equality_tester: AGENT_BASED_EQUALITY_TESTER [EPA_BASIC_BLOCK]
			-- Equality tester for {EPA_BASIC_BLOCK} objects.
		once
			create Result.make (
					agent (a_node1, a_node2: EPA_BASIC_BLOCK): BOOLEAN
						do
							Result := (a_node1 = Void and a_node2 = Void)
									or else ((a_node1 /= Void and a_node2 /= Void) and then a_node1 ~ a_node2)
						end)
		end

	Infinite_distance: INTEGER = 1_000_000
			-- Infinite distance for unreachable nodes.

feature{NONE} -- Auxiliary access

	context_class: CLASS_C
			-- Context class.

	context_feature: FEATURE_I
			-- Context feature.

	reference_bp_index: INTEGER
			-- Reference breakpoint index.
			-- Distances from other locations to this one are calculated.

	reference_node: EPA_BASIC_BLOCK
			-- CFG node, distances to which are to be calculated.
		require
			reference_bp_index_valid: reference_bp_index > 0
		do
			if reference_node_cache = Void then
				reference_node_cache := reference_node_at_bp_index (reference_bp_index)
			end
			Result := reference_node_cache
		end

feature{NONE} -- Cache

	last_report_cache: like last_report
			-- Cache for `last_report'.

	last_report_concerning_bp_indexes_cache: like last_report_concerning_bp_indexes
			-- Cache for `last_report_concerning_bp_indexes'.

	error_message_cache: like error_message
			-- Cache for `error_message'.

	reference_node_cache: like reference_node
			-- Cache for `reference_node'.

feature {NONE} -- Status set

	set_error_message (a_msg: STRING)
			-- Set error message, if it is not set yet.
			-- Use `reset_error_message' to clear the message.
		do
			if error_message.is_empty then
				error_message_cache := a_msg.twin
			end
		end

	reset_error_message
			-- Reset error message, i.e. clear the message.
		do
			error_message_cache := ""
		end

feature{NONE} -- Auxiliary routine

	reset_calculator
			-- Reset calculator from last calculation.
		do
			-- Setup the report.
			last_report.wipe_out
			last_report_concerning_bp_indexes.wipe_out
			graph := Void

			-- Wipe out existing visitor node actions
			first_visit_node_actions.wipe_out
			last_visit_node_actions.wipe_out
			ignore_visited_node_actions.wipe_out

			is_successful := True
			reset_error_message
			reference_node_cache := Void
			reference_bp_index := 0
		end

	use_breakpoint_index_as_node_id
			-- Use breakpoint indexes of basic blocks as their ids.
		require
			graph_attached: graph /= Void
		local
			l_found: BOOLEAN
			l_nodes: DS_HASH_TABLE [EGX_GENERAL_GRAPH_NODE [EPA_BASIC_BLOCK, EPA_CFG_EDGE], EPA_BASIC_BLOCK]
			l_cursor: DS_HASH_TABLE_CURSOR [EGX_GENERAL_GRAPH_NODE [EPA_BASIC_BLOCK, EPA_CFG_EDGE], EPA_BASIC_BLOCK]
			l_node: EGX_GENERAL_GRAPH_NODE [EPA_BASIC_BLOCK, EPA_CFG_EDGE]
			l_block: EPA_BASIC_BLOCK
		do
			l_nodes := graph.nodes

			l_cursor := l_nodes.new_cursor
			from
				l_nodes.start
			until
				l_nodes.after
			loop
				l_node := l_nodes.item_for_iteration
				l_block := l_node.data
				check l_block.asts /= Void and then l_block.asts.count = 1 end
				l_block.set_id (l_block.asts.first.breakpoint_slot)

				l_nodes.forth
			end
			l_nodes.go_to (l_cursor)
		end

	reference_node_at_bp_index (a_index: INTEGER): EPA_BASIC_BLOCK
			-- Node from `graph' with breakpoint index `a_index'.
		require
			graph_attached: graph /= Void
		local
			l_found: BOOLEAN
			l_nodes: DS_HASH_TABLE [EGX_GENERAL_GRAPH_NODE [EPA_BASIC_BLOCK, EPA_CFG_EDGE], EPA_BASIC_BLOCK]
			l_cursor: DS_HASH_TABLE_CURSOR [EGX_GENERAL_GRAPH_NODE [EPA_BASIC_BLOCK, EPA_CFG_EDGE], EPA_BASIC_BLOCK]
			l_node: EGX_GENERAL_GRAPH_NODE [EPA_BASIC_BLOCK, EPA_CFG_EDGE]
			l_block: EPA_BASIC_BLOCK
		do
			l_nodes := graph.nodes

			l_cursor := l_nodes.new_cursor
			from
				l_nodes.start
			until
				l_found or else l_nodes.after
			loop
				l_node := l_nodes.item_for_iteration
				l_block := l_node.data
				if l_block.asts /= Void and then l_block.asts.count = 1 and then l_block.asts.first.breakpoint_slot = a_index then
					l_found := True
					Result := l_block
				end
				l_nodes.forth
			end
			l_nodes.go_to (l_cursor)
		end

	string_without_extra_blanks (a_string: STRING): STRING
			-- The string with extra blanks, e.g. consecutive spaces, removed.
		local
			l_index: INTEGER
			l_after_blank: BOOLEAN
			l_char: CHARACTER
		do
			-- Replace "%T", "%N", and "%R" with ' '.
			Result := a_string.twin
			Result.replace_substring_all ("%N", " ")
			Result.replace_substring_all ("%T", " ")
			Result.replace_substring_all ("%R", " ")

			-- Remove consecutive spaces.
			from
				l_index := 1
				l_after_blank := True 	-- Preceding spaces should be removed.
			until
				l_index > Result.count
			loop
				l_char := Result [l_index]
				if l_after_blank and then l_char = ' ' then
					Result.remove (l_index)
				elseif l_after_blank and then l_char /= ' ' then
					l_index := l_index + 1
					l_after_blank := False
				elseif not l_after_blank and then l_char = ' ' then
					l_index := l_index + 1
					l_after_blank := True
				elseif not l_after_blank and then l_char /= ' ' then
					l_index := l_index + 1
				else
					check should_not_happen: False end
				end
			end
			Result.prune_all_trailing (' ')

		end


end
