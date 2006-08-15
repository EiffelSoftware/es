indexing
	description: "EiffelVision2 toolbar, implementation interface."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_TOOL_BAR_IMP

inherit
	EV_TOOL_BAR_I
		redefine
			interface
		end

	EV_PRIMITIVE_IMP
		redefine
			interface,
			initialize,
			needs_event_box,
			set_parent_imp
		end

	EV_ITEM_LIST_IMP [EV_TOOL_BAR_ITEM]
		undefine
			item_by_data
		redefine
			interface,
			insert_i_th,
			initialize
		end

create
	make

feature {NONE} -- Implementation

	needs_event_box: BOOLEAN is False

	remove_i_th (i: INTEGER) is
			-- Remove item at `i'-th position.
		do
		end

	make (an_interface: like interface) is
			-- Create the tool-bar.
		do
			base_make (an_interface)
		end

	initialize is
			-- Initialize `Current'.
		do
			Precursor {EV_ITEM_LIST_IMP}
			Precursor {EV_PRIMITIVE_IMP}
			has_vertical_button_style := True
		end

	list_widget: POINTER is
			--
		do
		end

	set_parent_imp (a_container_imp: EV_CONTAINER_IMP) is
			-- Set `parent_imp' to `a_container_imp'.
		do
		end

feature -- Status report

	has_vertical_button_style: BOOLEAN
			-- Is the `pixmap' displayed vertically above `text' for
			-- all buttons contained in `Current'? If `False', then
			-- the `pixmap' is displayed to left of `text'.

	is_vertical: BOOLEAN
			-- Are the buttons in `Current' arranged vertically?

feature -- Status setting

	enable_vertical_button_style is
			-- Ensure `has_vertical_button_style' is `True'.
		do
		end

	disable_vertical_button_style is
			-- Ensure `has_vertical_button_style' is `False'.
		do
		end

	enable_vertical is
			-- Enable vertical toolbar style.
		do
		end

	disable_vertical is
			-- Disable vertical toolbar style (ie: Horizontal).
		do
		end

feature {EV_DOCKABLE_SOURCE_I} -- Implementation

	block_selection_for_docking is
			--
		do
		end

feature -- Implementation

	update_toolbar_style is
			-- Set the style of `Current' relative to items
		do
		end

	insertion_position: INTEGER is
			-- `Result' is index - 1 of item beneath the
			-- current mouse pointer or count + 1 if over the toolbar
			-- and not over a button.
		do
		end

	insert_i_th (v: like item; i: INTEGER) is
			-- Insert `v' at position `i'.
		do
		end

	add_radio_button (w: like item) is
			-- Connect radio button to tool bar group.
		require
			w_not_void: w /= Void
		do
		end

feature {EV_TOOL_BAR_RADIO_BUTTON_IMP} -- Implementation

	radio_group: POINTER
		-- GSList containing the radio peers held within `Current'

feature {EV_ANY_I} -- Implementation

	interface: EV_TOOL_BAR;

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




end -- class EV_TOOL_BAR_IMP

