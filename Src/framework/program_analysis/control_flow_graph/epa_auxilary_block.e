note
	description: "Objects that represents auxilary basic blocks, for example, blocks used for the start and end node in a CFG"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_AUXILARY_BLOCK

inherit
	EPA_INSTRUCTION_BLOCK
		redefine
			is_auxilary
		end

create
	make

feature -- Status report

	is_auxilary: BOOLEAN = True
			-- Is current block auxilary?

end
