note
	description: "Class to find post-states in terms of breakpoint slots."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_POST_STATE_FINDER

inherit
	EPA_UTILITY

	EPA_CFG_BLOCK_VISITOR

create
	default_create, make

feature -- Creation procedure

	make (a_class: like class_; a_feature: like feature_)
			-- Initialize `class_' with `a_class' and `feature_' with `a_feature'
		do
			set_class (a_class)
			set_feature (a_feature)
		end

feature -- Operation

	find
			-- Finds all post-states and makes them available in `post_state_map'
		local
			l_cfg_builder: EPA_CFG_BUILDER
			l_cfg_printer: EGX_SIMPLE_DOT_GRAPH_PRINTER [EPA_BASIC_BLOCK, EPA_CFG_EDGE]
		do
			-- Initialize helper attributes
			create post_state_map.make_default
			create stack.make
			create missing_post_states.make_default
			create visited_loop_branching_blocks.make_default
			maximal_breakpoint_slot := 1

			-- Create the control flow graph which is used to find all
			-- post-states
			create l_cfg_builder
			l_cfg_builder.set_is_bp_slot_init_activated (True)
			l_cfg_builder.set_is_auxilary_nodes_created (True)
			l_cfg_builder.build_from_feature (class_, feature_)
			cfg := l_cfg_builder.last_control_flow_graph

			create l_cfg_printer.make_default
			l_cfg_printer.print_and_save_graph (cfg, "/tmp/" + feature_.e_feature.name + ".dot")

			-- Look for all post-states
			cfg.start_node.process (Current)
			add_missing_post_states
		ensure
			post_state_map_not_void: post_state_map /= Void
		end

feature -- Setting

	set_class (a_class: like class_)
			-- Set `class_' with `a_class'
		require
			a_class_not_void: a_class /= Void
		do
			class_ := a_class
		ensure
			class_set: class_ = a_class
		end

	set_feature (a_feature: like feature_)
			-- Set `feature_' with `a_feature'
		require
			a_feature_not_void: a_feature /= Void
		do
			feature_ := a_feature
		ensure
			feature_set: feature_ = a_feature
		end

feature -- Access

	class_: CLASS_C assign set_class
			-- Class in which post-states should be found

	feature_: FEATURE_I assign set_feature
			-- Feature for which post-states should be found

	post_state_map: DS_HASH_TABLE [DS_HASH_SET [INTEGER], INTEGER]
			-- Contains the found post-states.
			-- Keys are pre-states and values are (possibly multiple) post-states

	cfg: EPA_CONTROL_FLOW_GRAPH
			-- Control flow graph which is used to find the post-states

feature -- Printing			

	print_post_state_map
			-- Prints the post-state map in the console
		do
			from
				post_state_map.start
			until
				post_state_map.after
			loop
				io.put_string (post_state_map.key_for_iteration.out + ": ")
				from
					post_state_map.item_for_iteration.start
				until
					post_state_map.item_for_iteration.after
				loop
					io.put_string (post_state_map.item_for_iteration.item_for_iteration.out)
					if not post_state_map.item_for_iteration.is_last then
						io.put_string (", ")
					end
					post_state_map.item_for_iteration.forth
				end
				if not post_state_map.is_last then
					io.put_string ("%N%N")
				end
				post_state_map.forth
			end
		end

	print_post_state_map_into_file (a_path: STRING)
			-- Prints the post-state map into the folder specified by `a_path'.
			-- The file name contains the class and feature name to which the post-state
			-- map belongs to.
		require
			a_path_not_void: a_path /= Void
		local
			l_text_file: PLAIN_TEXT_FILE
		do
			create l_text_file.make_create_read_write (a_path + class_.name + "." + feature_.feature_name + ".txt")
			from
				post_state_map.start
			until
				post_state_map.after
			loop
				l_text_file.put_string (post_state_map.key_for_iteration.out + ": ")
				from
					post_state_map.item_for_iteration.start
				until
					post_state_map.item_for_iteration.after
				loop
					l_text_file.put_string (post_state_map.item_for_iteration.item_for_iteration.out)
					if not post_state_map.item_for_iteration.is_last then
						l_text_file.put_string (", ")
					end
					post_state_map.item_for_iteration.forth
				end
				if not post_state_map.is_last then
					l_text_file.put_string ("%N%N")
				end
				post_state_map.forth
			end
		end

feature -- Roundtrip

	process_instruction_block (a_block: EPA_INSTRUCTION_BLOCK)
			-- Process `a_block'.
		local
			l_asts: ARRAYED_LIST [AST_EIFFEL]
			l_successors: DS_HASH_SET [EPA_BASIC_BLOCK]
			i, l_breakpoint_slot: INTEGER
		do
			l_asts := a_block.asts

			if not a_block.is_start_node then
				add_post_state (stack.item, l_asts.i_th (1).breakpoint_slot)
				adjust_maximal_breakpoint_slot (l_asts.i_th (1).breakpoint_slot)
			end

			from
				i := 1
			until
				i > l_asts.count - 1
			loop
				l_breakpoint_slot := l_asts.i_th (i).breakpoint_slot
				add_post_state (l_breakpoint_slot, l_breakpoint_slot + 1)
				adjust_maximal_breakpoint_slot (l_breakpoint_slot + 1)

				i := i + 1
			end

			stack.put (l_asts.i_th (l_asts.count).breakpoint_slot)

			if not a_block.is_end_node then
				l_successors := a_block.successors

				from
					l_successors.start
				until
					l_successors.after
				loop
					l_successors.item_for_iteration.process (Current)

					l_successors.forth
				end
			else
				missing_post_states.force_last (stack.item)
			end

			if not post_state_map.has (stack.item) then
				missing_post_states.force_last (stack.item)
			end

			stack.remove
		end

	process_auxilary_block (a_block: EPA_AUXILARY_BLOCK)
			-- Process `a_block'.
		local
			l_successors: DS_HASH_SET [EPA_BASIC_BLOCK]
		do
			if not a_block.is_end_node then
				l_successors := a_block.successors

				from
					l_successors.start
				until
					l_successors.after
				loop
					l_successors.item_for_iteration.process (Current)

					l_successors.forth
				end
			else
				missing_post_states.force_last (stack.item)
			end
		end

feature -- Roundtrip

	process_if_branching_block (a_block: EPA_IF_BRANCHING_BLOCK)
			-- Process `a_block'.
		local
			l_successors: DS_HASH_SET [EPA_BASIC_BLOCK]
		do
			if not a_block.is_start_node then
				add_post_state (stack.item, a_block.condition.breakpoint_slot)
				adjust_maximal_breakpoint_slot (a_block.condition.breakpoint_slot)
			end

			stack.put (a_block.condition.breakpoint_slot)

			if not a_block.is_end_node then

				l_successors := a_block.successors

				from
					l_successors.start
				until
					l_successors.after
				loop
					l_successors.item_for_iteration.process (Current)

					l_successors.forth
				end
			else
				missing_post_states.force_last (stack.item)
			end

			stack.remove
		end

	process_inspect_branching_block (a_block: EPA_INSPECT_BRANCHING_BLOCK)
			-- Process `a_block'.
		local
			l_successors: DS_HASH_SET [EPA_BASIC_BLOCK]
		do
			if
				not a_block.is_start_node and then
				stack.item /= a_block.switch.breakpoint_slot
			then
				add_post_state (stack.item, a_block.switch.breakpoint_slot)
				adjust_maximal_breakpoint_slot (a_block.switch.breakpoint_slot)
			end

			stack.put (a_block.switch.breakpoint_slot)

			if not a_block.is_end_node then
				l_successors := a_block.successors

				from
					l_successors.start
				until
					l_successors.after
				loop
					l_successors.item_for_iteration.process (Current)

					l_successors.forth
				end
			else
				missing_post_states.force_last (stack.item)
			end

			stack.remove
		end

	process_loop_branching_block (a_block: EPA_LOOP_BRANCHING_BLOCK)
			-- Process `a_block'.
		local
			l_successors: DS_HASH_SET [EPA_BASIC_BLOCK]
		do
			if
				(not a_block.is_start_node and then
				not is_start_node_auxilary_node) or
				visited_loop_branching_blocks.has (a_block.id)
			then
				add_post_state (stack.item, a_block.condition.breakpoint_slot)
				adjust_maximal_breakpoint_slot (a_block.condition.breakpoint_slot)
			end

			stack.put (a_block.condition.breakpoint_slot)

			if not visited_loop_branching_blocks.has (a_block.id) then
				visited_loop_branching_blocks.force_last (a_block.id)

				if not a_block.is_end_node then
					l_successors := a_block.successors

					from
						l_successors.start
					until
						l_successors.after
					loop
						l_successors.item_for_iteration.process (Current)

						l_successors.forth
					end
				else
					missing_post_states.force_last (stack.item)
				end
			end

			stack.remove
		end

feature {NONE} -- Implementation

	stack: DS_LINKED_STACK [INTEGER]
			-- A stack temporarily storing the pre-states whose post-states are not
			-- in the same block of the CFG.

	missing_post_states: DS_HASH_SET [INTEGER]
			-- A set storing the pre-states for which post-states could not be found
			-- because the end node of the current CFG is a auxilary node.

	maximal_breakpoint_slot: INTEGER
			-- The maximal breakpoint slot value which was processed so far.

	visited_loop_branching_blocks: DS_HASH_SET [INTEGER]
			-- A set containing the loop branching blocks which were already visited.

feature {NONE} -- Implementation

	is_start_node_auxilary_node: BOOLEAN
			-- Is the start node of `cfg' an auxilary node?
		do
			Result := cfg.start_node.is_auxilary
		end

feature {NONE} -- Implementation

	add_post_state (a_pre_state_slot: INTEGER; a_post_state_slot: INTEGER)
			-- Adds a new post-state for a given pre-state to the post-state map.
		local
			l_set: DS_HASH_SET [INTEGER]
		do
			if post_state_map.has (a_pre_state_slot) then
				l_set := post_state_map.item (a_pre_state_slot)
				l_set.force_last (a_post_state_slot)
			else
				create l_set.make_default
				l_set.force_last (a_post_state_slot)
				post_state_map.force_last (l_set, a_pre_state_slot)
			end
		end

	add_missing_post_states
			-- Adds the missing post-states to the post-state map.
		do
			maximal_breakpoint_slot := maximal_breakpoint_slot + 1

			from
				missing_post_states.start
			until
				missing_post_states.after
			loop
				add_post_state (missing_post_states.item_for_iteration, maximal_breakpoint_slot)

				missing_post_states.forth
			end
		end

	adjust_maximal_breakpoint_slot (i: INTEGER)
			-- Adjusts `maximal_breakpoint_slot' if `i' is greater than
			-- `maximal_breakpoint_slot'.
		do
			if i > maximal_breakpoint_slot then
				maximal_breakpoint_slot := i
			end
		end

end
