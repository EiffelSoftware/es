note
	description: "The groups tool to view a project's group hierarchy and contained classes together with Subversion information."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_SVN_GROUPS_TOOL_PANEL

inherit
	ES_DOCKABLE_STONABLE_TOOL_PANEL [EB_GROUPS_GRID]
		redefine
			on_after_initialized,
			is_stone_sychronization_required,
			create_mini_tool_bar_items
		end

create
	make

feature {NONE} -- Initialization: User interface

	build_tool_interface (a_widget: attached EB_GROUPS_GRID)
			-- <Precursor>
		do
			a_widget.associate_with_window (develop_window)
		end

	on_after_initialized
			-- <Precursor>
		local
			l_project_manager: detachable EB_PROJECT_MANAGER
		do
			Precursor

			l_project_manager := workbench.eiffel_project.manager
			if not workbench.is_already_compiled then
					-- The is an incomplete compiled project, set up the agents to handle
					-- senitivity setting of project-sensitive widgets.
				register_action (l_project_manager.load_agents, agent on_project_loaded)
			else
				on_project_loaded
			end
		end

feature -- Access: Help

	help_context_id: STRING
			-- <Precursor>
		once
			Result := "0BAEBAA5-A9C8-4C7C-6ACE-C11D82804906"
		end

feature {NONE} -- Status report

	is_stone_sychronization_required (a_old_stone: detachable STONE; a_new_stone: detachable STONE): BOOLEAN
			-- <Precursor>
		do
				-- No synchornization required, stone setting is only used to locate a stone.
			Result := False
		end

feature {ES_GROUPS_COMMANDER_I} -- Basic operations

	highlight_stone (a_stone: attached STONE)
			-- <Precursor>
		do
			set_stone (a_stone)
		end

	highlight_editor_stone
			-- <Precursor>
		local
			l_editor: detachable EB_SMART_EDITOR
			l_stone: detachable STONE
			l_error: ES_ERROR_PROMPT
		do
			l_editor := develop_window.editors_manager.current_editor
			if l_editor /= Void then
				l_stone := l_editor.stone
				if l_stone /= Void then
					if is_stone_usable (l_stone) then
						highlight_stone (l_stone)
					elseif not is_in_stone_synchronization then
							-- No need to show an error during a synchornization. This should never actually
							-- happen because the tool {ES_SVN_GROUPS_TOOL} does not permit stone synchronization.
						create l_error.make_standard (locale_formatter.translation (e_invalid_editor))
						l_error.show_on_active_window
					end
				end
			else
				create l_error.make_standard (locale_formatter.translation (e_no_open_editor))
				l_error.show_on_active_window
			end
		end

feature {NONE} -- Action handlers

	on_stone_changed (a_old_stone: detachable like stone)
			-- <Precursor>
		local
			l_stone: like stone
		do
			l_stone := stone
			if l_stone /= Void and then not user_widget.is_empty then
				if attached {CLASSI_STONE}l_stone as l_class then
--					user_widget.show_class (l_class.class_i)
				elseif attached {CLUSTER_STONE} l_stone as l_group then
--					user_widget.show_subfolder (l_group.group, l_group.path)
				else
--					user_widget.show_stone (l_stone)
				end
			end
		end

	on_project_loaded
			-- Called when a project has been loaded.
		require
			is_interface_usable: is_interface_usable
			workbench_is_already_compiled: workbench.is_already_compiled
		do
			user_widget.on_project_loaded
			highlight_editor_stone
		end

feature {NONE} -- Factory

    create_widget: attached EB_GROUPS_GRID
			-- <Precursor>
		do
			create Result.make (context_menus)
		end

    create_mini_tool_bar_items: detachable DS_ARRAYED_LIST [SD_TOOL_BAR_ITEM]
			-- <Precursor>
		do
			create Result.make (1)
		end

    create_tool_bar_items: detachable DS_ARRAYED_LIST [SD_TOOL_BAR_ITEM]
			-- <Precursor>
		do
		end

feature {NONE} -- Internationalization

	e_no_open_editor: STRING = "There is no open editor to locate a class or cluster from."
	e_invalid_editor: STRING = "The active editor does not contain a valid class or cluster."

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
