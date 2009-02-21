indexing
	description: "TODO"
	date: "$Date$"
	revision: "$Revision$"

class
	ES_PROOF_TOOL_PANEL

inherit
	ES_CLICKABLE_EVENT_LIST_TOOL_PANEL_BASE
		redefine
			build_tool_interface,
			on_after_initialized,
			internal_recycle,
			create_right_tool_bar_items,
			surpress_synchronization,
			is_appliable_event,
			on_event_item_added,
			on_event_item_removed
		end

	SESSION_EVENT_OBSERVER
		export
			{NONE} all
		end

create {ES_PROOF_TOOL}
	make

feature {NONE} -- Initialization

	on_after_initialized
			-- <Precursor>
		do
				-- Bind redirecting pick and drop actions
			stone_director.bind (grid_events, Current)

				-- Hook up events for session data
			if session_manager.is_service_available then
				session_data.connect_events (Current)
			end

			Precursor
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
			successful_button.select_actions.extend (agent on_update_visiblity)

				-- "toggle failed" button
			create failed_button.make
				-- TODO: internationalization
			failed_button.set_text ("Failed")
			failed_button.set_pixmap (stock_pixmaps.debug_exception_handling_icon)
			failed_button.set_pixel_buffer (stock_pixmaps.debug_exception_handling_icon_buffer)
			failed_button.enable_select
			failed_button.select_actions.extend (agent on_update_visiblity)

				-- "toggle skipped" button
			create skipped_button.make
				-- TODO: internationalization
			skipped_button.set_text ("Skipped")
			skipped_button.set_pixmap (stock_pixmaps.general_warning_icon)
			skipped_button.set_pixel_buffer (stock_pixmaps.general_warning_icon_buffer)
			skipped_button.enable_select
			skipped_button.select_actions.extend (agent on_update_visiblity)

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
			l_button: SD_TOOL_BAR_BUTTON
		do
			create Result.make_default

				-- live text filter
			create l_box
			l_box.extend (create {EV_LABEL}.make_with_text ("Filter: "))
			l_box.disable_item_expand (l_box.last)
			create text_filter
			text_filter.key_release_actions.force_extend (agent on_update_visiblity)
			text_filter.set_minimum_width_in_characters (10)
			l_box.extend (text_filter)
			l_box.disable_item_expand (text_filter)

				-- clear button
			create l_button.make
			l_button.set_pixmap (stock_mini_pixmaps.general_delete_icon)
			l_button.pointer_button_press_actions.force_extend (
				agent
					do
						text_filter.set_text ("")
						on_update_visiblity
					end
				)
--			l_box.extend (l_button)


			Result.put_last (create {SD_TOOL_BAR_RESIZABLE_ITEM}.make (l_box))
			Result.put_last (l_button)
		end


	 build_tool_interface (a_widget: ES_GRID) is
			-- Builds the tools user interface elements.
			-- Note: This function is called prior to showing the tool for the first time.
			--
			-- `a_widget': A widget to build the tool interface using.
		local
			l_col: EV_GRID_COLUMN
		do
			Precursor {ES_CLICKABLE_EVENT_LIST_TOOL_PANEL_BASE} (a_widget)
			a_widget.set_column_count_to (info_column)

				-- Create columns
				-- TODO: internationalization
			l_col := a_widget.column (icon_column)
			l_col.set_width (20)
			l_col := a_widget.column (class_column)
			l_col.set_title ("Class")
			l_col.set_width (150)
			l_col := a_widget.column (feature_column)
			l_col.set_title ("Feature")
			l_col.set_width (150)
			l_col := a_widget.column (info_column)
			l_col.set_title ("Info")
			l_col.set_width (300)

			a_widget.enable_last_column_use_all_width

				-- Enable sorting
			enable_sorting_on_columns (<<a_widget.column (icon_column),
				a_widget.column (class_column),
				a_widget.column (feature_column)>>)
		end

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

	is_visible (a_item: EV_GRID_ROW): BOOLEAN
			-- Is `a_item' visible?
		local
			l_text: STRING
			l_item: EVENT_LIST_PROOF_ITEM_I
		do
			Result := True
			l_item ?= a_item.data
			if l_item /= Void then
				if is_successful_event (l_item) and not show_successful then
					Result := False
				elseif is_failed_event (l_item) and not show_failed then
					Result := False
				elseif is_skipped_event (l_item) and not show_skipped then
					Result := False
				else
					l_text := text_filter.text.as_lower
					if not l_text.is_empty then
						if
							not l_item.context_class.name.as_lower.has_substring (l_text) and
							(l_item.context_feature = Void or else
							 not l_item.context_feature.feature_name.as_lower.has_substring (l_text))
						then
							Result := False
						end
					end
				end
			end
		end

	frozen surpress_synchronization: BOOLEAN
			-- State to indicate if synchonization with the event list service should be suppressed
			-- when initializing.

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

	on_event_item_added (a_service: EVENT_LIST_S; a_event_item: EVENT_LIST_ITEM_I)
			-- <Precursor>
		local
			l_applicable: BOOLEAN
		do
			l_applicable := is_appliable_event (a_event_item)
			if l_applicable and not is_initialized then
					-- We have to perform initialization to set the icon and counter.
					-- Synchronization with the event list service is surpress to prevent duplication of event items being added.
				surpress_synchronization := True
				initialize
			end

			Precursor {ES_CLICKABLE_EVENT_LIST_TOOL_PANEL_BASE} (a_service, a_event_item)
		ensure then
			is_initialized: is_appliable_event (a_event_item) implies is_initialized
		end

	on_event_item_removed (a_service: EVENT_LIST_S; a_event_item: EVENT_LIST_ITEM_I) is
			-- <Precursor>
		local
			l_applicable: BOOLEAN
		do
			l_applicable := is_appliable_event (a_event_item)
			if l_applicable and not is_initialized then
					-- We have to perform initialization to set the icon and counter
					-- Synchronization with the event list service is surpress to prevent duplication of event items being added.
				surpress_synchronization := True
				initialize
			end

			Precursor {ES_CLICKABLE_EVENT_LIST_TOOL_PANEL_BASE} (a_service, a_event_item)
		ensure then
			is_initialized: is_appliable_event (a_event_item) implies is_initialized
		end

	on_update_visiblity is
			-- Called when visibility settings change
		require
			is_interface_usable: is_interface_usable
			is_initialized: is_initialized
		local
			l_row: EV_GRID_ROW
			l_count, i: INTEGER
		do
			from
				i := 1
				l_count := grid_events.row_count
			until
				i > l_count
			loop
				l_row := grid_events.row (i)
				if is_visible (l_row) then
					l_row.show
				else
					l_row.hide
				end
				i := i + 1
			end
		end

feature {NONE} -- Query


	is_appliable_event (a_event_item: EVENT_LIST_ITEM_I): BOOLEAN
			-- Determines if event `a_event_item' can be shown with the current event list tool
		do
			Result := is_successful_event (a_event_item) or is_failed_event (a_event_item) or is_skipped_event (a_event_item)
		end

	is_successful_event (a_event_item: EVENT_LIST_ITEM_I): BOOLEAN
			-- Determines if event `a_event_item' is a successful event
		do
			if {e: EVENT_LIST_PROOF_SUCCESSFUL_ITEM} a_event_item then
				Result := True
			end
		end

	is_failed_event (a_event_item: EVENT_LIST_ITEM_I): BOOLEAN
			-- Determines if event `a_event_item' is a failed event
		do
			if {e: EVENT_LIST_PROOF_FAILED_ITEM} a_event_item then
				Result := True
			end
		end

	is_skipped_event (a_event_item: EVENT_LIST_ITEM_I): BOOLEAN
			-- Determines if event `a_event_item' is a skipped event
		do
			if {e: EVENT_LIST_PROOF_SKIPPED_ITEM} a_event_item then
				Result := True
			end
		end

feature {NONE} -- Basic operations

	do_default_action (a_row: EV_GRID_ROW)
			-- <Precursor>
		do
			-- TODO
		end

	populate_event_grid_row_items (a_event_item: EVENT_LIST_ITEM_I; a_row: EV_GRID_ROW)
			-- Populates a grid row's item on a given row using the event `a_event_item'.
			--
			-- `a_event_item': A event to base the creation of a grid row on.
			-- `a_row': The row to create items on.
		local
			l_editor_item: EB_GRID_EDITOR_TOKEN_ITEM
			l_gen: EB_EDITOR_TOKEN_GENERATOR
			l_proof_event_item: EVENT_LIST_PROOF_ITEM_I
			l_label: EV_GRID_LABEL_ITEM
		do
			l_proof_event_item ?= a_event_item
			check l_proof_event_item /= Void end

				-- Class location
			create l_gen.make
			l_proof_event_item.context_class.append_name (l_gen)
			l_editor_item := create_clickable_grid_item (l_gen.last_line)
			a_row.set_item (class_column, l_editor_item)

				-- Feature location
			if l_proof_event_item.context_feature /= Void then
				create l_gen.make
				l_gen.add_feature_name (l_proof_event_item.context_feature.feature_name, l_proof_event_item.context_class)
				l_editor_item := create_clickable_grid_item (l_gen.last_line)
				a_row.set_item (feature_column, l_editor_item)
			end

			if is_successful_event (a_event_item) then
					-- Icon
				create l_label
				l_label.set_pixmap (stock_pixmaps.general_tick_icon)
				l_label.set_data ("successful")
				l_label.disable_full_select
				a_row.set_item (icon_column, l_label)

					-- Info
				a_row.set_item (info_column, create {EV_GRID_LABEL_ITEM}.make_with_text (l_proof_event_item.description))

					-- Display
				a_row.set_background_color (successful_color)
				if not show_successful then
					a_row.hide
				end
			elseif is_failed_event (a_event_item) then
					-- Icon
				create l_label
				l_label.set_pixmap (stock_pixmaps.general_error_icon)
				l_label.set_data ("failed")
				l_label.disable_full_select
				a_row.set_item (icon_column, l_label)

					-- Info
				a_row.set_item (info_column, create {EV_GRID_LABEL_ITEM}.make_with_text (l_proof_event_item.description))

					-- Display
				a_row.set_background_color (failed_color)
				if not show_failed then
					a_row.hide
				end
			elseif is_skipped_event (a_event_item) then
					-- Icon
				create l_label
				l_label.set_pixmap (stock_pixmaps.general_warning_icon)
				l_label.set_data ("skipped")
				l_label.disable_full_select
				a_row.set_item (icon_column, l_label)

					-- Info
				a_row.set_item (info_column, create {EV_GRID_LABEL_ITEM}.make_with_text (l_proof_event_item.description))

					-- Display
				a_row.set_background_color (skipped_color)
				if not show_skipped then
					a_row.hide
				end
			else
				check false end
			end

		end

feature {NONE} -- Clean up

	internal_recycle
			-- <Precursor>
		do
			if is_initialized then
				if session_manager.is_service_available then
					if session_data.is_connected (Current) then
						session_data.disconnect_events (Current)
					end
				end
			end
			Precursor {ES_CLICKABLE_EVENT_LIST_TOOL_PANEL_BASE}
		end

feature {NONE} -- Constants

	icon_column: INTEGER = 1
	class_column: INTEGER = 2
	feature_column: INTEGER = 3
	info_column: INTEGER = 4

	successful_color: EV_COLOR
			-- Background color for successful rows
		once
			create Result.make_with_rgb (0.9, 1.0, 0.9)
		end

	failed_color: EV_COLOR
			-- Background color for successful rows
		once
			create Result.make_with_rgb (1.0, 0.9, 0.9)
		end

	skipped_color: EV_COLOR
			-- Background color for successful rows
		once
			create Result.make_with_rgb (1.0, 1.0, 0.9)
		end

indexing
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
