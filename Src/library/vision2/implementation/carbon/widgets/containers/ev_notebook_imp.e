indexing
	description:
		"Eiffel Vision notebook. Carbon implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_NOTEBOOK_IMP

inherit
	EV_NOTEBOOK_I
		undefine
			propagate_foreground_color,
			propagate_background_color
		redefine
			interface,
			replace
		end

	EV_WIDGET_LIST_IMP
		redefine
			interface,
			replace,
			initialize,
			remove_i_th,
			needs_event_box
		end

	EV_FONTABLE_IMP
		redefine
			interface
		end

	EV_NOTEBOOK_ACTION_SEQUENCES_IMP
	CONTROLDEFINITIONS_FUNCTIONS_EXTERNAL
	CARBONEVENTS_FUNCTIONS_EXTERNAL

create
	make

feature {NONE} -- Initialization

	needs_event_box: BOOLEAN is True

	make (an_interface: like interface) is
			-- Create a fixed widget.
		local
			err : INTEGER
			rect : RECT_STRUCT
			struct_ptr : POINTER
		do
			base_make (an_interface)
			create rect.make_new_unshared
			rect.set_left(0)
			rect.set_right(0)
			rect.set_bottom(0)
			rect.set_top (0)
			err := create_tabs_control_external ( null, rect.item, {CONTROLDEFINITIONS_ANON_ENUMS}.kControlTabSizeLarge, {CONTROLDEFINITIONS_ANON_ENUMS}.kControlTabDirectionNorth, 0, null, $struct_ptr )
			set_c_object ( struct_ptr )

			id := app_implementation.get_id (current)  --getting an id from the application
			initialize
		end

	initialize is
			-- Initialize the notebook.
		local
			target, h_ret: POINTER
		do
			Precursor {EV_WIDGET_LIST_IMP}
			selected_item_index_internal := 0
			initialize_pixmaps

			target := get_control_event_target_external( c_object )
			h_ret := app_implementation.install_event_handler (id, target, {carbonevents_anon_enums}.kEventClassControl, {carbonevents_anon_enums}.kEventMouseDown)
		end

feature -- Access

		carbon_arrange_children is
			do

			end

	pointed_tab_index: INTEGER is
			-- index of tab currently under mouse pointer, or 0 if none.
		local
			i: INTEGER
			gdkwin, mouse_ptr_wid, tab_label: POINTER
			a_wid: EV_WIDGET_IMP
		do

		end

	pixmaps_size_changed is
			-- The size of the displayed pixmaps has just
			-- changed.
		do
			--| FIXME IEK Implement this
		end

feature {EV_NOTEBOOK, EV_NOTEBOOK_TAB_IMP} -- Access

	item_tab (an_item: EV_WIDGET): EV_NOTEBOOK_TAB is
			-- Tab associated with `an_item'.
		do
			create Result.make_with_widgets (interface, an_item)
		end

	item_text (an_item: like item): STRING_32 is
			-- Label of `an_item'.
		local
			item_imp: EV_WIDGET_IMP
			a_event_box, a_hbox, a_list, a_label: POINTER

		do

		end

	item_pixmap (an_item: like item): EV_PIXMAP is
			-- Pixmap of `an_item'.
		local
			item_imp: EV_WIDGET_IMP
			a_event_box, a_hbox, a_list, a_image, a_pixbuf: POINTER
			pix_imp: EV_PIXMAP_IMP
		do

		end

feature -- Status report

	selected_item: like item is
			-- Page displayed topmost.
		local
			p: POINTER
			pn: INTEGER
			imp: EV_WIDGET_IMP
		do

		end

	selected_item_index: INTEGER is
			-- Page index of selected item
		do
			if count > 0 then
				Result := selected_item_index_internal
			end
		end

	tab_position: INTEGER is
			-- Position of tabs.
 		local
 			gtk_pos: INTEGER
 		do
 			inspect
 				gtk_pos
 			when 0 then
 				Result := interface.Tab_left
 			when 1 then
 				Result := interface.Tab_right
 			when 2 then
 				Result := interface.Tab_top
 			when 3 then
 				Result := interface.Tab_bottom
			end
		end

feature {EV_NOTEBOOK} -- Status setting

	set_tab_position (a_tab_position: INTEGER) is
			-- Display tabs at `a_position'.
		local
			gtk_pos: INTEGER
		do
			if a_tab_position = interface.Tab_left then
				gtk_pos := 0
			elseif a_tab_position = interface.Tab_right then
				gtk_pos := 1
			elseif a_tab_position = interface.Tab_top then
				gtk_pos := 2
			elseif a_tab_position = interface.Tab_bottom then
				gtk_pos := 3
			end

		end

	select_item (an_item: like item) is
			-- Display `an_item' above all others.
		local
			item_imp: EV_WIDGET_IMP
		do
			item_imp ?= an_item.implementation
			check
				an_item_has_implementation: item_imp /= Void
			end

		end

feature -- Element change

	remove_i_th (i: INTEGER) is
			-- Remove item at `i'-th position.
		do
			Precursor {EV_WIDGET_LIST_IMP} (i)
			if count > 0 then
				selected_item_index_internal :=  1
			else
				selected_item_index_internal := 0
			end
		end

	replace (v: like item) is
			-- Replace current item by `v'.
		local
			i: INTEGER
		do
			i := 1
			remove_i_th (index)
			insert_i_th (v, index)

		end

feature {EV_NOTEBOOK, EV_NOTEBOOK_TAB_IMP} -- Element change

	ensure_tab_label (tab_widget: POINTER) is
			-- Ensure the is a tab label widget for `tab_widget'.
		local
			a_event_box, a_hbox, a_image, a_label: POINTER
		do

		end

	default_tab_label_spacing: INTEGER is 3
		-- Space between pixmap and text in the tab label.

	set_item_text (an_item: like item; a_text: STRING_GENERAL) is
			-- Assign `a_text' to the label for `an_item'.
		local
			item_imp: EV_WIDGET_IMP
		do
			item_imp ?= an_item.implementation

		end

	set_item_pixmap (an_item: like item; a_pixmap: EV_PIXMAP) is
			-- Assign `a_pixmap' to the tab for `an_item'.
		local
			item_imp: EV_WIDGET_IMP
			a_event_box, a_hbox, a_image, a_list, a_pixbuf: POINTER
			a_pix_imp: EV_PIXMAP_IMP
		do
			item_imp ?= an_item.implementation


		end

feature {EV_INTERMEDIARY_ROUTINES} -- Implementation

	page_switch (a_page: INTEGER) is
			-- Called when the page is switched.
		do
			if not is_destroyed then
				selected_item_index_internal := a_page + 1
				if selection_actions_internal /= Void and count > 0 then
					selection_actions_internal.call (Void)
				end
			end
		end

feature {EV_ANY_I} -- Implementation

	selected_item_index_internal: INTEGER
			-- Index `selected_item'

	gtk_reorder_child (a_container, a_child: POINTER; a_position: INTEGER) is
			-- Move `a_child' to `a_position' in `a_container'.
		do

		end

feature {EV_ANY_I, EV_ANY} -- Implementation

	interface: EV_NOTEBOOK;
			-- Provides a common user interface to platform dependent
			-- functionality implemented by `Current'

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end -- class EV_NOTEBOOK_IMP

