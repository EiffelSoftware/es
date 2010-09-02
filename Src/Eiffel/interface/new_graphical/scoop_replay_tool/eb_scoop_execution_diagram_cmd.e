note
	description: "Command that activates/deactivates scoop execution diagram generation."
	author: "Rusakov Andrey"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_SCOOP_EXECUTION_DIAGRAM_CMD

inherit
	EB_TOOLBARABLE_AND_MENUABLE_TOGGLE_COMMAND
		redefine
			tooltext,
			set_select
		end

	EB_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_manager: like debugger_manager)
			-- Initialize `Current'.
		do
			debugger_manager := a_manager 
		end

	debugger_manager: EB_DEBUGGER_MANAGER
			-- Manager in charge of all debugging operations.

feature -- Execution

	reset
		do
			set_select (False)
		end

	execute
		do
			execution_diagram_activated := not debugger_manager.scoop_execution_diagram_enabled
			debugger_manager.activate_scoop_execution_diagram (execution_diagram_activated )
		end

feature -- Status

	execution_diagram_activated: BOOLEAN
			-- Is activated ?

	is_selected: BOOLEAN
		do
			Result := debugger_manager.scoop_execution_diagram_enabled
		end

feature -- Change text

	set_select (b: BOOLEAN)
			-- <Precursor>
		do
			execution_diagram_activated := b
			Precursor (b)
			update_items
		end

feature -- Access

	description: STRING_GENERAL
			-- What appears in the customize dialog box.
		do
			Result := tooltip
		end

	tooltip: STRING_GENERAL
			-- Tooltip displayed on `Current's buttons.
		do
			if not is_selected then
				Result := Interface_names.b_activate_SCOOP_execution_diagram
			else
				Result := interface_names.b_deactivate_SCOOP_execution_diagram
			end
		end

	tooltext: STRING_GENERAL
			-- Text displayed on `Current's buttons.
		do
			if not is_selected then
				Result := Interface_names.b_activate_SCOOP_execution_diagram
			else
				Result := interface_names.b_deactivate_SCOOP_execution_diagram
			end
		end

	name: STRING = "scoop_execution_diagram"
			-- Name of the command.

	menu_name: STRING_GENERAL
			-- Menu entry corresponding to `Current'.
		do
			if not is_selected then
				Result := Interface_names.m_activate_SCOOP_execution_diagram
			else
				Result := interface_names.m_deactivate_SCOOP_execution_diagram
			end
		end

	pixmap: EV_PIXMAP
			-- Pixmap representing `Current' on buttons.
		do
			Result := pixmaps.icon_pixmaps.tool_diagram_icon
		end

	pixel_buffer: EV_PIXEL_BUFFER
			-- Pixel buffer representing the command.
		do
			Result := pixmaps.icon_pixmaps.diagram_anchor_icon_buffer
		end


note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
