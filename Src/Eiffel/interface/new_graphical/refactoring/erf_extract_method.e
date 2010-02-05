note
	description: "Summary description for {ERF_EXTRACT_METHOD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ERF_EXTRACT_METHOD
inherit
	ERF_ETR_REFACTORING
		redefine
			preferences,
			ask_run_settings,
			refactor
		end

	REFACTORING_HELPER
		export
			{NONE} all
		end

	SHARED_SERVER
	SHARED_ERROR_HANDLER

	ETR_SHARED_AST_TOOLS
	ETR_SHARED_PATH_TOOLS
	ETR_SHARED_OPERATORS

create
	make

feature -- Status

	class_set: BOOLEAN
			-- Has the class to change been set?
		do
			Result := class_i /= void
		end

feature -- Element change

	set_class (a_class: like class_i)
			-- That class that get's renamed
		require
			a_class_not_void: a_class /= void
		do
			class_i := a_class
		end

	set_feature_name (a_name: like feature_name)
			-- Set feature name to `a_name'
		do
			feature_name := a_name
		end

	set_start_line (a_line: INTEGER)
			-- Set start line to `a_line'
		do
			preferences.set_start_line (a_line)
		end

	set_end_line (a_line: INTEGER)
			-- Set end line to `a_line'
		do
			preferences.set_end_line (a_line)
		end

	set_original_feature_ast (a_ast: like original_feature_ast)
			-- Set original feature ast to `a_ast'
		do
			original_feature_ast := a_ast
		end

feature {ERF_EXTRACT_METHOD_CHECK} -- Element change

	set_transformable(a_transformable: like transformable)
			-- Set transformable
		do
			transformable := a_transformable
		end

	set_start_path(a_path: like start_path)
			-- Set start path
		do
			start_path := a_path
		end

	set_end_path(a_path: like end_path)
			-- Set end path	
		do
			end_path := a_path
		end

feature {NONE} -- Implementation

	preferences: ERF_EXTRACT_METHOD_PREFERENCES
			-- Preferences for this refactoring.

	refactor
			-- Do the refactoring changes.
		require else
			class_set: class_set
		local
			l_matchlist: LEAF_AS_LIST
			l_class_modifier: ERF_CLASS_TEXT_MODIFICATION
			l_replacement_text: STRING
			l_feat_comment: STRING
			l_replacement_region: ERT_TOKEN_REGION
			l_region_start_index, l_region_end_index: INTEGER
			l_brk_text: STRING
		do
			success := true

			etr_error_handler.reset_errors

			l_matchlist := match_list_server.item (class_i.compiled_class.class_id)

			l_feat_comment := ast_tools.extract_feature_comments(original_feature_ast, l_matchlist)

			-- Perform method extraction
			method_extractor.extract_method (transformable, feature_name, start_path, end_path, preferences.extracted_method_name)

			if not etr_error_handler.has_errors then
				-- Replace the old feature by the new one + extracted method

				-- Get the leading break text
				create l_brk_text.make_empty
				if original_feature_ast.has_leading_separator (l_matchlist) then
					l_region_start_index := original_feature_ast.first_token (l_matchlist).index-1
					l_brk_text := l_matchlist.i_th (l_region_start_index).text (l_matchlist)
					l_brk_text := ast_tools.remove_ending_indentation (l_brk_text, '%T')
				else
					l_region_start_index := original_feature_ast.first_token (l_matchlist).index
				end

				l_replacement_text := l_brk_text

				if not l_replacement_text.ends_with ("%N%N") then
					if l_replacement_text.ends_with ("%N") then
						l_replacement_text.append ("%N")
					else
						l_replacement_text.append ("%N%N")
					end
				end

				l_replacement_text.append 	(	ast_tools.commented_feature_to_string (
													method_extractor.old_method.target_node,
													l_feat_comment,
													1)
											)

				l_replacement_text.append ("%N")

				l_replacement_text.append 	(	ast_tools.commented_feature_to_string (
													method_extractor.extracted_method.target_node,
													" Extracted from `"+feature_name+"'",
													1)
											)

				-- Removing trailing newline, otherwise it's duplicate
				l_replacement_text.remove_tail (1)

				l_region_end_index := original_feature_ast.last_token (l_matchlist).index

				create l_replacement_region.make (l_region_start_index, l_region_end_index)
				l_matchlist.replace_region (l_replacement_region, l_replacement_text)

				create l_class_modifier.make (class_i)
				l_class_modifier.prepare
				l_class_modifier.set_changed_text (l_matchlist.all_modified_text)
				l_class_modifier.commit
	        	current_actions.extend (l_class_modifier)
	        else
	        	show_etr_error
	        	success := false
	        	error_handler.wipe_out
			end
		rescue
			show_etr_error
			success := false
			error_handler.wipe_out
		end

    ask_run_settings
            -- Ask for the settings, that are run specific.
		require else
			class_set: class_set
		local
			dialog: ERF_EXTRACT_METHOD_DIALOG
        do
			create dialog
			dialog.disable_user_resize

				-- set current settings
			dialog.set_extracted_method_name (preferences.extracted_method_name)
			dialog.set_start_line (preferences.start_line)
			dialog.set_end_line (preferences.end_line)
			dialog.set_class (class_i.name)

			dialog.show_modal_to_window (window_manager.last_focused_development_window.window)

				-- store new settings
			preferences.set_end_line (dialog.end_line)
			preferences.set_start_line (dialog.start_line)
			preferences.set_extracted_method_name (dialog.extracted_method_name)

				-- add checks
        	checks.wipe_out
			checks.extend (create {ERF_VALID_FEATURE_NAME}.make (preferences.extracted_method_name))
			checks.extend (create {ERF_FEATURE_NOT_IN_CLASS}.make (preferences.extracted_method_name, class_i.compiled_class, void, true, false))
			checks.extend (create {ERF_EXTRACT_METHOD_CHECK}.make (Current, class_i.compiled_class, preferences.start_line, preferences.end_line))

			retry_ask_run_settings := dialog.ok_pressed
        end

	class_i: EIFFEL_CLASS_I;
			-- The class we're operating in

	transformable: ETR_TRANSFORMABLE
			-- The transformable we're working on

	start_path: AST_PATH
			-- The start path

	end_path: AST_PATH
			-- The end path

	feature_name: STRING
			-- Name of the feature the lines are in

	original_feature_ast: FEATURE_AS
			-- AST node of the original feature
;
note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
