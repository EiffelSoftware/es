note
	description: "Summary description for {CA_CFG_INSTRUCTION}."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_CFG_INSTRUCTION

inherit
	CA_CFG_BASIC_BLOCK

create
	make_with_instruction,
	make_complete

feature {NONE} -- Initialization

	make_with_instruction (a_instruction: INSTRUCTION_AS)
		do
			initialize
			instruction := a_instruction
		end

	make_complete (a_instruction: INSTRUCTION_AS; a_label: INTEGER)
		do
			make_with_instruction (a_instruction)
			label := a_label
		end

feature -- Properties

	instruction: INSTRUCTION_AS

feature -- Visitor

	process (a_it: CA_CFG_ITERATOR)
		do
			a_it.bb_process_instr (Current)
		end

invariant
	out_edges.count <= 1
	-- `instruction' is not attached to an {IF_AS}, {INSPECT_AS}, or {LOOP_AS} instance.
end
