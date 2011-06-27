note
	description: "Iterator to transform AST and remove nodes irrelevant w.r.t. the snippet."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_PRUNE_REWRITER

inherit
	ETR_AST_STRUCTURE_PRINTER
		redefine
			make_with_output,
				-- List of instructions
			process_assigner_call_as,
			process_assign_as,
			process_check_as,
			process_creation_as,
			process_debug_as,
--			process_guard_as,
			process_if_as,
			process_inspect_as,
			process_instr_call_as,
			process_loop_as,
--			process_retry_as,
			process_reverse_as,
				-- Other AST nodes
			process_case_as
		end

	EXT_AST_UTILITY

	REFACTORING_HELPER

create
	make_with_output

feature {NONE} -- Creation

	make_with_output (a_output: like output)
			-- Make with `a_output'..
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

feature {NONE} -- Unconditional Pruning

	process_check_as (l_as: CHECK_AS)
		do
			-- do nothing
		end

	process_debug_as (l_as: DEBUG_AS)
		do
			-- do nothing
		end

feature {NONE} -- Conditional Pruning

	process_assigner_call_as (a_as: ASSIGNER_CALL_AS)
		do
			if is_ast_eiffel_using_variable_of_interest (a_as, variable_context) then
				Precursor (a_as)
			end
		end

	process_assign_as (a_as: ASSIGN_AS)
		do
			if is_ast_eiffel_using_variable_of_interest (a_as, variable_context) then
				Precursor (a_as)
			end
		end

	process_reverse_as (a_as: REVERSE_AS)
		do
			fixme ("Gather details about {REVERSE_AS} assignments.")
			if is_ast_eiffel_using_variable_of_interest (a_as, variable_context) then
				Precursor (a_as)
			end
		end

	process_creation_as (a_as: CREATION_AS)
		do
			if is_ast_eiffel_using_variable_of_interest (a_as, variable_context) then
				Precursor (a_as)
			end
		end

	process_case_as (a_as: CASE_AS)
		do
			if is_ast_eiffel_using_variable_of_interest (a_as, variable_context) then
				Precursor (a_as)
			end
		end

	process_if_as (a_as: IF_AS)
		local
			l_use_cond, l_use_branch_true, l_use_elsif_list, l_use_branch_false: BOOLEAN
			l_elsif_list: EIFFEL_LIST [ELSIF_AS]
		do
				-- Scan expression for variable usage.
			l_use_cond := is_ast_eiffel_using_variable_of_interest (a_as.condition, variable_context)

				-- Scan true branch
			if attached a_as.compound then
				l_use_branch_true := is_ast_eiffel_using_variable_of_interest (a_as.compound, variable_context)
			end

				-- Scan elseif list
			if attached a_as.elsif_list then
				create l_elsif_list.make (5)
					-- process all individual `{ELSIF_AS}' from list in reversed order.
					-- just remove the list item if no variables of interest were mentioned
					-- yet; this is because the list of expressions used before is
					-- necessary for simplifying the 'if' statement.
				across a_as.elsif_list.new_cursor.reversed as l_cursor loop
					if l_use_elsif_list or is_ast_eiffel_using_variable_of_interest (l_cursor.item, variable_context) then
							-- mark that at least one elseif has to be retained
						l_use_elsif_list := True
						l_elsif_list.put_front (l_cursor.item)
					end
				end
			end

				-- Scan false branch
			if attached a_as.else_part then
				l_use_branch_false := is_ast_eiffel_using_variable_of_interest (a_as.else_part, variable_context)
			end

				-- Based on structural information w.r.t. the subtrees, annotate `{IF_AS}'.
			if l_use_cond or l_use_branch_true or l_use_elsif_list or l_use_branch_false then
				output.append_string (ti_if_keyword+ti_Space)
				process_child (a_as.condition, a_as, 1)
				output.append_string (ti_Space+ti_then_keyword+ti_New_line)

				if l_use_branch_true then
					process_child_block_list (a_as.compound, void, a_as, 2)
				end

				if l_use_elsif_list then
					process_child (l_elsif_list, a_as, 3)
				end

				if l_use_branch_false then
					output.append_string(ti_else_keyword+ti_New_line)
					process_child_block_list(a_as.else_part, void, a_as, 4)
				end
				output.append_string (ti_End_keyword+ti_New_line)
			end
		end

	process_inspect_as (a_as: INSPECT_AS)
		local
			l_use_else_part: BOOLEAN
		do
			if is_ast_eiffel_using_variable_of_interest (a_as, variable_context) then

				if attached a_as.else_part then
					l_use_else_part := is_ast_eiffel_using_variable_of_interest (a_as.else_part, variable_context)
				end

				output.append_string (ti_inspect_keyword+ti_New_line)
				process_child_block (a_as.switch, a_as, 1)
				output.append_string (ti_New_line)

				if processing_needed (a_as.case_list, a_as, 2) then
					process_child (a_as.case_list, a_as, 2)
				end

				if l_use_else_part then
					output.append_string (ti_else_keyword+ti_New_line)
					process_child_block (a_as.else_part, a_as, 3)
				end

				output.append_string (ti_End_keyword+ti_New_line)
			end
		end

	process_instr_call_as (a_as: INSTR_CALL_AS)
		do
			if is_ast_eiffel_using_variable_of_interest (a_as, variable_context) then
				Precursor (a_as)
			end
		end

	process_loop_as (a_as: LOOP_AS)
		local
			l_use_stop, l_use_from_part, l_use_compound: BOOLEAN
		do
			if attached a_as.stop as l_stop_as then
				l_use_stop := is_ast_eiffel_using_variable_of_interest (l_stop_as, variable_context)
			end

			if attached a_as.from_part as l_from_part_as then
				l_use_from_part := is_ast_eiffel_using_variable_of_interest (l_from_part_as, variable_context)
			end

			if attached a_as.compound as l_compound_as then
				l_use_compound := is_ast_eiffel_using_variable_of_interest (l_compound_as, variable_context)
			end

			if l_use_stop or l_use_from_part or l_use_compound then
					-- Remove iteration.
--				if processing_needed (a_as.iteration, a_as, 6) then
--					output.append_string(ti_across_keyword+ti_New_line)
--					process_child_block(a_as.iteration, a_as, 6)
--					output.append_string (ti_New_line)
--				end

				if processing_needed (a_as.from_part, a_as, 1) or not processing_needed (a_as.iteration, a_as, 6) then
					output.append_string(ti_from_keyword+ti_New_line)
				end

				if processing_needed (a_as.from_part, a_as, 1) then
					process_child_block(a_as.from_part, a_as, 1)
				end

					-- Remove invariant.
--				if processing_needed (a_as.full_invariant_list, a_as, 2) then
--					output.append_string (ti_invariant_keyword+ti_New_line)
--					process_child_block_list(a_as.full_invariant_list, void, a_as, 2)
--					output.append_string (ti_New_line)
--				end

					-- Remove variant.
--				if processing_needed (a_as.variant_part, a_as, 5) then
--					output.append_string (ti_variant_keyword+ti_New_line)
--					process_child_block(a_as.variant_part, a_as, 5)
--					output.append_string (ti_New_line)
--				end

				if processing_needed (a_as.stop, a_as, 3) then
					output.append_string (ti_until_keyword+ti_New_line)
					process_child_block (a_as.stop, a_as, 3)
					output.append_string (ti_New_line)
				end

				output.append_string (ti_loop_keyword+ti_New_line)

				if processing_needed (a_as.compound, a_as, 4) then
					process_child_block_list(a_as.compound, void, a_as, 4)
				end

				output.append_string (ti_End_keyword+ti_New_line)
			end
		end

end
