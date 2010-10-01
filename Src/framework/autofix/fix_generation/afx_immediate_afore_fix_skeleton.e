note
	description: "Summary description for {AFX_IMMEDIATE_WRAP_FIX_SKELETON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_IMMEDIATE_AFORE_FIX_SKELETON

inherit
	AFX_AFORE_FIX_SKELETON
		redefine
			generate
		end

create
	make

feature -- Access

	original_ast: detachable AST_EIFFEL
			-- AST node of the original code, which is going to be wrapped
			-- When Void, `new_ast' is appended at the end of the routine.

	new_ast: detachable AST_EIFFEL
			-- New AST node which is to be prepended to `original_ast'

feature -- Setting

	set_original_ast (a_ast: like original_ast)
			-- Set `original_ast' with `a_ast'.
		do
			original_ast := a_ast
		ensure
			original_ast_set: original_ast = a_ast
		end

	set_new_ast (a_ast: like new_ast)
			-- Set `new_ast' with `a_ast'.
		do
			new_ast := a_ast
		ensure
			new_ast_set: new_ast = a_ast
		end

feature -- Basic operations

	generate
			-- Generate fixes and store result in `fixes'.
		local
			l_fix: AFX_FIX
			l_text: STRING
			l_written_class: CLASS_C
			l_match_list: LEAF_AS_LIST
			l_ranking: AFX_FIX_RANKING
			l_gtext: STRING
		do
			create fixes.make
			l_written_class := exception_spot.recipient_written_class
			l_match_list := match_list_server.item (l_written_class.class_id)

				-- Construct fix snippet.
			create l_text.make (1024)
			if guard_condition /= Void then
				l_text.append ("%Nif ")
				l_gtext := guard_condition.text.twin
				l_gtext.replace_substring_all ("old ", "")
				l_text.append (l_gtext)
				l_text.append (" then%N")
			else
				l_text.append ("%N")
			end			
			l_text.append (text_from_ast (new_ast))
			if guard_condition /= Void then
				l_text.append ("%Nend%N")
			end

				-- Decide where to put the fix snippet.
			if attached {AST_EIFFEL} original_ast as l_original_ast then
				l_original_ast.prepend_text (l_text, l_match_list)
			else
				feature_body_compound_ast.append_text (l_text, l_match_list)
			end

				-- Construct fix.
			create l_fix.make (exception_spot, next_fix_id)
			l_fix.set_text (feature_body_compound_ast.text (l_match_list))
			l_fix.set_feature_text (feature_as_ast.text (l_match_list))
			l_fix.set_pre_fix_execution_status (test_case_execution_status)
			l_fix.set_skeleton_type ({AFX_FIX}.wrapping_skeleton_type)
			l_match_list.remove_modifications
			l_ranking := ranking.twin
			l_ranking.set_snippet_complexity (1)
			l_fix.set_ranking (l_ranking)

			fixes.extend (l_fix)
		end
end
