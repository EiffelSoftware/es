note
	description: "[
		Command for launching a workbench system in replay mode
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_EXEC_REPLAYED_CMD

inherit
	ES_DBG_TOOLBARABLE_AND_MENUABLE_COMMAND
		redefine
			tooltext
		end

	EB_SHARED_PREFERENCES
		export
			{NONE} all
		end

create
	make

feature -- Initialization

	make
			-- Initialize `Current'.
		do
--			if attached preferences.misc_shortcut_data.shortcuts.item ("run_workbench_outside") as l_shortcut then
--				create accelerator.make_with_key_combination (l_shortcut.key, l_shortcut.is_ctrl, l_shortcut.is_alt, l_shortcut.is_shift)
--				set_referred_shortcut (l_shortcut)
--				accelerator.actions.extend (agent execute_from_accelerator)
--			end
		end

feature -- Execution

	execute_from_accelerator
			-- Execute from accelerator
		do
			execute
		end

	execute
			-- Execute Current.
		do
			if attached debugger_manager as dbg then
				dbg.controller.debug_application (dbg.current_execution_parameters, {EXEC_MODES}.replay)
			end
		end

feature -- Properties

	pixmap: EV_PIXMAP
			-- Pixmaps representing the command.
		do
			Result := pixmaps.icon_pixmaps.debug_run_icon
		end

	pixel_buffer: EV_PIXEL_BUFFER
			-- Pixel buffer representing the command.
		do
			Result := pixmaps.icon_pixmaps.debug_run_icon_buffer
		end

	description: STRING_GENERAL
			-- Text describing `Current' in the customize tool bar dialog.
		do
			Result := Interface_names.f_Run_replayed_workbench
		end

	tooltip: STRING_GENERAL
			-- Short description of Current.
		do
			Result := Interface_names.f_Run_replayed_workbench
		end

	tooltext: STRING_GENERAL
			-- Short description of Current.
		do
			Result := Interface_names.b_Run_replayed_workbench
		end

	name: STRING = "Run_replayed_workbench"
			-- Text internally defining Current.

	menu_name: STRING_GENERAL
			-- Name used in menu entry
		do
			Result := Interface_names.m_Run_replayed_workbench
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
