note
	description: "Simplifying and rewriting 'loop' statements with emtpy body."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_LOOP_AS_HOLE_PROCESSOR

inherit
	ETR_AST_STRUCTURE_PRINTER
		redefine
			process_loop_as
		end

	EXT_AST_REWRITER [EIFFEL_LIST [INSTRUCTION_AS]]

	EXT_HOLE_EXTRACTOR

	EXT_VARIABLE_CONTEXT_AWARE

	EXT_AST_UTILITY

	EPA_UTILITY

create
	make_with_arguments

feature {NONE} -- Creation

	make_with_arguments (a_output: like output; a_factory: like hole_factory)
			-- Make with `a_output'.
		do
			make_with_output (a_output)
			hole_factory := a_factory
		end

feature -- Basic operations

	extract (a_ast: AST_EIFFEL)
			-- Extract annotations from `a_ast' and
			-- make results available in `last_holes' and
			-- make transformed AST available in `last_ast'.
		do
				-- Freshly initialize variables holding the output of the run.
			initialize_hole_context

				-- Process and rewrite AST to output while collecting holes.
			a_ast.process (Current)
		end

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

	process_loop_as (l_as: LOOP_AS)
		local
			l_done: BOOLEAN
			l_use_from_part, l_use_stop, l_use_compound: BOOLEAN
		do
				-- l_as.iteration not handled.

			if attached l_as.from_part as l_from_part_as then
				l_use_from_part := is_ast_eiffel_using_variable_of_interest (l_from_part_as, variable_context)
			end

			if attached l_as.stop as l_stop_as then
				l_use_stop := is_ast_eiffel_using_variable_of_interest (l_stop_as, variable_context)
			end

				-- l_as.invariant not handled.
				-- l_as.variant not handled.
				-- l_as.variant_part not handled.

			if attached l_as.compound as l_compound_as then
				l_use_compound := is_ast_eiffel_using_variable_of_interest (l_compound_as, variable_context)
			end

				-- Decide on processing.
			if l_use_from_part and not l_use_stop and not l_use_compound then
				process_loop_as_only_from_part_used	(l_as)
				l_done := True
			end

			if not l_use_from_part and l_use_stop and not l_use_compound then
				process_loop_as_only_expression_used (l_as)
				l_done := True
			end

			if l_use_from_part and l_use_stop and not l_use_compound then
				process_loop_as_only_from_part_and_expression_used (l_as)
				l_done := True
			end

			if not l_use_from_part and not l_use_stop and l_use_compound then
				process_loop_as_only_compound_used (l_as)
				l_done := True
			end

			if not l_done then
				Precursor (l_as)
			end
		end

feature {NONE} -- Helpers

	process_loop_as_only_from_part_used (a_as: LOOP_AS)
			-- Replaces a 'loop' statement with the `{LOOP_AS}.from_part' instructions if
			-- neither the expression nor the body use variables of interest.
		do
			safe_process (a_as.from_part)
		end

	process_loop_as_only_expression_used (a_as: LOOP_AS)
		local
			l_hole: EXT_HOLE
		do
			l_hole := create_hole (a_as, False)
			add_hole (l_hole, a_as.path)

			output.append_string (l_hole.out)
			output.append_string (ti_New_line)
		end

	process_loop_as_only_from_part_and_expression_used (a_as: LOOP_AS)
		local
			l_hole: EXT_HOLE
		do
			l_hole := create_hole (a_as, False)
			add_hole (l_hole, a_as.path)

			safe_process (a_as.from_part)
			output.append_string (l_hole.out)
			output.append_string (ti_New_line)
		end

	process_loop_as_only_compound_used (a_as: LOOP_AS)
		local
			l_hole: EXT_HOLE
		do
			l_hole := create_hole (a_as, True)
			add_hole (l_hole, a_as.path)

			output.append_string (l_hole.out)
			output.append_string (ti_New_line)
		end

feature {NONE} -- Annotation Handling

	create_hole (a_ast: AST_EIFFEL; a_conditionally: BOOLEAN): EXT_HOLE
			-- Create a new `{EXT_ANN_HOLE}' with metadata.
		local
			l_annotation_set: LINKED_SET [EXT_MENTION_ANNOTATION]
			l_annotation_extractor: EXT_MENTION_ANNOTATION_EXTRACTOR
		do
			create l_annotation_extractor.make_from_variable_context (variable_context)
			l_annotation_extractor.set_conditional (a_conditionally)
			l_annotation_extractor.extract_from_ast (a_ast)

			create l_annotation_set.make
			l_annotation_extractor.last_annotations.do_all (agent l_annotation_set.force)

			Result := hole_factory.new_hole (l_annotation_set)
		end

end
