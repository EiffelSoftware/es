note
	description: "Visitor to traverse a control flow graph."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_CFG_BLOCK_VISITOR

feature -- Roundtrip

	process_instruction_block (a_block: EPA_INSTRUCTION_BLOCK)
			-- Process `a_block'.
		require
			a_block_not_void: a_block /= Void
		deferred
		end

	process_auxilary_block (a_block: EPA_AUXILARY_BLOCK)
			-- Process `a_block'.
		require
			a_block_not_void: a_block /= Void
		deferred
		end

feature -- Roundtrip

	process_if_branching_block (a_block: EPA_IF_BRANCHING_BLOCK)
			-- Process `a_block'.
		require
			a_block_not_void: a_block /= Void
		deferred
		end

	process_inspect_branching_block (a_block: EPA_INSPECT_BRANCHING_BLOCK)
			-- Process `a_block'.
		require
			a_block_not_void: a_block /= Void
		deferred
		end

	process_loop_branching_block (a_block: EPA_LOOP_BRANCHING_BLOCK)
			-- Process `a_block'.
		require
			a_block_not_void: a_block /= Void
		deferred
		end

end
