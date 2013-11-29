note
	description: "Summary description for {CA_CFG_BUILDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_CFG_BUILDER

create
	make,
	make_with_feature

feature {NONE} -- Initialization

	make
		do

		end

	make_with_feature (a_feature: FEATURE_AS)
			-- Initialization for `Current'.
		do
			current_feature := a_feature
		end

feature -- Actions

	set_feature (a_feature: FEATURE_AS)
		do
			current_feature := a_feature
		end

	build_cfg
		require
			feature_set: current_feature /= Void
			is_routine: current_feature.body.is_routine
			is_written_routine: attached {INTERNAL_AS} current_feature.body.as_routine.routine_body
		do
			if attached {INTERNAL_AS} current_feature.body.as_routine.routine_body as l_body then
				if attached l_body.compound as l_compound then
					current_label := 1
					cfg := process_compound (l_compound)
				end
			end
		end

	cfg: CA_CFG

	current_feature: detachable FEATURE_AS

feature {NONE} -- Implementation

	current_label: INTEGER

	process_compound (a_compound: EIFFEL_LIST [INSTRUCTION_AS]): CA_CFG
		require
			a_compound.count >= 1
		local
			l_cfg, l_subgraph: CA_CFG
			l_last_block, l_current_block, l_temp_block: CA_CFG_BASIC_BLOCK
		do
			create l_cfg.make

			l_last_block := l_cfg.start_node

				-- Lets build an ordinary CFG.
				from
					a_compound.start
				until
					a_compound.after
				loop
					if is_sequential (a_compound.item) then
						create {CA_CFG_INSTRUCTION} l_current_block.make_complete (a_compound.item, current_label)
						current_label := current_label + 1

						add_edge (l_last_block, l_current_block)

						if a_compound.index = a_compound.count then
							-- Last element.
							add_edge (l_current_block, l_cfg.end_node)
						else
							l_last_block := l_current_block
						end

						if a_compound.index = 1 then
							-- First element.
							add_edge (l_cfg.start_node, l_current_block)
						end

					elseif attached {IF_AS} a_compound.item as l_if then
						create {CA_CFG_IF} l_current_block.make_complete (l_if.condition, current_label)
						current_label := current_label + 1

						add_edge (l_last_block, l_current_block)

						create {CA_CFG_SKIP} l_last_block.make

						if attached l_if.compound as l_if_block then
							l_subgraph := process_compound (l_if_block)
							add_true_edge (l_current_block, l_subgraph.start_node)
							add_edge (l_subgraph.end_node, l_last_block)
						else
								-- If block is empty, therefore we have to add the condition itself to
								-- the predecessors of the next node.
							add_true_edge (l_current_block, l_last_block)
						end

						if a_compound.index = 1 then
							-- First element.
							add_edge (l_cfg.start_node, l_current_block)
						end

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
						if attached l_if.else_part as l_else_block then
							l_subgraph := process_compound (l_else_block)
							add_false_edge (l_current_block, l_subgraph.start_node)
							add_edge (l_subgraph.end_node, l_last_block)
						else
							add_false_edge (l_current_block, l_last_block)
						end

						if a_compound.index = a_compound.count then
							add_edge (l_last_block, l_cfg.end_node)
						end
					elseif attached {LOOP_AS} a_compound.item as l_loop then

						if attached l_loop.from_part as l_init then
							l_subgraph := process_compound (l_init)
							add_edge (l_last_block, l_subgraph.start_node)
							l_last_block := l_subgraph.end_node
						end

						create {CA_CFG_LOOP} l_current_block.make_complete (l_loop.stop, current_label)
						current_label := current_label + 1
						add_edge (l_last_block, l_current_block)
						create {CA_CFG_SKIP} l_last_block.make
						add_exit_edge (l_current_block, l_last_block)

						if attached l_loop.compound as l_loop_body then
							l_subgraph := process_compound (l_loop_body)
							add_loop_edge (l_current_block, l_subgraph.start_node)
							add_edge (l_subgraph.end_node, l_current_block)
						end

					elseif attached {INSPECT_AS} a_compound.item as l_inspect then
						-- TODO: translate to {CA_CFG_IF}'s
					end

					a_compound.forth
				end
		end

	is_sequential (a_instruction: INSTRUCTION_AS): BOOLEAN
		do
			Result := attached {ASSIGNER_CALL_AS} a_instruction
				or attached {ASSIGN_AS} a_instruction
				or attached {CREATION_AS} a_instruction
				or attached {INSTR_CALL_AS} a_instruction
		end

	add_edge (a_from, a_to: CA_CFG_BASIC_BLOCK)
		do
			a_from.add_out_edge (a_to)
			a_to.add_in_edge (a_from)
		end

	add_true_edge (a_from, a_to: CA_CFG_BASIC_BLOCK)
		do
			if attached {CA_CFG_IF} a_from as a_if then
				a_if.set_true_branch (a_to)
				a_to.add_in_edge (a_from)
			end
		end

	add_false_edge (a_from, a_to: CA_CFG_BASIC_BLOCK)
		do
			if attached {CA_CFG_IF} a_from as a_if then
				a_if.set_false_branch (a_to)
				a_to.add_in_edge (a_from)
			end
		end

	add_loop_edge (a_from, a_to: CA_CFG_BASIC_BLOCK)
		do
			if attached {CA_CFG_LOOP} a_from as a_loop then
				a_loop.set_loop_branch (a_to)
				a_to.add_in_edge (a_from)
			end
		end

	add_exit_edge (a_from, a_to: CA_CFG_BASIC_BLOCK)
		do
			if attached {CA_CFG_LOOP} a_from as a_loop then
				a_loop.set_exit_branch (a_to)
				a_to.add_in_edge (a_from)
			end
		end

end
