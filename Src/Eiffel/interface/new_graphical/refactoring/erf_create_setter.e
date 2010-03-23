note
	description: "Refactoring that creates a setter for an attribute."
	date: "$Date$"
	revision: "$Revision$"

class
	ERF_CREATE_SETTER

inherit
	ERF_ETR_REFACTORING
		redefine
			refactor,
			ask_run_settings,
			preferences
		end

	SHARED_WORKBENCH
		export
			{NONE} all
		end

	REFACTORING_HELPER
		export
			{NONE} all
		end

	SHARED_ERROR_HANDLER

	ETR_SHARED_TOOLS
	ETR_SHARED_OPERATORS
	ETR_SHARED_CONSTANTS
	ETR_SHARED_FACTORIES

create
	make

feature -- Status

	feature_set: BOOLEAN
			-- Has the the feature to pull been set?
		do
			Result := feature_i /= Void
		end

	is_custom: BOOLEAN
			-- Is a custom setter created

	use_custom_defaults: BOOLEAN
			-- Are preferences used even when default setter is created?

feature -- Element change

	set_use_custom_defaults (a_use_custom_defaults: like use_custom_defaults)
			-- Set `use_custom_defaults' to `a_use_custom_defaults'.
		do
			use_custom_defaults := a_use_custom_defaults
		ensure
			use_custom_defaults_set: use_custom_defaults = a_use_custom_defaults
		end

	set_custom (a_is_custom: like is_custom)
			-- Set `is_custom' to `a_is_custom'.
		do
			is_custom := a_is_custom
		ensure
			is_custom_set: is_custom = a_is_custom
		end

	set_feature (a_feature: FEATURE_I)
			-- The feature that get's pulled.
		require
			a_feature_not_void: a_feature /= Void
		do
			feature_i := a_feature
		ensure
			feature_set_correct: feature_set and feature_i = a_feature
		end

feature {NONE} -- Implementation

	preferences: ERF_CREATE_SETTER_PREFERENCES
			-- Preferences for this refactoring.

	feature_i: FEATURE_I
			-- The feature to pull.

	ask_run_settings
            -- Ask for the settings, that are run specific.
		require else
			feature_set: feature_set
		local
			dialog: ERF_CREATE_SETTER_DIALOG
			l_feat_name: STRING
        do
        	retry_ask_run_settings := false
        	if not is_custom then
        		retry_ask_run_settings := true
        	else
        		l_feat_name := feature_i.feature_name

				create dialog
				dialog.disable_user_resize

        		dialog.set_feature_name (l_feat_name)
        		dialog.set_use_as_assigner (preferences.use_as_assigner)

				dialog.show_modal_to_window (window_manager.last_focused_development_window.window)

				preferences.set_argument_name (dialog.argument_name)
        		preferences.set_assignment (dialog.assignment)
        		preferences.set_setter_name (dialog.setter_name)
        		preferences.set_postcondition (dialog.postcondition)
        		preferences.set_use_as_assigner (dialog.use_as_assigner)

	        	checks.wipe_out
				checks.extend (create {ERF_VALID_FEATURE_NAME}.make (preferences.argument_name))
				checks.extend (create {ERF_VALID_FEATURE_NAME}.make (preferences.setter_name))
				checks.extend (create {ERF_VALID_EXPR}.make (preferences.postcondition))
				checks.extend (create {ERF_VALID_INSTR}.make (preferences.assignment))

        		if dialog.ok_pressed then
        			retry_ask_run_settings := dialog.ok_pressed
        		end
        	end
        end

	refactor
			-- Do the refactoring changes.
		require else
			feature_set: feature_set
		local
			l_feat_ast: FEATURE_AS
			l_matchlist: LEAF_AS_LIST
			l_written_class: CLASS_C
			l_class_modifier: ERF_CLASS_TEXT_MODIFICATION
			l_transformable: ETR_TRANSFORMABLE
			l_append_text: STRING
			l_feat_name: STRING
			l_retry: BOOLEAN
			l_comment: STRING
			l_old_feat_text: STRING
		do
			if not l_retry then
				success := true
				etr_error_handler.reset_errors

				l_feat_ast := feature_i.e_feature.ast
				l_written_class := feature_i.written_class
				l_matchlist := system.match_list_server.item (l_written_class.class_id)

				l_transformable	:= transformable_factory.new_transformable_in_class (l_feat_ast, l_written_class)

				l_feat_name := l_feat_ast.feature_name.name

				if not is_custom then
					-- set default preferences
					preferences.set_argument_name ("a_"+l_feat_name)
					preferences.set_setter_name ("set_"+l_feat_name)
					preferences.set_assignment (l_feat_name+" := a_"+l_feat_name)
					preferences.set_postcondition (l_feat_name+" = a_"+l_feat_name)
					preferences.set_use_as_assigner (true)
				end

				setter_generator.generate_setter (l_transformable, preferences.setter_name, preferences.argument_name, preferences.assignment, preferences.postcondition)

				if preferences.use_as_assigner then
					-- relative to a feature "1.2.3" is always the assigner
					l_transformable.apply_modification (basic_operators.replace_with_string (create {AST_PATH}.make_from_string(f_assigner), preferences.setter_name))

					-- extract original comment
					l_comment := ast_tools.extract_feature_comments (l_feat_ast, l_matchlist)
				end

				if not etr_error_handler.has_errors then
					l_append_text := "%N"

					l_append_text.append (
						ast_tools.commented_feature_to_string (
							setter_generator.transformation_result,
							" Set `"+feature_i.feature_name+"' to `a_"+feature_i.feature_name+"'."
						)
					)

					l_append_text.append("%N%T")

					if preferences.use_as_assigner then
						l_old_feat_text :=
							ast_tools.commented_feature_to_string (
								l_transformable,
								l_comment
							)

						l_feat_ast.replace_text ("%N"+l_old_feat_text+l_append_text, l_matchlist)
					else
						l_feat_ast.append_text (l_append_text, l_matchlist)
					end

					create l_class_modifier.make (l_written_class.original_class)
					l_class_modifier.prepare
					l_class_modifier.set_changed_text (l_matchlist.all_modified_text)
					l_class_modifier.commit
		        	current_actions.extend (l_class_modifier)
				else
		        	show_etr_error
		        	success := false
		        	error_handler.wipe_out
				end
			end
		rescue
			show_etr_error
			success := false
			error_handler.wipe_out
			l_retry := true
			retry
		end

note
	copyright:	"Copyright (c) 1984-2010, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
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
