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
			refactor,
			execute
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
	ETR_SHARED_ERROR_HANDLER
		rename
			error_handler as etr_error_handler
		end

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

feature -- Basic

	execute
			-- Execute the refactoring
		local
			all_checks_ok: BOOLEAN
			compiler_check: ERF_COMPILATION_SUCCESSFUL
		do
			success := False
			status_bar := window_manager.last_focused_development_window.status_bar
			create compiler_check.make

				-- check if compilation is ok
			compiler_check.execute
			if not compiler_check.success then
				(create {ES_SHARED_PROMPT_PROVIDER}).prompts.show_error_prompt (compiler_check.error_message, Void, Void)
			else
					-- Get open classes
				window_manager.for_all_development_windows (agent add_window_to_open_classes)

					-- Ask settings till the checks all complete successfully or if the user cancels
				ask_run_settings
				if retry_ask_run_settings then
					from
						all_checks_ok := checks.for_all (agent check_successful)
					until
						not retry_ask_run_settings or else all_checks_ok
					loop
						ask_run_settings
						all_checks_ok := checks.for_all (agent check_successful)
					end
						-- Checks ok and user didn't cancel
					if all_checks_ok and retry_ask_run_settings then
							-- Handle undo
						create current_actions.make (0)

						refactor

						if success then
							-- Execute compilation
							compiler_check.execute
							success := compiler_check.success

								-- on error ask if we should rollback
							if not success then
									-- success, because, now the user can choose to keep the changes or if he rollbacks, success will be set to False
								success := True
								(create {ES_SHARED_PROMPT_PROVIDER}).prompts.show_question_prompt (compiler_check.error_message.as_string_32+" " + interface_names.l_rollback_question, Void, agent rollback, agent commit)
							else
								commit
							end
						end
					end
					window_manager.for_all_development_windows (agent {EB_DEVELOPMENT_WINDOW}.synchronize)
				end
			end
		rescue
				-- on exception undo any changes
			rollback
		end

feature {NONE} -- Implementation

	preferences: ERF_EXTRACT_METHOD_PREFERENCES
			-- Preferences for this refactoring.

	show_etr_error
			-- Report etr error
		local
			l_error_msg: STRING
		do
			if etr_error_handler.has_errors then
				from
					create l_error_msg.make_empty
					etr_error_handler.errors.start
				until
					etr_error_handler.errors.after
				loop
					l_error_msg.append (etr_error_handler.errors.item)
					etr_error_handler.errors.forth
					if not etr_error_handler.errors.after then
						l_error_msg.append ("%N")
					end
				end
				prompts.show_error_prompt (l_error_msg, Void, Void)
			end
		end

	refactor
			-- Do the refactoring changes.
		require else
			class_set: class_set
		local
			l_matchlist: LEAF_AS_LIST
			l_class_modifier: ERF_CLASS_TEXT_MODIFICATION
			l_replacement_text: STRING
		do
			success := true

			etr_error_handler.reset_errors

			l_matchlist := match_list_server.item (class_i.compiled_class.class_id)

			-- Perform method extraction
			method_extractor.extract_method (transformable, feature_name, start_path, end_path, preferences.extracted_method_name)

			if not etr_error_handler.has_errors then
				-- Replace the old feature by the new one + extracted method
				l_replacement_text := ast_tools.ast_to_string_with_indentation(method_extractor.old_method.target_node, 1)
				l_replacement_text.append (ast_tools.ast_to_string_with_indentation(method_extractor.extracted_method.target_node, 1))
				l_replacement_text.remove_tail (3)

				original_feature_ast.replace_text (l_replacement_text, l_matchlist)

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

			-- todo: add check for line numbers

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

	original_feature_ast: AST_EIFFEL
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
