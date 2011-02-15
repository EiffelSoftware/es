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
		rename
			exception_spot as exception_spot_not_used
		end

	AFX_SHARED_DYNAMIC_ANALYSIS_REPORT

	AFX_PROGRAM_EXECUTION_INVARIANT_ACCESS_MODE

	SHARED_SERVER

	AFX_FIX_ID_SERVER

	INTERNAL_COMPILER_STRING_EXPORTER

	AFX_FIX_SKELETON_CONSTANT

	REFACTORING_HELPER

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize.
		do
		end

feature -- Access

feature -- Basic operations

	generate
			-- <Precursor>
		local
			l_fixing_targets: DS_ARRAYED_LIST [AFX_FIXING_TARGET]
			l_ranking_cursor: DS_ARRAYED_LIST_CURSOR [AFX_FIXING_TARGET]
			l_target: AFX_FIXING_TARGET
			l_max_target, l_max_fix: INTEGER
			l_count: INTEGER
		do
			--Initialize.
			create fix_skeletons.make
			create fixes.make

			l_fixing_targets := fixing_target_list
			l_max_target := config.max_fixing_target
			l_max_fix := config.max_fix_candidate
			from
				l_ranking_cursor := l_fixing_targets.new_cursor
				l_ranking_cursor.start
--				l_ranking_cursor.forth
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
			-- Generate fixes for `a_target',
			--		put the skeletons into `fix_skeletons'.
		require
			target_attached: a_target /= Void
		local
			l_guard_conditions: DS_ARRAYED_LIST [TUPLE[AFX_PROGRAM_STATE_EXPRESSION, DOUBLE]]
			l_relevant_asts: LINKED_LIST [TUPLE [scope_level: INTEGER_32; instructions: LINKED_LIST [AFX_AST_STRUCTURE_NODE]]]
			l_requirements: DS_ARRAYED_LIST [AFX_STATE_CHANGE_REQUIREMENT]
--			l_operations: DS_ARRAYED_LIST [AFX_FIXING_OPERATION]
			l_condition: TUPLE[AFX_PROGRAM_STATE_EXPRESSION, DOUBLE]
			l_requirement: AFX_STATE_CHANGE_REQUIREMENT
--			l_operation: AFX_FIXING_OPERATION
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

						generate_one_fix (l_condition, l_requirement, l_instructions)

						l_relevant_asts.forth
					end

					l_requirements.forth
				end
				l_guard_conditions.forth
			end
		end

--	generate_one_fix (a_target: AFX_FIXING_TARGET; a_instructions: LINKED_LIST [AFX_AST_STRUCTURE_NODE])
--			-- Generate one fix using `a_condition', `a_operation' around `a_instructions'.
--			-- Put the generated fix into `fixes'.
--		local
--			l_guard_conditions: DS_ARRAYED_LIST [AFX_PROGRAM_STATE_EXPRESSION]
--			l_requirements: DS_ARRAYED_LIST [AFX_STATE_CHANGE_REQUIREMENT]
--			l_con: AFX_PROGRAM_STATE_EXPRESSION
--			l_req: AFX_STATE_CHANGE_REQUIREMENT
--			l_written_class: CLASS_C
--			l_match_list: LEAF_AS_LIST
--			l_first_as, l_last_as: AST_EIFFEL
--			l_state_change_assigner: AFX_STATE_CHANGE_ASSIGNER
--			l_state_change_substitutor: AFX_STATE_CHANGE_SUBSTITUTOR
--			l_fix_operation_texts: DS_ARRAYED_LIST [STRING]
--			l_if_instruction: STRING
--			l_feature_body_with_fix: STRING
--			l_feature_text_with_fix: STRING
--			l_fix: AFX_FIX
--			l_fix_ranking: AFX_FIX_RANKING
--		do
--			l_guard_conditions := guard_conditions_for_target (a_target)
--			l_requirements := change_requirements_for_target (a_target)

--			if not l_guard_conditions.is_empty and then not l_requirements.is_empty then
--				l_written_class := exception_spot.recipient_.written_class
--				l_match_list := match_list_server.item (l_written_class.class_id)
--				l_first_as := a_instructions.first.ast.ast
--				l_last_as := a_instructions.last.ast.ast

--				from l_guard_conditions.start
--				until l_guard_conditions.after
--				loop
--					l_con := l_guard_conditions.item_for_iteration

--					from l_requirements.start
--					until l_requirements.after
--					loop
--						l_req := l_requirements.item_for_iteration

--						l_fix_operation_texts := l_state_change_assigner.assignment_texts

--						-- Fix including an if-structure before the instructions.
--						if a_instructions.count = 1 then
--							-- Generate afore fixes.
--							l_if_instruction := "if " + l_con.text + " then%N" + a_operation.operation_text + "%Nend%N"
--							l_first_as.prepend_text (l_if_instruction, l_match_list)
--							l_feature_body_with_fix := feature_body_compound_ast.text (l_match_list).twin
--							l_feature_text_with_fix := feature_as_ast.text (l_match_list)
--							create l_fix.make (exception_spot, next_fix_id)
--							l_fix.set_text (l_feature_body_with_fix)
--							l_fix.set_feature_text (l_feature_text_with_fix)
--							l_fix.set_pre_fix_execution_status (test_case_execution_status)
--							l_fix.set_skeleton_type ({AFX_FIX}.Afore_skeleton_type)

--							create l_fix_ranking
--							l_fix_ranking.set_relevance_to_failure (a_operation.fixing_target.rank)
--							l_fix_ranking.set_fix_skeleton_complexity (afore_skeleton_complexity)
--							l_fix_ranking.set_scope_levels (1)
--							l_fix.set_ranking (l_fix_ranking)

--							fixes.force_last (l_fix)
--							l_match_list.remove_modifications

--							-- Generate substitution fixes.

--						end


--						l_requirements.forth
--					end
--					l_guard_conditions.forth
--				end



--			end


--		end

	generate_one_fix (a_condition: TUPLE[exp: AFX_PROGRAM_STATE_EXPRESSION; cat: DOUBLE]; a_requirement: AFX_STATE_CHANGE_REQUIREMENT; a_instructions: LINKED_LIST [AFX_AST_STRUCTURE_NODE])
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
			l_written_class := exception_spot.recipient_.written_class
			l_match_list := match_list_server.item (l_written_class.class_id)
			l_first_as := a_instructions.first.ast.ast
			l_last_as := a_instructions.last.ast.ast

			create l_state_change_assigner
			l_state_change_assigner.generate_assignment (a_requirement)
			l_assignment_operations := l_state_change_assigner.last_operation_texts

			-- Not fix operation specific.
			-- 		if not (failing_condition) then original_instr end
			l_if_instruction := "if not(" + a_condition.exp.text + ") then%N"
			l_first_as.prepend_text (l_if_instruction, l_match_list)
			l_last_as.append_text ("%Nend%N", l_match_list)
			l_feature_body_with_fix := feature_body_compound_ast.text (l_match_list).twin
			l_feature_text_with_fix := feature_as_ast.text (l_match_list).twin
			create l_fix.make (exception_spot, next_fix_id)
			l_fix.set_text (l_feature_body_with_fix)
			l_fix.set_feature_text (l_feature_text_with_fix)
			l_fix.set_pre_fix_execution_status (test_case_execution_status)
			l_fix.set_skeleton_type ({AFX_FIX}.Wrapping_skeleton_type)

			create l_fix_ranking
			l_fix_ranking.set_relevance_to_failure (a_requirement.fixing_target.rank)
			l_fix_ranking.set_fix_skeleton_complexity (wrapping_skeleton_complexity)
			l_fix_ranking.set_scope_levels (1)
			l_fix_ranking.set_fix_condition_category (a_condition.cat)
			l_fix.set_ranking (l_fix_ranking)

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

					l_if_instruction := "if " + a_condition.exp.text + " then%N" + l_operation + "%Nend%N"
					l_first_as.prepend_text (l_if_instruction, l_match_list)
					l_feature_body_with_fix := feature_body_compound_ast.text (l_match_list).twin
					l_feature_text_with_fix := feature_as_ast.text (l_match_list).twin
					create l_fix.make (exception_spot, next_fix_id)
					l_fix.set_text (l_feature_body_with_fix)
					l_fix.set_feature_text (l_feature_text_with_fix)
					l_fix.set_pre_fix_execution_status (test_case_execution_status)
					l_fix.set_skeleton_type ({AFX_FIX}.Afore_skeleton_type)

					create l_fix_ranking
					l_fix_ranking.set_relevance_to_failure (a_requirement.fixing_target.rank)
					l_fix_ranking.set_fix_skeleton_complexity (afore_skeleton_complexity)
					l_fix_ranking.set_scope_levels (1)
					l_fix_ranking.set_fix_condition_category (a_condition.cat)
					l_fix.set_ranking (l_fix_ranking)

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

					l_if_instruction := "if " + a_condition.exp.text + " then%N" + l_operation + "%Nelse%N"
					l_first_as.prepend_text (l_if_instruction, l_match_list)
					l_last_as.append_text ("%Nend%N", l_match_list)
					l_feature_body_with_fix := feature_body_compound_ast.text (l_match_list).twin
					l_feature_text_with_fix := feature_as_ast.text (l_match_list).twin
					create l_fix.make (exception_spot, next_fix_id)
					l_fix.set_text (l_feature_body_with_fix)
					l_fix.set_feature_text (l_feature_text_with_fix)
					l_fix.set_pre_fix_execution_status (test_case_execution_status)
					l_fix.set_skeleton_type ({AFX_FIX}.Wrapping_skeleton_type)

					create l_fix_ranking
					l_fix_ranking.set_relevance_to_failure (a_requirement.fixing_target.rank)
					l_fix_ranking.set_fix_skeleton_complexity (wrapping_skeleton_complexity)
					l_fix_ranking.set_scope_levels (1)
					l_fix_ranking.set_fix_condition_category (a_condition.cat)
					l_fix.set_ranking (l_fix_ranking)

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

				l_if_instruction := "if " + a_condition.exp.text + " then%N" + l_operation + "%Nelse%N"
				l_first_as.prepend_text (l_if_instruction, l_match_list)
				l_last_as.append_text ("%Nend%N", l_match_list)
				l_feature_body_with_fix := feature_body_compound_ast.text (l_match_list).twin
				l_feature_text_with_fix := feature_as_ast.text (l_match_list).twin
				create l_fix.make (exception_spot, next_fix_id)
				l_fix.set_text (l_feature_body_with_fix)
				l_fix.set_feature_text (l_feature_text_with_fix)
				l_fix.set_pre_fix_execution_status (test_case_execution_status)
				l_fix.set_skeleton_type ({AFX_FIX}.Wrapping_skeleton_type)

				create l_fix_ranking
				l_fix_ranking.set_relevance_to_failure (a_requirement.fixing_target.rank)
				l_fix_ranking.set_fix_skeleton_complexity (wrapping_skeleton_complexity)
				l_fix_ranking.set_scope_levels (1)
				l_fix_ranking.set_fix_condition_category (a_condition.cat)
				l_fix.set_ranking (l_fix_ranking)

				fixes.force_last (l_fix)
				l_match_list.remove_modifications

				l_assignment_operations.forth
			end
		end

	feature_body_compound_ast: EIFFEL_LIST [INSTRUCTION_AS]
			-- AST node for body of exception_spot.`recipient_'
			-- It is the compound part of a DO_AS.
			-- (from AFX_FIX_SKELETON)
			-- (export status {NONE})
		do
			if attached {BODY_AS} exception_spot.recipient_.body.body as l_body then
				if attached {ROUTINE_AS} l_body.content as l_routine then
					if attached {DO_AS} l_routine.routine_body as l_do then
						Result := l_do.compound
					end
				end
			end
		end

	feature_as_ast: FEATURE_AS
			-- AST for feature exception_spot.`recipient_'
			-- (from AFX_FIX_SKELETON)
			-- (export status {NONE})
		do
			Result := exception_spot.recipient_.e_feature.ast
		end

	change_requirements_for_target (a_target: AFX_FIXING_TARGET): DS_ARRAYED_LIST [AFX_STATE_CHANGE_REQUIREMENT]
			-- State change requirements regarding one fixing target.
		require
			target_attached: a_target /= Void
		local
			l_generator: AFX_STATE_CHANGE_REQUIREMENT_GENERATOR
		do
			create Result.make_default

			create l_generator
			l_generator.generate_change_requirements (a_target)
			Result.append_last (l_generator.last_generated_requirements)
		end

--	fixing_operations_for_target (a_target: AFX_FIXING_TARGET): DS_ARRAYED_LIST [AFX_FIXING_OPERATION]
--			-- Fixing operations for `a_target'.
--		require
--			target_attached: a_target /= Void
--		local
--			l_generator: AFX_FIXING_OPERATION_GENERATOR
--			l_substitutor: AFX_FIX_BY_SUBSTITUTION_GENERATOR
--			l_failing_location: INTEGER
--			l_failing_instr: AFX_AST_STRUCTURE_NODE
--		do
--			create Result.make_default

--			-- Generate necessary changes.


--			-- Operations that try to modify object states.
--			create l_generator
--			l_generator.generate_fixing_operations (a_target)
--			l_generator.last_fixing_operations.do_all (agent Result.force_last)

--			-- Operations that substitute bad objects in case of precondition-violation.
--			if current.exception_spot.exception_code = {EXCEP_CONST}.Precondition then
--				l_failing_location := exception_spot.failing_assertion_break_point_slot
--				l_failing_instr := exception_spot.recipient_ast_structure.node_at_break_point (l_failing_location)
--				create l_substitutor
--				l_substitutor.generate_substitution (a_target, l_failing_instr)
--				l_substitutor.last_substitution.do_all (agent Result.force_last)
--			end
--		end

	guard_conditions_for_target (a_target: AFX_FIXING_TARGET): DS_ARRAYED_LIST [TUPLE[AFX_PROGRAM_STATE_EXPRESSION,DOUBLE]]
			-- Guard conditions that can be used in fixes regarding `a_target'.
			-- Such conditions are from failing_invariants - passing_invariants.
			-- The conditions are sorted in decreasing order of their relevance to the fixing target.
			-- An expression sharing more common sub-expressions with the target is ranked higher.
		require
			target_attached: a_target /= Void
		local
			l_expressions: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			l_expression_cursor: DS_HASH_SET_CURSOR [AFX_PROGRAM_STATE_EXPRESSION]
			l_expression: AFX_PROGRAM_STATE_EXPRESSION
			l_sub_invariants, l_sub_targets: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			l_collector: AFX_PROGRAM_STATE_EXPRESSION_COLLECTOR
			l_invariants: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			l_most_relevant_invariant: TUPLE [inv: AFX_PROGRAM_STATE_EXPRESSION; rel: REAL_64]
			l_list_of_invariants_and_relevance: DS_ARRAYED_LIST [TUPLE [AFX_PROGRAM_STATE_EXPRESSION, REAL_64]]
			l_invariants_cursor: DS_HASH_SET_CURSOR [AFX_PROGRAM_STATE_EXPRESSION]
			l_inv: AFX_PROGRAM_STATE_EXPRESSION
			l_num_of_common_sub_expressions: INTEGER
			l_relevance: REAL_64
			l_equality_tester: AGENT_BASED_EQUALITY_TESTER [TUPLE [AFX_PROGRAM_STATE_EXPRESSION, REAL_64]]
			l_sorter: DS_QUICK_SORTER [TUPLE [AFX_PROGRAM_STATE_EXPRESSION, REAL_64]]
		do
			create Result.make (3)

			-- One possible condition is the `most_relevant_fixing_condition' associated with `a_target'.
			if a_target.most_relevant_fixing_condition = Void then
				-- Target expression itself should be a boolean expression.
				l_expressions := a_target.expressions
			else
				l_expressions := a_target.most_relevant_fixing_condition.expressions
			end
			check one_boolean_expression: l_expressions.count = 1 and then l_expressions.first.type.is_boolean end
			Result.force_last ([l_expressions.first, {AFX_FIX_RANKING}.fix_condition_category_evidence])

			-- Another possible condition is the most relevant invariant assocated with `a_target'.
			l_invariants := invariants_at (exception_spot.recipient_class_, exception_spot.recipient_, a_target.bp_index, Invariant_failing_only)
			if l_invariants /= Void then
				-- Set of sub-expressions from fixing target expressions.
				create l_sub_targets.make (10)
				l_sub_targets.set_equality_tester (program_state_expression_equality_tester)
				create l_collector.default_create
				from
					l_expressions := a_target.expressions
					l_expression_cursor := l_expressions.new_cursor
					l_expression_cursor.start
				until
					l_expression_cursor.after
				loop
					l_expression := l_expression_cursor.item

					l_collector.collect_from_expression (l_expression.class_, l_expression.feature_, l_expression.ast, True)
					l_sub_targets.append (l_collector.last_collection_in_written_class)

					l_expression_cursor.forth
				end

				-- Find the most relevant invariant.
				-- The relevance is defined as the number of common sub-expressions between the inv and the fixing target expressions.
				from
					l_invariants_cursor := l_invariants.new_cursor
					l_invariants_cursor.start
					l_most_relevant_invariant := [Void, 0.0]
				until
					l_invariants_cursor.after
				loop
					l_inv := l_invariants_cursor.item

					if l_inv /= Void then
						l_collector.collect_from_expression (l_inv.class_, l_inv.feature_, l_inv.ast, True)
						l_sub_invariants := l_collector.last_collection_in_written_class
						l_num_of_common_sub_expressions := l_sub_invariants.intersection (l_sub_targets).count
						l_relevance := l_num_of_common_sub_expressions / (l_sub_invariants.count + l_sub_targets.count - l_num_of_common_sub_expressions)

						if l_relevance > l_most_relevant_invariant.rel then
							l_most_relevant_invariant := [l_inv, l_relevance]
						end
					end

					l_invariants_cursor.forth
				end
				if l_most_relevant_invariant.inv /= Void then
					Result.force_last ([l_most_relevant_invariant.inv, {AFX_FIX_RANKING}.fix_condition_category_invariant])
				end
			end

--			-- Since we add the "failing_assertion" into expression set, this is no longer necessary.
--			-- Third option is to use the failed assertion.
--			create l_expression.make_with_text (exception_spot.recipient_class_, exception_spot.recipient_, "not (" + exception_spot.failing_assertion.text + ")",
--					exception_spot.recipient_written_class, a_target.bp_index)
--			Result.force_last ([l_expression, {AFX_FIX_RANKING}.fix_condition_category_assertion])
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
			l_spot: like exception_spot
			l_node: AFX_AST_STRUCTURE_NODE
			l_node_list: LINKED_LIST [AFX_AST_STRUCTURE_NODE]
		do
			create Result.make

			l_spot := exception_spot
			l_scope_level := 1

			-- Node list containing only the instruction right after the position of `a_target'.
			l_bp_index := a_target.bp_index
			l_node := l_spot.recipient_ast_structure.surrounding_instruction (l_bp_index)
			create l_node_list.make
			l_node_list.force (l_node)
			Result.force ([l_scope_level, l_node_list])

			-- Node list containing all instructions after `a_target', but within the same instruction list.
			if attached {LINKED_LIST [AFX_AST_STRUCTURE_NODE]} l_spot.recipient_ast_structure.instructions_in_block_as (l_node) as lt_list and then lt_list.count > 1 then
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
