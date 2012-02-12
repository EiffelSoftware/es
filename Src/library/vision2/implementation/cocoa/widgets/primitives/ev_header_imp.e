note
	description: "Cocoa Implementation for EV_HEADER_IMP."
	author: "Daniel Furrer"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_HEADER_IMP

inherit
	EV_HEADER_I
		redefine
			interface
		end

	EV_ITEM_LIST_IMP [EV_HEADER_ITEM, EV_HEADER_ITEM_IMP]
		redefine
			interface,
			make
		end

	EV_PRIMITIVE_IMP
		redefine
			interface,
			minimum_width,
			minimum_height,
			make,
			is_height_resizable
		end

	EV_FONTABLE_IMP
		redefine
			interface,
			make
		end

	EV_HEADER_ACTION_SEQUENCES_IMP

create
	make

feature -- Initialization

	make
			-- Initialize `Current'
		do
			create scroll_view.make
			cocoa_view := scroll_view
			scroll_view.set_translates_autoresizing_mask_into_constraints_ (False)
			scroll_view.set_has_horizontal_scroller_ (False)
			scroll_view.set_has_vertical_scroller_ (False)

			initialize_item_list

			create table_view.make
			scroll_view.set_document_view_ (table_view)

			initialize_pixmaps

			Precursor {EV_PRIMITIVE_IMP}
			disable_tabable_from
			disable_tabable_to
			set_is_initialized (True)
		end

feature -- Access

	insert_item (item_imp: EV_HEADER_ITEM_IMP; an_index: INTEGER)
			-- Insert `item_imp' at `an_index'.
		do
			table_view.add_table_column_ (item_imp.table_column)
		end

	remove_item (item_imp: EV_HEADER_ITEM_IMP)
			-- Remove `item' from the list
		do
			table_view.remove_table_column_ (item_imp.table_column)
		end

feature -- Size

	minimum_width: INTEGER = 72

	minimum_height : INTEGER = 17

feature {NONE} -- Implementation

	pointed_divider_index: INTEGER
			-- Index of divider currently beneath the mouse pointer, or
			-- 0 if none.
		do
		end

	call_item_resize_actions
			-- Call the item resize end actions.
		do
		end

	pixmaps_size_changed
			-- The size of the displayed pixmaps has just
			-- changed.
		do
		end

	table_view: NS_TABLE_VIEW

	scroll_view: NS_SCROLL_VIEW

feature {EV_ANY_I} -- Implementation

	is_height_resizable: BOOLEAN
		do
			Result := False
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_HEADER note option: stable attribute end

end
