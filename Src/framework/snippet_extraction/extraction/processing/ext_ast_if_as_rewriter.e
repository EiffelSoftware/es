note
	description: "Simplifying and rewriting 'if' statements with emtpy branches."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_IF_AS_REWRITER

inherit
	ETR_AST_STRUCTURE_PRINTER
		redefine
			make_with_output,
			process_if_as
		end

	EXT_AST_REWRITER [EIFFEL_LIST [INSTRUCTION_AS]]

	EXT_VARIABLE_CONTEXT_AWARE

	EXT_AST_UTILITY

	EPA_UTILITY

create
	make_with_output

feature {NONE} -- Creation

	make_with_output (a_output: like output)
			-- Make with `a_output'.
		do
			Precursor (a_output)
		end

feature -- Basic Operations

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

	process_if_as (l_as: IF_AS)
		local
			l_use_cond, l_use_branch_true, l_use_elsif_list, l_use_branch_false: BOOLEAN
			l_used_elseifs: INTEGER
			l_done: BOOLEAN
		do
				-- Scan expression.
			l_use_cond := is_ast_eiffel_using_variable_of_interest (l_as.condition, variable_context)

				-- Scan true branch
			if attached l_as.compound then
				l_use_branch_true := is_ast_eiffel_using_variable_of_interest (l_as.compound, variable_context)
			end

				-- Scan elseif list
			if attached l_as.elsif_list then
					-- process all individual `{ELSIF_AS}' from list
				across l_as.elsif_list as l_elsif_list loop
					if is_ast_eiffel_using_variable_of_interest (l_elsif_list.item, variable_context) then
							-- mark that at least one elseif has to be retained
						l_use_elsif_list := True
						l_used_elseifs := l_used_elseifs + 1
					end
				end
			end

				-- Scan false branch
			if attached l_as.else_part then
				l_use_branch_false := is_ast_eiffel_using_variable_of_interest (l_as.else_part, variable_context)
			end

				-- Decide on processing.
			if not l_use_elsif_list and then not l_use_branch_true and l_use_branch_false then
				process_if_as_only_retaining_false_branch (l_as)
				l_done := True
			end

			if l_use_elsif_list and l_used_elseifs = 1 and then not l_use_branch_true and not l_use_branch_false then
				process_if_as_only_retaining_one_elsif_branch (l_as)
				l_done := True
			end

			if not l_done then
				Precursor (l_as)
			end
		end

feature {NONE} -- Helpers

	process_if_as_only_retaining_false_branch (l_as: IF_AS)
			-- Rewrites an 'if' statement that the 'else' branch becomes the 'true' branch.
		require
			attached l_as.condition
		local
			l_condition: EXPR_AS
		do
			l_condition := negate_expression (l_as.condition)

			output.append_string (ti_if_keyword+ti_Space)
			process_child (l_condition, l_as, 1)
			output.append_string (ti_Space+ti_then_keyword+ti_New_line)

			if processing_needed (l_as.else_part, l_as, 2) then
				process_child_block_list (l_as.else_part, void, l_as, 2)
			end

			output.append_string (ti_End_keyword+ti_New_line)
		end

	process_if_as_only_retaining_one_elsif_branch (l_as: IF_AS)
			-- Rewrites an 'if' statement that a single 'elseif' branch becomes the 'true' branch.
		require
			attached l_as.condition
			attached l_as.elsif_list and then not l_as.elsif_list.is_empty
		local
			l_condition: EXPR_AS
			l_and_expression_list: LINKED_LIST [EXPR_AS]
			l_compound: EIFFEL_LIST [INSTRUCTION_AS]
		do
			create l_and_expression_list.make
			l_and_expression_list.compare_objects
			l_and_expression_list.force (negate_expression (l_as.condition))
			from
				l_as.elsif_list.start
			until
				l_as.elsif_list.after
			loop
				if l_as.elsif_list.islast then
					l_and_expression_list.force (l_as.elsif_list.item.expr)
				else
					l_and_expression_list.force (negate_expression (l_as.elsif_list.item.expr))
				end
				l_as.elsif_list.forth
			end

			l_condition := and_expression_list (l_and_expression_list)
			l_compound := l_as.elsif_list.last.compound

			output.append_string (ti_if_keyword+ti_Space)
			process_child (l_condition, l_as, 1)
			output.append_string (ti_Space+ti_then_keyword+ti_New_line)

			if processing_needed (l_compound, l_as, 2) then
				process_child_block_list (l_compound, void, l_as, 2)
			end

			output.append_string (ti_End_keyword+ti_New_line)
		end

end
