note
	description: "Summary description for {CA_CFG_BACKWARD_ITERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CA_CFG_BACKWARD_ITERATOR

inherit
	CA_CFG_ITERATOR

feature -- Iteration

	process_cfg (a_cfg: CA_CFG)
		do
			a_cfg.end_node.process (Current)
		end

feature {CA_CFG_BASIC_BLOCK} -- Iteration

	bb_process_instr (a_instr: CA_CFG_INSTRUCTION)
		do
			process_instruction (a_instr)
			across a_instr.in_edges as l_in loop
				l_in.item.process (Current)
			end
		end

	bb_process_loop (a_loop: CA_CFG_LOOP)
		do
			if process_loop (a_loop) then
					-- Keep iterating through the loop.
				a_loop.loop_in.process (Current)
			else
					-- Exit the loop.
				across a_loop.in_edges as l_in loop
					l_in.item.process (Current)
				end
			end
		end

	bb_process_if (a_if: CA_CFG_IF)
		do
			process_if (a_if)
			across a_if.in_edges as l_in loop
				l_in.item.process (Current)
			end
		end

	bb_process_skip (a_skip: CA_CFG_SKIP)
		do
			across a_skip.in_edges as l_in loop
				l_in.item.process (Current)
			end
		end

end
