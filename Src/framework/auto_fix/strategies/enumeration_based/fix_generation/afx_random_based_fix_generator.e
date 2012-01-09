note
	description: "Summary description for {AFX_RANDOM_BASED_FIX_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_RANDOM_BASED_FIX_GENERATOR

inherit

	AFX_SHARED_SESSION

	AFX_FIX_GENERATOR

	AFX_SHARED_DYNAMIC_ANALYSIS_REPORT

	AFX_PROGRAM_EXECUTION_INVARIANT_ACCESS_MODE

	SHARED_SERVER

	AFX_FIX_ID_SERVER

	INTERNAL_COMPILER_STRING_EXPORTER

	AFX_FIX_SKELETON_CONSTANT

	REFACTORING_HELPER

feature -- Basic operations

	generate
			-- <Precursor>
		local
			l_fixing_targets: DS_ARRAYED_LIST [AFX_FIXING_TARGET]
			l_ranking_cursor: DS_ARRAYED_LIST_CURSOR [AFX_FIXING_TARGET]
			l_target: AFX_FIXING_TARGET
			l_max_target, l_max_fix: INTEGER
			l_count: INTEGER
			l_parser: ETR_PARSING_HELPER
			l_fixes: like fixes
			l_fix: AFX_FIX
			l_fix_text: STRING
		do
				--Initialize.
			create fix_skeletons.make
			create fixes.make

				-- Generate from (at most) `max_fixing_target's (at most) `max_fix_candidate' fixes.
			l_fixing_targets := fixing_target_list
			l_max_target := config.max_fixing_target
			l_max_fix := config.max_fix_candidate
			from
				l_ranking_cursor := l_fixing_targets.new_cursor
				l_ranking_cursor.start
				l_count := 0
			until
				l_ranking_cursor.after
					or else (l_max_target /= 0 and then l_count > l_max_target)
					or else (l_max_fix /= 0 and then fixes.count > l_max_fix)
			loop
				l_target := l_ranking_cursor.item

				generate_fixes_for_target (l_target)

				l_count := l_count + 1
				l_ranking_cursor.forth
			end
		end

	generate_fixes_for_target (a_target: AFX_FIXING_TARGET)
			-- Generate fixes for `a_target'. Generated fixes are put into `fixes'.
		require
			target_attached: a_target /= Void
		local
			l_guard_conditions: DS_ARRAYED_LIST [EPA_EXPRESSION]
			l_relevant_asts: LINKED_LIST [TUPLE [scope_level: INTEGER_32; instructions: LINKED_LIST [AFX_AST_STRUCTURE_NODE]]]
			l_requirements: DS_ARRAYED_LIST [AFX_STATE_CHANGE_REQUIREMENT]
			l_condition: EPA_EXPRESSION
			l_requirement: AFX_STATE_CHANGE_REQUIREMENT
			l_instructions: LINKED_LIST [AFX_AST_STRUCTURE_NODE]
		do
			l_guard_conditions := guard_conditions_for_target (a_target)
			l_relevant_asts := relevant_asts_for_a_target (a_target)
			l_requirements := change_requirements_for_target (a_target)

			from l_guard_conditions.start
			until l_guard_conditions.after
			loop
				l_condition := l_guard_conditions.item_for_iteration

				from l_requirements.start
				until l_requirements.after
				loop
					l_requirement := l_requirements.item_for_iteration

					from l_relevant_asts.start
					until l_relevant_asts.after
					loop
						l_instructions := l_relevant_asts.item_for_iteration.instructions

						generate_one_fix (a_target, l_condition, l_requirement, l_instructions)

						l_relevant_asts.forth
					end

					l_requirements.forth
				end
				l_guard_conditions.forth
			end
		end

	generate_one_fix (a_target: AFX_FIXING_TARGET; a_condition: EPA_EXPRESSION; a_requirement: AFX_STATE_CHANGE_REQUIREMENT; a_instructions: LINKED_LIST [AFX_AST_STRUCTURE_NODE])
			-- Generate one fix using `a_condition', `a_requirement' around `a_instructions'.
			-- Put the generated fix into `fixes'.
		local
			l_written_class: CLASS_C
			l_match_list: LEAF_AS_LIST
			l_first_as, l_last_as: AST_EIFFEL
			l_state_change_assigner: AFX_STATE_CHANGE_ASSIGNER
			l_state_change_substitutor: AFX_STATE_CHANGE_SUBSTITUTOR
			l_assignment_operations: DS_ARRAYED_LIST [STRING]
			l_substitution_operations: DS_ARRAYED_LIST [STRING]
			l_operation: STRING
			l_instr: AFX_AST_STRUCTURE_NODE
			l_if_instruction: STRING
			l_feature_body_with_fix: STRING
			l_feature_text_with_fix: STRING
			l_fix: AFX_FIX
			l_fix_ranking: AFX_FIX_RANKING
		do
			l_written_class := exception_signature.recipient_feature.written_class
			l_match_list := match_list_server.item (l_written_class.class_id)
			l_first_as := a_instructions.first.ast.ast
			l_last_as := a_instructions.last.ast.ast

			create l_state_change_assigner
			l_state_change_assigner.generate_assignment (a_requirement)
			l_assignment_operations := l_state_change_assigner.last_operation_texts

				-- Not fix operation specific.
				-- 		if not (failing_condition) then original_instr end
			l_if_instruction := "if not(" + a_condition.text + ") then%N"
			l_first_as.prepend_text (l_if_instruction, l_match_list)
			l_last_as.append_text ("%Nend%N", l_match_list)
			l_feature_body_with_fix := exception_recipient_feature.body_compound_ast.text (l_match_list).twin
			l_feature_text_with_fix := exception_recipient_feature.feature_as_ast.text (l_match_list).twin
			create l_fix.make (next_fix_id)
			l_fix.set_text (l_feature_body_with_fix)
			l_fix.set_feature_text (l_feature_text_with_fix)
			l_fix.set_pre_fix_execution_status (test_case_execution_status)
			l_fix.set_skeleton_type ({AFX_FIX}.Wrapping_skeleton_type)

			create l_fix_ranking
			l_fix_ranking.set_relevance_to_failure (a_target.rank)
			l_fix_ranking.set_fix_skeleton_complexity (wrapping_skeleton_complexity)
			l_fix_ranking.set_scope_levels (1)
			l_fix.set_ranking (l_fix_ranking)

			l_fix.set_fixing_target (a_target)
			fixes.force_last (l_fix)
			l_match_list.remove_modifications

				-- The following two fixing schema are only applied when `a_instructions' has only one instruction:
			if a_instructions.count = 1 then
				l_instr := a_instructions.first

					-- Fix operation specific.
					-- 		if failing_condi then fix_op end
				from l_assignment_operations.start
				until l_assignment_operations.after
				loop
					l_operation := l_assignment_operations.item_for_iteration

					l_if_instruction := "if " + a_condition.text + " then%N" + l_operation + "%Nend%N"
					l_first_as.prepend_text (l_if_instruction, l_match_list)
					l_feature_body_with_fix := exception_recipient_feature.body_compound_ast.text (l_match_list).twin
					l_feature_text_with_fix := exception_recipient_feature.feature_as_ast.text (l_match_list).twin
					create l_fix.make (next_fix_id)
					l_fix.set_text (l_feature_body_with_fix)
					l_fix.set_feature_text (l_feature_text_with_fix)
					l_fix.set_pre_fix_execution_status (test_case_execution_status)
					l_fix.set_skeleton_type ({AFX_FIX}.Afore_skeleton_type)

					create l_fix_ranking
					l_fix_ranking.set_relevance_to_failure (a_target.rank)
					l_fix_ranking.set_fix_skeleton_complexity (afore_skeleton_complexity)
					l_fix_ranking.set_scope_levels (1)
					l_fix.set_ranking (l_fix_ranking)

					l_fix.set_fixing_target (a_target)
					fixes.force_last (l_fix)
					l_match_list.remove_modifications

					l_assignment_operations.forth
				end

					-- Fix by substitution.
					--		if failing_condi then fix_by_substitution else original_instru end
				create l_state_change_substitutor
				l_state_change_substitutor.perform (a_requirement, l_instr)
				l_substitution_operations := l_state_change_substitutor.last_operation_texts
				from l_substitution_operations.start
				until l_substitution_operations.after
				loop
					l_operation := l_substitution_operations.item_for_iteration

					l_if_instruction := "if " + a_condition.text + " then%N" + l_operation + "%Nelse%N"
					l_first_as.prepend_text (l_if_instruction, l_match_list)
					l_last_as.append_text ("%Nend%N", l_match_list)
					l_feature_body_with_fix := exception_recipient_feature.body_compound_ast.text (l_match_list).twin
					l_feature_text_with_fix := exception_recipient_feature.feature_as_ast.text (l_match_list).twin
					create l_fix.make (next_fix_id)
					l_fix.set_text (l_feature_body_with_fix)
					l_fix.set_feature_text (l_feature_text_with_fix)
					l_fix.set_pre_fix_execution_status (test_case_execution_status)
					l_fix.set_skeleton_type ({AFX_FIX}.Wrapping_skeleton_type)

					create l_fix_ranking
					l_fix_ranking.set_relevance_to_failure (a_target.rank)
					l_fix_ranking.set_fix_skeleton_complexity (wrapping_skeleton_complexity)
					l_fix_ranking.set_scope_levels (1)
					l_fix.set_ranking (l_fix_ranking)

					l_fix.set_fixing_target (a_target)
					fixes.force_last (l_fix)
					l_match_list.remove_modifications

					l_substitution_operations.forth
				end
			end

				-- Fix including an if-structure surrounding the instructions.
				-- 		if failing_condition then fixing_operation else original_instr end
			from l_assignment_operations.start
			until l_assignment_operations.after
			loop
				l_operation := l_assignment_operations.item_for_iteration

				l_if_instruction := "if " + a_condition.text + " then%N" + l_operation + "%Nelse%N"
				l_first_as.prepend_text (l_if_instruction, l_match_list)
				l_last_as.append_text ("%Nend%N", l_match_list)
				l_feature_body_with_fix := exception_recipient_feature.body_compound_ast.text (l_match_list).twin
				l_feature_text_with_fix := exception_recipient_feature.feature_as_ast.text (l_match_list).twin
				create l_fix.make (next_fix_id)
				l_fix.set_text (l_feature_body_with_fix)
				l_fix.set_feature_text (l_feature_text_with_fix)
				l_fix.set_pre_fix_execution_status (test_case_execution_status)
				l_fix.set_skeleton_type ({AFX_FIX}.Wrapping_skeleton_type)

				create l_fix_ranking
				l_fix_ranking.set_relevance_to_failure (a_target.rank)
				l_fix_ranking.set_fix_skeleton_complexity (wrapping_skeleton_complexity)
				l_fix_ranking.set_scope_levels (1)
				l_fix.set_ranking (l_fix_ranking)

				l_fix.set_fixing_target (a_target)
				fixes.force_last (l_fix)
				l_match_list.remove_modifications

				l_assignment_operations.forth
			end
		end

	change_requirements_for_target (a_target: AFX_FIXING_TARGET): DS_ARRAYED_LIST [AFX_STATE_CHANGE_REQUIREMENT]
			-- State change requirements regarding one fixing target.
		require
			target_attached: a_target /= Void
		do
			if attached {AFX_PROGRAM_STATE_ASPECT} a_target.expression as lv_aspect then
				Result := lv_aspect.derived_change_requirements
			else
				create Result.make_default
			end
		end

	guard_conditions_for_target (a_target: AFX_FIXING_TARGET): DS_ARRAYED_LIST [EPA_EXPRESSION]
			-- Guard conditions that can be used in fixes regarding `a_target'.
			-- Such conditions are from failing_invariants - passing_invariants.
			-- The conditions are sorted in decreasing order of their relevance to the fixing target.
			-- An expression sharing more common sub-expressions with the target is ranked higher.
		require
			target_attached: a_target /= Void
		do
			create Result.make (3)
			Result.force_last (a_target.expression)
		end

feature{NONE} -- Implementation operations

	relevant_asts_for_a_target (a_target: AFX_FIXING_TARGET): LINKED_LIST [TUPLE [scope_level: INTEGER_32; instructions: LINKED_LIST [AFX_AST_STRUCTURE_NODE]]]
			-- Relevant asts regarding the breakpoint position of `a_target'.
			-- For the moment, we only try to generate fixes before `a_target' or surrounding the single node or all the following nodes in the
			--	current instruction list.
		require
			target_attached: a_target /= Void
			valid_position: a_target.bp_index > 0
		local
			l_list: LINKED_LIST [TUPLE [scope_level: INTEGER_32; instructions: LINKED_LIST [AFX_AST_STRUCTURE_NODE]]]
			l_tuple: TUPLE [scope_level: INTEGER_32; instructions: LINKED_LIST [AFX_AST_STRUCTURE_NODE]]
			l_bp_index, l_scope_level: INTEGER
			l_signature: like exception_signature
			l_recipient: like exception_recipient_feature
			l_node: AFX_AST_STRUCTURE_NODE
			l_node_list: LINKED_LIST [AFX_AST_STRUCTURE_NODE]
		do
			create Result.make

			l_signature := exception_signature
			l_recipient := exception_recipient_feature
			l_scope_level := 1

				-- Node list containing only the instruction right after the position of `a_target'.
			l_bp_index := a_target.bp_index
			l_node := l_recipient.ast_structure.surrounding_instruction (l_bp_index)
			create l_node_list.make
			l_node_list.force (l_node)
			Result.force ([l_scope_level, l_node_list])

				-- Node list containing all instructions after `a_target', but within the same instruction list.
			if attached {LINKED_LIST [AFX_AST_STRUCTURE_NODE]} l_recipient.ast_structure.instructions_in_block_as (l_node) as lt_list and then lt_list.count > 1 then
				create l_node_list.make
				from lt_list.start
				until lt_list.after
				loop
					l_node := lt_list.item_for_iteration
					if l_node.breakpoint_slot >= l_bp_index then
						l_node_list.force (l_node)
					end
					lt_list.forth
				end
				if l_node_list.count > 1 then
					Result.force ([l_scope_level, l_node_list])
				end
			end
		end

feature{NONE} -- Implementation attributes

	fixing_locations: LINKED_LIST [TUPLE [scope_level: INTEGER; instructions: LINKED_LIST [AFX_AST_STRUCTURE_NODE]]]
			-- List of ASTs which will be involved in a fix.
			-- Item in the inner list `instructions' is a list of ASTs, they represent the ASTs whilch will be involved in a fix.
			-- `scope_level' is the scope level difference from `instructions' to the failing point. If `instructions' are in
			-- the same basic block as the failing point, `scope_level' will be 1. `scope_level' will be increased by 1, every time
			-- `instructions' goes away for the failing point. `scope_leve' is used for fix ranking.
			-- The outer list is needed because there may be more than one fixing locations.

end
