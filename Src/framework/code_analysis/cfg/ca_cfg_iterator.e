note
	description: "Summary description for {CA_CFG_ITERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CA_CFG_ITERATOR

feature -- Iteration

	process_cfg (a_cfg: CA_CFG)
		deferred
		end

	process_instruction (a_instr: CA_CFG_INSTRUCTION)
		deferred
		end

	process_loop (a_loop: CA_CFG_LOOP): BOOLEAN
			-- Process the loop header. Result is True if and only if iteration through the
			-- body of the loop shall continue. After a finite (and computationally
			-- reasonable) number of loop iterations, Result must be set to True.
		deferred
		end

	process_if (a_if: CA_CFG_IF)
		deferred
		end

	process_inspect (a_inspect: CA_CFG_INSPECT)
		deferred
		end

feature {CA_CFG_BASIC_BLOCK} -- Iteration

	bb_process_instr (a_instr: CA_CFG_INSTRUCTION)
		deferred
		end

	bb_process_loop (a_loop: CA_CFG_LOOP)
		deferred
		end

	bb_process_if (a_if: CA_CFG_IF)
		deferred
		end

	bb_process_inspect (a_inspect: CA_CFG_INSPECT)
		deferred
		end

	bb_process_skip (a_skip: CA_CFG_SKIP)
		deferred
		end

end
