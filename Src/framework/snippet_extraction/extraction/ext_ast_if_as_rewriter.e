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
			process_if_as,
			process_elseif_as
		end

	EXT_AST_UTILITY

create
	make_with_output

feature {NONE} -- Creation

	make_with_output (a_output: like output)
			-- Make with `a_output'.
		do
			Precursor (a_output)
		end

feature -- Configuration

	variable_context: EXT_VARIABLE_CONTEXT
		assign set_variable_context
			-- Contextual information about relevant variables.

	set_variable_context (a_context: EXT_VARIABLE_CONTEXT)
			-- Sets `variable_context' to `a_context'	
		require
			attached a_context
		do
			variable_context := a_context
		end

feature {NONE} -- Implementation

	process_if_as (l_as: IF_AS)
		local
			l_use_cond, l_use_branch_true, l_use_elsif_list, l_use_branch_false: BOOLEAN
			l_used_elseifs: INTEGER
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
			elseif l_use_elsif_list and then not l_use_branch_true and not l_use_branch_false then
				process_if_as_only_retaining_one_elsif_branch (l_as)
			else
				Precursor (l_as)
			end
		end

	process_elseif_as (l_as: ELSIF_AS)
		do
			to_implement ("Implement pruning of not used list items.")
			Precursor (l_as)
		end

feature {NONE} -- Helpers

	process_if_as_only_retaining_false_branch (l_as: IF_AS)
			-- Rewrites an 'if' statement that the 'else' branch becomes the 'true' branch.
		require
			attached l_as.condition
--			attached l_as.else_part
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
--			attached l_as.elsif_list.last.compound
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

feature {NONE} -- Helpers (Expression)

	negate_expression (l_as: EXPR_AS): EXPR_AS
			-- Negates an expression.
			-- If the root of the expression AST is of type `{UN_NOT_AS}' it will be removed.
			-- If the root of the expression AST is not of type `{UN_NOT_AS}' it such node
			-- including and inner `{PARAN_AS}' will be wrapped around.
		require
			attached l_as
		do
			if attached {UN_NOT_AS} l_as as l_un_not_as then
				Result := l_un_not_as.expr
			else
				Result := create {UN_NOT_AS}.initialize (paran_expression (l_as), Void)
			end
		ensure
			attached Result
		end

	and_expression_list (a_list: LIST [EXPR_AS]): EXPR_AS
			-- Concatenates a list of expressions with binary 'and'.
		require
			not a_list.is_empty
		local
			l_current: EXPR_AS
			l_new_list: like a_list
		do
			if a_list.count > 1 then
				l_new_list := a_list.twin
				l_current := l_new_list.last

				l_new_list.start
				l_new_list.prune (l_current)
				check l_new_list.count < a_list.count end

				Result := and_expression (and_expression_list (l_new_list), l_current)
			else
				Result := a_list.first
			end
		end

	and_expression (a_left_as, a_right_as: EXPR_AS): EXPR_AS
			-- Wraps parenthesis around both expressions and connects them with a binary 'and'.
		local
			l_bin_and_as: BIN_AND_AS
		do
			create l_bin_and_as.initialize (paran_expression (a_left_as), paran_expression (a_right_as), Void)
			Result := l_bin_and_as
		end

	paran_expression (a_as: EXPR_AS): EXPR_AS
			-- Creates a new expression of `a_as' with parenthesis wrapped around.
		local
			l_paran_as: PARAN_AS
		do
			create l_paran_as.initialize (a_as, Void, Void)
			Result := l_paran_as
		end

end
