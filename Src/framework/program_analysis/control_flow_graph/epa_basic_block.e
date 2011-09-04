note
	description: "Object that represents a basic block in a CFG."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_BASIC_BLOCK

inherit
	DEBUG_OUTPUT
		redefine
			is_equal,
			out
		end

	HASHABLE
		undefine
			out
		redefine
			is_equal
		end

	EPA_UTILITY
		undefine
			out,
			is_equal
		end

feature -- Access

	block_number: INTEGER
			-- This is the block number (possibly used for display)

	id: INTEGER
			-- Basic block identifier
			-- This is used as hash_code of a block, ideally, each block should have a different id.

	class_: CLASS_C
			-- Class to which current basic block is associated

	written_class: CLASS_C
			-- Class in which current basic block is written

	feature_: FEATURE_I
			-- Feature to which current basic block belongs

	hash_code: INTEGER
			-- Hash code value
		do
			Result := id
		end

	asts: ARRAYED_LIST [AST_EIFFEL]
			-- List of ASTs inside current block
			-- Note: Can be empty, for example, for a fake node added for ease of analysis.

	predecessors: DS_HASH_SET [EPA_BASIC_BLOCK]
			-- Set of predecessors of the current block.

	successors: DS_HASH_SET [EPA_BASIC_BLOCK]
			-- Set of successors of the current block.

	out: STRING
			-- String representation of Current
		do
			Result := debug_output
		end

feature -- Debug output

	debug_output: STRING
			-- <Precursor>
		local
			l_ast_list: ARRAYED_LIST [AST_EIFFEL]
			l_ast: AST_EIFFEL
		do
			from
				l_ast_list := asts
				Result := ""
				l_ast_list.start
			until
				l_ast_list.after
			loop
				Result.append (text_from_ast (l_ast_list.item_for_iteration))
				l_ast_list.forth
			end
		end

feature -- Status report

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result := id = other.id
		end

feature -- Status report

	is_auxilary: BOOLEAN
			-- Is current block auxilary?
		do
		end

	is_start_node: BOOLEAN
			-- Is current block the start node of the CFG?

	is_end_node: BOOLEAN
			-- Is current block the end node of the CFG?

feature -- Setting

	set_id (a_id: INTEGER)
			-- Set `id' with `a_id'.
		do
			id := a_id
		ensure
			id_set: id = a_id
		end

	set_class_ (a_class: like class_)
			-- Set `class_' with `a_class'.
		do
			class_ := a_class
		ensure
			class_set: class_ = a_class
		end

	set_written_class (a_class: like written_class)
			-- Set `written_class' with `a_class'.
		do
			written_class := a_class
		ensure
			written_classset: written_class = a_class
		end

	set_feature_ (a_feature: like feature_)
			-- Set `feature_' with `a_feature'.
		do
			feature_ := a_feature
		ensure
			feature_set: feature_ = a_feature
		end

	set_block_number (a_number: INTEGER)
			-- Set `block_number' with `a_number'.
		do
			block_number := a_number
		ensure
			block_number_set: block_number = a_number
		end

feature {EPA_CONTROL_FLOW_GRAPH} -- Setting

	set_is_start_node (b: BOOLEAN)
			-- Sets `is_start_node' to `b'.
		do
			is_start_node := b
		ensure
			is_start_node_set: is_start_node = b
		end

	set_is_end_node (b: BOOLEAN)
			-- Sets `is_end_node' to `b'.
		do
			is_end_node := b
		ensure
			is_end_node_set: is_end_node = b
		end

feature -- Visitor

	process (a_visitor: EPA_CFG_BLOCK_VISITOR)
			-- Visitor feature.
		require
			a_visitor_not_void: a_visitor /= Void
		deferred
		end

feature {NONE} -- Implementation

	initialize_data_structures
			-- Initializes `asts', `predecessors' and `successors' with `initial_capacity'
		do
			create asts.make (initial_capacity)
			create predecessors.make (initial_capacity)
			create successors.make (initial_capacity)
		ensure
			asts_not_void: asts /= Void
			predecessors_not_void: predecessors /= Void
			successors_not_void: successors /= Void
		end

	initial_capacity: INTEGER = 2
			-- Initial capacity for `asts', `predecessors' and `successors'

end
