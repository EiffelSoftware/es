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
			internal_recycle,
			create_mini_tool_bar_items
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
				overview_panel.update_blackboard_data
--				overview_panel.initialize_from_blackboard
			else
--				blackboard.data_initialized_event.subscribe (agent overview_panel.initialize_from_blackboard)
				blackboard.data_initialized_event.subscribe (agent overview_panel.update_blackboard_data)
			end

-- For the moment always recreate display
--			blackboard.data_changed_event.subscribe (agent overview_panel.update_display)
--			blackboard.data_changed_event.subscribe (agent overview_panel.initialize_from_blackboard)
			blackboard.data_changed_event.subscribe (agent overview_panel.update_blackboard_data)
			blackboard.tool_execution_changed_event.subscribe (agent progress_panel.update_display)

--			create update_task.make (agent overview_panel.initialize_from_blackboard, 5000)
			create update_task.make (agent overview_panel.update_blackboard_data, 5000)
			rota.run_task (update_task)
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

   create_mini_tool_bar_items: DS_ARRAYED_LIST [SD_TOOL_BAR_ITEM]
            -- Retrieves a list of tool bar items to display on the window title
		local
			l_button: SD_TOOL_BAR_BUTTON
			l_toggle_button: SD_TOOL_BAR_TOGGLE_BUTTON
        do
        	create Result.make (10)

        	create l_button.make
        	l_button.set_pixel_buffer (stock_pixmaps.debug_run_icon_buffer)
        	l_button.set_pixmap (stock_pixmaps.debug_run_icon)
        	l_button.set_tooltip ("Start verification assistant")
        	register_action (l_button.select_actions, agent on_start_control_clicked)
        	Result.put_last (l_button)
        	start_control_button := l_button

        	create l_button.make
        	l_button.set_pixel_buffer (stock_pixmaps.debug_stop_icon_buffer)
        	l_button.set_pixmap (stock_pixmaps.debug_stop_icon)
        	l_button.set_tooltip ("Stop verification assistant")
        	l_button.disable_sensitive
        	register_action (l_button.select_actions, agent on_stop_control_clicked)
        	Result.put_last (l_button)
        	stop_control_button := l_button

			Result.put_last (create {SD_TOOL_BAR_SEPARATOR}.make)

        	create l_toggle_button.make
        	l_toggle_button.set_pixel_buffer (stock_pixmaps.feature_attribute_icon_buffer)
        	l_toggle_button.set_pixmap (stock_pixmaps.feature_attribute_icon)
        	l_toggle_button.set_tooltip ("Show attributes")
--        	register_action (l_toggle_button.select_actions, agent on_show_verification_status)
        	Result.put_last (l_toggle_button)
--        	show_verification_status_button := l_toggle_button

			Result.put_last (create {SD_TOOL_BAR_SEPARATOR}.make)

        end

	build_tool_interface (root_widget: EV_NOTEBOOK)
			-- <Precursor>
		do
--			create system_grid.make
			create overview_panel.make (develop_window)
			create progress_panel.make
			create configuration_panel.make

--			user_widget.extend (system_grid)
			user_widget.extend (overview_panel.grid)
			user_widget.extend (progress_panel.grid)
			user_widget.extend (configuration_panel.panel)

			user_widget.item_tab (overview_panel.grid).set_text ("Overview")
			user_widget.item_tab (overview_panel.grid).set_pixmap (stock_pixmaps.general_information_icon)

			user_widget.item_tab (progress_panel.grid).set_text ("Progress")
			user_widget.item_tab (progress_panel.grid).set_pixmap (stock_pixmaps.debug_run_icon)

			user_widget.item_tab (configuration_panel.panel).set_text ("Configuration")
			user_widget.item_tab (configuration_panel.panel).set_pixmap (stock_pixmaps.tool_preferences_icon)
		end

feature -- Access

	overview_panel: ES_BLACKBOARD_OVERVIEW_PANEL
			-- Panel for system overview.

	progress_panel: ES_BLACKBOARD_PROGRESS_PANEL
			-- Panel displaying current progress.

	configuration_panel: ES_BLACKBOARD_CONFIGURATION_PANEL
			-- Panel for configuring blackboard.

	start_control_button: SD_TOOL_BAR_BUTTON
			-- Button to start control.

	stop_control_button: SD_TOOL_BAR_BUTTON
			-- Button to stop control.

feature -- Status report

feature {NONE} -- Event handlers

	on_start_control_clicked
			--
		do
			blackboard.control.start

			start_control_button.disable_sensitive
			stop_control_button.enable_sensitive
		end

	on_stop_control_clicked
			--
		do
			blackboard.control.stop

			start_control_button.enable_sensitive
			stop_control_button.disable_sensitive
		end

feature {NONE} -- Implementation

	frozen rota: ROTA_S
			-- Access to rota service.
		local
			l_service_consumer: SERVICE_CONSUMER [ROTA_S]
		once
			create l_service_consumer
			if l_service_consumer.is_service_available then
				Result := l_service_consumer.service
			else
				check False end
			end
		ensure
			result_attached: Result /= Void
		end

	update_task: ROTA_TIMED_AGENT_TASK
			-- Task to update display periodically.

	show_attributes_session_id: STRING_8 = "com.eiffel.eve.blackboard.show_attributes"
	control_session_id: STRING_8 = "com.eiffel.eve.blackboard.control"
			-- Session IDs

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
			update_task.cancel
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
