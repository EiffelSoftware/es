note
	description: "Summary description for {AFX_WRAP_FIX_SKELETON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_WRAP_FIX_SKELETON

inherit
	AFX_FIX_SKELETON
		redefine
			is_wrap
		end

create
	make

feature{NONE} -- Initialization

	make (a_spot: AFX_EXCEPTION_SPOT; a_guard_condition: AFX_EXPRESSION; a_config: like config; a_test_case_execution_status: like test_case_execution_status; a_guard_in_negation: BOOLEAN)
			-- Initialize.
		require
			a_guard_condition_attached: a_guard_condition /= Void
			a_config_attached: a_config /= Void
		do
			exception_spot := a_spot
			create relevant_ast.make
			create fixes.make
			set_guard_condition (a_guard_condition)
			config := a_config
			test_case_execution_status := a_test_case_execution_status
			set_is_guard_condition_in_negation_form (a_guard_in_negation)
		end

feature -- Access

	relevant_break_points: TUPLE [passing_bpslot: INTEGER; failing_bpslot: INTEGER]
			-- Relevant break points, one for passing runs, one for failing runs.
			-- Those break points will be used to infer state invariants.
		local
			l_passing_bpslot: INTEGER
			l_failing_bpslot: INTEGER
			l_last_wrapped_bpslot: INTEGER
			l_last_node: detachable AFX_AST_STRUCTURE_NODE
		do
				-- Decide the break point slot at which states in passing and failing runs should be compared.
			if relevant_ast.is_empty then
				check should_not_happen: False end
			else
				l_failing_bpslot := exception_spot.recipient_ast_structure.first_node_with_break_point (relevant_ast.first).breakpoint_slot
				if attached {AFX_AST_STRUCTURE_NODE} exception_spot.recipient_ast_structure.last_node_with_break_point (relevant_ast.last) as l_node then
					l_passing_bpslot := exception_spot.recipient_ast_structure.next_break_point (l_node.breakpoint_slot)
					if l_passing_bpslot = 0 then
						l_passing_bpslot := exception_spot.recipient_.number_of_breakpoint_slots
					end
				else
					l_passing_bpslot := exception_spot.recipient_.number_of_breakpoint_slots
				end
			end


			Result := [l_passing_bpslot, l_failing_bpslot]
		end

feature -- Status report

	is_wrap: BOOLEAN = True
			-- Is Current a wrap fix skeleton?

feature{NONE} -- Implementation

	generate_fixes_from_snippet (a_snippets: LINKED_LIST [TUPLE [snippet: STRING_8; ranking: INTEGER_32]]; a_precondition: AFX_STATE; a_postcondition: AFX_STATE; a_ignore_state_change: BOOLEAN)
			-- Generate fixes from `a_snippets' and store result in `fixes'.
		local
			l_fix_text: STRING
		do
				-- Insert a case where the else-branch is empty.
			fixes.extend (fix_with_text (Void, 0, a_precondition, a_postcondition))

				-- Insert fixes which tries to change state.
			if not a_ignore_state_change and then a_snippets /= Void then
				from
					a_snippets.start
				until
					a_snippets.after
				loop
					l_fix_text := a_snippets.item_for_iteration.snippet.twin
					if not l_fix_text.is_empty then
						fixes.extend (fix_with_text ("%N" + l_fix_text + "%N", a_snippets.item_for_iteration.ranking, a_precondition, a_postcondition))
					end
					a_snippets.forth
				end
			end
		end

	fix_with_text (a_else_part: detachable STRING; a_snippet_ranking: INTEGER; a_precondition: AFX_STATE; a_postcondition: AFX_STATE): AFX_FIX
			-- New text of `exception_spot'.`recipient_' with fix `a_fix' applied.
			-- `a_precondition' and `a_postcondition' are used to provide better logging information.
		local
			l_written_class: CLASS_C
			l_match_list: LEAF_AS_LIST

			l_first_as: AST_EIFFEL
			l_last_as: AST_EIFFEL

			l_then_text: STRING
			l_else_text: STRING
			l_ranking: AFX_FIX_RANKING
			l_gtext: STRING
		do
			l_written_class := exception_spot.recipient_.written_class
			l_match_list := match_list_server.item (l_written_class.class_id)

			check not relevant_ast.is_empty end

				-- Decide the first and last AST node in `relevant_ast'.
			l_first_as := relevant_ast.first.ast.ast
			l_last_as := relevant_ast.last.ast.ast

			l_gtext := guard_condition.text.twin
			l_gtext.replace_substring_all ("old ", "")
			l_then_text := "if " + l_gtext + " then%N"
			l_first_as.prepend_text (l_then_text, l_match_list)

			create l_else_text.make (64)
			if a_else_part /= Void then
				l_else_text.append ("%Nelse%N")
				l_else_text.append (a_else_part)
			end
			l_else_text.append ("%Nend%N")

			l_last_as.append_text (l_else_text, l_match_list)

				-- Build result fix.
			create Result.make (exception_spot, next_fix_id)
			Result.set_exception_spot (exception_spot)
			Result.set_text (feature_body_compound_ast.text (l_match_list))
			Result.set_feature_text (feature_as_ast.text (l_match_list))
			Result.set_precondition (a_precondition)
			Result.set_postcondition (a_postcondition)
			Result.set_pre_fix_execution_status (test_case_execution_status)
			Result.set_skeleton_type ({AFX_FIX}.wrapping_skeleton_type)
			l_match_list.remove_modifications
			l_ranking := ranking.twin
			l_ranking.set_snippet_complexity (a_snippet_ranking)
			Result.set_ranking (l_ranking)
		end

end
