note
	description: "Browse through serialized objects."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_TOOL_PANEL

inherit
	ES_DOCKABLE_TOOL_PANEL [EV_HORIZONTAL_SPLIT_AREA]
		redefine
			on_after_initialized,
			internal_recycle,
			create_tool_bar_items,
			create_right_tool_bar_items,
			create_mini_tool_bar_items,
			show
		end

	ES_TOOL_ICONS_PROVIDER_I [ES_EBBRO_TOOL_ICONS]
		rename
			tool as tool_descriptor
		export
			{NONE} all
		end

	EB_SHARED_WINDOW_MANAGER

	ES_EBBRO_DISPLAY_CONST

	ES_EBBRO_NAMES

	ES_EBBRO_PERSISTENCE_CONSTANTS


create
	make

feature {NONE} -- Initialization

	on_after_initialized
			-- <Precursor>
		do
			init_ebbro
			Precursor
		end

feature {NONE} -- User interface initialization

	 build_tool_interface (a_widget: EV_HORIZONTAL_SPLIT_AREA)
			-- Builds the tools user interface elements.
			-- Note: This function is called prior to showing the tool for the first time.
			--
			-- `a_widget': A widget to build the tool interface using.
		do
			create right_grid_view
			right_grid_view.ebbro_init(current,false)
			create left_grid_view
			left_grid_view.ebbro_init(current,true)
			right_grid_view.set_up
			left_grid_view.set_up

			right_grid_view.set_separator_color (colors.grid_line_color)
			left_grid_view.set_separator_color (colors.grid_line_color)

			main_container.extend(left_grid_view)
			main_container.extend(right_grid_view)
			main_container.set_proportion (0.5)
			main_container.disable_dockable


--			-- set actions
			right_grid_view.row_select_actions.extend (agent on_selecting_row(?,false))
			left_grid_view.row_select_actions.extend (agent on_selecting_row(?,true))

			-- init prefs
			if not preferences.ebbro_tool_data.is_split_screen_enabled then
				right_grid_view.hide
			else
				right_grid_view.toggle_is_split_screen
				left_grid_view.toggle_is_split_screen
			end

			if preferences.ebbro_tool_data.is_addr_column_shown then
				right_grid_view.column (4).show
				left_grid_view.column (4).show
			else
				right_grid_view.column (4).hide
				left_grid_view.column (4).hide
			end

			if preferences.ebbro_tool_data.is_cyclic_browsing_enabled then
				right_grid_view.set_allow_cyclic_browsing(true)
				left_grid_view.set_allow_cyclic_browsing(true)
			else
				right_grid_view.set_allow_cyclic_browsing(false)
				left_grid_view.set_allow_cyclic_browsing(false)
			end

			if preferences.ebbro_tool_data.is_filter_in_enabled then
				right_grid_view.set_filter_in (true)
				left_grid_view.set_filter_in (true)
			end
		end

	build_view_menu
			-- create and populate the view_menu.
		require
			view_menu_not_yet_created: view_menu = Void
		local
			menu_item: EV_CHECK_MENU_ITEM
			menu_item_n: EV_MENU_ITEM
			menu_item_r:EV_RADIO_MENU_ITEM
			menu:EV_MENU
		do
			create view_menu.make_with_text (Menu_view_item)

			-- allow cyclic browsing
			create menu_item.make_with_text (Menu_advanced_cyclic_item)
			menu_item.select_actions.extend(agent on_allow_cyclic(menu_item))
			view_menu.extend (menu_item)
			if preferences.ebbro_tool_data.is_cyclic_browsing_enabled then
				menu_item.toggle
			end

			-- show addr column
			create menu_item.make_with_text (Menu_view_addr_item)
			menu_item.select_actions.extend(agent on_view_addr_column(menu_item))

			if preferences.ebbro_tool_data.is_addr_column_shown then
				menu_item.toggle
			end
			view_menu.extend (menu_item)

			-- enable split screen
			create split_screen_menu_item.make_with_text (menu_view_split_item)
			split_screen_menu_item.select_actions.extend (agent on_show_split_screen(split_screen_menu_item))
			view_menu.extend (split_screen_menu_item)
			if preferences.ebbro_tool_data.is_split_screen_enabled then
				split_screen_menu_item.toggle
			end

			view_menu.extend (create {EV_MENU_SEPARATOR})

			--update all addresses
			create menu_item_n.make_with_text (Menu_advanced_addr_item)
			menu_item_n.select_actions.extend(agent on_update_addr)
			view_menu.extend (menu_item_n)

			view_menu.extend (create {EV_MENU_SEPARATOR})



			--filter options
			create menu.make_with_text (menu_advanced_filter_options)
			create menu_item_r.make_with_text (menu_advanced_filter_in)
			menu_item_r.select_actions.extend (agent on_filter_in(menu_item_r))
			menu.extend (menu_item_r)
			create menu_item_r.make_with_text (menu_advanced_filter_out)
			menu_item_r.select_actions.extend (agent on_filter_out(menu_item_r))
			menu.extend (menu_item_r)

			view_menu.extend (menu)
			if not preferences.ebbro_tool_data.is_filter_in_enabled then
				menu_item_r.enable_select
			end


		ensure
			view_menu_created: view_menu /= Void and then not view_menu.is_empty
		end

	init_ebbro
			-- initialize
		do
			create controller.make
			controller.set_window(current)
			init_actions
			init_pixmaps
		end


	init_actions
			-- registers for actions
		do
			controller.object_decoded_actions.extend (agent on_object_decoded(?))
			controller.decoding_error_actions.extend (agent on_decoding_error(?))
			controller.information_actions.extend(agent on_information(?))
			controller.encoding_error_actions.extend (agent on_encoding_error(?))
		end

	init_pixmaps
			-- initialize the shared pixmap hashtable
		do
			pixmap_hashtable.put (icons.object_type_base_icon, pixmap_base)
			pixmap_hashtable.put (icons.object_type_boolean_icon, pixmap_boolean)
			pixmap_hashtable.put (icons.object_type_container_icon, pixmap_container)
			pixmap_hashtable.put (icons.object_type_numeric_icon, pixmap_numeric)
			pixmap_hashtable.put (icons.object_type_pointer_icon, pixmap_pointer)
			pixmap_hashtable.put (icons.object_type_reference_icon, pixmap_reference)
			pixmap_hashtable.put (icons.object_type_string_icon, pixmap_string)
			pixmap_hashtable.put (icons.object_type_tuple_icon, pixmap_tuple)
			pixmap_hashtable.put (icons.object_type_void_icon, pixmap_void)
			pixmap_hashtable.put (icons.grid_cycle_reference_icon, pixmap_cycle_reference)
		end



feature {NONE} -- Clean up

	 internal_recycle
            -- <Precursor>
        do
            Precursor
        end


feature -- Access

	is_last_selected_row_on_left: BOOLEAN


feature -- Status report



feature {NONE} -- User interface items

	main_container: EV_HORIZONTAL_SPLIT_AREA
			-- Main container (contains all widgets displayed in this window)

	view_menu: EV_MENU
			-- view menu

	view_menu_entry: SD_TOOL_BAR_POPUP_BUTTON
			-- view menu popup button in the right toolbar

	open_file_button: SD_TOOL_BAR_BUTTON
			-- open file button

	save_file_button: SD_TOOL_BAR_BUTTON
			-- save file button

	delete_button: SD_TOOL_BAR_BUTTON
			-- Remove selected object button

	move_right_button: SD_TOOL_BAR_BUTTON
			-- Move object to the right of splitscreen button

	move_left_button: SD_TOOL_BAR_BUTTON
			-- Move object to the left of splitscreen button

	undo_edit_button: SD_TOOL_BAR_BUTTON
			-- Button for undo

	redo_edit_button: SD_TOOL_BAR_BUTTON
			-- Button for redo

	custom_serialization_button: SD_TOOL_BAR_BUTTON
			-- Button for custom serialization

	object_compare_button: SD_TOOL_BAR_BUTTON
			-- Compare objects button

	active_filter_label: EV_LABEL
			-- label in the title bar - which states the active filter

	right_grid_view: ES_EBBRO_GRID
			-- right grid of object browser

	left_grid_view: ES_EBBRO_GRID
			-- left grid view of object browser

	split_screen_menu_item: EV_CHECK_MENU_ITEM
			-- split screen shown/or not item


feature {NONE} -- Command items



feature {NONE} -- Controller connection

	controller: ES_EBBRO_CONTROLLER
			-- controller between GUI and Deserializer/Serializer

	file_opened (a_file_name,a_file_path:STRING)
			-- a file opened
		require
			not_void: a_file_name /= void and a_file_path /= void
		do
			last_opened_filename := a_file_name
			controller.open_file_actions.call ([a_file_name,a_file_path])
		end

	file_saved (a_displayable: ES_EBBRO_DISPLAYABLE;a_format:INTEGER; a_filename: STRING; a_filepath: STRING)
			-- save to file
		do
			controller.encoding_object_actions.call ([a_displayable,a_format, a_filename, a_filepath])
		end


feature -- Basic operations

	show
            -- Show the tool, if possible
        local
			l_split_pos:INTEGER
        do
        	Precursor
			l_split_pos := preferences.ebbro_tool_data.split_position
			if l_split_pos >= main_container.minimum_split_position and l_split_pos <= main_container.maximum_split_position then
				main_container.set_split_position (l_split_pos)
			end
        end

	set_active_filter_text (a_filter_id:INTEGER)
			-- sets the correct filter text for filtered objects
		local
			l_filter_prefix:STRING
		do
			l_filter_prefix := label_filter
			if preferences.ebbro_tool_data.is_filter_in_enabled then
				l_filter_prefix := l_filter_prefix + label_in_filter + ": "
			else
				l_filter_prefix := l_filter_prefix + label_out_filter + ": "
			end

			inspect a_filter_id
			when none_filter_id then
				-- not setting label, if there is no filter active on object
				reset_active_filter_text

				-- active_filter_label.set_text (l_filter_prefix + label_none_filter)
			when void_filter_id then
				active_filter_label.set_text (l_filter_prefix + label_void_filter)
			when cycle_filter_id then
				active_filter_label.set_text (l_filter_prefix + label_cycle_filter)
			else
				check
					unknown_filter_id:false
				end
			end
		end

	reset_active_filter_text
			-- resets the filter text
		do
			active_filter_label.set_text ("")
		end

	set_right_click_menu_pixmaps (a_menu:EV_MENU;is_left:BOOLEAN)
			-- sets the pixmaps in the right_click_menu of the ebbro_grid
		require
			non_void:a_menu /= void
		do
			a_menu.i_th (1).set_pixmap (stock_pixmaps.general_delete_icon)
			if is_left then
				a_menu.i_th (3).set_pixmap (icons.gui_move_right_icon)
			else
				a_menu.i_th (3).set_pixmap (icons.gui_move_left_icon)
			end
			a_menu.i_th (5).set_pixmap (icons.gui_filter_icon)
			a_menu.i_th (7).set_pixmap (stock_pixmaps.general_save_icon)
		end

	reset_object_buttons
			-- resets the buttons: move_left, move_right, delete_object
		do
			move_left_button.disable_sensitive
			move_right_button.disable_sensitive
			undo_edit_button.disable_sensitive
			redo_edit_button.disable_sensitive
			delete_button.disable_sensitive
		end



feature {ES_EBBRO_GRID} -- Action handlers

	request_open_file
			-- on opening an object
			-- show open file dialog
		local
			dialog:EB_FILE_OPEN_DIALOG
			l_diag_fact:ES_EBBRO_DIALOG_FACTORY
		do
			create l_diag_fact
			dialog := l_diag_fact.open_object_dialog

			dialog.show_modal_to_window (parent_window)
			if dialog.selected_button.is_equal ((create {EV_DIALOG_CONSTANTS}).ev_open) then
				file_opened(dialog.file_name, dialog.file_path)
			end
		end

	on_request_save_file (a_displayable:ES_EBBRO_DISPLAYABLE;a_filename:STRING)
			-- write the object back to the file
			-- with overwrite question or not...
		require
			not_void:a_displayable /= void and a_filename /= void
		local
			l_file:RAW_FILE
		do
			create l_file.make (a_filename)
			if l_file.exists and preferences.ebbro_tool_data.show_overwrite_question_on_save then
				if a_displayable.format_id = binary_format_id then
					prompts.show_question_prompt (m_overwrite_object_file, parent_window,agent file_saved(a_displayable,binary_format_id,a_filename, create {STRING}.make_empty),void)
				elseif a_displayable.format_id = dadl_format_id then
					prompts.show_question_prompt (m_overwrite_object_file, parent_window,agent file_saved(a_displayable,dadl_format_id,a_filename, create {STRING}.make_empty),void)
				else
					check
						unknown_format:false
					end
				end
			else
				if a_displayable.format_id = binary_format_id then
					file_saved(a_displayable,binary_format_id,a_filename, create {STRING}.make_empty)
				elseif a_displayable.format_id = dadl_format_id then
					file_saved(a_displayable,dadl_format_id,a_filename, create {STRING}.make_empty)
				else
					check
						unknown_format:false
					end
				end
			end

		end



	on_request_save_file_as (a_displayable: ES_EBBRO_DISPLAYABLE)
		-- select the file to write to.
		local
			dialog:EB_FILE_SAVE_DIALOG
			l_pref: PATH_PREFERENCE
		--	l_is_dadl:BOOLEAN
			l_filename:STRING
		do
			l_pref := preferences.dialog_data.last_opened_object_directory_in_ebbro
			if l_pref.value = Void or else l_pref.value.is_empty then
				l_pref.set_value (eiffel_layout.user_projects_path)
			end


			create dialog.make_with_preference (l_pref)


	--		if {l_dadl_dec: DADL_DECODED} a_displayable.original_decoded then
	--			l_is_dadl := true
	--			dialog.filters.extend (dadl_filter)
	--		else
				dialog.filters.extend (binary_filter)
	--			dialog.filters.extend (dadl_filter)
	--		end

			dialog.set_title ("Choose save location...")
			--dialog.save_actions.extend (agent file_saved(a_displayable, dialog.file_name,dialog.file_path))
			dialog.show_modal_to_window (parent_window)
			if dialog.selected_button.is_equal ((create {EV_DIALOG_CONSTANTS}).ev_save) then
				if dialog.filters.i_th (dialog.selected_filter_index).is_equal (dadl_filter) then
					if not dialog.file_name.ends_with (dadl_file_ending) then
						create l_filename.make_from_string (dialog.file_name + dadl_file_ending)
					else
						create l_filename.make_from_string (dialog.file_name)
					end

					file_saved(a_displayable,dadl_format_id,l_filename, dialog.file_path)
				else
					-- if binary filter was selected, but file has ".adls" at end -> still store in dadl format!
					if dialog.file_name.ends_with (dadl_file_ending) then
						create l_filename.make_from_string (dialog.file_name)
						file_saved(a_displayable,dadl_format_id,l_filename, dialog.file_path)
					else
						create l_filename.make_from_string (dialog.file_name)
						file_saved(a_displayable,binary_format_id,l_filename, dialog.file_path)
					end
				end
			end
		end

	on_custom_serialization
			-- let user select a class to create a custom serialization form
		local
			l_choose_dialog:EB_CHOOSE_CLASS_DIALOG
		do
			create l_choose_dialog.make
			l_choose_dialog.show_on_active_window
			if l_choose_dialog.selected then
				show_custom_serialization_selection(l_choose_dialog.class_name)
			end
		end

	on_custom_serialization_drop (a_pebble:ANY)
			-- drop occured on custom serialization button
			-- if its a class_stone -> show custom serialization dialog
		local
			l_classi_stone: CLASSI_STONE
		do
			l_classi_stone ?= a_pebble
			if l_classi_stone /= void and then l_classi_stone.is_valid then
				show_custom_serialization_selection(l_classi_stone.class_name)
			else
				prompts.show_info_prompt (m_custom_serialization_stone, parent_window, void)
			end
		end

	on_object_compare
			-- show compare dialog to user
		local
			l_diag:ES_EBBRO_COMPARE_OBJECTS_DIALOG
		do
			create l_diag.make
			l_diag.show_on_active_window
			if l_diag.selected then
				compare_two_objects (l_diag.object1_file_name, l_diag.object2_file_name)
			end

		end



feature {NONE} -- Events

	on_object_decoded (a_obj:ES_EBBRO_DISPLAYABLE)
			-- object decoded handler
		do
			if pending_compare_operation then
				if object1_to_compare = void then
					object1_to_compare := a_obj
				else
					run_comparison_and_display(object1_to_compare,a_obj)
				end
			else
				left_grid_view.display_object (a_obj,last_opened_filename,void,none_filter_id)
			end

		end

	on_decoding_error (a_msg:STRING)
			-- object decoded error handler
		do
			prompts.show_error_prompt (a_msg, parent_window, void)
		end

	on_encoding_error (a_msg:STRING)
			-- object decoded error handler
		do
			prompts.show_error_prompt (a_msg, parent_window, void)
		end


	on_information (a_msg:STRING)
			-- object decoding information handler
		do
			prompts.show_info_prompt (a_msg, parent_window, void)
		end

	on_view_addr_column (a_item:EV_CHECK_MENU_ITEM)
			-- view address bar
		do
			if a_item.is_selected then
				right_grid_view.column (4).show
				left_grid_view.column (4).show
			else
				right_grid_view.column (4).hide
				left_grid_view.column (4).hide
			end
			preferences.ebbro_tool_data.show_addr_column_preference.set_value ( not preferences.ebbro_tool_data.is_addr_column_shown)
		end

	on_update_addr
			-- update address handler
		do
			right_grid_view.update_obj_addresses
			left_grid_view.update_obj_addresses
		end

	on_allow_cyclic (a_item:EV_CHECK_MENU_ITEM)
			-- allow cyclic handler
		do
			if a_item.is_selected then
				right_grid_view.set_allow_cyclic_browsing(true)
				left_grid_view.set_allow_cyclic_browsing(true)
			else
				right_grid_view.set_allow_cyclic_browsing(false)
				left_grid_view.set_allow_cyclic_browsing(false)
			end
			preferences.ebbro_tool_data.cyclic_browsing_preference.set_value ( not preferences.ebbro_tool_data.is_cyclic_browsing_enabled)
		end

	on_show_split_screen (a_item:EV_CHECK_MENU_ITEM)
			-- show split screen handler
		local
			l_sel_row:EV_GRID_ROW
		do
			if a_item.is_selected then
				right_grid_view.show
				--main_container.set_split_position (preferences.ebbro_tool_data.split_position)
				if not left_grid_view.selected_rows.is_empty then
					l_sel_row := left_grid_view.selected_rows.i_th (1)
					if l_sel_row.parent_row = void then
						move_right_button.enable_sensitive
					end
				end
			else
				right_grid_view.hide
				move_right_button.disable_sensitive
				move_left_button.disable_sensitive
			end
			right_grid_view.toggle_is_split_screen
			left_grid_view.toggle_is_split_screen
			preferences.ebbro_tool_data.split_screen_preference.set_value ( not preferences.ebbro_tool_data.is_split_screen_enabled)
		end

	on_filter_in (a_item:EV_RADIO_MENU_ITEM)
			-- on filter in handler
		local
			l_filter_text:STRING
		do
			right_grid_view.set_filter_in(a_item.is_selected)
			left_grid_view.set_filter_in(a_item.is_selected)
			if not active_filter_label.text.is_empty then
				l_filter_text := active_filter_label.text
				l_filter_text.replace_substring_all(label_out_filter,label_in_filter)
				active_filter_label.set_text (l_filter_text)
			end
			preferences.ebbro_tool_data.filter_in_preference.set_value (true)
		end

	on_filter_out (a_item:EV_RADIO_MENU_ITEM)
			-- on filter out handler
		local
			l_filter_text:STRING
		do
			right_grid_view.set_filter_in(not a_item.is_selected)
			left_grid_view.set_filter_in(not a_item.is_selected)
			if not active_filter_label.text.is_empty then
				l_filter_text := active_filter_label.text
				l_filter_text.replace_substring_all(label_in_filter,label_out_filter)
				active_filter_label.set_text (l_filter_text)
			end
			preferences.ebbro_tool_data.filter_in_preference.set_value (false)
		end

	on_selecting_row (a_row:EV_GRID_ROW;is_on_left_grid:BOOLEAN)
			-- on selecting a row
		local
			l_data:TUPLE[ANY,ARRAY[INTEGER]]
			l_disp:ES_EBBRO_DISPLAYABLE
			l_filters:ARRAY[INTEGER]
		do
			is_last_selected_row_on_left := is_on_left_grid
			if a_row.parent_row = void then
				l_data ?= a_row.data
				-- filter text
				if l_data /= void then
					l_filters ?= l_data.reference_item(2)
					set_active_filter_text(l_filters.item (1))
				else
					reset_active_filter_text
				end
				-- move buttons
				if preferences.ebbro_tool_data.is_split_screen_enabled then
					if is_on_left_grid then
						move_right_button.enable_sensitive
						move_left_button.disable_sensitive
					else
						move_left_button.enable_sensitive
						move_right_button.disable_sensitive
					end
				end
				-- history buttons
				if l_data /= void then
					l_disp ?= l_data.reference_item (1)
					if l_disp /= void then
						if l_disp.history.is_redo_possible then
							redo_edit_button.enable_sensitive
						else
							redo_edit_button.disable_sensitive
						end
						if l_disp.history.is_undo_possible then
							undo_edit_button.enable_sensitive
						else
							undo_edit_button.disable_sensitive
						end
					end
				end
				delete_button.enable_sensitive
			else
				reset_active_filter_text
				reset_object_buttons
			end
		end

	on_move_right
			-- action when moving a root_object_row to the right of split screen
		do
			left_grid_view.on_moving_root_object
		end

	on_move_left
			-- action when moving a root_object_row to the left of split screen
		do
			right_grid_view.on_moving_root_object
		end

	on_remove_object
			-- action when removing a root_object_row
		do
			if is_last_selected_row_on_left then
				left_grid_view.on_remove_row_request
			else
				right_grid_view.on_remove_row_request
			end
		end

	on_undo
			-- action when undo on selected root_object_row is called
		local
			l_row: EV_GRID_ROW
			l_grid:ES_EBBRO_GRID
			l_tuple: TUPLE [ANY, ARRAY [INTEGER_32]]
			l_disp: ES_EBBRO_DISPLAYABLE
		do
			if is_last_selected_row_on_left then
				l_grid := left_grid_view
			else
				l_grid := right_grid_view
			end
			if not l_grid.selected_rows.is_empty then
				l_row := l_grid.selected_rows.i_th (1)
				if l_row.parent_row = Void then
					l_tuple ?= l_row.data
					l_disp ?= l_tuple.reference_item (1)
					if l_disp /= Void then
						l_disp.history.undo
						if l_disp.history.is_redo_possible then
							redo_edit_button.enable_sensitive
						else
							redo_edit_button.disable_sensitive
						end
						if l_disp.history.is_undo_possible then
							undo_edit_button.enable_sensitive
						else
							undo_edit_button.disable_sensitive
						end
					end
				end
			end
		end

	on_redo
			-- action when redo on selected root_object_row is called
		local
			l_row: EV_GRID_ROW
			l_grid:ES_EBBRO_GRID
			l_tuple: TUPLE [ANY, ARRAY [INTEGER_32]]
			l_disp: ES_EBBRO_DISPLAYABLE
		do
			if is_last_selected_row_on_left then
				l_grid := left_grid_view
			else
				l_grid := right_grid_view
			end
			if not l_grid.selected_rows.is_empty then
				l_row := l_grid.selected_rows.i_th (1)
				if l_row.parent_row = Void then
					l_tuple ?= l_row.data
					l_disp ?= l_tuple.reference_item (1)
					if l_disp /= Void then
						l_disp.history.redo
						if l_disp.history.is_redo_possible then
							redo_edit_button.enable_sensitive
						else
							redo_edit_button.disable_sensitive
						end
						if l_disp.history.is_undo_possible then
							undo_edit_button.enable_sensitive
						else
							undo_edit_button.disable_sensitive
						end
					end
				end
			end
		end



feature {NONE} -- Factory

	create_widget: EV_HORIZONTAL_SPLIT_AREA
			-- Create a new container widget upon request
		do
			create main_container
			main_container.disable_dockable
			main_container.enable_sensitive

			result := main_container

		end

	create_mini_tool_bar_items: ARRAYED_LIST[SD_TOOL_BAR_ITEM]
			-- Available tool bar items
		local
			l_item:SD_TOOL_BAR_WIDGET_ITEM
		do
			create result.make (1)

			create active_filter_label
			active_filter_label.set_minimum_width (150)

			create l_item.make (active_filter_label)
			result.extend (l_item)

		end

	create_tool_bar_items: ARRAYED_LIST [SD_TOOL_BAR_ITEM]
			-- Available tool bar items
		do

			create open_file_button.make
			open_file_button.set_pixel_buffer (stock_pixmaps.general_open_icon_buffer)
			open_file_button.set_pixmap(stock_pixmaps.general_open_icon)
			open_file_button.select_actions.extend (agent request_open_file)
			open_file_button.set_tooltip (locale_formatter.translation (f_open_button))

			create Result.make (4)
			Result.extend (open_file_button)
			Result.extend (create {SD_TOOL_BAR_SEPARATOR}.make)

			create custom_serialization_button.make
			custom_serialization_button.set_pixel_buffer (icons.gui_custom_serialization_icon_buffer)
			custom_serialization_button.set_pixmap (icons.gui_custom_serialization_icon)
			custom_serialization_button.select_actions.extend(agent on_custom_serialization)
			custom_serialization_button.drop_actions.extend (agent on_custom_serialization_drop)
			custom_serialization_button.set_tooltip (locale_formatter.translation (f_custom_serialization_button))

			Result.extend (custom_serialization_button)

			create object_compare_button.make
			object_compare_button.set_pixel_buffer (icons.gui_comparer_icon_buffer)
			object_compare_button.set_pixmap (icons.gui_comparer_icon)
			object_compare_button.select_actions.extend(agent on_object_compare)
			object_compare_button.set_tooltip (locale_formatter.translation (f_object_compare_button))

			Result.extend (object_compare_button)

		end

	create_right_tool_bar_items: ARRAYED_LIST [SD_TOOL_BAR_ITEM]
			-- Available tool bar items
		do
			create result.make (8)

			create move_left_button.make
			move_left_button.set_pixel_buffer (icons.gui_move_left_icon_buffer)
			move_left_button.set_pixmap (icons.gui_move_left_icon)
			move_left_button.set_tooltip (locale_formatter.translation (f_move_left_button))
			register_action (move_left_button.select_actions, agent on_move_left)
			move_left_button.disable_sensitive
			result.extend (move_left_button)

			create move_right_button.make
			move_right_button.set_pixel_buffer (icons.gui_move_right_icon_buffer)
			move_right_button.set_pixmap (icons.gui_move_right_icon)
			move_right_button.set_tooltip (locale_formatter.translation (f_move_right_button))
			register_action (move_right_button.select_actions, agent on_move_right)
			move_right_button.disable_sensitive
			Result.extend (move_right_button)

			Result.extend (create {SD_TOOL_BAR_SEPARATOR}.make)

			create undo_edit_button.make
			undo_edit_button.set_pixel_buffer (stock_pixmaps.general_undo_icon_buffer)
			undo_edit_button.set_pixmap (stock_pixmaps.general_undo_icon)
			undo_edit_button.set_tooltip (locale_formatter.translation (f_undo_button))
			register_action (undo_edit_button.select_actions, agent on_undo)
			undo_edit_button.disable_sensitive
			Result.extend (undo_edit_button)

			create redo_edit_button.make
			redo_edit_button.set_pixel_buffer (stock_pixmaps.general_redo_icon_buffer)
			redo_edit_button.set_pixmap (stock_pixmaps.general_redo_icon)
			redo_edit_button.set_tooltip (locale_formatter.translation (f_redo_button))
			register_action (redo_edit_button.select_actions, agent on_redo)
			redo_edit_button.disable_sensitive
			Result.extend (redo_edit_button)


			create delete_button.make
			delete_button.set_pixel_buffer (stock_pixmaps.general_delete_icon_buffer)
			delete_button.set_pixmap (stock_pixmaps.general_delete_icon)
			delete_button.set_tooltip (locale_formatter.translation (f_delete_button))
			register_action (delete_button.select_actions, agent on_remove_object)
			delete_button.disable_sensitive
			Result.extend (delete_button)

			Result.extend (create {SD_TOOL_BAR_SEPARATOR}.make)

			build_view_menu

			create view_menu_entry.make
			view_menu_entry.set_menu (view_menu)
			view_menu_entry.enable_displayed
			view_menu_entry.enable_sensitive
			view_menu_entry.set_text ("View")


			result.extend (view_menu_entry)

		end


feature {NONE} -- Implementation

	last_opened_filename: STRING
			-- path of last openend file

	last_opened_multiple_filenames: ARRAYED_LIST[STRING]
			-- filenames from last multiple open call

	pending_compare_operation: BOOLEAN
			-- is there a pending compare operation?

	object1_to_compare: ES_EBBRO_DISPLAYABLE
			-- the first object to compare to the next one, which will be deserialized
			-- used for compare feature

	parent_window: EV_WINDOW
			-- the parent window
		do
			Result := window_manager.last_focused_development_window.window
		end

	show_custom_serialization_selection (a_class_name:STRING)
			-- shows dialog in which the user can select attributes to serialize
		require
			valid_name:a_class_name /= void and then not a_class_name.is_empty
		local
			l_diag:ES_EBBRO_CUSTOM_SERIALIZATION_DIALOG
		do
			create l_diag.make_with_name(a_class_name)
			if l_diag.is_valid then
				l_diag.show_on_active_window
				if l_diag.selected then
					show_custom_serialization_output(l_diag.attribute_list,a_class_name)
				end
			else
				prompts.show_info_prompt (m_custom_serialization_stone, parent_window, void)
			end

		end

	show_custom_serialization_output (an_attribute_list: ARRAYED_LIST [STRING_8];a_class_name:STRING)
			-- shows output dialog of custom_serialization code generator
		require
			valid_attributes: an_attribute_list /= void and then not an_attribute_list.is_empty
			valid_name: a_class_name /= void and then not a_class_name.is_empty
		local
			l_diag:ES_EBBRO_CUSTOM_SERIALIZATION_OUTPUT_DIALOG
		do
			create l_diag.make_with_attributes (an_attribute_list, a_class_name)
			l_diag.show_on_active_window
		end

	compare_two_objects (a_file_name1,a_file_name2:STRING)
			-- starts the comparison of two object files
			-- will set pending_compare_operation to true
			-- so the on_object_decoded will know how to handle the decoded object
		require
			valid_names: a_file_name1 /= void and a_file_name2 /= void
		local
			l_list:ARRAYED_LIST[STRING]
		do
			pending_compare_operation := true
			object1_to_compare := void

			create l_list.make (2)
			l_list.extend (a_file_name1)
			l_list.extend (a_file_name2)

			--remember file names
			last_opened_multiple_filenames := l_list

			--ensure split screen visible
			if not split_screen_menu_item.is_selected then
				split_screen_menu_item.enable_select
				split_screen_menu_item.select_actions.call ([split_screen_menu_item])
			end

			controller.open_multiple_files_actions.call ([l_list])

		end

	run_comparison_and_display (an_obj1,an_obj2:ES_EBBRO_DISPLAYABLE)
			-- once both object files have been deserialized
			-- this method will run and display the objects
			-- then run the comparison
		local
			l_insert_pref:BOOLEAN
			l_comparer:ES_EBBRO_TREE_COMPARER
		do
			pending_compare_operation := false
			object1_to_compare := void

			-- display objects
			l_insert_pref := left_grid_view.tree_builder.insert_at_top
			left_grid_view.tree_builder.set_insert_at_top (true)
			left_grid_view.display_object (an_obj1,last_opened_multiple_filenames.i_th (1),void,none_filter_id)
			left_grid_view.tree_builder.set_insert_at_top (l_insert_pref)

			l_insert_pref := right_grid_view.tree_builder.insert_at_top
			right_grid_view.tree_builder.set_insert_at_top (true)
			right_grid_view.display_object (an_obj2,last_opened_multiple_filenames.i_th (2),void,none_filter_id)
			right_grid_view.tree_builder.set_insert_at_top (l_insert_pref)

			-- compare
			create l_comparer
			l_comparer.compare_two_root_objects (left_grid_view.row (left_grid_view.tree_builder.last_root_object_index) , right_grid_view.row (right_grid_view.tree_builder.last_root_object_index))

		end



invariant

note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
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
