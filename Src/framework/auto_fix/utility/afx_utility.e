note
	description: "Summary description for {AFX_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_UTILITY

inherit
	EPA_CONTRACT_EXTRACTOR

	EPA_SOLVER_FACTORY

	EPA_UTILITY

	EPA_SHARED_EQUALITY_TESTERS

	EPA_SHARED_EQUALITY_TESTERS

	EPA_TYPE_UTILITY

	EPA_PROCESS_UTILITY

feature -- Formatting

	lines_with_prefixes (a_text: STRING; a_prefix: STRING): LIST [STRING]
			-- List of lines in `a_text', each line is prepended with `a_prefix'.
		require
			a_text_attached: a_text /= Void
			a_prefix_attached: a_prefix /= Void
		local
			l_lines: LIST [STRING]
		do
			if a_text.is_empty then
				create {ARRAYED_LIST [STRING]} Result.make (0)
			else
				l_lines := a_text.split ('%N')
				if not l_lines.is_empty then
					l_lines.finish
					l_lines.remove
				end
				from
					l_lines.start
				until
					l_lines.after
				loop
					l_lines.item.prepend (a_prefix)
					l_lines.forth
				end
				Result := l_lines
			end
		ensure
			result_attached: Result /= Void
			data_correct: not Result.has (Void)
			result_is_empty_when_a_text_is_empty: a_text.is_empty implies Result.is_empty
		end

	formated_feature (a_feature: FEATURE_I): STRING
			-- Pretty printed feature `a_feature'
		local
			l_printer: ETR_AST_STRUCTURE_PRINTER
			l_output: ETR_AST_STRING_OUTPUT
			l_feat_text: STRING
			l_match_list: LEAF_AS_LIST
		do
			l_match_list := match_list_server.item (a_feature.written_class.class_id)
			Entity_feature_parser.set_syntax_version (Entity_feature_parser.Provisional_syntax)
			entity_feature_parser.parse_from_utf8_string ("feature " + a_feature.e_feature.ast.original_text (l_match_list), Void)
			create l_output.make_with_indentation_string ("%T")
			create l_printer.make_with_output (l_output)
			l_printer.print_ast_to_output (a_feature.e_feature.ast)
			Result := l_output.string_representation
		end

	formated_fix (a_fix: AFX_CODE_FIX_TO_FAULT): STRING
			-- Pretty printed feature text for `a_fix'
		local
			l_printer: ETR_AST_STRUCTURE_PRINTER
			l_output: ETR_AST_STRING_OUTPUT
			l_feat_text: STRING
			l_parser: like entity_feature_parser
		do
			if a_fix.fixed_body_text.has_substring ("should not happen") then
				Result := a_fix.fixed_body_text.twin
			else
				l_parser := entity_feature_parser
				l_parser.set_syntax_version (l_parser.provisional_syntax)
				l_parser.parse_from_utf8_string ("feature " + a_fix.fixed_feature_text, Void)
				create l_output.make_with_indentation_string ("%T")
				create l_printer.make_with_output (l_output)
				l_printer.print_ast_to_output (l_parser.feature_node)
				Result := l_output.string_representation
			end
		end

feature -- Operations

	exception_summary_from_trace_file (a_path: PATH): EPA_EXCEPTION_TRACE_SUMMARY
			--
		local
			l_explainer: EPA_EXCEPTION_TRACE_EXPLAINER
			l_summary: EPA_EXCEPTION_TRACE_SUMMARY
			l_file: PLAIN_TEXT_FILE
			l_content: STRING
			l_delimiter: STRING
			l_index, l_start_index, l_end_index: INTEGER
		do
			create l_file.make_with_path (a_path)
			l_file.open_read

				-- Read the whole file.
			if l_file.is_open_read then
				from
					l_content := ""
					l_file.read_line
				until
					l_file.end_of_file
				loop
					l_content.append (l_file.last_string + "%N")
					l_file.read_line
				end
			end

				-- Extract only the exception trace into 'l_content'.
			l_delimiter := {EPA_EXCEPTION_TRACE_PARSER}.dash_line
			l_start_index := l_content.substring_index (l_delimiter, 1)
			check l_start_index > 0 end
			from
				l_index := l_start_index + 1
			until
				l_index = 0
			loop
				l_index := l_content.substring_index (l_delimiter, l_index + l_delimiter.count)
				if l_index > 0 then
					l_end_index := l_index
				end
			end
			l_end_index := l_end_index + l_delimiter.count - 1
			l_content := l_content.substring (l_start_index, l_end_index)

				-- Process the exception trace
			create l_explainer
			l_explainer.explain (l_content)
			Result := l_explainer.last_explanation
		end

	features_to_monitor_by_names (a_features: DS_LINEAR [AFX_FEATURE_TO_MONITOR]): DS_HASH_TABLE [AFX_FEATURE_TO_MONITOR, STRING]
			--
		require
			a_features /= Void
		do
			create Result.make_equal (a_features.count + 1)
			a_features.do_all (
					agent (a_feature: AFX_FEATURE_TO_MONITOR; a_map: DS_HASH_TABLE [AFX_FEATURE_TO_MONITOR, STRING])
						local
							l_name: STRING
						do
							l_name := a_feature.qualified_feature_name
							if not a_map.has (l_name) then
								a_map.force (a_feature, l_name)
							end
						end (?, Result)
					)
		end

end
