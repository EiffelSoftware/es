note
	description: "Summary description for {EPA_CFG_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_CFG_UTILITY

inherit
	REFACTORING_HELPER

feature -- Status report: AST

	is_branching_instruction (a_instruction: AST_EIFFEL): BOOLEAN
			-- Is `a_instruction' a branching instruction?
		do
			fixme ("Use a visitor to avoid object tests is a better solution. 28.2.2010 Jasonw")
			Result :=
				attached {IF_AS} a_instruction or else
				attached {LOOP_AS} a_instruction or else
				attached {INSPECT_AS} a_instruction
		end

	is_sequential_instruction (a_instruction: AST_EIFFEL): BOOLEAN
			-- Is `a_instruction' a sequential (not branching) instruction?
		do
			Result := not is_branching_instruction (a_instruction)
		end

feature -- Status report: CFG

	is_branching_block (a_block: EPA_BASIC_BLOCK): BOOLEAN
			-- Is `a_block' a branching block?
		require
			a_block_not_void: a_block /= Void
		do
			Result := attached {EPA_BRANCHING_BLOCK} a_block
		end

	is_instruction_block (a_block: EPA_BASIC_BLOCK): BOOLEAN
			-- Is `a_block' a basic instruction (not branching) block?
		require
			a_block_not_void: a_block /= Void
		do
			Result := attached {EPA_INSTRUCTION_BLOCK} a_block
		end

	is_auxilary_block (a_block: EPA_BASIC_BLOCK): BOOLEAN
			-- Is `a_block' an auxilary block?
		require
			a_block_not_void: a_block /= Void
		do
			Result := attached {EPA_AUXILARY_BLOCK} a_block
		end

end
