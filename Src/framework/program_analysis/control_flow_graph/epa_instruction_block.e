note
	description: "Summary description for {EPA_INSTRUCTION_BLOCK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_INSTRUCTION_BLOCK

inherit
	EPA_BASIC_BLOCK
		redefine
			asts
		end

feature -- Access

	asts: ARRAYED_LIST [AST_EIFFEL]
			-- List of instructions in current basic block

	predecessors: ARRAYED_LIST [EPA_BASIC_BLOCK]
			-- Predecessor blocks
		do
		end

	successors: ARRAYED_LIST [EPA_BASIC_BLOCK]
			-- Successor blocks
		do
		end

end
