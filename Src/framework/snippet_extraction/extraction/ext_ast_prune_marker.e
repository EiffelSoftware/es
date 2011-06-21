note
	description: "Iterator deciding on statement level if to keep or reject it."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_PRUNE_MARKER

inherit
	AST_ITERATOR
		redefine
			process_assigner_call_as,
			process_assign_as,
			process_case_as,
			process_check_as,
			process_creation_as,
			process_debug_as,
--			process_guard_as,
			process_if_as,
			process_inspect_as,
			process_instr_call_as,
			process_loop_as
--			process_retry_as
		end

	EXT_AST_UTILITY

	REFACTORING_HELPER

create
	make

feature {NONE} -- Initialization

	make
			-- Default initialization.
		do
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

	annotation_context: EXT_ANNOTATION_CONTEXT
		assign set_annotation_context
			-- Contextual information about relevant variables.

	set_annotation_context (a_context: EXT_ANNOTATION_CONTEXT)
			-- Sets `annotation_context' to `a_context'	
		require
			attached a_context
		do
			annotation_context := a_context
		end

	annotation_factory: EXT_ANNOTATION_FACTORY
			-- Annotation factory to create new typed annotation instances.

feature {NONE} -- Unconditional Pruning

	process_check_as (l_as: CHECK_AS)
		require else
			l_as_path_not_void: attached l_as.path
		do
			annotation_context.add_annotation (l_as.path, annotation_factory.new_ann_prune)
		end

	process_debug_as (l_as: DEBUG_AS)
		require else
			l_as_path_not_void: attached l_as.path
		do
			annotation_context.add_annotation (l_as.path, annotation_factory.new_ann_prune)
		end

feature {NONE} -- Conditional Pruning (w.r.t. Variable Usage)

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
		require else
			l_as_path_not_void: attached l_as.path
		do
			if is_ast_eiffel_using_variable_of_interest (l_as, variable_context) then
				Precursor (l_as)
			else
				annotation_context.add_annotation (l_as.path, annotation_factory.new_ann_prune)
			end
		end

	process_assign_as (l_as: ASSIGN_AS)
		require else
			l_as_path_not_void: attached l_as.path
		do
			if is_ast_eiffel_using_variable_of_interest (l_as, variable_context) then
				Precursor (l_as)
			else
				annotation_context.add_annotation (l_as.path, annotation_factory.new_ann_prune)
			end
		end

--	process_guard_as (l_as: GUARD_AS)
--		require else
--			l_as_path_not_void: attached l_as.path
--		do
--			if is_ast_eiffel_using_variable_of_interest (l_as) then
--				Precursor (l_as)
--			else
--				annotation_context.add_annotation (l_as.path, annotation_factory.new_ann_prune)
--			end
--		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
		require else
			l_as_path_not_void: attached l_as.path
		do
			if is_ast_eiffel_using_variable_of_interest (l_as, variable_context) then
				Precursor (l_as)
			else
				annotation_context.add_annotation (l_as.path, annotation_factory.new_ann_prune)
			end
		end

	process_creation_as (l_as: CREATION_AS)
		require else
			l_as_path_not_void: attached l_as.path
		do
			if is_ast_eiffel_using_variable_of_interest (l_as, variable_context) then
				Precursor (l_as)
			else
				annotation_context.add_annotation (l_as.path, annotation_factory.new_ann_prune)
			end
		end

--	process_retry_as (l_as: RETRY_AS)
--		require else
--			l_as_path_not_void: attached l_as.path
--		do
--			if is_ast_eiffel_using_variable_of_interest (l_as) then
--				Precursor (l_as)
--			else
--				annotation_context.add_annotation (l_as.path, annotation_factory.new_ann_prune)
--			end
--		end

feature {NONE} -- Conditional Pruning (w.r.t. Structural Evaluation)

	process_if_as (l_as: IF_AS)
		local
			l_use_cond, l_use_branch_true, l_use_elsif_list, l_use_branch_false: BOOLEAN
		do
				-- Scan expression for variable usage.
			l_use_cond := is_ast_eiffel_using_variable_of_interest (l_as.condition, variable_context)

				-- Scan and annotate true branch
			if attached l_as.compound then
				l_use_branch_true := is_ast_eiffel_using_variable_of_interest (l_as.compound, variable_context)

				if l_use_branch_true then
					l_as.compound.process (Current)
				else
						-- prune it: no variables of interest used
					annotation_context.add_annotation (l_as.compound.path, annotation_factory.new_ann_prune)
				end
			end

				-- Scan and annotate elseif list
			if attached l_as.elsif_list then
					-- process all individual `{ELSIF_AS}' from list in reversed order.
					-- just remove the list item if no variables of interest were mentioned
					-- yet; this is because the list of expressions used before is
					-- necessary for simplifying the 'if' statement.
				across l_as.elsif_list.new_cursor.reversed as l_elsif_list loop
					if is_ast_eiffel_using_variable_of_interest (l_elsif_list.item, variable_context) then
							-- mark that at least one elseif has to be retained
						l_use_elsif_list := True
						l_elsif_list.item.process (Current)
					elseif not l_use_elsif_list then
							-- prune it: no variables of interest used
						annotation_context.add_annotation (l_elsif_list.item.path, annotation_factory.new_ann_prune)
					end
				end

					-- process `{ELSIF_AS}' list
				if not l_use_elsif_list then
						-- prune it: no variables of interest used
					annotation_context.add_annotation (l_as.elsif_list.path, annotation_factory.new_ann_prune)
				end
			end

				-- Scan and annotate false branch
			if attached l_as.else_part then
				l_use_branch_false := is_ast_eiffel_using_variable_of_interest (l_as.else_part, variable_context)

				if l_use_branch_false then
					l_as.else_part.process (Current)
				else
						-- prune it: no variables of interest used
					annotation_context.add_annotation (l_as.else_part.path, annotation_factory.new_ann_prune)
				end
			end

				-- Based on structural information w.r.t. the subtrees, annotate `{IF_AS}'.
			if not (l_use_cond or l_use_branch_true or l_use_elsif_list or l_use_branch_false) then
					-- prune it: no variables of interest used at all in if statement
				annotation_context.add_annotation (l_as.path, annotation_factory.new_ann_prune)
			end

			fixme ("Create a hole if only the expression but not the body mentions a variable of interest.")
		end

	process_case_as (l_as: CASE_AS)
		require else
			l_as_path_not_void: attached l_as.path
		do
			if is_ast_eiffel_using_variable_of_interest (l_as, variable_context) then
				Precursor (l_as)
			else
				annotation_context.add_annotation (l_as.path, annotation_factory.new_ann_prune)
			end
		end

	process_inspect_as (l_as: INSPECT_AS)
		require else
			l_as_path_not_void: attached l_as.path
		do
			if is_ast_eiffel_using_variable_of_interest (l_as, variable_context) then
				l_as.switch.process (Current)
				safe_process (l_as.case_list)
					-- Check if else part is using variables of interest. If not, it will be removed.
				if attached l_as.else_part as l_else_part and then not is_ast_eiffel_using_variable_of_interest (l_else_part, variable_context) then
					annotation_context.add_annotation (l_else_part.path, annotation_factory.new_ann_prune)
				end
			else
				annotation_context.add_annotation (l_as.path, annotation_factory.new_ann_prune)
			end
		end

	process_loop_as (l_as: LOOP_AS)
		require else
			l_as_path_not_void: attached l_as.path
		local
			l_use_stop, l_use_from_part, l_use_compound: BOOLEAN
		do
				-- Remove iteration.
			if attached l_as.iteration as l_iteration_as then
				annotation_context.add_annotation (l_iteration_as.path, annotation_factory.new_ann_prune)
			end

			if attached l_as.stop as l_stop_as then
				l_use_stop := is_ast_eiffel_using_variable_of_interest (l_stop_as, variable_context)
				l_stop_as.process (Current)
			end

			if attached l_as.from_part as l_from_part_as then
				l_use_from_part := is_ast_eiffel_using_variable_of_interest (l_from_part_as, variable_context)
				l_from_part_as.process (Current)
			end

				-- Remove invariant.
			if attached l_as.invariant_part as l_invariant_part_as then
				annotation_context.add_annotation (l_invariant_part_as.path, annotation_factory.new_ann_prune)
			end

			if attached l_as.compound as l_compound_as then
				l_use_compound := is_ast_eiffel_using_variable_of_interest (l_compound_as, variable_context)
				l_compound_as.process (Current)
			end

				-- Remove variant.
			if attached l_as.variant_part as l_variant_part_as then
				annotation_context.add_annotation (l_variant_part_as.path, annotation_factory.new_ann_prune)
			end

			if not (l_use_stop or l_use_from_part or l_use_compound) then
				annotation_context.add_annotation (l_as.path, annotation_factory.new_ann_prune)
			end
		end

end
