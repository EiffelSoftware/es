note
	description: "Refactoring that extracts a constant."
	date: "$Date$"
	revision: "$Revision$"

class
	ERF_EXTRACT_CONSTANT
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

	ETR_SHARED_TOOLS
	ETR_SHARED_OPERATORS
	ETR_SHARED_LOGGER

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

	set_constant (a_constant: AST_EIFFEL)
			-- Set constant
		require
			non_void: a_constant /= void
		do
			original_constant := a_constant
		end

	set_containing_feature (a_name: STRING)
			-- Set containing feature
		require
			a_name_set: a_name /= void
		do
			containing_feature := a_name
		end

feature {NONE} -- Implementation

	preferences: ERF_EXTRACT_CONSTANT_PREFERENCES
			-- Preferences for this refactoring.

	original_constant: AST_EIFFEL

	class_i: EIFFEL_CLASS_I;
			-- The class we're operating in

	containing_feature: STRING
			-- The feature the constant occurs in

	declaring_class: CLASS_C

	is_already_declared: BOOLEAN

	class_modifiers: LINKED_LIST[ERF_CLASS_TEXT_MODIFICATION]

	apply_class_modifications(a_mods: TUPLE[occ_class: CLASS_C; mods: LIST[ETR_AST_MODIFICATION]])
			-- apply `a_mods'
		local
			l_class_modifier: ERF_CLASS_TEXT_MODIFICATION
			l_modifier: ETR_AST_MODIFIER
			l_trans: ETR_TRANSFORMABLE
			l_comments: HASH_TABLE[STRING,STRING]
			l_matchlist: LEAF_AS_LIST
			l_class_string: STRING
		do
			if a_mods.occ_class.feature_named (preferences.constant_name) = void or else (a_mods.occ_class.class_id = declaring_class.class_id and is_already_declared) then
				l_matchlist := match_list_server.item (a_mods.occ_class.class_id)

				l_comments := ast_tools.extract_class_comments (a_mods.occ_class.ast, l_matchlist)

				create l_modifier.make
				create l_trans.make_in_class (a_mods.occ_class.ast, a_mods.occ_class)
				l_modifier.add_list (a_mods.mods)
				l_modifier.apply_to (l_trans)

				if not etr_error_handler.has_errors then
					-- add comment for new constant
					l_comments.force (" Extracted from "+class_i.name+".", preferences.constant_name)

					l_class_string := ast_tools.commented_class_to_string (l_modifier.modified_ast.target_node, l_comments)

					create l_class_modifier.make (a_mods.occ_class.original_class)
					l_class_modifier.prepare
					l_class_modifier.set_changed_text (l_class_string)
					class_modifiers.extend(l_class_modifier)
				else
					etr_error_handler.add_error (Current, "apply_class_modifications", "Failed to apply modifications to "+a_mods.occ_class.name_in_upper + ".")
				end
			else
				etr_error_handler.add_error (Current, "apply_class_modifications", a_mods.occ_class.name_in_upper + " already has a feature with name " + preferences.constant_name + " and it's not the declaring class.")
			end
		end

	refactor
			-- Do the refactoring changes.
		require else
			class_set: class_set
		local
			l_matchlist: LEAF_AS_LIST
			l_retry: BOOLEAN
			l_cons_trans: ETR_TRANSFORMABLE
			l_confirmation_string: STRING
			window: EB_DEVELOPMENT_WINDOW
			l_cur_occs: INTEGER
		do
			if not l_retry then
				success := true

				etr_error_handler.reset_errors

				l_matchlist := match_list_server.item (class_i.compiled_class.class_id)

				create l_cons_trans.make_in_class (original_constant, class_i.compiled_class)

				constant_extractor.extract_constant (l_cons_trans, containing_feature, preferences.constant_name, preferences.whole_class_flag, preferences.ancestors_flag, preferences.descendants_flag)

				if etr_error_handler.has_errors then
					show_etr_error
		        	success := false
		        	error_handler.wipe_out
		        else
		        	is_already_declared := constant_extractor.is_already_declared
		        	declaring_class := constant_extractor.declaring_class

		        	from
		        		create class_modifiers.make
						constant_extractor.modifiers.start
					until
						constant_extractor.modifiers.after
					loop
						apply_class_modifications(constant_extractor.modifiers.item)

						constant_extractor.modifiers.forth
					end

					if etr_error_handler.has_errors then
						show_etr_error
			        	success := false
			        	error_handler.wipe_out
			        else
			        	-- ask for confirmation

			        	if is_already_declared then
			        		l_confirmation_string := preferences.constant_name + " is already declared in " + declaring_class.name_in_upper + ".%N%N"
			        	else
			        		l_confirmation_string := preferences.constant_name + " will be declared in " + declaring_class.name_in_upper + ".%N%N"
			        	end

			        	l_confirmation_string.append ("The following classes will be modified:%N")

			        	from
			        		constant_extractor.modifiers.start
			        	until
			        		constant_extractor.modifiers.after
			        	loop
							l_cur_occs := constant_extractor.modifiers.item.mods.count

							if constant_extractor.declaring_class.class_id = constant_extractor.modifiers.item.occ_class.class_id and not is_already_declared then
								l_cur_occs := l_cur_occs - 1
							end

			        		l_confirmation_string.append (constant_extractor.modifiers.item.occ_class.name_in_upper + " (" + l_cur_occs.out + " occurrence")

			        		if l_cur_occs>1 then
			        			l_confirmation_string.append ("s")
			        		end

			        		l_confirmation_string.append (")%N")

			        		constant_extractor.modifiers.forth
			        	end

			        	l_confirmation_string.append ("%NContinue?")

			        	window := window_manager.last_focused_development_window

			        	prompts.show_question_prompt (l_confirmation_string, window.window, agent continue_yes, agent continue_no)
			        end
				end
			end
		rescue
			log_exception(Current, "refactor")

			show_etr_error
			success := false
			error_handler.wipe_out
			l_retry := true
			retry
		end

	continue_yes
		do
			success := true
			from
				class_modifiers.start
			until
				class_modifiers.after
			loop
				class_modifiers.item.commit
	        	current_actions.extend (class_modifiers.item)

				class_modifiers.forth
			end
		end

	continue_no
		do
			success := false
		end

    ask_run_settings
            -- Ask for the settings, that are run specific.
		require else
			class_set: class_set
		local
			dialog: ERF_EXTRACT_CONSTANT_DIALOG
			l_matchlist: LEAF_AS_LIST
        do
        	l_matchlist := match_list_server.item (class_i.compiled_class.class_id)

			create dialog
			dialog.disable_user_resize

				-- set current settings
			dialog.set_ancestors_flag (preferences.ancestors_flag)
			dialog.set_descendants_flag (preferences.descendants_flag)
			dialog.set_constant_name (preferences.constant_name)
			dialog.set_constant_value (original_constant.text (l_matchlist))
			dialog.set_class_flag (preferences.whole_class_flag)

			dialog.show_modal_to_window (window_manager.last_focused_development_window.window)

				-- store new settings
			preferences.set_ancestors (dialog.ancestors_flag)
			preferences.set_descendants (dialog.descendants_flag)
			preferences.set_constant_name (dialog.constant_name)
			preferences.set_whole_class (dialog.class_flag)

				-- add basic checks
        	checks.wipe_out
			checks.extend (create {ERF_VALID_FEATURE_NAME}.make (preferences.constant_name))

			retry_ask_run_settings := dialog.ok_pressed
        end
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
