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

create
	make

feature{NONE} -- Initialisation

	build_interface is
			-- redefine
		local
			l_cell: EV_CELL
			l_rw: EV_GRID_ROW
		do

			create widget

			create refresh_button.make_with_text_and_action ("Refresh", agent refresh_workitem_list)
			widget.extend (refresh_button)
			widget.disable_item_expand (refresh_button)
			layout_constants.set_default_size_for_button (refresh_button)

			create l_cell
			l_cell.set_minimum_size (layout_constants.small_padding_size, layout_constants.small_padding_size)
			widget.extend (l_cell)
			widget.disable_item_expand (l_cell)

			create information_label.make_with_text ("Reading workitem list...")
			information_label.align_text_center

			create workitem_grid
			workitem_grid.set_column_count_to (5)
			workitem_grid.column (1).set_title ("Date")
			workitem_grid.column (2).set_title ("Project")
			workitem_grid.column (3).set_title ("User")
			workitem_grid.column (4).set_title ("Type")
			workitem_grid.column (5).set_title ("Text")
			workitem_grid.set_row_count_to (7)

			l_rw := workitem_grid.row (1)
			l_rw.set_background_color(create {EV_COLOR}.make_with_8_bit_rgb (120, 120, 120))
			l_rw.set_item (1, create {EV_GRID_TEXT_ITEM}.make_with_text ("in 2 weeks"))
			l_rw.set_item (2, create {EV_GRID_TEXT_ITEM}.make_with_text ("brick-breaker"))
			l_rw.set_item (3, create {EV_GRID_TEXT_ITEM}.make_with_text ("bischora"))
			l_rw.set_item (4, create {EV_GRID_TEXT_ITEM}.make_with_text ("commit"))
			l_rw.set_item (5, create {EV_GRID_TEXT_ITEM}.make_with_text ("moo"))

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
				widget.extend (workitem_grid)
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
				widget.extend (information_label)
				widget.enable_item_expand (information_label)
			end
		ensure
			has_information_label: widget.has (information_label)
			has_not_workitem_grid: not widget.has (workitem_grid)
		end

	set_information_label_text (a_text: STRING) is
			-- set text of information labewl
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
			create l_api_calls.make (Void)
			l_session := l_api_calls.login
			if l_session = Void then
				set_information_label_text (l_api_calls.last_error)
				show_information_label
			else
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
		do
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

	color_dark: EV_COLOR is
			-- dark color for row background
		once
			create Result.make_with_8_bit_rgb (120, 120, 120)
		end

	color_light: EV_COLOR is
			-- light color for row background
		once
			create Result.make_with_8_bit_rgb (60, 60, 60)
		end


invariant
	informatation_label_not_void: information_label /= Void
	workitem_list_not_void: workitem_grid /= Void
end
