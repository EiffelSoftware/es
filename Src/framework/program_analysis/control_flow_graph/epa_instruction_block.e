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

	EPA_CFG_UTILITY
		undefine
			is_equal,
			out
		end

create
	make,
	make_with_ast,
	make_with_ast_list

feature{NONE} -- Initialization

	make (a_id: INTEGER)
			-- Initialize Current.
		do
			set_id (a_id)
			create asts.make (initial_capacity)
		ensure
			id_est: id = a_id
		end

	make_with_ast (a_id: INTEGER; a_ast: AST_EIFFEL)
			-- Initialize Current.
		require
			a_ast_not_branching: not is_branching_instruction (a_ast)
		do
			set_id (a_id)
			create asts.make (1)
			asts.extend (a_ast)
		end

	make_with_ast_list (a_id: INTEGER; a_asts: LIST [AST_EIFFEL])
			-- Initialize Current.
		require
			a_asts_not_branching: a_asts.for_all (agent is_sequential_instruction)
		do
			set_id (a_id)
			create asts.make (a_asts.count)
			asts.append (a_asts)
		end

feature -- Access

	asts: ARRAYED_LIST [AST_EIFFEL]
			-- List of instructions in current basic block

end
