note
	description: "Command for the extract method refactoring."
	date: "$Date$"
	revision: "$Revision$"

class
	EB_RF_EXTRACT_METHOD_COMMAND
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
			Result := interface_names.f_refactoring_extract_method
		end

	tooltip: STRING_GENERAL
			-- Pop-up help on buttons.
		do
			Result := description
		end

	tooltext: STRING_GENERAL
			-- Text for toolbar button
		do
			Result := interface_names.b_refactoring_extract_method
		end

	new_sd_toolbar_item (display_text: BOOLEAN): EB_SD_COMMAND_TOOL_BAR_BUTTON
			-- Create a new toolbar button for `Current'.
		do
			Result := Precursor {EB_TOOLBARABLE_AND_MENUABLE_COMMAND} (display_text)
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

	Name: STRING = "RF_extract_method"
			-- Name of `Current' to identify it.

feature -- Execution

	execute
			-- Execute.
		local
			window: EB_DEVELOPMENT_WINDOW
			rf: ERF_EXTRACT_METHOD
			displayed_text: CLICKABLE_TEXT
		do
			window := window_manager.last_focused_development_window

			if attached {CLASSI_STONE}window.stone as cs and then attached {EIFFEL_CLASS_I}cs.class_i as eif_class_i and then eif_class_i.is_compiled then
				rf := manager.extract_method_refactoring
				rf.set_class (eif_class_i)

				displayed_text := window.ui.current_editor.text_displayed

				if not displayed_text.selection_is_empty then
					rf.set_start_line(displayed_text.selection_start.y_in_lines)
					rf.set_end_line(displayed_text.selection_end.y_in_lines)
				else
					rf.set_start_line (displayed_text.cursor.y_in_lines)
					rf.set_end_line (displayed_text.cursor.y_in_lines)
				end

				manager.execute_refactoring (rf)
			else
				prompts.show_info_prompt (warning_messages.w_Class_not_compiled, window.window, Void)
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
