note
	description: "Summary description for {ES_ADB_FIX_IMPLEMENTATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_FIX_IMPLEMENTATION

inherit
	ES_ADB_FIX_AUTOMATIC

	SHARED_EIFFEL_PARSER
		undefine is_equal end

	SHARED_SERVER
		undefine is_equal end

	INTERNAL_COMPILER_STRING_EXPORTER
		undefine is_equal end

	EPA_UTILITY
		undefine is_equal end

create
	make

feature{NONE} -- Initialization

	make (a_fault: ES_ADB_FAULT; a_id_string: STRING; a_fixed_body: STRING; a_nature_str: STRING; a_ranking: REAL)
			-- Initialization.
		require
			a_fault /= Void
			a_id_string /= Void and then not a_id_string.is_empty
			a_fixed_body /= Void and then not a_fixed_body.is_empty
			Ranking_maximum >= a_ranking and then a_ranking >= Ranking_minimum
		local
		do
			make_automatic (a_fault, a_id_string)

			fix_text := a_fixed_body.twin
			set_nature_of_change (nature_of_change_from_string (a_nature_str))
			has_change_to_implementation := True
			has_change_to_contract := False
			has_been_applied := False
			type := Type_implementation_fix
			set_ranking (a_ranking)

			a_fault.add_fix (Current)
		end

feature -- Status report

	is_valid_nature_of_change (a_nature: INTEGER): BOOLEAN
			-- <Precursor>
		do
			Result := Nature_unconditional_add <= a_nature and then a_nature <= Nature_conditional_replace
		end

feature -- Access

	code_before_fix: STRING
			-- <Precursor>
		local
			l_written_class: CLASS_C
			l_match_list: LEAF_AS_LIST
			l_feature_as: FEATURE_AS
			l_do_text, l_old_do_text: STRING
			l_do_as, l_old_do_as: DO_AS
		do
			if code_before_fix_internal = Void then
				l_written_class := fault.signature.recipient_.written_class
				l_match_list := match_list_server.item (l_written_class.class_id)

					-- Keep the original feature header, but reformat the feature body.
				l_feature_as := fault.signature.recipient_.e_feature.ast
				l_do_as := do_as_from_feature_as (l_feature_as)
				l_do_text := as_to_string (l_do_as, "%T%T")
				l_do_as.replace_text (l_do_text, l_match_list)
				code_before_fix_internal := l_feature_as.text_32 (l_match_list).twin
				l_match_list.remove_modifications
			end
			Result := code_before_fix_internal
		end

	code_after_fix: STRING
			-- <Precursor>
		local
			l_written_class: CLASS_C
			l_match_list: LEAF_AS_LIST
			l_printer: ETR_AST_STRUCTURE_PRINTER
			l_output: ETR_AST_STRING_OUTPUT
			l_feat_text: STRING
			l_old_feature_as: FEATURE_AS
			l_do_text, l_old_do_text: STRING
			l_do_as, l_old_do_as: DO_AS
			l_parser: like entity_feature_parser
		do
			if code_after_fix_internal = Void then
				l_written_class := fault.signature.recipient_.written_class
				l_match_list := match_list_server.item (l_written_class.class_id)

					-- Get new body for feature
				l_parser := entity_feature_parser
				l_parser.set_syntax_version (l_parser.provisional_syntax)
				l_parser.parse_from_utf8_string ("feature " + fix_text, Void)
				l_do_as := do_as_from_feature_as (l_parser.feature_node)
				l_do_text := as_to_string (l_do_as, "%T%T")

					-- Replace old body with new body, keeping the head comment for feature.
				l_old_feature_as := fault.signature.recipient_.e_feature.ast
				l_old_do_as := do_as_from_feature_as (l_old_feature_as)
				l_old_do_as.replace_text (l_do_text, l_match_list)
				code_after_fix_internal := l_old_feature_as.text_32 (l_match_list).twin
				l_match_list.remove_modifications
			end
			Result := code_after_fix_internal
		end

	do_as_from_feature_as (a_feature_as: FEATURE_AS): DO_AS
			--
		do
			if attached {BODY_AS} a_feature_as.body as lt_body then
				if attached {ROUTINE_AS} lt_body.content as lt_routine then
					if attached {DO_AS} lt_routine.routine_body as lt_do then
						Result := lt_do
					end
				end
			end
		end

feature -- Operation

	apply (a_path: PATH)
			-- Apply current to the class at `a_path'.
			-- Put error message in `error_message'.
		local
			l_retried, l_has_error: BOOLEAN
			l_name_of_feature_to_fix, l_name_of_class_to_fix: STRING
			l_file: KL_BINARY_INPUT_FILE
			l_gobo: GOBO_FILE_UTILITIES
			l_class_as: CLASS_AS
			l_feature_as: FEATURE_AS

			l_do_text_in_file, l_original_do_text_in_file: STRING

			l_class: CLASS_C
			l_feature: FEATURE_I
			l_class_path: PATH
			l_class_file: PLAIN_TEXT_FILE
			l_match_list: LEAF_AS_LIST
			l_routine_body_as: ROUT_BODY_AS
			l_new_body_text, l_new_class_content: STRING
			l_result_file_lines: DS_LINKED_LIST[STRING]
			l_content, l_line: STRING
		do
			if not l_retried then
				error_message := ""
					-- Check if `code_before_fix' is equal to the feature body of the class at `a_path'.
					-- Set 'l_has_error' accordingly.
				l_name_of_class_to_fix := fault.signature.recipient_written_class.name_in_upper
				l_name_of_feature_to_fix := fault.signature.recipient_.feature_name
				l_file := l_gobo.make_binary_input_file (a_path.out)
				l_file.open_read
				roundtrip_eiffel_parser.parse (l_file)
				l_file.close
				l_class_as := roundtrip_eiffel_parser.root_node
				if attached l_class_as as lt_class_as and then lt_class_as.class_name.name.is_case_insensitive_equal_general (l_name_of_class_to_fix) then
					l_feature_as := lt_class_as.feature_of_name (l_name_of_feature_to_fix, False)
					if l_feature_as /= Void then
						l_do_text_in_file := as_to_string (do_as_from_feature_as (l_feature_as), "")
						l_original_do_text_in_file := as_to_string (do_as_from_feature_as (fault.signature.recipient_.e_feature.ast), "")
						if not l_do_text_in_file.is_case_insensitive_equal_general (l_original_do_text_in_file) then
							l_has_error := True
							error_message := "Feature to fix has been changed in file " + a_path.out
						end
					else
						l_has_error := True
						error_message := "Feature " + l_name_of_feature_to_fix + " does not exist in file " + a_path.out
					end
				else
					l_has_error := True
					error_message := "Class " + l_name_of_class_to_fix + " does not exist in file " + a_path.out
				end

				if not l_has_error then
						-- New content of class.
					l_match_list := roundtrip_eiffel_parser.match_list
					l_feature_as.replace_text (code_after_fix, l_match_list)
					l_new_class_content := l_class_as.text (l_match_list)

						-- Write new content to file.
					create l_class_file.make_with_path (a_path)
--					create l_class_file.make_with_name (a_path.out + ".afx")
					l_class_file.open_write
					if l_class_file.is_open_write then
						l_class_file.put_string (l_new_class_content)
						l_class_file.close
					end

					set_has_been_applied
				end
			end
		rescue
			l_retried := True
			error_message := "Error reading/writing file " + a_path.out
			retry
		end

	error_message: STRING
			-- Error message from last `apply'.

feature -- Query

	nature_of_change_strings: DS_HASH_TABLE [STRING_8, INTEGER]
			-- <Precursor>
		do
			if nature_of_change_strings_internal = Void then
				create nature_of_change_strings_internal.make_equal (10)
				nature_of_change_strings_internal.force ("Unconditional add", Nature_unconditional_add)
				nature_of_change_strings_internal.force ("Conditional add", Nature_conditional_add)
				nature_of_change_strings_internal.force ("Conditional execute", Nature_conditional_execute)
				nature_of_change_strings_internal.force ("Conditional replace", Nature_conditional_replace)
			end
			Result := nature_of_change_strings_internal
		end

feature{NONE} -- Implementation

	Roundtrip_eiffel_parser: EIFFEL_PARSER
			-- Shared instance of roundtrip parser
			-- (export status {NONE})
		once
			create Result.make_with_factory (create {AST_ROUNDTRIP_FACTORY})
			Result.set_syntax_version ({CONF_OPTION}.syntax_index_transitional)
		ensure
			attached_eiffel_parser: Result /= Void
		end

	as_to_string (a_as: AST_EIFFEL; a_prefix: STRING): STRING
			-- String representation of `a_as'.
		require
			a_as /= VOid
		local
			l_printer: ETR_AST_STRUCTURE_PRINTER
			l_output: ETR_AST_STRING_OUTPUT
		do
			create l_output.make_with_indentation_string (a_prefix)
			create l_printer.make_with_output (l_output)
			l_printer.print_ast_to_output (a_as)
			Result := l_output.string_representation
		end

feature -- Constant

	Nature_unconditional_add: INTEGER = 1
	Nature_conditional_add: INTEGER = 2
	Nature_conditional_execute: INTEGER = 3
	Nature_conditional_replace: INTEGER = 4

feature{NONE} -- Cache

	code_before_fix_internal: STRING

	code_after_fix_internal: STRING

	nature_of_change_strings_internal: like nature_of_change_strings

;
note
	copyright: "Copyright (c) 1984-2015, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
