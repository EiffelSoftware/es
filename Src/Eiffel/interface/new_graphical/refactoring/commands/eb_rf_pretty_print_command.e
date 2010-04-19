note
	description: "Command for the pretty print refactoring."
	date: "$Date$"
	revision: "$Revision$"

class
	EB_RF_PRETTY_PRINT_COMMAND
inherit
	EB_TOOLBARABLE_AND_MENUABLE_COMMAND
		redefine
			new_sd_toolbar_item,
			tooltext,
			is_tooltext_important
		end

	SHARED_DEBUGGER_MANAGER

	SHARED_EIFFEL_PROJECT

	EB_SHARED_MANAGERS

	EB_CONSTANTS

	EB_SHARED_PREFERENCES

create
	make

feature {NONE} -- Initialization

	make (a_manager: ERF_MANAGER)
			-- Create associated to `a_manager'.
		require
			a_manager_not_void: a_manager /= Void
		do
			manager := a_manager
		end

feature -- Events

	drop_feature (fs: FEATURE_STONE)
			-- Process feature stone.
		local
			feature_i: FEATURE_I
			rf: ERF_FEATURE_PRETTY_PRINT
		do
			if fs.e_class /= Void then
				feature_i := fs.e_class.feature_of_feature_id (fs.e_feature.feature_id)
			end
			if feature_i /= Void and then fs.e_feature.associated_class.class_id = feature_i.written_in then
				rf := manager.feature_pretty_print_refactoring
				rf.set_feature (feature_i)
				manager.execute_refactoring (rf)
			else
				prompts.show_error_prompt (warning_messages.w_feature_not_written_in_class, Void, Void)
			end
		end

	drop_class (cs: CLASSI_STONE)
			-- Process class stone.
		local
			window: EB_DEVELOPMENT_WINDOW
			rf: ERF_CLASS_PRETTY_PRINT
		do
			if not attached {FEATURE_STONE}cs then
				if attached {EIFFEL_CLASS_I} cs.class_i as eif_class_i and then eif_class_i.is_compiled then
					rf := manager.class_pretty_print_refactoring
					rf.set_class (eif_class_i)

					manager.execute_refactoring (rf)
				else
					window := window_manager.last_focused_development_window
					prompts.show_info_prompt ("Select a compiled Eiffel-class", window.window, Void)
				end
			else
				-- Ignore this drop action
			end
		end

feature -- Status

	is_tooltext_important: BOOLEAN
			-- Is the tooltext important shown when view is 'Selective Text'
		do
			Result := True
		end

feature -- Access

	description: STRING_GENERAL
			-- What is printed in the customize dialog.
		do
			Result := interface_names.f_refactoring_pretty_print
		end

	tooltip: STRING_GENERAL
			-- Pop-up help on buttons.
		do
			Result := description
		end

	tooltext: STRING_GENERAL
			-- Text for toolbar button
		do
			Result := interface_names.b_refactoring_pretty_print
		end

	new_sd_toolbar_item (display_text: BOOLEAN): EB_SD_COMMAND_TOOL_BAR_BUTTON
			-- Create a new toolbar button for `Current'.
		do
			Result := Precursor {EB_TOOLBARABLE_AND_MENUABLE_COMMAND} (display_text)
			Result.drop_actions.extend (agent drop_feature (?))
			Result.drop_actions.extend (agent drop_class (?))
		end

	menu_name: STRING_GENERAL
			-- Menu entry corresponding to `Current'.
		do
			Result := tooltext
		end

	pixmap: EV_PIXMAP
			-- Icon for `Current'.
		do
			Result := pixmaps.icon_pixmaps.tool_config_icon
		end

	pixel_buffer: EV_PIXEL_BUFFER
			-- Pixel buffer representing the command.
		do
			Result := pixmaps.icon_pixmaps.tool_config_icon_buffer
		end

	Name: STRING = "RF_pretty_print"
			-- Name of `Current' to identify it.

feature -- Execution

	execute
			-- Execute.
		local
			window: EB_DEVELOPMENT_WINDOW
		do
			window := window_manager.last_focused_development_window

			if attached {CLASSI_STONE}window.stone as cs then
				drop_class (cs)
			elseif attached {FEATURE_STONE}window.stone as fs then
				drop_feature (fs)
			else
				prompts.show_info_prompt ("Select a feature or class to pretty print", window.window, Void)
			end
		end

feature {NONE} -- Implementation

	manager: ERF_MANAGER
			-- Refactoring manager
invariant
	manager_not_void: manager /= Void
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
