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

create
	make

feature{NONE} -- Initialisation

	build_interface is
			-- redefine
		local
			l_label: EV_LABEL
			wi: EB_ORIGO_WORKITEM
			l_row: EV_MULTI_COLUMN_LIST_ROW
			l_item: EV_GRID_ITEM
			l_rw: EV_GRID_ROW
			l_text: EV_GRID_TEXT_ITEM
		do

			create widget
			create l_label.make_with_text ("Reading workitem list...");

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


			hide_information_label
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
			widget.prune (information_label)
			widget.extend (workitem_grid)
		end

	show_information_label is
			-- show information label
		do
			widget.prune (workitem_grid)
			widget.extend (information_label)
		end

	set_information_label_text (a_text: STRING) is
			-- set text of information labewl
		require
			a_text_set: a_text /= Void and not a_text.is_empty
		do
			information_label.set_text (a_text)
			information_label.refresh_now
		ensure
			set: information_label.text = a_text
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
