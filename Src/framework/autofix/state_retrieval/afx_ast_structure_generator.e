note
	description: "Summary description for {AFX_AST_STRUCTURE_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_AST_STRUCTURE_GENERATOR

inherit
	AST_ITERATOR
		redefine
			process_if_as,
			process_elseif_as,
			process_loop_as,
			process_inspect_as,
			process_case_as,
			process_debug_as,
			process_check_as
		end

	REFACTORING_HELPER

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize.
		do
			initialize
		end


feature -- Access

	level_table: HASH_TABLE [LINKED_LIST [AFX_HASHABLE_AST], STRING]
			-- Table for ASTs with their level.
			-- A level is a dot separated string represents the context where an AST
			-- appears, for example "0.1.2.3"
			-- Key is a level, value is a list of ASTs with the same level

	ast_table: HASH_TABLE [LINKED_LIST [STRING], AFX_HASHABLE_AST]
			-- Table for ASTs with the level.
			-- Key is an AST, value is the list of levels associated with it

feature -- Basic operations

	generate (a_feature: like feature_)
			-- Populate `level_table' and `ast_table' for `a_feature'.
		do
			initialize
			feature_ := a_feature

			if attached {BODY_AS} a_feature.body.body as l_body then
				if attached {ROUTINE_AS} l_body.content as l_routine then
					if attached {DO_AS} l_routine.routine_body as l_do then
						extend_level (0)
						safe_process_instructions (l_do.compound)
						check level_stack.count = 1 end
					end
				end
			end
		end

feature{NONE} -- Implementation

	feature_: FEATURE_I
			-- Feature for which data is generated

	written_class: CLASS_C
			-- Class in which `feature_' is written
		do
			Result := feature_.written_class
		end

	level_stack: LINKED_LIST [INTEGER]
			-- Stack for level generation

	level_string: STRING
			-- String representation of `level_stack'
		local
			l_cursor: CURSOR
			l_stack: like level_stack
			i: INTEGER
			c: INTEGER
		do
			l_stack := level_stack
			c := l_stack.count
			create Result.make (c * 3)
			l_cursor := l_stack.cursor
			from
				l_stack.start
				i := 1
			until
				l_stack.after
			loop
				Result.append (l_stack.item_for_iteration.out)
				if i < c then
					Result.append_character ('.')
				end
				l_stack.forth
				i := i + 1
			end
			l_stack.go_to (l_cursor)
		end

	hashable_ast (a_ast: AST_EIFFEL): AFX_HASHABLE_AST
			-- Hashable AST for `a_ast'
		do
			create Result.make (a_ast, written_class)
		end

	put_ast_with_level (a_ast: AFX_HASHABLE_AST; a_level: STRING)
			-- Put `a_ast' with `a_level' into `level_table' and `ast_table'.
		local
			l_ast_list: LINKED_LIST [AFX_HASHABLE_AST]
			l_level_list: LINKED_LIST [STRING]
		do
			if level_table.has (a_level) then
				l_ast_list := level_table.item (a_level)
			else
				create l_ast_list.make
			end
			l_ast_list.extend (a_ast)

			if ast_table.has (a_ast) then
				l_level_list := ast_table.item (a_ast)
			else
				create l_level_list.make
			end
			l_level_list.extend (a_level)
			io.put_string (a_level + " : " + a_ast.ast.generating_type + "%N")
		end

feature{NONE} -- Process

	process_if_as (l_as: IF_AS)
		local
			l_new_level: INTEGER
			l_level_str: STRING
			l_cursor: INTEGER
			l_branch_id: INTEGER
			l_hash_elsif_as: AFX_HASHABLE_AST
		do
			l_branch_id := 1
			l_level_str := level_string

				-- Process then part.
			l_as.condition.process (Current)

			extend_level (l_branch_id)
			safe_process (l_as.compound)
			safe_process_instructions (l_as.compound)
			remove_level

				-- Process elseif parts.
			if attached l_as.elsif_list as l_elsif_as then
				from
					l_cursor := l_elsif_as.index
					l_elsif_as.start
				until
					l_elsif_as.after
				loop
					create l_hash_elsif_as.make (l_elsif_as.item, written_class)
					put_ast_with_level (l_hash_elsif_as, l_level_str)
					l_branch_id := l_branch_id + 1
					extend_level (l_branch_id)
					l_elsif_as.item.process (Current)
					remove_level
					l_elsif_as.forth
				end
				l_elsif_as.go_i_th (l_cursor)
			end

				-- Process else part.
			if attached l_as.else_part as l_else_part then
				l_branch_id := l_branch_id + 1
				extend_level (l_branch_id)
				l_else_part.process (Current)
				safe_process_instructions (l_else_part)
				remove_level
			end
		end

	process_elseif_as (l_as: ELSIF_AS)
		do
			safe_process_instructions (l_as.compound)
		end

	process_element_list (l_as: EIFFEL_LIST [AST_EIFFEL])
		local
			l_cursor: INTEGER
			l_hash_ast: AFX_HASHABLE_AST
		do
			extend_level (0)
			from
				l_cursor := l_as.index
				l_as.start
			until
				l_as.after
			loop
				increase_last_level
				create l_hash_ast.make (l_as.item, written_class)
				put_ast_with_level (l_hash_ast, level_string)
				l_as.item.process (Current)
				l_as.forth
			end
			remove_level
			l_as.go_i_th (l_cursor)
		end

	process_loop_as (l_as: LOOP_AS)
		local
			l_branch_id: INTEGER
			l_stop_as: AFX_HASHABLE_AST
			l_from_instr_count: INTEGER
			l_loop_str: STRING
			l_body_count: INTEGER
		do
				-- Get the level string of the whole loop AST.
			l_loop_str := level_string

				-- Process from part.
			l_branch_id := 1
			extend_level (l_branch_id)
			if attached l_as.from_part as l_from_part then
				l_from_instr_count := l_from_part.count
			end
			safe_process_instructions (l_as.from_part)

				-- Process invariant part.
			fixme ("Do not support loop invariant for the moment. 6.12.2009 Jasonw")
--			safe_process (l_as.invariant_part)

				-- Process stop part.
			extend_level (l_from_instr_count + 1)
			create l_stop_as.make (l_as.stop, written_class)
			put_ast_with_level (l_stop_as, level_string)
			put_ast_with_level (l_stop_as, l_loop_str)
			remove_level
			remove_level

				-- Process loop body.
			l_branch_id := l_branch_id + 1
			extend_level (l_branch_id)
			safe_process_instructions (l_as.compound)
			if attached l_as.compound as l_body then
				l_body_count := l_body.count
			end
			extend_level (l_body_count + 1)
			put_ast_with_level (l_stop_as, level_string)
			remove_level
			remove_level

				-- Process loop variant.
			fixme ("Do not support loop variant for the moment. 6.12.2009 Jasonw")
--			safe_process (l_as.variant_part)
		end

	process_inspect_as (l_as: INSPECT_AS)
		local
			l_branch_id: INTEGER
			l_case_as: AFX_HASHABLE_AST
			l_inspect_str: STRING
			l_cursor: INTEGER
		do
			l_inspect_str := level_string
			l_branch_id := 1

				-- Process case list.
			if attached l_as.case_list as l_cases then
				from
					l_cursor := l_cases.index
					l_cases.start
				until
					l_cases.after
				loop
					extend_level (l_branch_id)
					create l_case_as.make (l_cases.item, written_class)
					put_ast_with_level (l_case_as, l_inspect_str)
					l_cases.item.process (Current)
					remove_level
					l_branch_id := l_branch_id + 1
					l_cases.forth
				end
				l_cases.go_i_th (l_cursor)
			end

				-- Process else part.
			extend_level (l_branch_id)
			safe_process_instructions (l_as.else_part)
			remove_level
		end

	process_debug_as (l_as: DEBUG_AS)
		do
			safe_process_instructions (l_as.compound)
		end

	process_check_as (l_as: CHECK_AS)
		do
			safe_process_tags (l_as.check_list)
		end

	process_case_as (l_as: CASE_AS)
		do
			safe_process_instructions (l_as.compound)
		end

	safe_process_instructions (l_as: EIFFEL_LIST [AST_EIFFEL])
			-- Process `l_as' if it is a list of instructions.
		do
			if attached {EIFFEL_LIST [INSTRUCTION_AS]} l_as as l_instr then
				process_element_list (l_instr)
			end
		end

	safe_process_tags (l_as: EIFFEL_LIST [TAGGED_AS])
			-- Process `l_as' if it is a list of instructions.
		do
			if attached l_as as l_tags then
				process_element_list (l_tags)
			end
		end

feature{NONE} -- Implementation

	initialize
			-- Initialize data structures.
		do
			create level_table.make (20)
			level_table.compare_objects

			create ast_table.make (20)
			ast_table.compare_objects

			create level_stack.make
		end

	extend_level (i: INTEGER)
			-- Extend `level'.
		do
			level_stack.extend (i)
		end

	remove_level
			-- Remove the last level.
		do
			level_stack.finish
			level_stack.remove
		end

	increase_last_level
			-- Increase last level.
		do
			level_stack.finish
			level_stack.replace (level_stack.item_for_iteration + 1)
		end

end
