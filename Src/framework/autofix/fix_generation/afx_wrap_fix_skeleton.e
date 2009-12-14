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

	make (a_spot: AFX_EXCEPTION_SPOT; a_guard_condition: AFX_EXPRESSION)
			-- Initialize.
		require
			a_guard_condition_attached: a_guard_condition /= Void
		do
			exception_spot := a_spot
			create relevant_ast.make
			create fixes.make
			set_guard_condition (a_guard_condition)
		end

feature -- Status report

	is_wrap: BOOLEAN = True
			-- Is Current a wrap fix skeleton?

feature -- Basic operations

	generate
			-- Generate fixes and store result in `fixes'.
		local
			l_bpslot: INTEGER
			l_snippets: LINKED_LIST [ETR_TRANSFORMABLE]
			l_tran: ETR_TRANSFORMABLE
		do
				-- Decide the break point slot at which states in passing and failing runs should be compared.
			if relevant_ast.is_empty then
				l_bpslot := exception_spot.recipient_ast_structure.last_breakpoint_slot_number + 1
			else
				l_bpslot := relevant_ast.first.breakpoint_slot
			end

			create l_tran.make_with_node (Void, Void)
			create l_snippets.make
			l_snippets.extend (l_tran)
			generate_fixes (l_snippets)
		end

feature{NONE} -- Implementation

	generate_fixes (a_trans: LINKED_LIST [ETR_TRANSFORMABLE])
			-- Generate `fixes' from `a_trans'.
			-- `a_trans' is a list of transformable snippets containing the actual fixes.
			-- A standalone fix will be generated from a transformable.
		local
			l_fix_text: STRING
			l_fix: AFX_FIX
		do
			create fixes.make
			from
				a_trans.start
			until
				a_trans.after
			loop
				l_fix_text := "%Ndo_nothing%N"
				l_fix := fix_with_text (l_fix_text)

				io.put_string (l_fix.text)
				io.put_string ("%N-------------------------------------------%N")
				a_trans.forth
			end
		end

	fix_with_text (a_else_part: detachable STRING): AFX_FIX
			-- New text of `exception_spot'.`recipient_' with fix `a_fix' applied.
		local
			l_written_class: CLASS_C
			l_match_list: LEAF_AS_LIST

			l_first_as: AST_EIFFEL
			l_last_as: AST_EIFFEL

			l_then_text: STRING
			l_else_text: STRING
		do
			l_written_class := exception_spot.recipient_.written_class
			l_match_list := match_list_server.item (l_written_class.class_id)

			check not relevant_ast.is_empty end

				-- Decide the first and last AST node in `relevant_ast'.
			l_first_as := relevant_ast.first.ast.ast
			l_last_as := relevant_ast.last.ast.ast

			l_then_text := "if " + guard_condition.text + " then%N"
			l_first_as.prepend_text (l_then_text, l_match_list)

			create l_else_text.make (64)
			if a_else_part /= Void then
				l_else_text.append ("%Nelse%N")
				l_else_text.append (a_else_part)
			end
			l_else_text.append ("%Nend%N")

			l_last_as.append_text (l_else_text, l_match_list)

				-- Build result fix.
			create Result
			Result.set_exception_spot (exception_spot)
			Result.set_text (feature_body_compound_ast.text (l_match_list))
			l_match_list.undo_modifications
		end


end
