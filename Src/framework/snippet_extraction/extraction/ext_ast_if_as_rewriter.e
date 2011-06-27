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

	EPA_UTILITY

	EXT_ANN_UTILITY

	EXT_AST_UTILITY

create
	make_with_output

feature {NONE} -- Creation

	make_with_output (a_output: like output)
			-- Make with `a_output'.
		do
			Precursor (a_output)
			create annotation_factory.make
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

	annotation_factory: EXT_ANNOTATION_FACTORY
			-- Annotation factory to create new typed annotation instances.		

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

			if not l_use_elsif_list and not l_use_branch_true and not l_use_branch_false and l_use_cond then
				process_if_as_only_condition_used (l_as)
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

	process_if_as_only_condition_used (a_as: IF_AS)
			-- Creates an `{EXT_ANN_HOLE}' instead of the empty 'if' statement.
		do
			output.append_string (create_annotation_hole (a_as).out)
			output.append_string (ti_New_line)
		end

feature {NONE} -- Annotation Handling

	create_annotation_hole (a_ast: AST_EIFFEL): EXT_ANNOTATION
			-- Create a new `{EXT_ANN_HOLE}' with metadata.
		do
			Result := annotation_factory.new_ann_hole (collect_mentions_set (a_ast, variable_context), Void)
		end

end
