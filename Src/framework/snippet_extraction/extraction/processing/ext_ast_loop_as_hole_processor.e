note
	description: "Simplifying and rewriting 'loop' statements with emtpy body."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_LOOP_AS_HOLE_PROCESSOR

inherit
	ETR_AST_STRUCTURE_PRINTER
		export
			{NONE} all
		redefine
			process_loop_as
		end

	EXT_HOLE_EXTRACTOR

	EXT_HOLE_FACTORY_AWARE

	EXT_HOLE_UTILITY
		export
			{NONE} all
		end

	EXT_VARIABLE_CONTEXT_AWARE

	EXT_AST_UTILITY

	EPA_UTILITY

create
	make_with_arguments

feature {NONE} -- Creation

	make_with_arguments (a_output: like output; a_holes: HASH_TABLE [EXT_HOLE, STRING]; a_variable_context: like variable_context; a_factory: like hole_factory)
			-- Make with essential arguments.
		local
			l_variable_set: DS_HASH_SET [STRING]
		do
			make_with_output (a_output)
			holes := a_holes.twin
			variable_context := a_variable_context
			hole_factory := a_factory

			create l_variable_set.make_equal (10)
			variable_context.variables_of_interest.current_keys.do_all (agent l_variable_set.put)

			create variable_of_interest_usage_checker.make_from_variables (l_variable_set)

			create last_holes_removed.make (10)
			last_holes_removed.compare_objects
		end

feature -- Access

	last_ast: detachable EIFFEL_LIST [INSTRUCTION_AS]
			-- AST transfomed by last `extract'.

	last_holes_removed: HASH_TABLE [EXT_HOLE, STRING]
			-- Holes removed due to merging by last `extract'.

feature -- Basic operations

	extract (a_ast: AST_EIFFEL)
			-- Extract annotations from `a_ast' and
			-- make results available in `last_holes' and
			-- make transformed AST available in `last_ast'.
		local
			l_path_initializer: ETR_AST_PATH_INITIALIZER
		do
				-- Freshly initialize variables holding the output of the run.
			initialize_hole_context

				-- Reset rewritten AST.
			last_ast := Void

				-- Extract and rewrite AST.
			if attached {EIFFEL_LIST [INSTRUCTION_AS]} ast_from_compound_text (text_from_ast_with_printer (a_ast, Current)) as l_rewritten_ast then
					-- Assign path IDs to nodes.
				create l_path_initializer
				l_path_initializer.process_from_root (l_rewritten_ast)

				last_ast := l_rewritten_ast
			end
		end

feature {NONE} -- Implementation

	holes: HASH_TABLE [EXT_HOLE, STRING]
			-- List of holes that were present at initialization.

	variable_of_interest_usage_checker: EXT_AST_VARIABLE_USAGE_CHECKER
			-- Checks if an AST is accessing any variable of interest.

	process_loop_as (l_as: LOOP_AS)
		local
			l_done: BOOLEAN
			l_use_iteration, l_use_from_part, l_use_stop, l_use_compound: BOOLEAN
		do
			if attached l_as.iteration as l_iteration_as then
				variable_of_interest_usage_checker.check_ast (l_iteration_as)
				l_use_iteration := variable_of_interest_usage_checker.passed_check
			end

			if attached l_as.from_part as l_from_part_as then
				variable_of_interest_usage_checker.check_ast (l_from_part_as)
				l_use_from_part := variable_of_interest_usage_checker.passed_check
			end

			if attached l_as.stop as l_stop_as then
				variable_of_interest_usage_checker.check_ast (l_stop_as)
				l_use_stop := variable_of_interest_usage_checker.passed_check
			end

				-- l_as.invariant not handled.
				-- l_as.variant not handled.
				-- l_as.variant_part not handled.

			if attached l_as.compound as l_compound_as then
				variable_of_interest_usage_checker.check_ast (l_compound_as)
				l_use_compound := variable_of_interest_usage_checker.passed_check
			end

				-- Decide on processing.
			if not l_use_iteration then
				if not l_done and l_use_from_part and not l_use_stop and not l_use_compound then
					process_loop_as_only_from_part_used	(l_as)
					l_done := True
				end

				if not l_done and not l_use_from_part and l_use_stop and not l_use_compound then
					process_loop_as_only_expression_used (l_as)
					l_done := True
				end

				if not l_done and l_use_from_part and l_use_stop and not l_use_compound then
					process_loop_as_only_from_part_and_expression_used (l_as)
					l_done := True
				end

				if not l_done and not l_use_from_part and not l_use_stop and l_use_compound then
					process_loop_as_only_compound_used (l_as)
					l_done := True
				end
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

			output.append_string (l_hole.hole_name)
			output.append_string (ti_New_line)
		end

	process_loop_as_only_from_part_and_expression_used (a_as: LOOP_AS)
		local
			l_hole: EXT_HOLE
		do
			l_hole := create_hole (a_as, False)
			add_hole (l_hole, a_as.path)

			safe_process (a_as.from_part)
			output.append_string (l_hole.hole_name)
			output.append_string (ti_New_line)
		end

	process_loop_as_only_compound_used (a_as: LOOP_AS)
		local
			l_hole: EXT_HOLE
		do
			l_hole := create_hole (a_as, True)
			add_hole (l_hole, a_as.path)

			output.append_string (l_hole.hole_name)
			output.append_string (ti_New_line)
		end

feature {NONE} -- Annotation Handling

	create_hole (a_ast: AST_EIFFEL; a_conditionally: BOOLEAN): EXT_HOLE
			-- Create a new `{EXT_ANN_HOLE}' with metadata and merges it with other holes that are contained within `a_ast'.
		local
			l_hole_type_string: STRING
			l_annotation_extractor: EXT_MENTION_ANNOTATION_EXTRACTOR
			l_hole_names: DS_HASH_SET [STRING]
		do
				-- Extract fresh annotations.
			create l_annotation_extractor.make_from_variable_context (variable_context)
			l_annotation_extractor.set_conditional (a_conditionally)
			l_annotation_extractor.extract_from_ast (a_ast)

			if evaluate_hole_types then
				-- Try to determine hole type.
				l_hole_type_string := get_hole_type (a_ast, variable_context.context_class, variable_context.context_feature)
			end

				-- Extract subsumed holes and merge into fresh hole.
			l_hole_names := collect_hole_names (a_ast)

			from
				l_hole_names.start
			until
				l_hole_names.after
			loop
				check
					attached l_hole_names.item_for_iteration as l_key and then
					attached holes.at (l_key) as l_item
				then
						-- Book-keeping.	
					last_holes_removed.force (l_item, l_key)

						-- Merge annotations, but set them to conditional.
					if attached l_item.annotations as a then
						from
							a.start
						until
							a.after
						loop
							Result.annotations.force (
								create {ANN_MENTION_ANNOTATION}.make_as_conditional (a.item_for_iteration.expression)
							)
							a.forth
						end
					end
				end

				l_hole_names.forth
			end

				-- Create new hole and fill with fresh annotations
			Result := hole_factory.new_hole (l_annotation_extractor.last_annotations, l_hole_type_string)
		end

end
