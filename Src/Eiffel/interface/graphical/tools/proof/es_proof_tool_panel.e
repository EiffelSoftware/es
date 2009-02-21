indexing
	description: "TODO"
	date: "$Date$"
	revision: "$Revision$"

class
	ES_PROOF_TOOL_PANEL

inherit
	ES_DOCKABLE_TOOL_PANEL [ES_GRID]
		rename
			user_widget as proof_results
		redefine
			create_right_tool_bar_items
		end

create {ES_PROOF_TOOL}
	make

feature -- Status report

	show_successful: BOOLEAN
			-- Indicates if errors should be shown
		do
			Result := not is_initialized or else successful_button.is_selected
		end

	show_failed: BOOLEAN
			-- Indicates if errors should be shown
		do
			Result := not is_initialized or else failed_button.is_selected
		end

	show_skipped: BOOLEAN
			-- Indicates if errors should be shown
		do
			Result := not is_initialized or else skipped_button.is_selected
		end

feature

    create_widget: ES_GRID
            -- Create a new container widget upon request.
            -- Note: You may build the tool elements here or in `build_tool_interface'
		do
			create Result.default_create
		end

    create_tool_bar_items: DS_ARRAYED_LIST [SD_TOOL_BAR_ITEM]
            -- <Precursor>
		do
			create Result.make_default

				-- "toggle successful" button
			create successful_button.make
				-- TODO: internationalization
			successful_button.set_text ("Successful")
			successful_button.set_pixmap (stock_pixmaps.general_check_document_icon)
			successful_button.set_pixel_buffer (stock_pixmaps.general_check_document_icon_buffer)
			successful_button.enable_select
			successful_button.select_actions.extend (agent on_toogle_successful_button)

				-- "toggle failed" button
			create failed_button.make
				-- TODO: internationalization
			failed_button.set_text ("Failed")
			failed_button.set_pixmap (stock_pixmaps.debug_exception_handling_icon)
			failed_button.set_pixel_buffer (stock_pixmaps.debug_exception_handling_icon_buffer)
			failed_button.enable_select
			failed_button.select_actions.extend (agent on_toogle_failed_button)

				-- "toggle skipped" button
			create skipped_button.make
				-- TODO: internationalization
			skipped_button.set_text ("Skipped")
			skipped_button.set_pixmap (stock_pixmaps.general_warning_icon)
			skipped_button.set_pixel_buffer (stock_pixmaps.general_warning_icon_buffer)
			skipped_button.enable_select
			skipped_button.select_actions.extend (agent on_toogle_skipped_button)

			Result.put_last (develop_window.commands.proof_command.new_sd_toolbar_item (True))
			Result.put_last (create {SD_TOOL_BAR_SEPARATOR}.make)
			Result.put_last (successful_button)
			Result.put_last (failed_button)
			Result.put_last (skipped_button)
		end

	create_right_tool_bar_items: DS_ARRAYED_LIST [SD_TOOL_BAR_ITEM]
			-- <Precursor>
		local
			l_box: EV_HORIZONTAL_BOX
		do
			create Result.make_default

				-- live text filter
			create l_box
			l_box.extend (create {EV_LABEL}.make_with_text ("Filter: "))
			create text_filter
			text_filter.set_capacity (30)
			text_filter.key_release_actions.extend (agent on_filter_key_released)
			l_box.extend (text_filter)

			Result.put_last (create {SD_TOOL_BAR_RESIZABLE_ITEM}.make (l_box))
		end


    build_tool_interface (a_widget: ES_GRID)
            -- Builds the tools user interface elements.
            -- Note: This function is called prior to showing the tool for the first time.
            --
            -- `a_widget': A widget to build the tool interface using.
		local
			l_col: EV_GRID_COLUMN
			l_row: EV_GRID_ROW
		do
			a_widget.set_column_count_to (info_column)
				-- Create columns
			l_col := a_widget.column (class_column)
			l_col.set_title ("Class")
			l_col.set_width (150)
			l_col := a_widget.column (feature_column)
			l_col.set_title ("Feature")
			l_col.set_width (150)
--			l_col := a_widget.column (status_column)
--			l_col.set_title ("Status")
--			l_col.set_width (150)
			l_col := a_widget.column (info_column)
			l_col.set_title ("Info")
			l_col.set_width (300)

			a_widget.enable_last_column_use_all_width


			l_row := a_widget.extended_new_row
			l_row.set_background_color (create {EV_COLOR}.make_with_rgb (0.9, 1.0, 0.9))
--			l_row.set_item (status_column, create {EV_GRID_LABEL_ITEM}.make_with_text ("successful"))

			l_row := a_widget.extended_new_row
			l_row.set_background_color (create {EV_COLOR}.make_with_rgb (1.0, 0.9, 0.9))
--			l_row.set_item (status_column, create {EV_GRID_LABEL_ITEM}.make_with_text ("failed"))

			l_row := a_widget.extended_new_row
			l_row.set_background_color (create {EV_COLOR}.make_with_rgb (1.0, 1.0, 0.9))
--			l_row.set_item (status_column, create {EV_GRID_LABEL_ITEM}.make_with_text ("skipped"))
		end

feature {NONE} -- User interface items

	successful_button: SD_TOOL_BAR_TOGGLE_BUTTON
			-- Toogle to show/hide successful proofs

	failed_button: SD_TOOL_BAR_TOGGLE_BUTTON
			-- Toogle to show/hide failed proofs

	skipped_button: SD_TOOL_BAR_TOGGLE_BUTTON
			-- Toogle to show/hide skipped proofs

	text_filter: EV_TEXT_FIELD
			-- Text field to enter filter

feature {NONE} -- Events

	on_toogle_successful_button is
			-- Called when `successful_button' is selected
		require
			is_interface_usable: is_interface_usable
			is_initialized: is_initialized
		local
			l_row: EV_GRID_ROW
			l_event_item: EVENT_LIST_ITEM_I
			l_count, i: INTEGER
		do
			from
				i := 1
				l_count := proof_results.row_count
			until
				i > l_count
			loop
				l_row := proof_results.row (i)
				l_event_item ?= l_row.data
				if l_event_item /= Void then
					if is_successful_event (l_event_item) then
						if show_successful then
							l_row.show
						else
							l_row.hide
						end
					end
				end
				i := i + 1
			end
		end

	on_toogle_failed_button is
			-- Called when `failed_button' is selected
		require
			is_interface_usable: is_interface_usable
			is_initialized: is_initialized
		local
			l_row: EV_GRID_ROW
			l_event_item: EVENT_LIST_ITEM_I
			l_count, i: INTEGER
		do
			from
				i := 1
				l_count := proof_results.row_count
			until
				i > l_count
			loop
				l_row := proof_results.row (i)
				l_event_item ?= l_row.data
				if l_event_item /= Void then
					if is_failed_event (l_event_item) then
						if show_failed then
							l_row.show
						else
							l_row.hide
						end
					end
				end
				i := i + 1
			end
		end

	on_toogle_skipped_button is
			-- Called when `skipped_button' is selected
		require
			is_interface_usable: is_interface_usable
			is_initialized: is_initialized
		local
			l_row: EV_GRID_ROW
			l_event_item: EVENT_LIST_ITEM_I
			l_count, i: INTEGER
		do
			from
				i := 1
				l_count := proof_results.row_count
			until
				i > l_count
			loop
				l_row := proof_results.row (i)
				l_event_item ?= l_row.data
				if l_event_item /= Void then
					if is_skipped_event (l_event_item) then
						if show_skipped then
							l_row.show
						else
							l_row.hide
						end
					end
				end
				i := i + 1
			end
		end

	on_filter_key_released (a_key: EV_KEY)
			-- Called when a key is released in filter text field.
		do

		end

feature {NONE} -- Query

	is_successful_event (a_event_item: EVENT_LIST_ITEM_I): BOOLEAN
			-- Determines if event `a_event_item' is a successful event
		do
			Result := True
		end

	is_failed_event (a_event_item: EVENT_LIST_ITEM_I): BOOLEAN
			-- Determines if event `a_event_item' is a failed event
		do
			Result := True
		end

	is_skipped_event (a_event_item: EVENT_LIST_ITEM_I): BOOLEAN
			-- Determines if event `a_event_item' is a skipped event
		do
			Result := True
		end

feature {NONE} -- Constants

	class_column: INTEGER = 1
	feature_column: INTEGER = 2
	status_column: INTEGER = 3
	info_column: INTEGER = 4

;indexing
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
