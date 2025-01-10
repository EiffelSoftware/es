note
	description	: "Command to reset links layout."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date		: "$Date$"
	revision	: "$Revision$"

class
	EB_RESET_LINK_TOOL_COMMAND

inherit
	EB_CONTEXT_DIAGRAM_COMMAND
		undefine
			menu_name
		end

create
	make

feature -- Basic operations

	execute
			-- Perform on the whole diagram.
		do
		end

	execute_with_link_stone (a_stone: LINK_STONE)
			-- Change `a_stone' layout as the user wants.
		local
			lf: EIFFEL_LINK_FIGURE
		do
			if a_stone.source.world = tool.world then
					-- Save current link midpoints.
				lf := a_stone.source
				lf.reset

				history.do_named_undoable (
					Interface_names.t_Diagram_remove_handles_cmd,
					agent lf.reset,
					agent lf.retrieve_edges (saved_edges)
				)

				tool.projector.project
				saved_edges := lf.edges
			end
		end


feature -- Access

	tooltip: STRING_GENERAL
			-- Tooltip for the toolbar button.
		do
			Result := Interface_names.t_Diagram_remove_handles_cmd
		end

feature {NONE} -- Implementation

	current_stone: LINK_STONE
			-- Last dropped stone.

	pixmap: EV_PIXMAP
			-- Pixmap representing the command.
		do
			Result := pixmaps.icon_pixmaps.general_reset_icon
		end

	pixel_buffer: EV_PIXEL_BUFFER
			-- Pixel buffer representing the command.
		do
			Result := pixmaps.icon_pixmaps.general_reset_icon_buffer
		end

	menu_name: STRING_GENERAL
			-- Name of the menu entry
		do
			Result := Interface_names.m_diagram_reset_link_tool
		end

	name: STRING = "ResetLink_tool"
			-- Name of the command. Used to store the command in the
			-- preferences.

	saved_edges: LIST [EG_EDGE]
			-- Backup of previous link midpoints.

invariant

note
	copyright:	"Copyright (c) 1984-2024, Eiffel Software"
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
