note
	description: "The repositories tool to view a repository's hierarchy"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_REPOSITORIES_TOOL_PANEL

inherit
	ES_DOCKABLE_STONABLE_TOOL_PANEL [EB_REPOSITORIES_TREE]
		redefine
			is_stone_sychronization_required,
			create_mini_tool_bar_items
		end

create
	make

feature {NONE} -- Initialization: User interface

    build_tool_interface (a_widget: attached EB_REPOSITORIES_TREE)
            -- <Precursor>
		do

		end

feature {NONE} -- Access
	repositories_manager: attached EB_REPOSITORIES_MANAGER
		do
			Result := develop_window.repositories_manager.as_attached
		end

feature {NONE} -- Access: User interface

	new_repository_button: SD_TOOL_BAR_BUTTON
			-- Button used to add a new repository.

	delete_repository_button: SD_TOOL_BAR_BUTTON
			-- Button used to remove an existing repository.

feature {NONE} -- Status report

	is_stone_sychronization_required (a_old_stone: detachable STONE; a_new_stone: detachable STONE): BOOLEAN
			-- <Precursor>
		do
				-- No synchornization required, stone setting is only used to locate a stone.
			Result := False
		end

feature {NONE} -- Action handlers

	on_stone_changed (a_old_stone: detachable like stone)
			-- <Precursor>
		do
			-- File at repository URL could be displayed
		end

	on_project_loaded
			-- Called when a project has been loaded.
		require
			is_interface_usable: is_interface_usable
			workbench_is_already_compiled: workbench.is_already_compiled
		do
		end

feature {NONE} -- Factory

    create_widget: attached EB_REPOSITORIES_TREE
			-- <Precursor>
		do
			Result := repositories_manager.widget.as_attached
		end

    create_mini_tool_bar_items: detachable DS_ARRAYED_LIST [SD_TOOL_BAR_ITEM]
			-- <Precursor>
		local
			l_button: SD_TOOL_BAR_BUTTON
		do
			create Result.make (2)

				-- Add button `new_repository_button' to the toolbar
			create l_button.make
			l_button.set_tooltip (Interface_names.t_new_repository)
			l_button.select_actions.extend (agent repositories_manager.show_add_repository_dialog)
			l_button.set_pixel_buffer (stock_mini_pixmaps.general_edit_icon_buffer)
			l_button.set_pixmap (stock_mini_pixmaps.general_edit_icon)
			new_repository_button := l_button

			Result.put_last (l_button)

				-- Add button `delete_repository_button' to the toolbar
			create l_button.make
			l_button.set_tooltip ("Delete repository")
			l_button.select_actions.extend (agent repositories_manager.remove_repository)
			l_button.set_pixel_buffer (stock_mini_pixmaps.general_delete_icon_buffer)
			l_button.set_pixmap (stock_mini_pixmaps.general_delete_icon)
			delete_repository_button := l_button

			Result.put_last (l_button)
		end

    create_tool_bar_items: detachable DS_ARRAYED_LIST [SD_TOOL_BAR_ITEM]
			-- <Precursor>
		do
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
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
