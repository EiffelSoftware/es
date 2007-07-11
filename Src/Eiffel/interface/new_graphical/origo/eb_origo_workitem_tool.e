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

--			refresh_workitem_list





--			create workitem_list			
--			workitem_list.set_column_title ("Date", 1)
--			workitem_list.set_column_title ("Project", 2)
--			workitem_list.set_column_title ("User", 3)
--			workitem_list.set_column_title ("Text", 4)


--			create l_row
--			l_row.force ("2 Weeks ago")
--			l_row.force ("Brick breaker")
--			l_row.force ("bischora")
--			l_row.force ("mooooo%Ncow")
--			workitem_list.force (l_row)



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
		do
			set_information_label_text ("Refreshing workitem list:%NLogging in...")
			show_information_label

			create l_api_calls.make (Void)
			l_session := l_api_calls.login
			if l_session = Void then
				set_information_label_text (l_api_calls.last_error)
				show_information_label
			else
				set_information_label_text ("Refreshing workitem list:%NReceiving workitem list...")

				l_workitem_list := l_api_calls.workitem_list (l_session, preferences.origo_data.maximum_workitem_age, preferences.origo_data.show_unread_only)

				if l_workitem_list = Void then
					set_information_label_text (l_api_calls.last_error)
					show_information_label
				else
					fill_workitem_grid (l_workitem_list)
				end
			end
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
				l_row.set_item (column_index_project, create {EV_GRID_TEXT_ITEM}.make_with_text (l_workitem.project))
				l_row.set_item (column_index_user, create {EV_GRID_TEXT_ITEM}.make_with_text (l_workitem.user))
				l_row.set_item (column_index_type, create {EV_GRID_TEXT_ITEM}.make_with_text (l_workitem.type_name))
				l_row.set_item (column_index_text, create {EV_GRID_TEXT_ITEM}.make_with_text (l_workitem.out_short))
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


--			workitem_grid.set_item (a_column, a_row: INTEGER_32, a_item: EV_GRID_ITEM)

--			l_rw := workitem_grid.row (1)
--			l_rw.set_background_color(create {EV_COLOR}.make_with_8_bit_rgb (120, 120, 120))
--			l_rw.set_item (1, create {EV_GRID_TEXT_ITEM}.make_with_text ("in 2 weeks"))
--			l_rw.set_item (2, create {EV_GRID_TEXT_ITEM}.make_with_text ("brick-breaker"))
--			l_rw.set_item (3, create {EV_GRID_TEXT_ITEM}.make_with_text ("bischora"))
--			l_rw.set_item (4, create {EV_GRID_TEXT_ITEM}.make_with_text ("commit"))
--			l_rw.set_item (5, create {EV_GRID_TEXT_ITEM}.make_with_text ("moo"))

			hide_information_label
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
