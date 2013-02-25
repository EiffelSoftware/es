note
	description: "Summary description for {AFX_STATE_CHANGE_SUBSTITUTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_STATE_CHANGE_SUBSTITUTOR

inherit
	SHARED_SERVER

	REFACTORING_HELPER

create
	default_create

feature -- Access

	last_operation_texts: DS_ARRAYED_LIST [STRING]
			-- Operation texts from last substitution.
		do
			if last_operation_texts_cache = Void then
				create last_operation_texts_cache.make_default
			end
			Result := last_operation_texts_cache
		end

feature{NONE} -- Cache

	last_operation_texts_cache: like last_operation_texts
			-- Cache for `last_operation_texts'.

feature -- Basic operation

	perform (a_requirement: AFX_STATE_CHANGE_REQUIREMENT; a_instruction: EPA_AST_STRUCTURE_NODE)
			-- Modify `a_instruction' according to the substitution defined by `a_requirement'.
		local
			l_src: EPA_EXPRESSION
			l_dest: EPA_EXPRESSION
			l_src_text: STRING
			l_dest_text: STRING
			l_instr_ast: AST_EIFFEL
			l_instr_text, l_new_instr_text: STRING
			l_match_list: LEAF_AS_LIST
			l_start_index, l_src_length: INTEGER

		do
			fixme("Traverse the AST for substitution.")

			last_operation_texts.wipe_out

			l_src := a_requirement.src_expr
			l_src_text := l_src.text
			l_dest := a_requirement.dest_expr
			l_dest_text := "(" + l_dest.text + ")"
			l_instr_ast := a_instruction.ast.ast
			l_match_list := match_list_server.item (a_instruction.feature_.written_class.class_id)
			l_instr_text := l_instr_ast.text_32 (l_match_list).twin

				-- Replace src_text with dest_text.
			from
				l_start_index := l_instr_text.substring_index (l_src_text, 1)
				l_src_length := l_src_text.count
			until l_start_index = 0
			loop
				l_new_instr_text := l_instr_text.twin
				l_new_instr_text.replace_substring (l_dest_text, l_start_index, l_start_index + l_src_length - 1)

					-- Add only valid instructions as candidate fixes.
				Parser_helper.parse_instruction (l_new_instr_text, a_instruction.written_class)
				if Parser_helper.parsed_instruction /= Void then
					last_operation_texts.force_last (l_new_instr_text)
				end

				l_start_index := l_instr_text.substring_index (l_src_text, l_start_index + 1)
			end
		end

feature

	Parser_helper: ETR_PARSING_HELPER
			-- Shared parser.
		once
			create Result
		end
end
