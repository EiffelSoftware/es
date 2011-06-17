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
--			process_elseif_as,
			process_if_as,
			process_inspect_as,
			process_instr_call_as,
			process_loop_as
--			process_retry_as
		end

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
			if is_ast_eiffel_using_variable_of_interest (l_as) then
				Precursor (l_as)
			else
				annotation_context.add_annotation (l_as.path, annotation_factory.new_ann_prune)
			end
		end

	process_assign_as (l_as: ASSIGN_AS)
		require else
			l_as_path_not_void: attached l_as.path
		do
			if is_ast_eiffel_using_variable_of_interest (l_as) then
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
			if is_ast_eiffel_using_variable_of_interest (l_as) then
				Precursor (l_as)
			else
				annotation_context.add_annotation (l_as.path, annotation_factory.new_ann_prune)
			end
		end

	process_creation_as (l_as: CREATION_AS)
		require else
			l_as_path_not_void: attached l_as.path
		do
			if is_ast_eiffel_using_variable_of_interest (l_as) then
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

--	process_elseif_as (l_as: ELSIF_AS)
--		require else
--			l_as_path_not_void: attached l_as.path
--		do
--			if is_ast_eiffel_using_variable_of_interest (l_as) then
--				Precursor (l_as)
--			else
--				annotation_context.add_annotation (l_as.path, annotation_factory.new_ann_prune)
--			end
--		end

	process_if_as (l_as: IF_AS)
		local
			l_use_cond, l_use_branch_true, l_use_elsif_list, l_use_branch_false: BOOLEAN
		do
				-- Scan expression for variable usage.
			l_use_cond := is_ast_eiffel_using_variable_of_interest (l_as.condition)

				-- Scan and annotate true branch
			if attached l_as.compound then
				l_use_branch_true := is_ast_eiffel_using_variable_of_interest (l_as.compound)

				if l_use_branch_true then
					l_as.compound.process (Current)
				else
						-- prune it: no variables of interest used
					annotation_context.add_annotation (l_as.compound.path, annotation_factory.new_ann_prune)
				end
			end

				-- Scan and annotate elseif list
			if attached l_as.elsif_list then
					-- process all individual `{ELSIF_AS}' from list
				across l_as.elsif_list as l_elsif_list loop
					if is_ast_eiffel_using_variable_of_interest (l_elsif_list.item) then
							-- mark that at least one elseif has to be retained
						l_use_elsif_list := True
						l_elsif_list.item.process (Current)
					else
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
				l_use_branch_false := is_ast_eiffel_using_variable_of_interest (l_as.else_part)

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
			if is_ast_eiffel_using_variable_of_interest (l_as) then
				Precursor (l_as)
			else
				annotation_context.add_annotation (l_as.path, annotation_factory.new_ann_prune)
			end
		end

	process_inspect_as (l_as: INSPECT_AS)
		require else
			l_as_path_not_void: attached l_as.path
		do
			if is_ast_eiffel_using_variable_of_interest (l_as) then
				l_as.switch.process (Current)
				safe_process (l_as.case_list)
					-- Check if else part is using variables of interest. If not, it will be removed.
				if attached l_as.else_part as l_else_part and then not is_ast_eiffel_using_variable_of_interest (l_else_part) then
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
			l_use_compound: BOOLEAN
		do
				-- Check if loop body is using variables of interest. If not, the whole
				-- loop is removed.
			if attached l_as.compound as l_compound_as then
				l_use_compound := is_ast_eiffel_using_variable_of_interest (l_compound_as)
			end

			if l_use_compound then
				Precursor (l_as)
			else
				annotation_context.add_annotation (l_as.path, annotation_factory.new_ann_prune)
			end
		end

feature {NONE} -- Helper

	is_ast_eiffel_using_variable_of_interest (a_as: AST_EIFFEL): BOOLEAN
			-- AST iterator processing `a_as' answering if a variable of interest is used in that AST.
		local
			l_variable_usage: LINKED_SET [STRING]
			l_variable_usage_finder: EXT_IDENTIFIER_USAGE_CALLBACK_SERVICE
		do
				-- Set up callback to track variable usage in arguments.
			create l_variable_usage.make

			create l_variable_usage_finder
			l_variable_usage_finder.set_is_mode_disjoint (False)
			l_variable_usage_finder.set_on_access_identifier (
				agent (l_as: ACCESS_AS; a_variable_usage: LINKED_SET [STRING])
					do
						if variable_context.is_variable_of_interest (l_as.access_name_8) then
							a_variable_usage.force (l_as.access_name_8)
						end
					end (?, l_variable_usage)
			)

			a_as.process (l_variable_usage_finder)

			Result := not l_variable_usage.is_empty
		end

end
