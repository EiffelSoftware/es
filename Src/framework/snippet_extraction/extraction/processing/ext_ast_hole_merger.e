note
	description: "Merges consecutive holes in compound statements."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_HOLE_MERGER

inherit
	ETR_AST_STRUCTURE_PRINTER
		export
			{NONE} all
		redefine
			process_eiffel_list,
			process_list_with_separator
		end

	EXT_HOLE_MERGER

	EXT_HOLE_FACTORY_AWARE

	EXT_HOLE_UTILITY
		export
			{NONE} all
		end

	EPA_UTILITY

	REFACTORING_HELPER

create
	make_with_arguments

feature {NONE} -- Initialization

	make_with_arguments (a_output: like output; a_holes: like holes; a_hole_factory: like hole_factory)
		require
			attached a_output
			attached a_holes
			attached a_hole_factory
		do
			make_with_output (a_output)
			holes := a_holes.deep_twin
			hole_factory := a_hole_factory

			initialize_hole_context
		end

feature -- Basic operations

	rewrite (a_ast: EIFFEL_LIST [INSTRUCTION_AS])
		local
			l_path_initializer: ETR_AST_PATH_INITIALIZER
		do
			last_ast := Void

			if attached {EIFFEL_LIST [INSTRUCTION_AS]} ast_from_compound_text (text_from_ast_with_printer (a_ast, Current)) as l_rewritten_ast then
					-- Assign path IDs to nodes.
				create l_path_initializer
				l_path_initializer.process_from_root (l_rewritten_ast)

				last_ast := l_rewritten_ast
			end
		end

feature {NONE} -- Implementation

	holes: HASH_TABLE [EXT_HOLE, STRING]
			-- Set of holes in current snippet
			-- Keys are names of holes, values are the holes.	

	process_eiffel_list (a_as: EIFFEL_LIST [AST_EIFFEL])
			-- Processes `a_as' but also merges consecutive holes.
		local
			l_merged_list: EIFFEL_LIST [INSTRUCTION_AS]
		do
			if attached {EIFFEL_LIST [INSTRUCTION_AS]} a_as as l_as then
				l_merged_list := merge_holes_in_list (l_as)
				Precursor (l_merged_list)
			else
				Precursor (a_as)
			end
		end

	process_list_with_separator (a_as: detachable EIFFEL_LIST[AST_EIFFEL]; separator: detachable STRING; a_parent: AST_EIFFEL; a_branch: INTEGER)
			-- Process `a_as' and use `separator' for string output.
		local
			l_merged_list: EIFFEL_LIST [INSTRUCTION_AS]
		do
			if attached {EIFFEL_LIST [INSTRUCTION_AS]} a_as as l_as then
				l_merged_list := merge_holes_in_list (l_as)
				Precursor (l_merged_list, separator, a_parent, a_branch)
			else
				Precursor (a_as, separator, a_parent, a_branch)
			end
		end

feature {NONE} -- Hole Handling

	merge_holes_in_list (a_ast: EIFFEL_LIST [INSTRUCTION_AS]): EIFFEL_LIST [INSTRUCTION_AS]
			-- Merge consecutive holes in `a_ast' and return a that condensed list.
		local
			l_cursor: INTEGER
			l_consecutive_hole: BOOLEAN
			l_merged_hole, l_actual_hole, l_start_hole: EXT_HOLE
		do
			create Result.make (10)
			l_cursor := a_ast.index
			from
				a_ast.start
			until
				a_ast.after
			loop
				if not is_hole (a_ast.item) then
					Result.force (a_ast.item)
					a_ast.forth
				else
						-- Retrieve current hole.
					l_start_hole := holes.at (get_hole_name (a_ast.item))
					check attached l_start_hole end

						-- Create new hole with annotations from retrieved hole.
					l_merged_hole := hole_factory.new_hole (l_start_hole.annotations)

					from
						l_consecutive_hole := False
						a_ast.forth
					until
						a_ast.after or not is_hole (a_ast.item)
					loop
						l_consecutive_hole := True

						l_actual_hole := holes.at (get_hole_name (a_ast.item))
						check attached l_actual_hole end

							-- Book-keeping.
						last_holes_removed.force (l_actual_hole, l_actual_hole.hole_name)

							-- Merge annotations.
						l_merged_hole.annotations.merge (l_actual_hole.annotations)

						a_ast.forth
					end

					if l_consecutive_hole then
						Result.force (ast_from_statement_text (l_merged_hole.hole_name))

							-- Book-keeping.
						last_holes_added.force (l_merged_hole, l_merged_hole.hole_name)
						last_holes_removed.force (l_start_hole, l_start_hole.hole_name)
					else
						Result.force (ast_from_statement_text (l_start_hole.hole_name))
					end
				end
			end
			a_ast.go_i_th (l_cursor)
		end

end
