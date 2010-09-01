note
	description:
		"Graphical panel for blackboard."
	date: "$Date$"
	revision: "$Revision$"

class
	ES_BLACKBOARD_TOOL_PANEL

inherit
	ES_DOCKABLE_STONABLE_TOOL_PANEL [EV_NOTEBOOK]
		redefine
			on_before_initialize,
			on_after_initialized,
			internal_recycle
		end

	EBB_SHARED_BLACKBOARD

	EBB_SHARED_LOG

	EB_CLUSTER_MANAGER_OBSERVER
		export {NONE} all end

	EV_SHARED_APPLICATION
		export {NONE} all end

create {ES_BLACKBOARD_TOOL}
	make

feature {NONE} -- Initialization

	on_before_initialize
			-- <Precursor>
		do
			manager.extend (Current)

			log_cell.put (create {ES_BLACKBOARD_LOG})
		end

	on_after_initialized
			-- <Precursor>
		do
			propagate_drop_actions (Void)

				-- Register events
			if blackboard.is_initialized then
				system_grid.initialize_from_blackboard
			else
				blackboard.data_initialized_event.subscribe (agent system_grid.initialize_from_blackboard)
			end

-- For the moment always recreate display
--			blackboard.data_changed_event.subscribe (agent overview_panel.update_display)
			blackboard.data_changed_event.subscribe (agent system_grid.initialize_from_blackboard)
			blackboard.tool_execution_changed_event.subscribe (agent progress_panel.update_display)
		end

	create_widget: EV_NOTEBOOK
			-- <Precursor>
		do
			create Result
		end

	create_tool_bar_items: DS_ARRAYED_LIST [SD_TOOL_BAR_ITEM]
			-- <Precursor>
		local
			l_button: SD_TOOL_BAR_BUTTON
		do
		end

	build_tool_interface (root_widget: EV_NOTEBOOK)
			-- <Precursor>
		do
			create system_grid.make
			create progress_panel.make
			create configuration_panel.make

			user_widget.extend (system_grid)
			user_widget.extend (progress_panel.grid)
			user_widget.extend (configuration_panel.panel)

			user_widget.item_tab (system_grid).set_text ("Overview")
			user_widget.item_tab (system_grid).set_pixmap (stock_pixmaps.general_information_icon)

			user_widget.item_tab (progress_panel.grid).set_text ("Progress")
			user_widget.item_tab (progress_panel.grid).set_pixmap (stock_pixmaps.debug_run_icon)

			user_widget.item_tab (configuration_panel.panel).set_text ("Configuration")
			user_widget.item_tab (configuration_panel.panel).set_pixmap (stock_pixmaps.tool_preferences_icon)
		end

feature -- Access

	system_grid: ES_BLACKBOARD_SYSTEM_GRID
			-- Panel for system overview.

	overview_panel: ES_BLACKBOARD_OVERVIEW_PANEL
			-- Panel for system overview.

	progress_panel: ES_BLACKBOARD_PROGRESS_PANEL
			-- Panel displaying current progress.

	configuration_panel: ES_BLACKBOARD_CONFIGURATION_PANEL
			-- Panel for configuring blackboard.

feature -- Status report

feature {NONE} -- Implementation

	frozen rota: ROTA_S
			-- Access to rota service
		local
			l_service_consumer: SERVICE_CONSUMER [ROTA_S]
		do
			create l_service_consumer
			if l_service_consumer.is_service_available then
				Result := l_service_consumer.service
			else
				check False end
			end
		end

feature {NONE} -- User interface items


feature {NONE} -- Events

	on_stone_changed (a_old_stone: detachable like stone)
			-- <Precursor>
		do
		end

feature {NONE} -- Clean up

	internal_recycle
			-- <Precursor>
		do
			manager.prune (Current)
			Precursor
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
