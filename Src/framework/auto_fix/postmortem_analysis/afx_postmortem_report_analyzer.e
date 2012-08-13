note
	description: "Summary description for {AFX_POSTMORTEM_REPORT_ANALYZER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_POSTMORTEM_REPORT_ANALYZER

inherit
	EPA_UTILITY

	REFACTORING_HELPER

create
	make

feature{NONE} -- Initialization

	make (a_file: FILE_NAME; a_config: AFX_CONFIG)
			-- Initialization.
		require
			file_valid: a_file /= Void and then a_file.is_valid
		do
			file_name := a_file.twin
			output_dir := a_config.postmortem_analysis_output_dir
		end

feature -- Access

	file_name: FILE_NAME
			-- Name of the file associated to the record.

	result_records: DS_LINKED_LIST [AFX_POSTMORTEM_ANALYSIS_RECORD]
			-- List of result records from `file_name'.

feature -- Basic operation

	analyze_report
			-- Analyze the report in `file_name', and make the records available in `result_records'.
		local
			l_fixes: DS_LINKED_LIST[TUPLE[INTEGER, BOOLEAN, STRING]]
		do
			create result_records.make
			parse_file_name
			save_ast (recipient_feature_with_context.feature_.body, "original")
			l_fixes := fixes_from_file
			l_fixes.do_all (agent (a_fix: TUPLE[INTEGER, BOOLEAN, STRING]) do analysis_record_for_fix (a_fix) end)
		end

feature{NONE} -- Parsing

	base_name: STRING
			-- Base name of the report.

	fix_under_analysis: TUPLE[starting_ln: INTEGER; is_proper: BOOLEAN; text: STRING]
			-- List of fixes from `file_name.

	class_under_test_str: STRING
			-- Name of the class under test.

	feature_under_test_str: STRING
			-- Name of the feature under test.

	exception_code: INTEGER
			-- Exception code.

	breakpoint: INTEGER
			-- Breakpoint index.

	recipient_class_str: STRING
			-- Name of the recipient class.

	recipient_feature_str: STRING
			-- Name of the recipient feature.

	feature_under_test_with_context: EPA_FEATURE_WITH_CONTEXT_CLASS
			-- Feature under test.

	recipient_feature_with_context: EPA_FEATURE_WITH_CONTEXT_CLASS
			-- Recipient feature.

	recipient_feature_ast_structure_node: AFX_FEATURE_AST_STRUCTURE_NODE
			-- Structure node for the recipient feature.

	parse_file_name
			-- Parse the file name to get the information on the target fault.
		require
			file_name_valid: file_name /= VOid and then file_name.is_valid
		local
			l_str, l_base_name: STRING
			l_full_name_length, l_extension_length: INTEGER
			l_sep_loc: INTEGER
			l_segs: LIST[STRING]
			l_class: CLASS_C
		do
				-- Get the base file name.
			l_str := file_name.out
			l_full_name_length := l_str.count
			l_sep_loc := l_str.last_index_of ('/', l_full_name_length).max (l_str.last_index_of ('\', l_full_name_length)) + 1
			l_extension_length := 7 	-- Length of ".proper"
			l_str := l_str.substring (l_sep_loc, l_full_name_length - l_extension_length)
			base_name := l_str.twin

			l_str.replace_substring_all ("__", ",")
			l_segs := l_str.split (',')
			check l_segs.count = 6 end
			class_under_test_str := l_segs[1]
			feature_under_test_str := l_segs[2]
			exception_code := l_segs[3].to_integer
			recipient_class_str := l_segs[5]
			recipient_class_str.remove_substring (1, 4)
			recipient_feature_str := l_segs[6]

			fixme("HACK: hard-coded breakpoint locations in recipients for precondition violations.")
			if exception_code = {EXCEP_CONST}.Precondition then
				breakpoint := mapping_precondition_violations_to_breakpoints_in_recipient.item (base_name)
			else
				breakpoint := l_segs[4].to_integer
			end

			create feature_under_test_with_context.make (feature_from_class (class_under_test_str, feature_under_test_str), first_class_starts_with_name (class_under_test_str))
			create recipient_feature_with_context.make (feature_from_class (recipient_class_str, recipient_feature_str), first_class_starts_with_name (recipient_class_str))

			structure_generator.generate (recipient_feature_with_context.context_class, recipient_feature_with_context.feature_)
			recipient_feature_ast_structure_node := structure_generator.structure
		end

	fixes_from_file: DS_LINKED_LIST[TUPLE[INTEGER, BOOLEAN, STRING]]
			-- (Possibly empty) list of fixes from `file_name'.
			-- Each fix consists of the number of its starting line in the file, and its text.
		local
			l_file: PLAIN_TEXT_FILE
			l_in_fix, l_is_proper: BOOLEAN
			l_line_no, l_starting_ln: INTEGER
			l_str, l_fix: STRING
		do
			create Result.make
			create l_file.make_open_read (file_name)
			if l_file.is_open_read then
				from
					l_file.read_line
					l_line_no := 1
				until l_file.end_of_file
				loop
					l_str := l_file.last_string

					if not l_in_fix and then l_str.starts_with (fix_beginning_tag) then
						create l_fix.make (512)
						l_starting_ln := l_line_no
						l_in_fix := True
						l_is_proper := l_str.has_substring ("proper")
					elseif l_in_fix and then l_str ~ fix_ending_tag then
						Result.force_last ([l_starting_ln, l_is_proper, l_fix])
						l_in_fix := False
					elseif l_in_fix then
						l_fix.append (l_str + "%N")
					end

					l_file.readline
					l_line_no := l_line_no + 1
				end
				l_file.close
			end
		end

	fix_beginning_tag: STRING
			-- Tag marking the begin of a fix.
		once
			Result := ">> valid_fix_candidate_start_tag <<"
		end

	fix_ending_tag: STRING
			-- Tag marking the end of a fix.
		once
			Result := ">> valid_fix_candidate_end_tag <<"
		end

feature{NONE} -- Analysis

	has_found_difference: BOOLEAN

	analysis_record_for_fix (a_fix: TUPLE[starting_ln: INTEGER; is_proper: BOOLEAN; text: STRING])
			-- Analysis record for the recipient feature, w.r.t. `a_fix'.
		require
			fix_not_empty: a_fix /= Void and then not a_fix.is_empty
		local
			l_original_structure, l_fixed_structure: AFX_FEATURE_AST_STRUCTURE_NODE
			l_fixed_feature_as: FEATURE_AS
		do
			l_original_structure := recipient_feature_ast_structure_node
			Entity_feature_parser.parse_from_utf8_string ("feature " + a_fix.text, Void)
			l_fixed_feature_as := Entity_feature_parser.feature_node
			if l_fixed_feature_as /= Void and then l_fixed_feature_as.feature_name.name ~ recipient_feature_str then
				fixme ("Bypass the cases where AutoFix didn't fix the right feature.")
				structure_generator.generate_from_feature_as (recipient_feature_with_context.context_class, recipient_feature_with_context.feature_, l_fixed_feature_as)
				l_fixed_structure := structure_generator.structure

				has_found_difference := False
				fix_under_analysis := a_fix
				compare_structure_node (l_original_structure, l_fixed_structure)
				save_ast (l_fixed_feature_as, fix_under_analysis.starting_ln.out)
			end
		end

	summary_string_for_structure_node (a_node: AFX_AST_STRUCTURE_NODE): STRING
			-- Concise string capturing the high level summay of `a_node'.
		do
			if a_node.is_check then
				Result := "check"
			elseif a_node.is_debug then
				Result := "debug"
			elseif a_node.is_elseif then
				Result := "elseif"
			elseif a_node.is_inspect then
				Result := "inspect"
			elseif a_node.is_loop then
				Result := "loop"
			elseif a_node.is_if and then attached {IF_AS} a_node.ast.ast as l_if then
				Result := "if " + text_from_ast (l_if.condition)
			elseif a_node.is_feature_node then
				Result := "feature"
			elseif a_node.is_instruction and then attached {INSTRUCTION_AS} a_node.ast.ast as l_instr then
				Result := text_from_ast (l_instr)
			end
		end

	mapping_precondition_violations_to_breakpoints_in_recipient: DS_HASH_TABLE[INTEGER, STRING]
			-- Table mapping report names for preconditions to the breakpoint indexes in the recipient feature.
		once
			create Result.make_equal (50)
			Result.force(6, "ACTIVE_LIST__update_for_added__3__1__REC_ACTIVE_LIST__update_for_added")
			Result.force(4, "ACTIVE_LIST__update_for_added__3__3__REC_ACTIVE_LIST__update_for_added")
			Result.force(1, "ARRAYED_CIRCULAR__duplicate__3__1__REC_ARRAYED_CIRCULAR__new_chain")
			Result.force(13, "ARRAYED_SET__move_item__3__1__REC_ARRAYED_SET__move_item")
			Result.force(14, "ARRAYED_SET__move_item__3__2__REC_ARRAYED_SET__move_item")
			Result.force(1, "ARRAY__filled_with__3__3__REC_ARRAY__filled_with")
			Result.force(4, "ARRAY__keep_tail__3__6__REC_ARRAY__keep_tail")
			Result.force(7, "ARRAY__subcopy__3__4__REC_ARRAY__subcopy")
			Result.force(7, "ARRAY__subcopy__3__6__REC_ARRAY__subcopy")
			Result.force(7, "ARRAY__subcopy__3__7__REC_ARRAY__subcopy")
			Result.force(2, "DS_ARRAYED_LIST__keep_last__3__1__REC_DS_ARRAYED_LIST__prune_first")
			Result.force(4, "DS_ARRAYED_LIST__prune_left__3__1__REC_DS_ARRAYED_LIST__prune_left_cursor")
			Result.force(4, "DS_ARRAYED_LIST__prune_right__3__1__REC_DS_ARRAYED_LIST__prune_right_cursor")
			Result.force(11, "DS_HASH_SET__forth__3__1__REC_DS_HASH_SET__cursor_forth")
			Result.force(9, "TWO_WAY_SORTED_SET__duplicate__3__2__REC_TWO_WAY_SORTED_SET__duplicate")
			Result.force(14, "TWO_WAY_SORTED_SET__intersect__3__1__REC_TWO_WAY_SORTED_SET__intersect")
			Result.force(16, "TWO_WAY_SORTED_SET__merge__3__1__REC_TWO_WAY_SORTED_SET__merge")
			Result.force(11, "TWO_WAY_SORTED_SET__subtract__3__1__REC_TWO_WAY_SORTED_SET__subtract")
			Result.force(4, "EDL_FILE_NAME__base_name__3__2__REC_EDL_FILE_NAME__base_name")
			Result.force(4, "EDL_FILE_NAME__directory_name__3__2__REC_EDL_FILE_NAME__directory_name")
			Result.force(11, "EDL_HTML_TRANSLATOR_CONTEXT__resolve_reference__3__1__REC_EDL_HTML_TRANSLATOR_CONTEXT__resolve_reference")
			Result.force(13, "EDL_LATEX_TRANSLATOR__visit_section__3__1__REC_EDL_LATEX_TRANSLATOR__visit_section")
			Result.force(2, "BC_MESSAGE_BASE__decoded__3__1__REC_BC_MESSAGE_BASE__decoded")
			Result.force(4, "BE_LOGIC_PLAYER__has_higher_card__3__1__REC_BE_LOGIC_PLAYER__has_higher_card")
			Result.force(4, "BE_LOGIC_PLAYER__has_trump__3__1__REC_BE_LOGIC_PLAYER__has_trump")
			Result.force(7, "BU_LOGIC_ARMY__attack__3__1__REC_BU_LOGIC_ARMY__attack")
			Result.force(4, "BU_LOGIC_ARMY__disband__3__2__REC_BU_LOGIC_ARMY__disband")
			Result.force(3, "BU_LOGIC_CARD_DECK_BEATEN__append_deck__3__2__REC_BU_LOGIC_CARD_DECK_BEATEN__append_deck")
			Result.force(2, "MA_MAKAO_DECK__last_card__3__2__REC_MA_MAKAO_DECK__last_card")
			Result.force(4, "SQ_CARD_SET__add_set__3__1__REC_SQ_CARD_SET__add_set")
			Result.force(2, "SQ_CARD_SET__is_flush__3__3__REC_SQ_CARD_SET__is_flush")
			Result.force(6, "SQ_CARD_SET__remove_set__3__1__REC_SQ_CARD_SET__remove_set")
			Result.force(1, "TS_DRAWING_STACK__restock__3__1__REC_TS_DRAWING_STACK__restock")
			Result.force(2, "TS_GAME_STATE__remove_player_from_game__3__1__REC_TS_GAME_STATE__remove_player_from_game")
			Result.force(3, "TS_PLAYING_STACK__remove_all_but_top_card__3__1__REC_TS_PLAYING_STACK__remove_all_but_top_card")
			Result.force(13, "EI_TEST__make_test__3__1__REC_EI_TEST__make_test")
			Result.force(2, "G4_CATEGORIES_HELPER__get_category_id__3__1__REC_G4_CATEGORIES_HELPER__get_category_id")
			Result.force(2, "G4_TEST_QUESTION_AND_ANSWER_ENTITY__set_multichoice_answer__3__1__REC_G4_TEST_QUESTION_AND_ANSWER_ENTITY__set_multichoice_answer")
			Result.force(2, "G4_VOCABULARY_HELPER__get_vocabulary_id__3__1__REC_G4_VOCABULARY_HELPER__get_vocabulary_id")
			Result.force(13, "G9_STORE_TEST__get_flashcards_list__3__1__REC_G9_STORE_TEST__get_flashcards_list")
			Result.force(16, "G9_STORE_TEST__get_flashcards_list__3__3__REC_G9_STORE_TEST__get_flashcards_list")
			Result.force(16, "G9_STORE_TEST__get_multichoice_list__3__1__REC_G9_STORE_TEST__get_multichoice_list")
			Result.force(7, "GB_LESSON__make_new_lesson__3__3__REC_GB_LESSON__make_new_lesson")
			Result.force(3, "HE_MULTI_CHOICE_QUESTION__make__3__3__REC_HE_MULTI_CHOICE_QUESTION__make")
		end

	node_difference (a_original, a_fixed: AFX_AST_STRUCTURE_NODE): AFX_POSTMORTEM_ANALYSIS_RECORD
			-- Difference between the two nodes `a_original' and `a_fixed'.
		local
			l_children_count: INTEGER
			l_then_trunk, l_else_trunk: LINKED_LIST[AFX_AST_STRUCTURE_NODE]
			l_old_start_node, l_then_start_node, l_else_start_node, l_failing_node: AFX_AST_STRUCTURE_NODE
			l_original_string, l_fixed_string, l_then_start_string, l_else_start_string: STRING
			l_nbr_old_statements, l_size_snippet, l_branching_factor, l_failing_node_depth: INTEGER
			l_then_size, l_else_size: INTEGER
			l_schema_type: INTEGER
		do
			l_old_start_node := a_original
			if a_fixed.is_if then
				l_children_count := a_fixed.children.count

					-- According to the structure node generator, there should always be two trunks in such an 'if' node.
				check l_children_count = 2 end
				l_then_trunk := a_fixed.children.at (1)
				l_then_start_node := l_then_trunk.first
				l_then_size := l_then_trunk.count
				l_else_trunk := a_fixed.children.at (2)
				l_else_size := l_else_trunk.count

				if l_else_size = 0 then
					if a_original.ast.ast ~ l_then_start_node.ast.ast then
							-- if old_statement end
						l_schema_type := {AFX_POSTMORTEM_ANALYSIS_RECORD}.Schema_if_old
						l_nbr_old_statements := l_then_size
						l_size_snippet := 0
					else
							-- if snippet end; old_statement
						l_schema_type := {AFX_POSTMORTEM_ANALYSIS_RECORD}.Schema_if_snippet
						l_nbr_old_statements := 0
						l_size_snippet := l_then_size
					end
				elseif l_else_size > 0 then
					l_else_start_node := l_else_trunk.first
					if a_original.ast.ast.same_type (l_then_start_node.ast.ast) and then a_original.ast.ast.is_equivalent (l_then_start_node.ast.ast) then
							-- if c1 then old_statement else snippet end
						l_schema_type := {AFX_POSTMORTEM_ANALYSIS_RECORD}.Schema_if_old_else_snippet
						l_nbr_old_statements := l_then_size
						l_size_snippet := l_else_size
					elseif a_original.ast.ast.same_type (l_else_start_node.ast.ast) and then a_original.ast.ast.is_equivalent (l_else_start_node.ast.ast) then
							-- if c1 then snippet else old_statement end
						l_schema_type := {AFX_POSTMORTEM_ANALYSIS_RECORD}.Schema_if_snippet_else_old
						l_nbr_old_statements := l_else_size
						l_size_snippet := l_then_size
					else
						check False end
					end
				end
			else
				l_schema_type := {AFX_POSTMORTEM_ANALYSIS_RECORD}.Schema_snippet
				l_nbr_old_statements := 0
				l_size_snippet := 1
			end

				-- Compute branching factor.
			l_failing_node := recipient_feature_ast_structure_node.surrounding_instruction (breakpoint)
			if l_failing_node = Void then
					-- Postcondition or class invariant violations.
				l_failing_node_depth := 1
			else
				l_failing_node_depth := l_failing_node.depth
			end
			l_branching_factor := l_failing_node_depth - l_old_start_node.depth

			create Result.make (recipient_feature_with_context, fix_under_analysis.starting_ln.out, fix_under_analysis.is_proper, fix_under_analysis.text.twin, l_schema_type, l_nbr_old_statements, l_size_snippet, l_branching_factor)
		end

	compare_structure_node (a_original, a_fixed: AFX_AST_STRUCTURE_NODE)
			-- Compare the structure nodes `a_original' and `a_fixed'.
		local
			l_original_children, l_fixed_children: LINKED_LIST[LINKED_LIST[AFX_AST_STRUCTURE_NODE]]
			l_original_trunk, l_fixed_trunk: LINKED_LIST[AFX_AST_STRUCTURE_NODE]
			l_index, l_count: INTEGER
		do
			if not has_found_difference then
				if (summary_string_for_structure_node (a_original) /~ summary_string_for_structure_node (a_fixed)) then
					result_records.force_last (node_difference (a_original, a_fixed))
					has_found_difference := True
				else
					l_original_children := a_original.children
					l_fixed_children := a_fixed.children
					check l_original_children.count = l_fixed_children.count end
					from
						l_index := 1
						l_count := l_original_children.count
					until
						l_index > l_count or else has_found_difference
					loop
						l_original_trunk := l_original_children.at (l_index)
						l_fixed_trunk := l_fixed_children.at (l_index)

						compare_structure_node_trunk (l_original_trunk, l_fixed_trunk)

						l_index := l_index + 1
					end
				end
			end
		end

	compare_structure_node_trunk (a_original_trunk, a_fixed_trunk: LINKED_LIST[AFX_AST_STRUCTURE_NODE])
		local
			l_original_count, l_fixed_count, l_index, l_min_count: INTEGER
			l_original_node, l_fixed_node: AFX_AST_STRUCTURE_NODE
			l_nbr_old_statements, l_size_snippet, l_branching_factor: INTEGER
			l_schema_type: INTEGER
			l_record: AFX_POSTMORTEM_ANALYSIS_RECORD
		do
			l_original_count := a_original_trunk.count
			l_fixed_count := a_fixed_trunk.count
			l_min_count := l_original_count.min (l_fixed_count)
			from l_index := 1
			until l_index > l_min_count or else has_found_difference
			loop
				l_original_node := a_original_trunk.at (l_index)
				l_fixed_node := a_fixed_trunk.at (l_index)

				compare_structure_node (l_original_node, l_fixed_node)

				l_index := l_index + 1
			end

			if not has_found_difference and then l_original_count < l_fixed_count then
					-- Fixes at the end of the feature body---for postcondition or class invariant violations.
				l_fixed_node := a_fixed_trunk.last
				if l_fixed_node.is_if then
					l_schema_type := {AFX_POSTMORTEM_ANALYSIS_RECORD}.Schema_if_snippet
				else
					l_schema_type := {AFX_POSTMORTEM_ANALYSIS_RECORD}.Schema_snippet
				end
				l_nbr_old_statements := 0
				l_size_snippet := 1
				l_branching_factor := 0
				create l_record.make (recipient_feature_with_context, fix_under_analysis.starting_ln.out, fix_under_analysis.is_proper, fix_under_analysis.text, l_schema_type, l_nbr_old_statements, l_size_snippet, l_branching_factor)
				result_records.force_last (l_record)
				has_found_difference := True
			end
		end

	structure_generator: AFX_AST_STRUCTURE_NODE_GENERATOR
			-- Structure generator.
		once
			create Result
		end

feature{NONE} -- Output

	output_dir: STRING
			-- Dir to store the fixes in XML.

	xml_writer: EXT_XML_AST_WRITER
			-- XML writer.
		once
			create Result
		end

	save_ast (a_ast: AST_EIFFEL; a_id: STRING)
			-- Save `a_ast' in XML format with `a_id'.
		require
			ast_attached: a_ast /= Void
		local
			l_path: FILE_NAME
			l_directory: DIRECTORY
		do
			if output_dir /= Void then
				create l_path.make_from_string (output_dir)
				l_path.set_subdirectory ("XML")
				l_path.set_subdirectory (base_name)
				create l_directory.make (l_path)
				if not l_directory.exists then
					l_directory.recursive_create_dir
				end
				if l_directory.exists then
					l_path.set_file_name (a_id)
					l_path.add_extension ("xml")
					xml_writer.write_to_file (a_ast, l_path)
				else
					check False end
				end
			end
		end

end
