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
			remove_i_th
		end

	EV_FONTABLE_IMP
		redefine
			interface
		end

	EV_NOTEBOOK_ACTION_SEQUENCES_IMP
	CONTROLDEFINITIONS_FUNCTIONS_EXTERNAL
	CONTROLS_FUNCTIONS_EXTERNAL
	CARBONEVENTS_FUNCTIONS_EXTERNAL

create
	make

feature {NONE} -- Initialization

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
		end

	initialize is
			-- Initialize the notebook.
		local
			target, h_ret: POINTER
		do
			Precursor {EV_WIDGET_LIST_IMP}
			initialize_pixmaps

			target := get_control_event_target_external( c_object )
			h_ret := app_implementation.install_event_handler (id, target, {carbonevents_anon_enums}.kEventClassControl, {carbonevents_anon_enums}.kEventMouseDown)
			tab_position := interface.tab_top
		end

feature -- Access

	carbon_arrange_children is
			-- Recreate the tab control with changed settings
		local
			a_parent : POINTER
			a_rect : RECT_STRUCT
			dummy_ptr : POINTER
			new_view : POINTER
			a_layout_info : HILAYOUT_INFO_STRUCT
			orientation : INTEGER
			err : INTEGER
			i : INTEGER
			tab_array : EWG_POINTER_ARRAY
			tab_entry : CONTROL_TAB_ENTRY_STRUCT
			help_array : ARRAY[CONTROL_TAB_ENTRY_STRUCT]
			w_imp : EV_WIDGET_IMP
		do
				a_parent := hiview_get_superview_external ( c_object )
				create a_rect.make_new_unshared
				dummy_ptr := get_control_bounds_external ( c_object, a_rect.item )
				create a_layout_info.make_new_unshared
				a_layout_info.set_version ( {HIVIEW_ANON_ENUMS}.kHILayoutInfoVersionZero )
				err := hiview_get_layout_info_external ( c_object, a_layout_info.item )

	 			if tab_position = interface.Tab_top  then
	 				orientation := {CONTROLDEFINITIONS_ANON_ENUMS}.kControlTabDirectionNorth
	 			elseif tab_position =  interface.Tab_left  then
	 				orientation := {CONTROLDEFINITIONS_ANON_ENUMS}.kControlTabDirectionWest
	 			elseif tab_position =  interface.Tab_bottom  then
	 				orientation := {CONTROLDEFINITIONS_ANON_ENUMS}.kControlTabDirectionSouth
	 			elseif tab_position =  interface.Tab_right  then
	 				orientation := {CONTROLDEFINITIONS_ANON_ENUMS}.kControlTabDirectionEast
	 			else
	 				check
	 					must_not_be_reached : false
	 				end
				end

				create tab_array.make_new_unshared ( count )
				create help_array.make ( 1, count ) -- Array to put in STRUCT wrappers so that they don't get collected
				from
					i := 1
				until
					i > count
				loop
					create tab_entry.make_new_unshared
					w_imp ?= i_th ( i ).implementation
					check
						w_imp_not_void : w_imp /= Void
					end
					err := hiview_remove_from_superview_external ( w_imp.c_object )


					help_array.put ( tab_entry, i )
					tab_array.put ( tab_entry.item, i )
				end

				err := create_tabs_control_external ( a_parent, a_rect.item, {CONTROLDEFINITIONS_ANON_ENUMS}.kControlTabSizeLarge, orientation, count, tab_array.array_address, $new_view )

				set_control_bounds_external ( new_view, a_rect.item )
				err := hiview_set_layout_info_external ( new_view, a_layout_info.item )
				err := hiview_apply_layout_external ( new_view )

				dispose_control_external ( c_object )
				set_c_object ( new_view )
		end

	pointed_tab_index: INTEGER is
			-- index of tab currently under mouse pointer, or 0 if none.
		local
			err: INTEGER
			a_point : CGPOINT_STRUCT
		do
			create a_point.make_new_unshared

			--err := hiview_get_subview_hit_external ( c_object,

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

		end

	tab_position: INTEGER
			-- Position of tabs.


feature {EV_NOTEBOOK} -- Status setting

	set_tab_position (a_tab_position: INTEGER) is
			-- Display tabs at `a_position'.
		do


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

