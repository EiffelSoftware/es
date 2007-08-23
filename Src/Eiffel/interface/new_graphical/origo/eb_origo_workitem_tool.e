indexing
	description: "Origo Workitem Tool"
	author: "Rafael Bischof <rafael@xanis.ch>"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_ORIGO_WORKITEM_TOOL

inherit
	EB_TOOL
		redefine
			pixmap
		end

	EB_SHARED_PREFERENCES
		export
			{NONE} all
		end

	EB_ORIGO_CONSTANTS
		export
			{NONE} all
		end

create
	make

feature{NONE} -- Initialisation

	build_interface is
			-- redefine
		local
			l_cell: EV_CELL
			l_button_box: EV_HORIZONTAL_BOX
		do

			create widget

			create l_cell
			l_cell.set_minimum_size (layout_constants.tiny_padding_size, layout_constants.tiny_padding_size)
			widget.extend (l_cell)
			widget.disable_item_expand (l_cell)

				-- button box with refresh button
			create l_button_box
			widget.extend (l_button_box)
			widget.disable_item_expand (l_button_box)

			create l_cell
			l_button_box.extend (l_cell)

			create refresh_button.make_with_text_and_action ("Refresh", agent refresh_workitem_list)
			layout_constants.set_default_size_for_button (refresh_button)
			l_button_box.extend (refresh_button)
			l_button_box.disable_item_expand (refresh_button)

			create information_label.make_with_text ("")
			information_label.align_text_center

			create workitem_grid
			workitem_grid.enable_single_row_selection
			workitem_grid.set_column_count_to (5)
			workitem_grid.column (Column_index_date).set_title ("Date")
			workitem_grid.column (Column_index_project).set_title ("Project")
			workitem_grid.column (Column_index_user).set_title ("User")
			workitem_grid.column (Column_index_type).set_title ("Type")
			workitem_grid.column (Column_index_text).set_title ("Text")

			show_information_label
		end


feature -- Access

	title: STRING_GENERAL is
			-- title displayed
		do
			Result := "Origo workitems"
		ensure then
			Result_not_void: Result /= Void
		end

	pixmap: EV_PIXMAP is
			-- redefine
		do
			Result := pixmaps.bm_origo
		ensure then
			not_void: Result /= Void
		end

feature -- Status setting

	hide_information_label is
			-- hide information label
		do
			if widget.has (information_label) then
				widget.prune (information_label)
				widget.put_front (workitem_grid)
				widget.enable_item_expand (workitem_grid)
			end
		ensure
			has_not_information_label: not widget.has (information_label)
			has_workitem_grid: widget.has (workitem_grid)
		end

	show_information_label is
			-- show information label
		do
			if not widget.has (information_label) then
				widget.prune (workitem_grid)
				widget.put_front (information_label)
				widget.enable_item_expand (information_label)
			end
		ensure
			has_information_label: widget.has (information_label)
			has_not_workitem_grid: not widget.has (workitem_grid)
		end

	set_information_label_text (a_text: STRING) is
			-- set text of information label
		require
			a_text_set: a_text /= Void and not a_text.is_empty
		do
			information_label.set_text (a_text)
			information_label.refresh_now
		ensure
			set: information_label.text.is_equal (a_text)
		end

feature {NONE} -- Implementation

	refresh_workitem_list is
			-- refresh workitem list
		local
			l_workitem_list: DS_LINKED_LIST [EB_ORIGO_WORKITEM]
			l_api_calls: EB_ORIGO_API_CALLS
			l_session: STRING
			l_old_pointer_style: EV_POINTER_STYLE
		do
			l_old_pointer_style := develop_window.window.pointer_style
			develop_window.window.set_pointer_style (create {EV_POINTER_STYLE}.make_predefined ({EV_POINTER_STYLE_CONSTANTS}.wait_cursor))

			set_information_label_text ("Refreshing workitem list:%NLogging in...")
			show_information_label

			create l_api_calls.make (develop_window.window)
			l_session := l_api_calls.login
			if l_session = Void then
				set_information_label_text (l_api_calls.last_error)
				show_information_label
			else
				set_information_label_text ("Refreshing workitem list:%NReceiving workitem list...")

				l_workitem_list := l_api_calls.workitem_list (l_session, preferences.origo_data.number_of_workitems, preferences.origo_data.show_unread_only)

				if l_workitem_list = Void then
					set_information_label_text (l_api_calls.last_error)
					show_information_label
				else
					fill_workitem_grid (l_workitem_list)
				end
			end

			develop_window.window.set_pointer_style (l_old_pointer_style)
		end

	fill_workitem_grid (a_workitem_list: DS_LINKED_LIST [EB_ORIGO_WORKITEM]) is
			-- fill `workitem_grid' with tate in `a_workitem_list'
		local
			l_row: EV_GRID_ROW
			i: INTEGER
			l_workitem: EB_ORIGO_WORKITEM
		do
			set_information_label_text ("Refreshing workitem list:%NProcessing data...")
			show_information_label

			workitem_grid.clear
			workitem_grid.set_row_count_to (a_workitem_list.count)

			from
				i := 1
				a_workitem_list.start
			until
				a_workitem_list.after
			loop
				l_workitem := a_workitem_list.item_for_iteration
				l_row := workitem_grid.row (i)
				l_row.set_item (column_index_date, create {EV_GRID_TEXT_ITEM}.make_with_text (l_workitem.creation_time.out))
				l_row.item (column_index_date).pointer_double_press_actions.force_extend (agent display_workitem_details (l_workitem.workitem_id))
				l_row.set_item (column_index_project, create {EV_GRID_TEXT_ITEM}.make_with_text (l_workitem.project))
				l_row.item (column_index_project).pointer_double_press_actions.force_extend (agent display_workitem_details (l_workitem.workitem_id))
				l_row.set_item (column_index_user, create {EV_GRID_TEXT_ITEM}.make_with_text (l_workitem.user))
				l_row.item (column_index_user).pointer_double_press_actions.force_extend (agent display_workitem_details (l_workitem.workitem_id))
				l_row.set_item (column_index_type, create {EV_GRID_TEXT_ITEM}.make_with_text (l_workitem.type_name))
				l_row.item (column_index_type).pointer_double_press_actions.force_extend (agent display_workitem_details (l_workitem.workitem_id))
				l_row.set_item (column_index_text, create {EV_GRID_TEXT_ITEM}.make_with_text (l_workitem.out))
				l_row.item (column_index_text).pointer_double_press_actions.force_extend (agent display_workitem_details (l_workitem.workitem_id))
				if (i \\ 2) = 0 then
					l_row.set_background_color (color2)
				else
					l_row.set_background_color (color1)
				end

				i := i + 1
				a_workitem_list.forth
			end

			from
				i := 1
			until
				i > workitem_grid.column_count
			loop
				workitem_grid.resize_column_to_content (workitem_grid.column (1), true, false)
				i := i + 1
			end

			hide_information_label
		end

	display_workitem_details (a_workitem_id: INTEGER) is
			-- display the workitem details
		require
			positive: a_workitem_id > 0
		local
			l_dialog: EB_ORIGO_WORKITEM_DETAIL_DIALOG
			l_workitem: EB_ORIGO_WORKITEM
			l_api_calls: EB_ORIGO_API_CALLS
			l_session: STRING
			l_warning_dialog: EB_WARNING_DIALOG
			l_old_pointer_style: EV_POINTER_STYLE
		do
			l_old_pointer_style := develop_window.window.pointer_style
			develop_window.window.set_pointer_style (create {EV_POINTER_STYLE}.make_predefined ({EV_POINTER_STYLE_CONSTANTS}.wait_cursor))

			create l_api_calls.make (develop_window.window)
			l_session := l_api_calls.login

			if l_session /= Void then
				l_workitem := l_api_calls.workitem_details (l_session, a_workitem_id)
			end

			develop_window.window.set_pointer_style (l_old_pointer_style)

			if l_workitem = Void then
				create l_warning_dialog.make_with_text (l_api_calls.last_error)
				l_warning_dialog.show_modal_to_window (develop_window.window)
			elseif not l_workitem.detailed then
				create l_warning_dialog.make_with_text ("No details available for this workitem.")
				l_warning_dialog.show_modal_to_window (develop_window.window)
			else
				create l_dialog.make (l_workitem.label_text, l_workitem.text_field_text)
				l_dialog.show_modal_to_window (develop_window.window)
			end
		end

feature {NONE} -- Implementation

	title_for_pre: STRING is "Origo workitems"
			-- Redefine

	widget: EV_VERTICAL_BOX
			-- Key Widget

	information_label: EV_LABEL
			-- label to show information

	workitem_grid: ES_GRID
			-- list that contains the workitems

	refresh_button: EV_BUTTON
			-- refresh button

	color1: EV_COLOR is
			-- dark color for row background
		once
			create Result.make_with_8_bit_rgb (220, 220, 220)
		end

	color2: EV_COLOR is
			-- light color for row background
		once
			create Result.make_with_8_bit_rgb (240, 240, 240)
		end

invariant
	informatation_label_not_void: information_label /= Void
	workitem_list_not_void: workitem_grid /= Void
end
