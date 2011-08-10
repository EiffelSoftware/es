note
	description: "Class to extract fragments from a snippet"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_FRAGMENT_EXTRACTOR

inherit
	AST_ITERATOR
		redefine
			process_access_feat_as,
			process_create_as,
			process_if_as,
			process_loop_as,
			process_id_as,
			process_elseif_as,
			process_create_creation_as
		end

	EPA_FEATURE_CALL_COLLECTOR_UTILITY

feature -- Access

	last_fragments: LINKED_LIST [EXT_FRAGMENT]
			-- Fragments from last `extract'
			-- Results are ascendingly sorted by fragment position.

feature -- Basic operations

	extract (a_snippet: EXT_SNIPPET)
			-- Extract fragments from `a_snippet' and make
			-- results available in `last_fragments'.
		do
			create last_fragments.make
			snippet := a_snippet
			create fragments_internal.make (20)
			create bp_to_block_table.make (50)
			create calls.make (10)
			build_cfg
			visit_cfg
			collect_calls
			generate_fragments
		end

feature{NONE} -- Implementation

	snippet: EXT_SNIPPET
			-- Snippet to be processed

	cfg: EPA_CONTROL_FLOW_GRAPH
			-- Control flow graph of `snippet'

	position: INTEGER
			-- Fragment position

	block_id: INTEGER
			-- Basic block id

	bp_to_block_table: HASH_TABLE [INTEGER, INTEGER]
			-- Table from breakpoint slot id to basic block id
			-- Keys are breakpoint slot ids and values are
			-- basic block ids to which those breakpoints belong

	calls: HASH_TABLE [LINKED_LIST [CALL_AS], INTEGER]
			-- Feature calls that appear in `snippet'
			-- Keys are breakpoint slots, values are feature
			-- calls appearing at those breakpoint slots.

	fragments_internal: DS_ARRAYED_LIST [EXT_FRAGMENT]
			-- Fragments from last `extract'

	build_cfg
			-- Build `cfg' for `snippet'.
		local
			l_builder: EPA_CFG_BUILDER
		do
			create l_builder
			l_builder.set_next_block_number (1)
			l_builder.set_is_auxilary_nodes_created (True)
			l_builder.set_is_single_instruction_block (False)
			l_builder.build_from_compound (snippet.ast, Void, Void)
			cfg := l_builder.last_control_flow_graph
		end

	visit_cfg
			-- Visit `cfg' and collect data
			-- during visiting.
		local
			l_visitor: EGX_GRAPH_DFS_VISITOR [EPA_BASIC_BLOCK, EPA_CFG_EDGE]
			l_status: EGX_GRAPH_UNORDERED_VISITOR_NODE_STATUS [EPA_BASIC_BLOCK, EPA_CFG_EDGE]
		do
			create l_status
			create l_visitor.make
			l_visitor.set_visited_node_status (l_status)
			l_visitor.set_graph (cfg)
			l_visitor.first_visit_node_actions.extend (agent first_visit_node_action (?, ?, ?, ?))
			l_visitor.prepare_visit
			l_visitor.visit_all
		end

	set_position (i: INTEGER)
			-- Set `position' with `i'.
		do
			position := i
		end

	set_block_id (i: INTEGER)
			-- Set `block_id' with `i'.
		do
			block_id := i
		end

	first_visit_node_action (a_start_node: EPA_BASIC_BLOCK; a_end_node: EPA_BASIC_BLOCK; a_edge: EPA_CFG_EDGE; a_new_start: BOOLEAN)
		do
			if a_end_node.asts /= Void and then not a_end_node.asts.is_empty then
				across a_end_node.asts as l_ast loop
					bp_to_block_table.force (a_end_node.block_number, l_ast.item.breakpoint_slot)
				end
			end
		end

	collect_calls
			-- Collect feature calls from `snippet' and
			-- store results in `calls'.
		local
			l_collector: EXT_SNIPPET_FEATURE_CALL_COLLECTOR
		do
			create l_collector
			l_collector.collect (snippet)
			calls := l_collector.last_calls
		end

	generate_fragments
			-- Generate fragments from `snippets'.
		local
			l_sorter: DS_QUICK_SORTER [EXT_FRAGMENT]
			l_cursor: DS_ARRAYED_LIST_CURSOR [EXT_FRAGMENT]
		do
			create processed_bp_slots.make (20)
			set_position (0)
			set_block_id (0)
			fragments_internal.force_last (create {EXT_FRAGMENT}.make_as_start (position, block_id))

			safe_process (snippet.ast)

			set_position (position + 1)
			set_block_id (block_id + 1)
			fragments_internal.force_last (create {EXT_FRAGMENT}.make_as_end (position, block_id))

			create l_sorter.make (
				create {AGENT_BASED_EQUALITY_TESTER [EXT_FRAGMENT]}.make (
					agent (a, b: EXT_FRAGMENT): BOOLEAN
						do
							Result := a.position < b.position
						end))

			l_sorter.sort (fragments_internal)
			from
				l_cursor := fragments_internal.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				last_fragments.extend (l_cursor.item)
				l_cursor.forth
			end

			across last_fragments as l_frags loop
				l_frags.item.set_fragment_count (last_fragments.count)
				l_frags.item.set_basic_block_count (block_id)
			end
		end

	processed_bp_slots: DS_HASH_SET [INTEGER]
			-- Set of breakpoints that have been processed

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			if not processed_bp_slots.has (l_as.breakpoint_slot) then
				process_ast (l_as)
				processed_bp_slots.force_last (l_as.breakpoint_slot)
			end
		end

	process_ast (a_ast: AST_EIFFEL)
			-- Process `a_ast'.
		local
			l_bp: INTEGER
			l_sig: like signature_of_call
			l_frag: EXT_FRAGMENT
			l_block_id: INTEGER
		do
			l_bp := a_ast.breakpoint_slot
			if not processed_bp_slots.has (l_bp) then
				calls.search (l_bp)
				if calls.found then
					set_position (position + 1)
					across calls.found_item as l_feat_calls loop
						l_sig := signature_of_call (l_feat_calls.item)
						l_block_id := bp_to_block_table.item (l_bp)
						create l_frag.make (position, l_block_id, create {EXT_FEATURE_TOKEN}.make (l_sig.feature_name))
						fragments_internal.force_last (l_frag)
					end
				end
				if l_block_id > block_id then
					set_block_id (l_block_id)
				end
				processed_bp_slots.force_last (l_bp)
			end
		end

	process_create_creation_as (l_as: CREATE_CREATION_AS)
			-- Process `l_as'.
		do
			process_ast (l_as)
		end

	process_create_as (l_as: CREATE_AS)
		do
			process_ast (l_as)
			safe_process (l_as.clients)
			safe_process (l_as.feature_list)
		end

	process_if_as (l_as: IF_AS)
		do
			process_keyword (ti_if_keyword, l_as)

			process_ast (l_as.condition)
			l_as.condition.process (Current)
			process_keyword (ti_then_keyword, l_as.condition)
			safe_process (l_as.compound)
			safe_process (l_as.elsif_list)
			if l_as.else_part /= Void then
				process_keyword (ti_else_keyword, l_as.else_part)
			end
			safe_process (l_as.else_part)
		end

	process_keyword (a_keyword: STRING; a_ast: AST_EIFFEL)
			--
		local
			l_frag: EXT_FRAGMENT
			l_block: INTEGER
		do
			set_position (position + 1)
			if a_ast /= Void then
				l_block := bp_to_block_table.item (a_ast.breakpoint_slot)
				if l_block = 0 then
					l_block := block_id
				end
				create l_frag.make (position, l_block, create {EXT_KEYWORD_TOKEN}.make (a_keyword))
			else
				create l_frag.make (position, block_id, create {EXT_KEYWORD_TOKEN}.make (a_keyword))
			end
			fragments_internal.force_last (l_frag)
		end

	process_elseif_as (l_as: ELSIF_AS)
		do
			process_keyword (ti_elseif_keyword, l_as)
			l_as.expr.process (Current)
			process_keyword (ti_then_keyword, l_as.expr)
			safe_process (l_as.compound)
		end

	process_loop_as (l_as: LOOP_AS)
		local
			l_frag: EXT_FRAGMENT
		do
			safe_process (l_as.iteration)
			process_keyword (ti_from_keyword, l_as.from_part)
			safe_process (l_as.from_part)
			safe_process (l_as.invariant_part)
			if l_as.stop /= Void then
				process_keyword (ti_until_keyword, l_as.stop)
			end
			safe_process (l_as.stop)
			process_keyword (ti_loop_keyword, l_as.compound)
			safe_process (l_as.compound)
			safe_process (l_as.variant_part)
		end

	process_id_as (l_as: ID_AS)
		do
			process_ast (l_as)
		end

end
