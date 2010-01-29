note
	description: "Summary description for {ERF_EXTRACT_METHOD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ERF_EXTRACT_METHOD
inherit
	ERF_REFACTORING
		redefine
			preferences,
			ask_run_settings,
			refactor
		end

	SHARED_WORKBENCH
		export
			{NONE} all
		end

	REFACTORING_HELPER
		export
			{NONE} all
		end

	EXCEPTIONS
		export
			{NONE} all
		end

	CONF_ACCESS

	SHARED_SERVER

	ETR_SHARED_AST_TOOLS
	ETR_SHARED_PATH_TOOLS
	ETR_SHARED_OPERATORS
	ETR_SHARED_ERROR_HANDLER

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

feature {NONE} -- Implementation

	preferences: ERF_EXTRACT_METHOD_PREFERENCES
			-- Preferences for this refactoring.

	refactor
			-- Do the refactoring changes.
		require else
			class_set: class_set
		local
			l_matchlist: LEAF_AS_LIST
			l_compiled_class: CLASS_C
			l_start_path, l_end_path: AST_PATH
			l_context: ETR_FEATURE_CONTEXT
			l_feat_transformable: ETR_TRANSFORMABLE
			l_feat_ast: AST_EIFFEL
			l_orig_feat: AST_EIFFEL
			l_written_feature: FEATURE_I
			l_class_modifier: ERF_CLASS_TEXT_MODIFICATION
		do
			error_handler.reset_errors

			-- Get the compiled class and feature
			l_compiled_class := class_i.compiled_class
			l_matchlist := match_list_server.item (l_compiled_class.class_id)

			-- fixme: get current feature from line number!
			l_written_feature := l_compiled_class.feature_named ("test")
			l_orig_feat := l_written_feature.e_feature.ast

			-- Create a transformable
			create l_context.make (l_written_feature, void)
			create l_feat_transformable.make_from_ast (l_orig_feat, l_context, true)
			l_feat_ast := l_feat_transformable.target_node

			-- Convert line numbers to paths
			l_start_path := path_tools.path_from_line (l_orig_feat, l_matchlist, preferences.start_line)
			l_start_path.set_root (l_feat_ast)

			l_end_path := path_tools.path_from_line (l_orig_feat, l_matchlist, preferences.end_line)
			l_end_path.set_root (l_feat_ast)

			-- Perform method extraction
			method_extractor.extract_method (l_feat_transformable, l_start_path, l_end_path, preferences.extracted_method_name)

			-- Replace the old feature by the new one + extracted method
			-- fixme: correct indentation !
			-- use custom printer!
			l_orig_feat.replace_text (ast_tools.ast_to_string (method_extractor.old_method.target_node)+"%N%N"+ast_tools.ast_to_string (method_extractor.extracted_method.target_node), l_matchlist)

			if not error_handler.has_errors then
				create l_class_modifier.make (class_i)
				l_class_modifier.prepare
				l_class_modifier.set_changed_text (l_matchlist.all_modified_text)
				l_class_modifier.commit
	        	current_actions.extend (l_class_modifier)
	        else
	        	-- fixme: show error
			end
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

			dialog.show_modal_to_window (window_manager.last_focused_development_window.window)

				-- store new settings
			preferences.set_end_line (dialog.end_line)
			preferences.set_start_line (dialog.start_line)
			preferences.set_extracted_method_name (dialog.extracted_method_name)

				-- add checks
        	checks.wipe_out
			checks.extend (create {ERF_VALID_FEATURE_NAME}.make (preferences.extracted_method_name))
			checks.extend (create {ERF_FEATURE_NOT_IN_CLASS}.make (preferences.extracted_method_name, class_i.compiled_class, void, true, false))
			-- todo: add check for line numbers

			retry_ask_run_settings := dialog.ok_pressed
        end

--    apply_to_project
--            -- Make project global changes (eg. *.ace, create/remove/rename cluster/files, ...).
--		require else
--			class_set: class_set
--		local
--			project_modifier: ERF_PROJECT_TEXT_MODIFICATION
--			file_rename: ERF_CLASS_FILE_RENAME
--			l_root: SYSTEM_ROOT
--        do
--        		-- Change root class if renamed class is on of the current root classes
--        		--
--        		-- Note: this code must be updated to support multiple root features
--        	if not system.root_creators.is_empty then
--        		l_root := system.root_creators.first
--        		if l_root.root_class.name.is_equal (preferences.new_class_name) then
--        			create project_modifier
--					project_modifier.prepare
--					project_modifier.change_root_class (preferences.new_class_name.as_upper)
--					project_modifier.commit
--		        	current_actions.extend (project_modifier)
--        		end
--        	end

--	        	-- TODO handle other cases where the class was in the project file
--	        to_implement ("TODO handle other cases where the class was in the project file")

--				-- if the file should be renamed
--        	if preferences.file_rename then
--        		-- rename file action
--        		create file_rename.make (preferences.new_class_name.as_lower, class_i)
--        		file_rename.redo
--        		if file_rename.is_error then
--        			prompts.show_error_prompt (file_rename.error_message, Void, Void)
--        		else
--        			current_actions.extend (file_rename)
--        		end
--        	end
--		end

--    apply_to_class (a_class: CLASS_I)
--            -- Make the changes in `a_class'.
--		require else
--			class_set: class_set
--		local
--			class_modifier: ERF_CLASS_TEXT_MODIFICATION
--			rename_visitor: AST_RENAME_CLASS_VISITOR
--        do
--        	create class_modifier.make (a_class)
--        		-- if we want to process all classes, enable parsing on demand
--        	if preferences.all_classes then
--        		class_modifier.enable_parsing
--        	end
--			class_modifier.prepare

--			create rename_visitor.make (preferences.old_class_name, preferences.new_class_name, preferences.update_comments, preferences.update_strings)
--			class_modifier.execute_visitor (rename_visitor, false)

--        	class_modifier.commit
--        	current_actions.extend (class_modifier)
--        end

	class_i: EIFFEL_CLASS_I;
			-- The class we're operating in
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
