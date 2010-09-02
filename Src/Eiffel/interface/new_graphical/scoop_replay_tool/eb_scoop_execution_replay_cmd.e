note

	description: "Command that launches scoop execution replay wizard."
	author: "Rusakov Andrey"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_SCOOP_EXECUTION_REPLAY_CMD

inherit
	EB_TOOLBARABLE_AND_MENUABLE_COMMAND
		redefine
			tooltext
		end

	EB_CONSTANTS

	SHARED_DEBUGGER_MANAGER

	EB_SHARED_WINDOW_MANAGER

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
		end

feature -- Formatting

	execute
		local
			wizard_manager: EB_SCOOP_REPLAY_WIZARD_MANAGER
		do
			create wizard_manager.make_and_launch (window_manager.last_focused_development_window.window)
		end

feature -- Dialog

	build_handler_dialog
			-- Build handler dialog
		local
			dialog: ES_EXCEPTION_HANDLER_DIALOG
		do
			create dialog.make
			dialog.set_handler (Debugger_manager.exceptions_handler)
			handler_dialog := dialog
		end

	handler_dialog: EV_DIALOG
			-- last opened handler dialog.

feature {NONE} -- Attributes

	name: STRING = "scoop_execution_replay"
			-- Name of the command.

	description: STRING_GENERAL
			-- What appears in the customize dialog box.
		do
			Result := tooltip
		end

	tooltip: STRING_GENERAL
			-- Tooltip displayed on `Current's buttons.
		do
			Result := Interface_names.e_scoop_execution_replay
		end

	tooltext: STRING_GENERAL
			-- Text displayed on `Current's buttons.
		do
			Result := Interface_names.b_scoop_execution_replay
		end

	menu_name: STRING_GENERAL
			-- Menu entry corresponding to `Current'.
		once
			Result := Interface_names.m_scoop_execution_replay
		end

	pixmap: EV_PIXMAP
			-- Pixmap representing `Current' on buttons.
		do
			Result := pixmaps.icon_pixmaps.execution_replay_icon
		end

	pixel_buffer: EV_PIXEL_BUFFER
			-- Pixel buffer representing the command.
		do
			Result := pixmaps.icon_pixmaps.execution_replay_icon_buffer
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
