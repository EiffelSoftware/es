note
	description: "Provides functionality to build a Control Flow Graph from an Abstract Syntax Tree."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_CFG_BUILDER

create
	make,
	make_with_feature

feature {NONE} -- Initialization

	make
			-- Initialization.
		do

		end

	make_with_feature (a_feature: FEATURE_AS)
			-- Initialization for `Current' using feature AST `a_feature'.
		do
			current_feature := a_feature
		end

feature -- Actions

	set_feature (a_feature: FEATURE_AS)
			-- Sets the feature whose CFG shall be built to `a_feature'.
		do
			current_feature := a_feature
		end

	build_cfg
			-- Builds the CFG for the feature that has been set.
		require
			feature_set: current_feature /= Void
			is_routine: current_feature.body.is_routine
			is_written_routine: attached {INTERNAL_AS} current_feature.body.as_routine.routine_body
		do
			if attached {INTERNAL_AS} current_feature.body.as_routine.routine_body as l_body then
				if attached l_body.compound as l_compound then
					current_label := 1
					cfg := process_compound (l_compound)
					cfg.set_max_label (current_label)
				else
					create cfg.make (1, 2)
				end
			end
		end

	cfg: detachable CA_CFG
			-- Last CFG that has been built.

	current_feature: detachable FEATURE_AS
			-- Feature whose CFG shall be built.

feature {NONE} -- Implementation

	current_label: INTEGER
			-- Current label counter.

	process_compound (a_compound: EIFFEL_LIST [INSTRUCTION_AS]): CA_CFG
			-- Creates the CFG for `a_compound'.
		require
			a_compound.count >= 1
		local
			l_cfg, l_subgraph: CA_CFG
			l_last_block, l_current_block, l_temp_block: CA_CFG_BASIC_BLOCK
			l_intervals: LINKED_LIST [EIFFEL_LIST [INTERVAL_AS]]
			l_empty: BOOLEAN
		do
			create l_cfg.make (current_label, current_label + 1)
			current_label := current_label + 2

			l_last_block := l_cfg.start_node

			from
				a_compound.start
			until
				a_compound.after
			loop
				if is_sequential (a_compound.item) then
					create {CA_CFG_INSTRUCTION} l_current_block.make_complete (a_compound.item, current_label)
					current_label := current_label + 1

					add_edge (l_last_block, l_current_block)

					l_last_block := l_current_block

				elseif attached {IF_AS} a_compound.item as l_if then
					create {CA_CFG_IF} l_current_block.make_complete (l_if.condition, current_label)
					current_label := current_label + 1

					add_edge (l_last_block, l_current_block)

					create {CA_CFG_SKIP} l_last_block.make (current_label)
					current_label := current_label + 1

					if attached l_if.compound as l_if_block then
						l_subgraph := process_compound (l_if_block)
						add_true_edge (l_current_block, l_subgraph.start_node)
						add_edge (l_subgraph.end_node, l_last_block)
					else
							-- If block is empty, therefore we have to add the condition itself to
							-- the predecessors of the next node.
						add_true_edge (l_current_block, l_last_block)
					end

					if attached l_if.elsif_list then
						across l_if.elsif_list as l_elseifs loop
							l_temp_block := l_current_block
							create {CA_CFG_IF} l_current_block.make_complete (l_elseifs.item.expr, current_label)
							current_label := current_label + 1

							add_false_edge (l_temp_block, l_current_block)

							if attached l_elseifs.item.compound as l_compound then
								l_subgraph := process_compound (l_compound)
								add_true_edge (l_current_block, l_subgraph.start_node)
								add_edge (l_subgraph.end_node, l_last_block)
							else
								add_true_edge (l_current_block, l_last_block)
							end
						end
					end

					if attached l_if.else_part as l_else_block then
						l_subgraph := process_compound (l_else_block)
						add_false_edge (l_current_block, l_subgraph.start_node)
						add_edge (l_subgraph.end_node, l_last_block)
					else
						add_false_edge (l_current_block, l_last_block)
					end
				elseif attached {INSPECT_AS} a_compound.item as l_inspect then

					create l_intervals.make
					if attached l_inspect.case_list then
						across l_inspect.case_list as l_cases loop
							l_intervals.extend (l_cases.item.interval)
						end
					end
					create {CA_CFG_INSPECT} l_current_block.make_complete (l_inspect.switch,
								l_intervals, attached l_inspect.else_part, current_label)
					current_label := current_label + 1

					add_edge (l_last_block, l_current_block)

					create {CA_CFG_SKIP} l_last_block.make (current_label)
					current_label := current_label + 1

					l_empty := True

					if attached l_inspect.case_list then
						across l_inspect.case_list as l_cases loop
							if attached l_cases.item.compound as l_comp then
								l_subgraph := process_compound (l_comp)
								add_when_edge (l_current_block, l_subgraph.start_node, l_cases.cursor_index)
								add_edge (l_subgraph.end_node, l_last_block)
								l_empty := False
							end
						end
					end
					if attached l_inspect.else_part as l_else then
						l_subgraph := process_compound (l_else)
						add_else_edge (l_current_block, l_subgraph.start_node)
						add_edge (l_subgraph.end_node, l_last_block)
						l_empty := False
					end
						-- TODO: If there is nothing in the `inspect'?

				elseif attached {LOOP_AS} a_compound.item as l_loop then

					if attached l_loop.from_part as l_init then
						l_subgraph := process_compound (l_init)
						add_edge (l_last_block, l_subgraph.start_node)
						l_last_block := l_subgraph.end_node
					end

					create {CA_CFG_LOOP} l_current_block.make (l_loop, current_label)
					current_label := current_label + 1
					add_edge (l_last_block, l_current_block)
					create {CA_CFG_SKIP} l_last_block.make (current_label)
					current_label := current_label + 1
					add_exit_edge (l_current_block, l_last_block)

					if attached l_loop.compound as l_loop_body then
						l_subgraph := process_compound (l_loop_body)
						add_loop_edge (l_current_block, l_subgraph.start_node)
						add_loop_in_edge (l_subgraph.end_node, l_current_block)
					else
							-- Add self-edge because for analysis, the loop-in edge must be set.
						add_loop_in_edge (l_current_block, l_current_block)
					end
				end

				if a_compound.index = a_compound.count then
					add_edge (l_last_block, l_cfg.end_node)
				end

				a_compound.forth
			end

			Result := l_cfg
		end

	is_sequential (a_instruction: INSTRUCTION_AS): BOOLEAN
			-- Is `a_instruction' a "sequential" instruction, i. e. not
			-- a branch like if, etc.?
		do
			Result := attached {ASSIGNER_CALL_AS} a_instruction
				or attached {ASSIGN_AS} a_instruction
				or attached {CREATION_AS} a_instruction
				or attached {INSTR_CALL_AS} a_instruction
		end

	add_edge (a_from, a_to: CA_CFG_BASIC_BLOCK)
			-- Updates `a_from' and `a_to' so that they both have information
			-- about the edge from `a_from' to `a_to'.
		do
			a_from.add_out_edge (a_to)
			a_to.add_in_edge (a_from)
		end

	add_true_edge (a_from, a_to: CA_CFG_BASIC_BLOCK)
			-- Adds a "true" edge from `a_from' to `a_to'.
		require
			attached {CA_CFG_IF} a_from
		do
			if attached {CA_CFG_IF} a_from as a_if then
				a_if.set_true_branch (a_to)
				a_to.add_in_edge (a_from)
			end
		end

	add_false_edge (a_from, a_to: CA_CFG_BASIC_BLOCK)
			-- Adds a "false" edge from `a_from' to `a_to'.
		require
			attached {CA_CFG_IF} a_from
		do
			if attached {CA_CFG_IF} a_from as a_if then
				a_if.set_false_branch (a_to)
				a_to.add_in_edge (a_from)
			end
		end

	add_when_edge (a_from, a_to: CA_CFG_BASIC_BLOCK; a_index: INTEGER)
			-- Adds a "when" edge from `a_from' to `a_to'.
		require
			attached {CA_CFG_INSPECT} a_from
		do
			if attached {CA_CFG_INSPECT} a_from as a_inspect then
				a_inspect.set_when_branch (a_inspect, a_index)
				a_to.add_in_edge (a_from)
			end
		end

	add_else_edge (a_from, a_to: CA_CFG_BASIC_BLOCK)
			-- Adds an "else" edge from `a_from' to `a_to'.
		require
			attached {CA_CFG_INSPECT} a_from
		do
			if attached {CA_CFG_INSPECT} a_from as a_inspect then
				a_inspect.set_else_branch (a_to)
				a_to.add_in_edge (a_from)
			end
		end

	add_loop_edge (a_from, a_to: CA_CFG_BASIC_BLOCK)
			-- Adds a "loop" edge from `a_from' to `a_to'.
		require
			attached {CA_CFG_LOOP} a_from
		do
			if attached {CA_CFG_LOOP} a_from as a_loop then
				a_loop.set_loop_branch (a_to)
				a_to.add_in_edge (a_from)
			end
		end

	add_exit_edge (a_from, a_to: CA_CFG_BASIC_BLOCK)
			-- Adds an "exit" edge from `a_from' to `a_to'.
		require
			attached {CA_CFG_LOOP} a_from
		do
			if attached {CA_CFG_LOOP} a_from as a_loop then
				a_loop.set_exit_branch (a_to)
				a_to.add_in_edge (a_from)
			end
		end

	add_loop_in_edge (a_from, a_to: CA_CFG_BASIC_BLOCK)
			-- Adds a "loop-in" edge from `a_from' to `a_to'.
		require
			attached {CA_CFG_LOOP} a_from
		do
			if attached {CA_CFG_LOOP} a_to as a_loop then
				a_from.add_out_edge (a_to)
				a_loop.set_loop_in (a_from)
			end
		end

end
