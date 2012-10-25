note
	description: "Post-state breakpoint finder which finds post-state breakpoints for every%
		%possible pre-state breakpoint of a given feature."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_POST_STATE_BREAKPOINT_FINDER

inherit
	EPA_UTILITY
		export
			{NONE} all
		end

	EPA_CFG_BLOCK_VISITOR
		export
			{NONE} all
		end

create
	default_create, make

feature {NONE} -- Initialization

	make (a_class: like class_; a_feature: like feature_)
			-- Initialize post-state breakpoint finder.
		require
			a_class_not_void: a_class /= Void
			a_feature_not_void: a_feature /= Void
		do
			set_class (a_class)
			set_feature (a_feature)
		ensure
			class_set: class_ = a_class
			feature_set: feature_ = a_feature
		end

feature -- Access

	class_: CLASS_C
			-- Context class of `feature_'.

	feature_: FEATURE_I
			-- Feature for which post-state breakpoints should be
			-- found for every pre-state breakpoint.

	last_post_state_breakpoints: DS_HASH_TABLE [DS_HASH_SET [INTEGER], INTEGER]
			-- Post-state breakpoints for every pre-state breakpoint of `feature_'.
			-- Keys are pre-state breakpoints.
			-- Values are (possibly multiple) post-state breakpoints.

feature -- Basic operations

	find
			-- Find all post-state breakpoints of `feature_' and make them available in
			-- `last_post_state_breakpoints'.
		do
			-- Initialize data structures for finding.
			create last_post_state_breakpoints.make_default
			create final_pre_state_breakpoints_of_previous_blocks.make
			create unresolved_pre_state_breakpoints.make_default
			create visited_loop_branching_blocks.make_default
			maximal_pre_state_breakpoint := 1

			-- Find post-state breakpoints in the feature body of `feature_'.
			find_for_feature_body

			-- Find post-state breakpoints in the contracts of `feature_'.
			find_for_contracts
		ensure
			last_post_state_breakpoints_not_void: last_post_state_breakpoints /= Void
		end

feature -- Setting

	set_class (a_class: like class_)
			-- Set `class_' to `a_class'.
		require
			a_class_not_void: a_class /= Void
		do
			class_ := a_class
		ensure
			class_set: class_ = a_class
		end

	set_feature (a_feature: like feature_)
			-- Set `feature_' to `a_feature'.
		require
			a_feature_not_void: a_feature /= Void
		do
			feature_ := a_feature
		ensure
			feature_set: feature_ = a_feature
		end

feature {EPA_BASIC_BLOCK} -- Roundtrip

	process_instruction_block (a_block: EPA_INSTRUCTION_BLOCK)
			-- Process `a_block'.
		local
			l_asts: ARRAYED_LIST [AST_EIFFEL]
			l_successor_blocks: DS_HASH_SET [EPA_BASIC_BLOCK]
			i, l_number_of_asts, l_pre_state_breakpoint, l_post_state_breakpoint: INTEGER
		do

			l_asts := a_block.asts

			-- Add the post-state breakpoint for the last pre-state breakpoint of the preceding
			-- block if current instruction block is not the start block of `control_flow_graph'.
			if
				not a_block.is_start_node
			then
				extend_post_state_breakpoints (
					final_pre_state_breakpoints_of_previous_blocks.item,
					l_asts.i_th (1).breakpoint_slot)
				adjust_maximal_pre_state_breakpoint (l_asts.i_th (1).breakpoint_slot)
			end

			-- Add post-state breakpoints for pre-state breakpoints in current instruction block.
			-- Handle the last pre-state breakpoint in current instruction block seperately.
			l_number_of_asts := l_asts.count - 1

			from
				i := 1
			until
				i > l_number_of_asts
			loop
				l_pre_state_breakpoint := l_asts.i_th (i).breakpoint_slot
				l_post_state_breakpoint := l_pre_state_breakpoint + 1
				extend_post_state_breakpoints (l_pre_state_breakpoint, l_post_state_breakpoint)
				adjust_maximal_pre_state_breakpoint (l_post_state_breakpoint)

				i := i + 1
			end

			-- Store the last pre-state breakpoint of current instruction block so that its
			-- post-state breakpoint can be searched in successor blocks of the current instruction
			-- block.
			final_pre_state_breakpoints_of_previous_blocks.put (l_asts.last.breakpoint_slot)

			-- Find post-state breakpoints in successor blocks of the current instruction block if
			-- there are any.
			if
				not a_block.is_end_node
			then
				-- Iterate over successor blocks of the current instruction block to find post-state
				-- breakpoints.
				l_successor_blocks := a_block.successors

				from
					l_successor_blocks.start
				until
					l_successor_blocks.after
				loop
					l_successor_blocks.item_for_iteration.process (Current)

					l_successor_blocks.forth
				end
			else
				-- Add last pre-state breakpoint of current instruction block to set of unresolved
				-- pre-state breakpoints since there are no successor blocks of the current
				-- instruction block.
				unresolved_pre_state_breakpoints.force_last (
					final_pre_state_breakpoints_of_previous_blocks.item
				)
			end

			-- Check if a post-state breakpoint exists for the last pre-state breakpoint of current
			-- instruction block. If not add last pre-state breakpoint of current instruction block
			-- to set of unresolved pre-state breakpoints.
			if
				not last_post_state_breakpoints.has (final_pre_state_breakpoints_of_previous_blocks.item)
			then
				unresolved_pre_state_breakpoints.force_last (
					final_pre_state_breakpoints_of_previous_blocks.item
				)
			end

			-- Remove the last pre-state breakpoint of current instruction block from
			-- `final_pre_state_breakpoints_of_previous_blocks'.
			final_pre_state_breakpoints_of_previous_blocks.remove
		end

	process_auxilary_block (a_block: EPA_AUXILARY_BLOCK)
			-- Process `a_block'.
		local
			l_successor_blocks: DS_HASH_SET [EPA_BASIC_BLOCK]
		do
			-- Find post-state breakpoints in successor blocks of the current auxiliary block
			-- if there are any.
			if
				not a_block.is_end_node
			then
				-- Iterate over successor blocks of the current auxiliary block to find post-state
				-- breakpoints.
				l_successor_blocks := a_block.successors

				from
					l_successor_blocks.start
				until
					l_successor_blocks.after
				loop
					l_successor_blocks.item_for_iteration.process (Current)

					l_successor_blocks.forth
				end
			else
				-- Add last pre-state breakpoint of previous block to set of missing post-state
				-- breakpoints since there are no successor blocks of the current auxiliary block.
				unresolved_pre_state_breakpoints.force_last (
					final_pre_state_breakpoints_of_previous_blocks.item
				)
			end
		end

feature {EPA_BASIC_BLOCK} -- Roundtrip

	process_if_branching_block (a_block: EPA_IF_BRANCHING_BLOCK)
			-- Process `a_block'.
		local
			l_successor_blocks: DS_HASH_SET [EPA_BASIC_BLOCK]
			l_condition_breakpoint: INTEGER
		do
			l_condition_breakpoint := a_block.condition.breakpoint_slot

			-- Add the post-state breakpoint for the last pre-state breakpoint of the preceding
			-- block in `control_flow_graph' if current if branching block is not the start block
			-- of `control_flow_graph'.
			if
				not a_block.is_start_node
			then
				extend_post_state_breakpoints (
					final_pre_state_breakpoints_of_previous_blocks.item,
					l_condition_breakpoint
				)
				adjust_maximal_pre_state_breakpoint (l_condition_breakpoint)
			end

			-- Store the last pre-state breakpoint of current if branching block so that its
			-- post-state breakpoint can be searched in successor blocks of the current if
			-- branching block.
			final_pre_state_breakpoints_of_previous_blocks.put (l_condition_breakpoint)

			-- Find post-state breakpoints in successor blocks of the current if branching block if
			-- there are any.
			if
				not a_block.is_end_node
			then
				-- Iterate over successor blocks of the current if branching block to find
				-- post-state breakpoints.
				l_successor_blocks := a_block.successors

				from
					l_successor_blocks.start
				until
					l_successor_blocks.after
				loop
					l_successor_blocks.item_for_iteration.process (Current)

					l_successor_blocks.forth
				end
			else
				-- Add last pre-state breakpoint of current if branching block to set of unresolved
				-- post-state breakpoints since there are no successor blocks of the current if
				-- branching block.
				unresolved_pre_state_breakpoints.force_last (
					final_pre_state_breakpoints_of_previous_blocks.item
				)
			end

			-- Remove the last pre-state breakpoint of current if branching block from
			-- `final_pre_state_breakpoints_of_previous_blocks'.
			final_pre_state_breakpoints_of_previous_blocks.remove
		end

	process_inspect_branching_block (a_block: EPA_INSPECT_BRANCHING_BLOCK)
			-- Process `a_block'.
		local
			l_successor_blocks: DS_HASH_SET [EPA_BASIC_BLOCK]
			l_switch_breakpoint: INTEGER
		do
			l_switch_breakpoint := a_block.switch.breakpoint_slot

			-- Add the post-state breakpoint for the last pre-state breakpoint of the preceding
			-- block if current inspect branching block is not the start
			-- block of `control_flow_graph' and if the last pre-state breakpoint is not the
			-- switch breakpoint of the current inspect branching block.
			if
				not a_block.is_start_node and then
				final_pre_state_breakpoints_of_previous_blocks.item /= l_switch_breakpoint
			then
				extend_post_state_breakpoints (
					final_pre_state_breakpoints_of_previous_blocks.item,
					l_switch_breakpoint
				)
				adjust_maximal_pre_state_breakpoint (l_switch_breakpoint)
			end

			-- Store the last pre-state breakpoint of current inspect branching block so that
			-- its post-state breakpoint can be searched in successor blocks of the current
			-- inspect branching block.
			final_pre_state_breakpoints_of_previous_blocks.put (l_switch_breakpoint)

			-- Find post-state breakpoints in successor blocks of the current inspect branching block
			-- if there are any.
			if
				not a_block.is_end_node
			then
				-- Iterate over successor blocks of the current inspect branching block to find post-state
				-- breakpoints.
				l_successor_blocks := a_block.successors

				from
					l_successor_blocks.start
				until
					l_successor_blocks.after
				loop
					l_successor_blocks.item_for_iteration.process (Current)

					l_successor_blocks.forth
				end
			else
				-- Add last pre-state breakpoint of current inspect branching block to set of
				-- unresolved post-state breakpoints since there are no successor blocks of the
				-- current inspect branching block.
				unresolved_pre_state_breakpoints.force_last (
					final_pre_state_breakpoints_of_previous_blocks.item
				)
			end

			-- Remove the last pre-state breakpoint of current inspect branching block from
			-- `final_pre_state_breakpoints_of_previous_blocks'.
			final_pre_state_breakpoints_of_previous_blocks.remove
		end

	process_loop_branching_block (a_block: EPA_LOOP_BRANCHING_BLOCK)
			-- Process `a_block'.
		local
			l_successor_blocks: DS_HASH_SET [EPA_BASIC_BLOCK]
			l_condition_breakpoint, l_block_id: INTEGER
		do
			l_condition_breakpoint := a_block.condition.breakpoint_slot
			l_block_id := a_block.id

			-- Add the post-state breakpoint for the last pre-state breakpoint of the preceding
			-- block if current loop branching block is not the start
			-- block of `control_flow_graph' and if the start block is not an auxiliary block
			-- or if the current loop branching block was not already visited.
			if
				(not a_block.is_start_node and then
				not control_flow_graph.start_node.is_auxilary) or else
				visited_loop_branching_blocks.has (l_block_id)
			then
				extend_post_state_breakpoints (
					final_pre_state_breakpoints_of_previous_blocks.item,
					l_condition_breakpoint
				)
				adjust_maximal_pre_state_breakpoint (l_condition_breakpoint)
			end

			-- Store the last pre-state breakpoint of current loop branching block so that
			-- its post-state breakpoint can be searched in successor blocks of the current
			-- loop branching block.
			final_pre_state_breakpoints_of_previous_blocks.put (l_condition_breakpoint)

			-- Visit successors of current loop branching block if the current loop branching block
			-- was not already visited.
			if
				not visited_loop_branching_blocks.has (l_block_id)
			then
				visited_loop_branching_blocks.force_last (l_block_id)

				-- Find post-state breakpoints in successor blocks of the current loop branching
				-- block if there are any.
				if
					not a_block.is_end_node
				then
					l_successor_blocks := a_block.successors

					from
						l_successor_blocks.start
					until
						l_successor_blocks.after
					loop
						l_successor_blocks.item_for_iteration.process (Current)

						l_successor_blocks.forth
					end
				else
					-- Add last pre-state breakpoint of current loop branching block to set of
					-- unresolved post-state breakpoints since there are no successor blocks of the
					-- current loop branching block.
					unresolved_pre_state_breakpoints.force_last (
						final_pre_state_breakpoints_of_previous_blocks.item
					)
				end
			end

			-- Remove the last pre-state breakpoint of current loop branching block from
			-- `final_pre_state_breakpoints_of_previous_blocks'.
			final_pre_state_breakpoints_of_previous_blocks.remove
		end

feature {NONE} -- Implementation

	control_flow_graph: EPA_CONTROL_FLOW_GRAPH
			-- Control flow graph of `feature_' which is used to find post-state breakpoints.

	final_pre_state_breakpoints_of_previous_blocks: DS_LINKED_STACK [INTEGER]
			-- Final pre-state breakpoints of control flow graph blocks whose post-state
			-- breakpoints are not in the same block of the control flow graph.

	unresolved_pre_state_breakpoints: DS_HASH_SET [INTEGER]
			-- Unresolved pre-state breakpoints for which post-state breakpoints could not be found
			-- because the end block of the current control flow graph is a auxiliary block.

	maximal_pre_state_breakpoint: INTEGER
			-- Maximal pre-state breakpoint which was processed so far.

	visited_loop_branching_blocks: DS_HASH_SET [INTEGER]
			-- Loop branching blocks which were already visited.

feature {NONE} -- Implementation

	extend_post_state_breakpoints (
		a_pre_state_breakpoint: INTEGER;
		a_post_state_breakpoint: INTEGER
	)
			-- Extend `last_post_state_breakpoints' with `a_pre_state_breakpoint' and
			-- `a_post_state_breakpoint'.
		require
			a_pre_state_breakpoint_valid: a_pre_state_breakpoint >= 1
			a_post_state_breakpoint_valid: a_post_state_breakpoint >= 1
		local
			l_post_state_breakpoints: DS_HASH_SET [INTEGER]
		do
			if
				last_post_state_breakpoints.has (a_pre_state_breakpoint)
			then
				l_post_state_breakpoints := last_post_state_breakpoints.item (
					a_pre_state_breakpoint
				)
				l_post_state_breakpoints.force_last (a_pre_state_breakpoint)
			else
				create l_post_state_breakpoints.make_default
				l_post_state_breakpoints.force_last (a_post_state_breakpoint)
				last_post_state_breakpoints.force_last (
					l_post_state_breakpoints,
					a_pre_state_breakpoint
				)
			end
		ensure
			a_pre_state_breakpoint_added: last_post_state_breakpoints.has (a_pre_state_breakpoint)
			a_post_state_breakpoint_added:
				last_post_state_breakpoints.item (a_pre_state_breakpoint).has (a_post_state_breakpoint)
		end

	find_for_feature_body
			-- Find post-state breakpoints for every pre-state breakpoint in the feature body of
			-- `feature_'
		local
			l_control_flow_graph_builder: EPA_CFG_BUILDER
			l_post_state_breakpoint: INTEGER
		do
			-- Create the control flow graph of `feature_' which is used to find all post-state
			-- breakpoints for every pre-state breakpoint.
			create l_control_flow_graph_builder
			l_control_flow_graph_builder.set_is_bp_slot_init_activated (True)
			l_control_flow_graph_builder.set_is_auxilary_nodes_created (True)
			l_control_flow_graph_builder.build_from_feature (class_, feature_)
			control_flow_graph := l_control_flow_graph_builder.last_control_flow_graph

			-- Find all post-state breakpoints for every pre-state breakpoint using
			-- `control_flow_graph'.
			control_flow_graph.start_node.process (Current)

			-- Resolve unresolved pre-state breakpoints for which post-state breakpoints could not
			-- be found because the end block of the current control flow graph is a auxiliary
			-- block.
			l_post_state_breakpoint := maximal_pre_state_breakpoint + 1

			-- Iterate over unresolved pre-state breakpoints and add them to
			-- `last_post_state_breakpoints'.
			from
				unresolved_pre_state_breakpoints.start
			until
				unresolved_pre_state_breakpoints.after
			loop
				extend_post_state_breakpoints (
					unresolved_pre_state_breakpoints.item_for_iteration, l_post_state_breakpoint
				)

				unresolved_pre_state_breakpoints.forth
			end
		end

	find_for_contracts
			-- Find post-state breakpoints for every pre-state breakpoint in the contracts of
			-- `feature_' if there are any.
		local
			l_feature_body_breakpoint_interval: INTEGER_INTERVAL
			i, l_first_feature_body_breakpoint, l_final_feature_body_breakpoint: INTEGER
			l_number_of_feature_breakpoints: INTEGER
			l_post_state_breakpoints: DS_HASH_SET [INTEGER]
		do
			l_feature_body_breakpoint_interval := feature_body_breakpoint_slots (feature_)
			l_number_of_feature_breakpoints := breakpoint_count (feature_)

			-- Add post-state breakpoints for the preconditions of `feature_' if there are any.
			l_first_feature_body_breakpoint := l_feature_body_breakpoint_interval.lower

			if
				l_first_feature_body_breakpoint > 1
			then
				from
					i := 1
				until
					i >= l_first_feature_body_breakpoint
				loop
					create l_post_state_breakpoints.make_default
					l_post_state_breakpoints.force_last (i + 1)
					last_post_state_breakpoints.force_last (l_post_state_breakpoints, i)

					i := i + 1
				end
			end

			-- Add post-state breakpoints for the postconditions of `feature_' if there are any.
			l_final_feature_body_breakpoint := l_feature_body_breakpoint_interval.upper

			if
				l_final_feature_body_breakpoint + 1 < breakpoint_count (feature_)
			then
				from
					i := l_final_feature_body_breakpoint + 1
				until
					i >= l_number_of_feature_breakpoints
				loop
					create l_post_state_breakpoints.make_default
					l_post_state_breakpoints.force_last (i + 1)
					last_post_state_breakpoints.force_last (l_post_state_breakpoints, i)

					i := i + 1
				end
			end
		end

	adjust_maximal_pre_state_breakpoint (a_pre_state_breakpoint: INTEGER)
			-- Adjust `maximal_pre_state_breakpoint' if `a_pre_state_breakpoint' is greater than
			-- `maximal_pre_state_breakpoint'.
		require
			a_a_pre_state_breakpoint_valid: a_pre_state_breakpoint >= 1
		do
			if
				a_pre_state_breakpoint > maximal_pre_state_breakpoint
			then
				maximal_pre_state_breakpoint := a_pre_state_breakpoint
			end
		ensure
			maximal_pre_state_breakpoint_increasing:
				maximal_pre_state_breakpoint >= old maximal_pre_state_breakpoint
		end

end
