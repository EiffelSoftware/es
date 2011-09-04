note
	description: "Object that represents a instruction block in a CFG."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_INSTRUCTION_BLOCK

inherit
	EPA_BASIC_BLOCK

	EPA_CFG_UTILITY
		undefine
			is_equal,
			out
		end

create
	make,
	make_with_ast,
	make_with_ast_list

feature {NONE} -- Initialization

	make (a_id: INTEGER)
			-- Initialize Current.
		do
			set_id (a_id)
			initialize_data_structures
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
			initialize_data_structures
		end

	make_with_ast_list (a_id: INTEGER; a_asts: LIST [AST_EIFFEL])
			-- Initialize Current.
		require
			a_asts_not_branching: a_asts.for_all (agent is_sequential_instruction)
		do
			set_id (a_id)
			create asts.make (a_asts.count)
			asts.append (a_asts)
			initialize_data_structures
		end

feature -- Visitor

	process (a_visitor: EPA_CFG_BLOCK_VISITOR)
			-- Visitor feature.
		do
			a_visitor.process_instruction_block (Current)
		end

end
