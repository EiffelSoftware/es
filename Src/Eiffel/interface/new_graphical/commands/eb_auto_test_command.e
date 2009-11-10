note
	description: "Summary description for {EB_AUTO_TEST_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_AUTO_TEST_COMMAND

inherit

	EB_TOOLBARABLE_AND_MENUABLE_COMMAND
		redefine
			tooltext,
			new_sd_toolbar_item,
			new_mini_sd_toolbar_item,
			initialize_sd_toolbar_item
		end

	COMPILER_EXPORTER
		export {NONE} all end

	SHARED_WORKBENCH
		export {NONE} all end

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

	SHARED_ERROR_HANDLER
		export {NONE} all end

	SHARED_EIFFEL_PROJECT
		export {NONE} all end

	EB_SHARED_MANAGERS
		export {NONE} all end

	SHARED_TEST_SERVICE
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- Creation method.
		do
			enable_sensitive
			set_up_menu_items
		end

feature -- Execution

	execute is
			-- Execute menu command.
		do
			execute_test_current_item
		end

	execute_with_stone (a_stone: STONE)
			-- Execute with `a_stone'.
		do
			execute_with_stone_content (a_stone, Void)
		end

	execute_with_stone_content (a_stone: STONE; a_content: SD_CONTENT) is
			-- Execute with `a_stone'.
		local
			l_config: TEST_GENERATOR_CONF
			l_prefs: EB_SHARED_PREFERENCES
			l_test_info: ES_TEST_WIZARD_INFORMATION
		do
			if not eiffel_project.is_compiling then
				if attached {CLASSC_STONE} a_stone as l_stone then
					create l_prefs
					create l_test_info.make (l_prefs.preferences.testing_tool_data)
					l_config := l_test_info.generator_conf.deep_twin
					l_config.set_ddmin_enabled (False)
					l_config.set_slicing_enabled (False)
					l_config.set_html_output (False)
					l_config.set_time_out (1)
					l_config.set_cluster (universe.cluster_of_name (universe.system.root_type.associated_class.group.name))
					l_config.set_path ("")
					l_config.types_cache.force_last (l_stone.class_name)
					launch_processor ({TEST_GENERATOR_I}, l_config)
				end
			end
		end

feature -- Items

	new_sd_toolbar_item (display_text: BOOLEAN): EB_SD_COMMAND_TOOL_BAR_DUAL_POPUP_BUTTON
			-- <Precursor>
		do
			create Result.make (Current)
			initialize_sd_toolbar_item (Result, display_text)
			Result.select_actions.extend (agent execute_last_action)

			Result.drop_actions.extend (agent execute_with_stone)
			Result.drop_actions.set_veto_pebble_function (agent droppable)
		end

	new_mini_sd_toolbar_item: EB_SD_COMMAND_TOOL_BAR_BUTTON
			-- <Precursor>
		do
			Result := Precursor {EB_TOOLBARABLE_AND_MENUABLE_COMMAND}
			Result.drop_actions.extend (agent execute_with_stone)
			Result.drop_actions.set_veto_pebble_function (agent droppable)
		end

	initialize_sd_toolbar_item (a_item: EB_SD_COMMAND_TOOL_BAR_DUAL_POPUP_BUTTON; display_text: BOOLEAN) is
			-- <Precursor>
		do
			Precursor (a_item, display_text)
			a_item.set_menu_function (agent drop_down_menu)
		end

feature -- Status report

	droppable (a_pebble: ANY): BOOLEAN is
			-- Can user drop `a_pebble' on `Current'?
		local
			l_class_stone: CLASSC_STONE
		do
			l_class_stone ?= a_pebble
			Result := l_class_stone /= Void
		end

feature {NONE} -- Implementation

	window: EB_DEVELOPMENT_WINDOW
			-- Associated development window (if any)

	pixmap: EV_PIXMAP
			-- Pixmap representing the command.
		do
			Result := pixmaps.icon_pixmaps.testing_new_unit_test_icon
		end

	pixel_buffer: EV_PIXEL_BUFFER
			-- Pixel buffer representing the command.
		do
			Result := pixmaps.icon_pixmaps.testing_new_unit_test_icon_buffer
		end

	execute_last_action
			-- Execute same action as last time.
		do
			last_execution.call ([])
		end

	put_output_message (a_string: STRING)
			-- Put `a_string' to output panel.
		do
			output_manager.add_string (a_string)
			output_manager.add_new_line
			output_manager.end_processing
		end

	put_window_message (a_string: STRING)
			-- Put `a_string' to window status bar.
		do
			window_manager.display_message (a_string)
		end

feature {NONE} -- Implementation

	execute_test_current_item
			-- Proof current item
		local
			l_window: EB_DEVELOPMENT_WINDOW
		do
			l_window := window_manager.last_focused_development_window
			if droppable (l_window.stone) then
				execute_with_stone (l_window.stone)
			end
		end

	set_up_menu_items
			-- Set up menu items of proof button
		do
			last_execution := agent execute_test_current_item
			create test_current_item_item.make_with_text_and_action ("Test current class", agent execute_test_current_item)
			test_current_item_item.toggle
		end

	drop_down_menu: EV_MENU is
			-- Drop down menu for `new_sd_toolbar_item'.
		once
			create Result
			Result.extend (test_current_item_item)
		ensure
			not_void: Result /= Void
		end

	last_execution: PROCEDURE [ANY, TUPLE []]
			-- Last executed actions

	test_current_item_item: EV_CHECK_MENU_ITEM
			-- Menu item to proof current item

	menu_name: STRING_GENERAL
			-- Name as it appears in the menu (with & symbol).
		do
			Result := locale.translation ("AutoTest")
		end

	tooltip: STRING_GENERAL
			-- Tooltip for the toolbar button.
		do
			Result := locale.translation ("AutoTest current class")
		end

	tooltext: STRING_GENERAL
			-- Text for the toolbar button.
		do
			Result := locale.translation ("AutoTest")
		end

	description: STRING_GENERAL
			-- Description for this command.
		do
			Result := locale.translation ("AutoTest")
		end

	name: STRING_GENERAL
			-- Name of the command. Used to store the command in the
			-- preferences.
		do
			Result := "AutoTest"
		end

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
