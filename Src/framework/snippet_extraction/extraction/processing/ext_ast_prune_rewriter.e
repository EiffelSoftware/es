note
	description: "Iterator to transform AST and remove nodes irrelevant w.r.t. the snippet."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_PRUNE_REWRITER

inherit
	ETR_AST_STRUCTURE_PRINTER
		redefine
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

	EXT_VARIABLE_CONTEXT_AWARE

	REFACTORING_HELPER

create
	make_with_arguments

feature {NONE} -- Creation

	make_with_arguments (a_output: like output; a_variable_context: like variable_context)
			-- Initialize with essential arguments.
		local
			l_variable_set: DS_HASH_SET [STRING]
		do
			make_with_output (a_output)
			variable_context := a_variable_context

			create l_variable_set.make_equal (10)
			variable_context.variables_of_interest.current_keys.do_all (agent l_variable_set.put)

			create variable_of_interest_usage_checker.make_from_variables (l_variable_set)
		end

feature {NONE} -- Implementation

	variable_of_interest_usage_checker: EXT_AST_VARIABLE_USAGE_CHECKER
			-- Checks if an AST is accessing any variable of interest.

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
			variable_of_interest_usage_checker.check_ast (a_as)
			if variable_of_interest_usage_checker.passed_check then
				Precursor (a_as)
			end
		end

	process_assign_as (a_as: ASSIGN_AS)
		do
			variable_of_interest_usage_checker.check_ast (a_as)
			if variable_of_interest_usage_checker.passed_check then
				Precursor (a_as)
			end
		end

	process_reverse_as (a_as: REVERSE_AS)
		do
			fixme ("Gather details about {REVERSE_AS} assignments.")
			variable_of_interest_usage_checker.check_ast (a_as)
			if variable_of_interest_usage_checker.passed_check then
				Precursor (a_as)
			end
		end

	process_creation_as (a_as: CREATION_AS)
		do
			variable_of_interest_usage_checker.check_ast (a_as)
			if variable_of_interest_usage_checker.passed_check then
				Precursor (a_as)
			end
		end

	process_case_as (a_as: CASE_AS)
		do
			variable_of_interest_usage_checker.check_ast (a_as)
			if variable_of_interest_usage_checker.passed_check then
				Precursor (a_as)
			end
		end

	process_if_as (a_as: IF_AS)
		local
			l_use_cond, l_use_branch_true, l_use_elsif_list, l_use_branch_false: BOOLEAN
			l_elsif_list: EIFFEL_LIST [ELSIF_AS]
		do
				-- Scan expression for variable usage.
			variable_of_interest_usage_checker.check_ast (a_as.condition)
			l_use_cond := variable_of_interest_usage_checker.passed_check

				-- Scan true branch
			if attached a_as.compound then
				variable_of_interest_usage_checker.check_ast (a_as.compound)
				l_use_branch_true := variable_of_interest_usage_checker.passed_check
			end

				-- Scan elseif list
			if attached a_as.elsif_list then
				create l_elsif_list.make (5)
					-- process all individual `{ELSIF_AS}' from list in reversed order.
					-- just remove the list item if no variables of interest were mentioned
					-- yet; this is because the list of expressions used before is
					-- necessary for simplifying the 'if' statement.
				across a_as.elsif_list.new_cursor.reversed as l_cursor loop
					variable_of_interest_usage_checker.check_ast (l_cursor.item)
					if l_use_elsif_list or variable_of_interest_usage_checker.passed_check then
							-- mark that at least one elseif has to be retained
						l_use_elsif_list := True
						l_elsif_list.put_front (l_cursor.item)
					end
				end
			end

				-- Scan false branch
			if attached a_as.else_part then
				variable_of_interest_usage_checker.check_ast (a_as.else_part)
				l_use_branch_false := variable_of_interest_usage_checker.passed_check
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
			l_use_switch, l_use_case_list, l_use_else_part: BOOLEAN
		do
			variable_of_interest_usage_checker.check_ast (a_as.switch)
			l_use_switch := variable_of_interest_usage_checker.passed_check

			if attached a_as.case_list as l_as then
				variable_of_interest_usage_checker.check_ast (l_as)
				l_use_case_list := variable_of_interest_usage_checker.passed_check
			end

			if attached a_as.else_part as l_as then
				variable_of_interest_usage_checker.check_ast (l_as)
				l_use_else_part := variable_of_interest_usage_checker.passed_check
			end

			if l_use_switch or l_use_case_list or l_use_else_part then
				output.append_string (ti_inspect_keyword+ti_New_line)
				process_child_block (a_as.switch, a_as, 1)
				output.append_string (ti_New_line)

				if l_use_case_list then
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
			variable_of_interest_usage_checker.check_ast (a_as)
			if variable_of_interest_usage_checker.passed_check then
				Precursor (a_as)
			end
		end

	process_loop_as (a_as: LOOP_AS)
		local
			l_use_iteration, l_use_stop, l_use_from_part, l_use_compound: BOOLEAN
		do
			if attached a_as.iteration as l_iteration_as then
				variable_of_interest_usage_checker.check_ast (l_iteration_as)
				l_use_iteration := variable_of_interest_usage_checker.passed_check
			end

			if attached a_as.stop as l_stop_as then
				variable_of_interest_usage_checker.check_ast (l_stop_as)
				l_use_stop := variable_of_interest_usage_checker.passed_check
			end

			if attached a_as.from_part as l_from_part_as then
				variable_of_interest_usage_checker.check_ast (l_from_part_as)
				l_use_from_part := variable_of_interest_usage_checker.passed_check
			end

			if attached a_as.compound as l_compound_as then
				variable_of_interest_usage_checker.check_ast (l_compound_as)
				l_use_compound := variable_of_interest_usage_checker.passed_check
			end

			if l_use_iteration or l_use_stop or l_use_from_part or l_use_compound then
				if processing_needed (a_as.iteration, a_as, 6) then
					output.append_string(ti_across_keyword+ti_New_line)
					process_child_block(a_as.iteration, a_as, 6)
					output.append_string (ti_New_line)
				end

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
