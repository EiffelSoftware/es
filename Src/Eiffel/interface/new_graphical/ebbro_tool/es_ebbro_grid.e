note
	description: "Ebbro grid represents a main grid which displays objects - like EV_GRID"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_GRID

inherit
	EV_GRID
	ES_EBBRO_DISPLAY_CONST
		export
			{NONE} all
		undefine
			default_create, copy
		end

feature -- init

	ebbro_init(a_panel:ES_EBBRO_TOOL_PANEL;is_on_left_hand:BOOLEAN)
			-- creation
		do
			is_left := is_on_left_hand
			split_screen_enabled := false
			create tree_builder.make
			tree_builder.set_grid (current)
			create tree_filter.make
			tree_filter.set_grid (current)
			build_right_click_menu
			a_panel.set_right_click_menu_pixmaps (right_click_menu,is_on_left_hand )
			main_window := a_panel
		end


	set_up is
			-- set up default settings, visualization
		do
			enable_tree
			show_tree_node_connectors
			set_column_count_to (4)
			column (1).set_title (column_title_1)
			column (1).set_width (column_width_1)
			column (2).set_title (column_title_2)
			column (2).set_width (column_width_2)
			column (3).set_title (column_title_3)
			column (3).set_width (column_width_3)
			column (4).set_title (column_title_4)
			column (4).set_width (column_width_4)
			enable_single_row_selection
			--disable_vertical_scrolling_per_item
			enable_column_separators
			enable_row_separators
			enable_row_height_fixed
			mouse_wheel_actions.extend (agent on_grid_scroll)
			key_press_actions.extend (agent on_grid_key_press)
			pointer_button_press_item_actions.extend (agent on_p_button_press)
		end

	set_is_left
			-- set is left flag (left grid, in split view)
		do
			is_left := true
		end


feature -- access

	is_left:BOOLEAN
			-- is left grid in splitarea

	split_screen_enabled:BOOLEAN
			-- is split screen enabled

	tree_builder:ES_EBBRO_TREE_BUILDER
			-- internal tree builder

	tree_filter:ES_EBBRO_TREE_FILTER
			-- internal tree filter

	right_click_menu:EV_MENU
			-- right click menu for root objects

	filter_menu:EV_MENU
			-- filter menu

	main_window:ES_EBBRO_TOOL_PANEL
			-- main window of application

feature -- basic operations

	toggle_is_split_screen
			-- toggles split screen option on/off
		do
			split_screen_enabled := not split_screen_enabled
		end

	set_filter_in(a_value:BOOLEAN)
			-- sets the filter in option
		do
			tree_filter.set_filter_in(a_value)
		end

	display_object(an_obj:ES_EBBRO_DISPLAYABLE;a_file_name,an_object_name:STRING;a_filter_id:INTEGER)
			-- displays an object of type displayable
		local
			l_data:TUPLE[ANY,ARRAY[INTEGER]]
			l_array:ARRAY[INTEGER]
			l_row:EV_GRID_ROW
		do
			tree_builder.display_object (an_obj, a_file_name,an_object_name)
			if a_filter_id /= none_filter_id then
				l_row := row (tree_builder.last_root_object_index)
				l_data ?= l_row.data
				if l_data /= void then
					l_array ?= l_data.reference_item(2)
					l_array.put (a_filter_id,1)
				end
				activate_filter (l_row,  a_filter_id)
			end
		end




feature -- implementation

	build_right_click_menu
			-- builds the right click menu
		local
			l_item:EV_MENU_ITEM
			--l_pix:EV_PIXMAP
		do
			create right_click_menu

			create l_item.make_with_text_and_action (menu_right_click_remove, agent on_remove_row_request)

			right_click_menu.extend(l_item)
			right_click_menu.extend (create {EV_MENU_SEPARATOR})
			--create l_pix
			if is_left then
				create l_item.make_with_text_and_action (menu_right_click_move_right, agent on_moving_root_object)
				--l_pix.set_with_named_file (pixmap_move_right)
			else
				create l_item.make_with_text_and_action (menu_right_click_move_left, agent on_moving_root_object)
				--l_pix.set_with_named_file (pixmap_move_left)
			end
			--l_item.set_pixmap (l_pix)
			right_click_menu.extend(l_item)

			right_click_menu.extend (create {EV_MENU_SEPARATOR})
			build_filter_menu

			right_click_menu.extend (filter_menu)

			--TODO: clean up. string in seperate class
			---------------------------------------------
			right_click_menu.extend (create {EV_MENU_SEPARATOR})
			create l_item.make_with_text_and_action (Menu_right_click_save, agent on_save)
			right_click_menu.extend (l_item )
			create l_item.make_with_text_and_action (Menu_right_click_save_as, agent on_save_as)
			right_click_menu.extend (l_item )
			---------------------------------------------

		end

	build_filter_menu
			-- builds the filter menu
		local
			menu_item:EV_RADIO_MENU_ITEM
			--l_pix:EV_PIXMAP
		do
			create filter_menu.make_with_text(Menu_filter_item)
			--create l_pix
			--l_pix.set_with_named_file (pixmap_filter)
			--filter_menu.set_pixmap (l_pix)

			--none filter
			create menu_item.make_with_text_and_action (Menu_filter_none_item, agent on_activate_filter(none_filter_id))
			menu_item.set_data (none_filter_id)
			filter_menu.extend (menu_item)

			--void filter
			create menu_item.make_with_text_and_action (Menu_filter_void_item, agent on_activate_filter(void_filter_id))
			menu_item.set_data (void_filter_id)
			filter_menu.extend (menu_item)

			--cycle filter
			create menu_item.make_with_text_and_action (Menu_filter_cycle_item, agent on_activate_filter(cycle_filter_id))
			menu_item.set_data (cycle_filter_id)
			filter_menu.extend (menu_item)
		end

	select_correct_filters_on_menu(a_tuple:TUPLE[ANY,ARRAY[INTEGER]])
			-- selects the correct filter in the menu
		require
			not_void:a_tuple /= void
		local
			l_filter_ids:ARRAY[INTEGER]
			l_filter:INTEGER
			l_item:EV_RADIO_MENU_ITEM
		do
			--currently only one filter possibility
			l_filter_ids ?= a_tuple.reference_item (2)
			l_filter := l_filter_ids.item (1)
			l_item ?= filter_menu.retrieve_item_by_data (l_filter,true)
			if l_item /= void then
				l_item.enable_select
			end
		end

	activate_filter(a_row:EV_GRID_ROW;a_filter_id:INTEGER)
			-- activates a filter on a given row
		do
			inspect a_filter_id
			when none_filter_id then
				tree_filter.reset_object_filter(a_row)
			when void_filter_id then
				tree_filter.activate_void_filter(a_row)
			when cycle_filter_id then
				tree_filter.activate_cycle_filter(a_row)
			else

			end
		end




feature -- actions

	on_moving_root_object
			-- move an object to other split area
		local
			l_row:EV_GRID_ROW
			l_split:EV_HORIZONTAL_SPLIT_AREA
			l_grid:ES_EBBRO_GRID
			l_tuple:TUPLE[ANY,ARRAY[INTEGER]]
			l_arr:ARRAY[INTEGER]
			l_disp:ES_EBBRO_DISPLAYABLE
			l_item:EV_GRID_LABEL_ITEM
			l_obj:ANY
		do
			if not selected_rows.is_empty then
				l_row := selected_rows.i_th (1)
				l_split ?= parent
				l_tuple ?= l_row.data
				l_disp ?= l_tuple.reference_item (1)
				if l_disp = void then
					-- we have to create wrapper
					l_obj ?= l_tuple.reference_item (1)
					create l_disp.make_wrapping (l_obj.generating_type)
					l_disp.set_wrapped_object (l_obj)
				end
				l_arr ?= l_tuple.reference_item (2)
				if is_left then
					l_grid ?= l_split.second
				else
					l_grid ?= l_split.first
				end
				l_item ?= l_row.item(1)
				-- reset histoty
				l_disp.reset_history
				-- display object
				l_grid.display_object (l_disp, l_item.tooltip,l_item.text,l_arr.item (1))
				on_remove_row_request
				main_window.reset_active_filter_text
				main_window.reset_object_buttons
			end
		end


	on_p_button_press(x_pos,y_pos,a_button:INTEGER_32;a_item:EV_GRID_ITEM)
			-- on pointer button press - show right click menu
		local
			l_data:TUPLE[ANY,ARRAY[INTEGER]]
			l_ypos:INTEGER
		do
			if a_item /= void and then a_button.is_equal ({EV_POINTER_CONSTANTS}.right) then
				--is root item
				if a_item.row.parent_row = void then
					if not selected_rows.is_empty then
						selected_rows.i_th (1).disable_select
					end
					a_item.row.enable_select
					if split_screen_enabled then
						right_click_menu.i_th (3).enable_sensitive
					else
						right_click_menu.i_th (3).disable_sensitive
					end
					l_data ?= a_item.row.data
					select_correct_filters_on_menu(l_data)
					l_ypos := y_pos - (vertical_scroll_bar.value*20)   + 20

					right_click_menu.show_at(current,x_pos,l_ypos)
				end
			--TODO: clean up
			----------------------------------------------
			elseif a_item /= void and then a_button.is_equal ({EV_POINTER_CONSTANTS}.left) then
				if  a_item.row.item (2) = a_item  then
				a_item.activate
				end
			end
			----------------------------------------------
		end


	on_grid_scroll(b:INTEGER;a_grid:EV_GRID)
			-- manually scrolling ...not working otherwise ?!
		do
			if b /= 0 and vertical_scroll_bar.is_displayed then
				vertical_scroll_bar.set_step (b.abs)
				if b > 0 then
					vertical_scroll_bar.step_backward
				else
					vertical_scroll_bar.step_forward
				end
			end

		end

	on_remove_row_request
			-- on remove object
		do
			tree_builder.remove_selected_root_object
			main_window.reset_active_filter_text
			main_window.reset_object_buttons
		end


	on_grid_key_press(a_key:EV_KEY)
			-- key press action handler
		do
			if selected_rows.count > 0 then
				if a_key.code = {EV_KEY_CONSTANTS}.key_delete then
					main_window.reset_active_filter_text
					main_window.reset_object_buttons
				end
				tree_builder.key_pressed(a_key)
			else
				--dialog maybe
			end
		end

	set_allow_cyclic_browsing(a_value:BOOLEAN)
			-- sets allowing cycle browsing
		do
			tree_builder.set_allow_cyclic_browsing (a_value)
		end

	update_obj_addresses is
			-- updated the object addresses within column 4
		do
			tree_builder.update_obj_addresses
		end

	on_activate_filter(a_filter_id:INTEGER)
			-- action when filter should get activated
		local
			l_data:TUPLE[ANY,ARRAY[INTEGER]]
			l_array:ARRAY[INTEGER]
		do
			if not selected_rows.is_empty then

				l_data ?= selected_rows.i_th (1).data
				if l_data /= void then
					l_array ?= l_data.reference_item(2)
					l_array.put (a_filter_id,1)
				end

				main_window.set_active_filter_text (a_filter_id)

				activate_filter(selected_rows.i_th (1),a_filter_id)
			end
		end

	on_save
			-- On save request

		local
			l_data:TUPLE[ANY,ARRAY[INTEGER]]
			l_disp:ES_EBBRO_DISPLAYABLE
		do
			l_data ?= selected_rows.i_th (1).data
			l_disp ?= l_data.reference_item (1)

			if l_disp /= Void then
				main_window.on_request_save_file (l_disp,selected_rows.i_th (1).item (1).tooltip)
			end
		end

	on_save_as
			--TODO: implement

		local
			l_data:TUPLE[ANY,ARRAY[INTEGER]]
			l_disp:ES_EBBRO_DISPLAYABLE
		do
			l_data ?= selected_rows.i_th (1).data
			l_disp ?= l_data.reference_item (1)

			if l_disp /= Void then

				main_window.on_request_save_file_as (l_disp)





			end
		end



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
