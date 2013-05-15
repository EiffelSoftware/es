note
	description:
		"Graphical panel for Proof tool"
	date: "$Date$"
	revision: "$Revision$"

class
	ES_AUTOPROOF_TOOL_PANEL

inherit
	ES_CLICKABLE_EVENT_LIST_TOOL_PANEL_BASE
		redefine
			build_tool_interface,
			on_before_initialize,
			on_after_initialized,
			internal_recycle,
			create_right_tool_bar_items,
			is_event_list_synchronized_on_initialized,
			is_event_list_scrolled_automatically,
			is_appliable_event,
			on_event_item_added,
			on_event_item_removed,
			find_event_row
		end

	SESSION_EVENT_OBSERVER
		export {NONE} all end

	SHARED_ERROR_TRACER
		export {NONE} all end

	EBB_SHARED_BLACKBOARD

	E2B_SHARED_CONTEXT

create {ES_AUTOPROOF_TOOL}
	make

feature {NONE} -- Initialization

	on_before_initialize
			-- <Precursor>
		local
			l_shared_writer: EB_SHARED_WRITER
		do
			Precursor

--			create l_shared_writer
--			l_shared_writer.label_font_table.item (0).set_height (16)
--			l_shared_writer.label_font_table.item (1).set_height (16)
--			l_shared_writer.label_font_table.item (2).set_height (16)

				-- We want the tool to synchronize with the event list, when first initialized.
			is_event_list_synchronized_on_initialized := True
		end

	on_after_initialized
			-- <Precursor>
		do
				-- Bind redirecting pick and drop actions
			stone_director.bind (grid_events, Current)

				-- Hook up events for session data
			if session_manager.is_service_available then
				session_data.session_connection.connect_events (Current)
			end

			is_event_list_scrolled_automatically := False

			Precursor
		end

    create_tool_bar_items: ARRAYED_LIST [SD_TOOL_BAR_ITEM]
            -- <Precursor>
		do
				-- "toggle successful" button
			create successful_button.make
			successful_button.set_pixmap (stock_pixmaps.general_check_document_icon)
			successful_button.set_pixel_buffer (stock_pixmaps.general_check_document_icon_buffer)
			successful_button.enable_select
			successful_button.select_actions.extend (agent on_update_visiblity)

				-- "toggle failed" button
			create failed_button.make
			failed_button.set_pixmap (stock_pixmaps.debug_exception_handling_icon)
			failed_button.set_pixel_buffer (stock_pixmaps.debug_exception_handling_icon_buffer)
			failed_button.enable_select
			failed_button.select_actions.extend (agent on_update_visiblity)

				-- "toggle skipped" button
			create skipped_button.make
			skipped_button.set_pixmap (stock_pixmaps.general_warning_icon)
			skipped_button.set_pixel_buffer (stock_pixmaps.general_warning_icon_buffer)
			skipped_button.enable_select
			skipped_button.select_actions.extend (agent on_update_visiblity)

			update_button_titles

			create Result.make (5)
			proof_button := (create {ES_AUTOPROOF_COMMAND}.make).new_sd_toolbar_item (True)
			Result.extend (proof_button)
			Result.extend (create {SD_TOOL_BAR_SEPARATOR}.make)
			Result.extend (successful_button)
			Result.extend (failed_button)
--			Result.extend (skipped_button)
		end

	create_right_tool_bar_items: ARRAYED_LIST [SD_TOOL_BAR_ITEM]
			-- <Precursor>
		local
			l_box: EV_HORIZONTAL_BOX
			l_button: SD_TOOL_BAR_BUTTON
			l_popup_button: SD_TOOL_BAR_POPUP_BUTTON
		do
				-- live text filter
			create l_box
			l_box.extend (create {EV_LABEL}.make_with_text (ep_names.tool_text_filter + ": "))
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

				-- options button
			create l_popup_button.make
			l_popup_button.set_pixmap (stock_pixmaps.metric_filter_icon)
			l_popup_button.set_pixel_buffer (stock_pixmaps.metric_filter_icon_buffer)
			l_popup_button.set_tooltip ("AutoProof options")
			l_popup_button.set_menu_function (agent build_options_menu)

			create Result.make (4)
			Result.extend (create {SD_TOOL_BAR_RESIZABLE_ITEM}.make (l_box))
			Result.extend (l_button)
			Result.extend (create {SD_TOOL_BAR_SEPARATOR}.make)
			Result.extend (l_popup_button)
		end

	build_options_menu: EV_MENU
			-- Build options menu.
		local
			l_item: EV_CHECK_MENU_ITEM
		do
			create Result

			create l_item.make_with_text_and_action ("Two-step verification using inlining",
				agent do
					options.set_reverification_with_inlining_enabled (not options.is_reverification_with_inlining_enabled)
				end)
			if options.is_reverification_with_inlining_enabled then
				l_item.toggle
			end
			Result.extend (l_item)

			create l_item.make_with_text_and_action ("Automatic inlining of routines without postcondition",
				agent do
					options.set_automatic_inlining_enabled (not options.is_automatic_inlining_enabled)
				end)
			if options.is_automatic_inlining_enabled then
				l_item.toggle
			end
			Result.extend (l_item)

			create l_item.make_with_text_and_action ("Automatic unrolling of loops without invariants",
				agent do
					options.set_automatic_loop_unrolling_enabled (not options.is_automatic_loop_unrolling_enabled)
				end)
			if options.is_automatic_loop_unrolling_enabled then
				l_item.toggle
			end
			Result.extend (l_item)

			create l_item.make_with_text_and_action ("Use sound loop unrolling",
				agent do
					options.set_sound_loop_unrolling_enabled (not options.is_sound_loop_unrolling_enabled)
				end)
			if options.is_sound_loop_unrolling_enabled then
				l_item.toggle
			end
			Result.extend (l_item)

			create l_item.make_with_text_and_action ("Check integer overflow",
				agent do
					options.set_checking_overflow (not options.is_checking_overflow)
				end)
			if options.is_checking_overflow then
				l_item.toggle
			end
			Result.extend (l_item)

			create l_item.make_with_text_and_action ("Check frame condition",
				agent do
					options.set_checking_frame (not options.is_checking_frame)
				end)
			if options.is_checking_frame then
				l_item.toggle
			end
			Result.extend (l_item)
		end

	build_tool_interface (a_widget: ES_GRID)
			-- Builds the tools user interface elements.
			-- Note: This function is called prior to showing the tool for the first time.
			--
			-- `a_widget': A widget to build the tool interface using.
		local
			l_col: EV_GRID_COLUMN
		do
			Precursor {ES_CLICKABLE_EVENT_LIST_TOOL_PANEL_BASE} (a_widget)
			a_widget.set_column_count_to (time_column)

				-- Create columns
			l_col := a_widget.column (1)
			l_col.set_width (20)
			l_col := a_widget.column (icon_column)
			l_col.set_width (20)
			l_col := a_widget.column (class_column)
			l_col.set_title (ep_names.tool_header_class)
			l_col.set_width (100)
			l_col := a_widget.column (feature_column)
			l_col.set_title (ep_names.tool_header_feature)
			l_col.set_width (120)
			l_col := a_widget.column (info_column)
			l_col.set_title (ep_names.tool_header_information)
			l_col.set_width (300)
			l_col := a_widget.column (position_column)
			l_col.set_title (ep_names.tool_header_position)
			l_col.set_width (40)
			l_col := a_widget.column (time_column)
			l_col.set_title (ep_names.tool_header_time)
			l_col.set_width (50)

			a_widget.enable_tree
			a_widget.disable_row_height_fixed
			a_widget.enable_auto_size_best_fit_column (info_column)

				-- Enable sorting
			enable_sorting_on_columns (
				<<
					a_widget.column (icon_column),
					a_widget.column (class_column),
					a_widget.column (feature_column),
					a_widget.column (time_column)
				>>)
		end

feature -- Access

	proof_button: EB_SD_COMMAND_TOOL_BAR_BUTTON
			-- Button to launch AutoProof.

	successful_count: INTEGER
			-- Number of successful events

	failed_count: INTEGER
			-- Number of successful events

	skipped_count: INTEGER
			-- Number of successful events

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

	is_item_visible (a_item: EV_GRID_ROW): BOOLEAN
			-- Is `a_item' visible?
		local
			l_text: STRING
			l_item: E2B_VERIFICATION_EVENT
		do
			Result := True
			l_item ?= a_item.data
			if l_item /= Void then
				if is_successful_event (l_item) and not show_successful then
					Result := False
				elseif is_failed_event (l_item) and not show_failed then
					Result := False
				else
					l_text := text_filter.text.as_lower
					if not l_text.is_empty then
						if
							not l_item.context_class.name.as_lower.has_substring (l_text) and
							(l_item.context_feature = Void or else
							 not l_item.context_feature.feature_name_32.as_lower.has_substring (l_text)) and
							not l_item.description.as_lower.has_substring (l_text)
						then
							Result := False
						end
					end
				end
			end
		end

	frozen is_event_list_synchronized_on_initialized: BOOLEAN
			-- <Precursor>

	frozen is_event_list_scrolled_automatically: BOOLEAN
			-- <Precursor>

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
				is_event_list_synchronized_on_initialized := True
				initialize
			end
			if l_applicable then
				if is_successful_event (a_event_item) then
					successful_count := successful_count + 1
				elseif is_failed_event (a_event_item) then
					failed_count := failed_count + 1
				else
					check false end
				end

				update_button_titles

				Precursor {ES_CLICKABLE_EVENT_LIST_TOOL_PANEL_BASE} (a_service, a_event_item)
			end
		ensure then
			is_initialized: is_appliable_event (a_event_item) implies is_initialized
		end

	on_event_item_removed (a_service: EVENT_LIST_S; a_event_item: EVENT_LIST_ITEM_I)
			-- <Precursor>
		local
			l_applicable: BOOLEAN
		do
			l_applicable := is_appliable_event (a_event_item)
			if l_applicable and not is_initialized then
					-- We have to perform initialization to set the icon and counter
					-- Synchronization with the event list service is surpress to prevent duplication of event items being added.
				is_event_list_synchronized_on_initialized := True
				initialize
			end
			if l_applicable then
				if is_successful_event (a_event_item) then
					successful_count := successful_count - 1
				elseif is_failed_event (a_event_item) then
					failed_count := failed_count - 1
				else
					check false end
				end

				update_button_titles

				Precursor {ES_CLICKABLE_EVENT_LIST_TOOL_PANEL_BASE} (a_service, a_event_item)
			end
		ensure then
			is_initialized: is_appliable_event (a_event_item) implies is_initialized
		end

	on_update_visiblity
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
				if is_item_visible (l_row) then
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
			Result := attached {E2B_VERIFICATION_EVENT} a_event_item or attached {E2B_FAILED_EXECUTION_EVENT} a_event_item
		end

	is_successful_event (a_event_item: EVENT_LIST_ITEM_I): BOOLEAN
			-- Determines if event `a_event_item' is a successful event
		do
			Result :=
				attached {E2B_VERIFICATION_EVENT} a_event_item as l_event and then
				attached {E2B_SUCCESSFUL_VERIFICATION} l_event.data
		end

	is_failed_event (a_event_item: EVENT_LIST_ITEM_I): BOOLEAN
			-- Determines if event `a_event_item' is a failed event
		do
			Result :=
				attached {E2B_VERIFICATION_EVENT} a_event_item as l_event and then
				attached {E2B_FAILED_VERIFICATION} l_event.data
		end

	is_failed_execution_event (a_event_item: EVENT_LIST_ITEM_I): BOOLEAN
			-- Determines if event `a_event_item' is a skipped event
		do
			Result := attached {E2B_FAILED_EXECUTION_EVENT} a_event_item
		end

feature {NONE} -- Basic operations

	do_default_action (a_row: EV_GRID_ROW)
			-- <Precursor>
		local
			l_stone: STONE
		do
			if attached {E2B_VERIFICATION_EVENT} a_row.parent_row_root.data as l_event_item then
				if attached {E2B_VERIFICATION_ERROR} a_row.data as l_error then
					create {COMPILED_LINE_STONE} l_stone.make_with_line (l_event_item.context_class, l_error.eiffel_line_number, False)
				elseif l_event_item.line_number > 0 then
					create {COMPILED_LINE_STONE} l_stone.make_with_line (l_event_item.context_class, l_event_item.line_number, False)
				elseif l_event_item.context_feature /= Void then
					create {FEATURE_STONE} l_stone.make (l_event_item.context_feature.api_feature (l_event_item.context_class.class_id))
				else
					create {CLASSC_STONE} l_stone.make (l_event_item.context_class)
				end
			end
			if l_stone /= Void and then l_stone.is_valid then
				(create {EB_CONTROL_PICK_HANDLER}).launch_stone (l_stone)
			end
		end

	populate_event_grid_row_items (a_event_item: EVENT_LIST_ITEM_I; a_row: EV_GRID_ROW)
			-- Populates a grid row's item on a given row using the event `a_event_item'.
			--
			-- `a_event_item': A event to base the creation of a grid row on.
			-- `a_row': The row to create items on.
		local
			l_editor_item: EB_GRID_EDITOR_TOKEN_ITEM
			l_gen, l_message_gen, l_text_gen: EB_EDITOR_TOKEN_GENERATOR
			l_lines: LIST [EIFFEL_EDITOR_LINE]
			l_tip: EB_EDITOR_TOKEN_TOOLTIP
			l_label: EV_GRID_LABEL_ITEM
			l_error_list: LIST [EP_ERROR]
			l_error: EP_ERROR
			l_row: EV_GRID_ROW

		do
			a_row.set_data (a_event_item)
			if is_failed_execution_event (a_event_item) then
					-- Icon
				create l_label
				l_label.set_pixmap (stock_pixmaps.general_warning_icon)
				l_label.set_data ("warning")
				l_label.disable_full_select
				a_row.set_item (icon_column, l_label)

					-- Message
				create l_label.make_with_text (a_event_item.data.out)
				a_row.set_item (info_column, l_label)

					-- Color
				a_row.set_background_color (failed_color)

			elseif attached {E2B_VERIFICATION_EVENT} a_event_item as l_result then
					-- Class location
				create l_gen.make
				l_result.context_class.append_name (l_gen)
				l_editor_item := create_clickable_grid_item (l_gen.last_line, True)
				a_row.set_item (class_column, l_editor_item)

					-- Feature location
				if l_result.context_feature /= Void then
					create l_gen.make
					l_gen.add_feature_name (l_result.context_feature.feature_name_32, l_result.context_class)
					l_editor_item := create_clickable_grid_item (l_gen.last_line, True)
					a_row.set_item (feature_column, l_editor_item)
				end

					-- Time information
				create l_label.make_with_text (l_result.milliseconds_used.out)
				a_row.set_item (time_column, l_label)

				if is_successful_event (a_event_item) then
						-- Icon
					create l_label
					l_label.set_pixmap (stock_pixmaps.general_tick_icon)
					l_label.set_data ("successful")
					l_label.disable_full_select
					a_row.set_item (icon_column, l_label)

						-- Info
					create l_message_gen.make
					l_result.single_line_message (l_message_gen)
					l_editor_item := create_clickable_grid_item (l_message_gen.last_line, True)
					a_row.set_height (l_editor_item.required_height_for_text_and_component)
					a_row.set_item (info_column, l_editor_item)

						-- Display
					a_row.set_background_color (successful_color)

					if attached {E2B_SUCCESSFUL_VERIFICATION} a_event_item.data as l_success then
						if attached l_success.suggestion and then not l_success.suggestion.is_empty then
							insert_subrow_for_suggestion (a_row, l_success.suggestion)
						end
						if attached l_success.original_errors then
							across l_success.original_errors as l_errors loop
								insert_subrow_for_error (a_row, l_errors.item)
							end
							a_row.set_background_color (partial_color)
						end
					end

				elseif is_failed_event (a_event_item) then
						-- Icon
					create l_label
					l_label.set_pixmap (stock_pixmaps.general_error_icon)
					l_label.set_data ("failed")
					l_label.disable_full_select
					a_row.set_item (icon_column, l_label)

						-- Info
					create l_message_gen.make
					l_result.single_line_message (l_message_gen)
					l_editor_item := create_clickable_grid_item (l_message_gen.last_line, True)
					a_row.set_height (l_editor_item.required_height_for_text_and_component)
					a_row.set_item (info_column, l_editor_item)

						-- Display
					a_row.set_background_color (failed_color)

					if attached {E2B_FAILED_VERIFICATION} a_event_item.data as l_failure then
						across
							l_failure.errors as l_errors
						loop
							insert_subrow_for_error (a_row, l_errors.item)
						end
					end

						 -- Position
					if l_result.line_number > 0 then
						a_row.set_item (position_column, create {EV_GRID_LABEL_ITEM}.make_with_text (l_result.line_number.out))
					end
				end
			else
				check False end
			end


			if not is_item_visible (a_row) then
				a_row.hide
			end
		end

	insert_subrow_for_error (a_parent: EV_GRID_ROW; a_error: E2B_VERIFICATION_ERROR)
			-- Insert a new subrow into `a_parent' for `a_error'.
		local
			l_index: INTEGER
			l_row: EV_GRID_ROW
			l_text_gen: EB_EDITOR_TOKEN_GENERATOR
			l_editor_item: EB_GRID_EDITOR_TOKEN_ITEM
		do
			l_index := a_parent.subrow_count + 1

			a_parent.insert_subrow (l_index)
			l_row := a_parent.subrow (l_index)
			l_row.set_data (a_error)

			l_row.set_item (icon_column, create {EV_GRID_LABEL_ITEM})
			l_row.set_item (class_column, create {EV_GRID_LABEL_ITEM})
			l_row.set_item (feature_column, create {EV_GRID_LABEL_ITEM})

			create l_text_gen.make
			l_text_gen.enable_multiline
			a_error.multi_line_message (l_text_gen)
			l_text_gen.add_new_line
			l_editor_item := create_multiline_clickable_grid_item (l_text_gen.lines, True, False)
			l_row.set_height (l_editor_item.required_height_for_text_and_component)
			l_row.set_item (info_column, l_editor_item)

			if a_error.eiffel_line_number > 0 then
				l_row.set_item (position_column, create {EV_GRID_LABEL_ITEM}.make_with_text (a_error.eiffel_line_number.out))
			end

			if l_index \\ 2 = 1 then
				l_row.set_background_color (odd_failed_sub_color)
			else
				l_row.set_background_color (even_failed_sub_color)
			end

		end

	insert_subrow_for_suggestion (a_parent: EV_GRID_ROW; a_suggestion: STRING)
			-- Insert a new subrow into `a_parent' for `a_error'.
		local
			l_index: INTEGER
			l_row: EV_GRID_ROW
			l_text_gen: EB_EDITOR_TOKEN_GENERATOR
			l_editor_item: EB_GRID_EDITOR_TOKEN_ITEM
		do
			l_index := a_parent.subrow_count + 1

			a_parent.insert_subrow (l_index)
			l_row := a_parent.subrow (l_index)
			l_row.set_data (a_suggestion)

			l_row.set_item (icon_column, create {EV_GRID_LABEL_ITEM})
			l_row.set_item (class_column, create {EV_GRID_LABEL_ITEM})
			l_row.set_item (feature_column, create {EV_GRID_LABEL_ITEM})
			l_row.set_item (info_column, create {EV_GRID_LABEL_ITEM}.make_with_text (a_suggestion))

			l_row.set_background_color (partial_color)

		end

	update_button_titles
			-- Update button titles with number of events.
		do
			successful_button.set_text (successful_count.out + " " + ep_names.tool_button_successful)
			failed_button.set_text (failed_count.out + " " + ep_names.tool_button_failed)
			skipped_button.set_text (skipped_count.out + " " + ep_names.tool_button_skipped)
		end

	find_event_row (a_event_item: EVENT_LIST_ITEM_I): EV_GRID_ROW
			-- <Precursor>
		local
			l_grid: like grid_events
			l_row: EV_GRID_ROW
			i: INTEGER
		do
			l_grid := grid_events
			from
					-- Count backwards as it is more optimal for use in item insertion/removal.
				i := l_grid.row_count
			until
				i = 0
			loop
				l_row := l_grid.row (i)
				if l_row.data = a_event_item then
					Result := l_row
					i := 0
				else
					i := i - 1
				end
			end
		end

feature {NONE} -- Clean up

	internal_recycle
			-- <Precursor>
		do
			if is_initialized then
				if session_manager.is_service_available then
					if session_data.session_connection.is_connected (Current) then
						session_data.session_connection.disconnect_events (Current)
					end
				end
			end
			Precursor {ES_CLICKABLE_EVENT_LIST_TOOL_PANEL_BASE}
		end

feature {NONE} -- Constants

	icon_column: INTEGER = 2
	class_column: INTEGER = 3
	feature_column: INTEGER = 4
	info_column: INTEGER = 5
	position_column: INTEGER = 6
	time_column: INTEGER = 7

	successful_color: EV_COLOR
			-- Background color for successful rows
		once
			create Result.make_with_rgb (0.8, 1.0, 0.8)
		end

	failed_color: EV_COLOR
			-- Background color for successful rows
		once
			create Result.make_with_rgb (1.0, 0.7, 0.7)
		end

	even_failed_sub_color: EV_COLOR
			-- Background color for successful rows
		once
			create Result.make_with_rgb (1.0, 0.9, 0.9)
		end

	odd_failed_sub_color: EV_COLOR
			-- Background color for successful rows
		once
			create Result.make_with_rgb (1.0, 0.8, 0.8)
		end

	partial_color: EV_COLOR
			-- Background color for partial success
		once
			create Result.make_with_rgb (1.0, 0.9, 0.4)
		end

	ep_names: !EP_NAMES
			-- Shared access to interface names
		once
			create Result
		end

note
	copyright: "Copyright (c) 1984-2013, Eiffel Software"
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
