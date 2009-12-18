note
	description: "Summary description for {AFX_AFORE_FIX_SKELETON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_AFORE_FIX_SKELETON

inherit
	AFX_FIX_SKELETON
		redefine
			is_afore
		end

create
	make

feature{NONE} -- Initialization

	make (a_spot: AFX_EXCEPTION_SPOT)
			-- Initialize.
		do
			exception_spot := a_spot
			create relevant_ast.make
			create fixes.make
		end

feature -- Status report

	is_afore: BOOLEAN = True
			-- Is Current an afore fix skeleton?

	is_guard_ignorable: BOOLEAN
			-- Is `guard' ignorable?
			-- If True, the generated fix may not contain if-statement.

feature -- Basic operations

	relevant_break_points: TUPLE [passing_bpslot: INTEGER; failing_bpslot: INTEGER]
			-- Relevant break points, one for passing runs, one for failing runs.
			-- Those break points will be used to infer state invariants.
		local
			l_passing_bpslot: INTEGER
			l_failing_bpslot: INTEGER
		do
				-- Decide the break point slot at which states in passing and failing runs should be compared.
			if relevant_ast.is_empty then
				l_passing_bpslot := exception_spot.recipient_ast_structure.last_breakpoint_slot_number + 1
			else
				l_passing_bpslot := exception_spot.recipient_ast_structure.first_node_with_break_point(relevant_ast.first).breakpoint_slot
			end
			l_failing_bpslot := l_passing_bpslot
			Result := [l_passing_bpslot, l_failing_bpslot]
		end

feature{NONE} -- Implementation

	generate_fixes_from_snippet (a_snippets: LINKED_LIST [TUPLE [snippet: STRING_8; ranking: INTEGER_32]])
			-- Generate fixes from `a_snippets' and store result in `fixes'.
		local
			l_fix_text: STRING
		do
			from
				a_snippets.start
			until
				a_snippets.after
			loop
				l_fix_text := a_snippets.item_for_iteration.snippet.twin
				if attached {AFX_EXPRESSION} guard_condition as l_guard then
					l_fix_text.prepend ("if " + l_guard.text + " then%N%T%T")
					l_fix_text.append ("%Nend%N")
				end
				fixes.extend (fix_with_text ("%N" + l_fix_text, a_snippets.item_for_iteration.ranking))
				a_snippets.forth
			end
		end

	fix_with_text (a_text: STRING; a_snippet_ranking: INTEGER): AFX_FIX
			-- New text of `exception_spot'.`recipient_' with fix `a_fix' applied.
		local
			l_after_do: BOOLEAN
			l_anchor_as: AST_EIFFEL
			l_written_class: CLASS_C
			l_match_list: LEAF_AS_LIST
			l_ranking: like ranking
		do
			l_written_class := exception_spot.recipient_.written_class
			l_match_list := match_list_server.item (l_written_class.class_id)
			l_after_do := relevant_ast.is_empty

				-- Decide the anchor AST node to which `a_fix' is attached.
			if l_after_do then
					-- `a_fix' should be generated at the end of the feature body compound.
				l_anchor_as := feature_body_compound_ast
				l_anchor_as.append_text (a_text, l_match_list)
			else
					-- `a_fix' should be generated before the first node of `relevant_ast'.
				l_anchor_as := relevant_ast.first.ast.ast
				l_anchor_as.prepend_text (a_text, l_match_list)
			end

				-- Build result fix.
			create Result
			Result.set_exception_spot (exception_spot)
			Result.set_text (feature_body_compound_ast.text (l_match_list))
			l_match_list.remove_modifications
			l_ranking := ranking.twin
			l_ranking.set_snippet_complexity (a_snippet_ranking)
		end

end
