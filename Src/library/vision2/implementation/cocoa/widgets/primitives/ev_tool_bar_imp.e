note
	description: "EiffelVision2 toolbar, Cocoa implementation."
	author: "Daniel Furrer"
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
		undefine
			update_for_pick_and_drop
		redefine
			interface,
			make,
			set_parent_imp
		end

	EV_ITEM_LIST_IMP [EV_TOOL_BAR_ITEM, EV_ITEM_IMP]
		undefine
			item_by_data
		redefine
			interface,
			make
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
			initialize_item_list
			create radio_group.make
			create tool_bar.make
			tool_bar.set_translates_autoresizing_mask_into_constraints_ (False)
			cocoa_view := tool_bar

			Precursor {EV_PRIMITIVE_IMP}
			disable_tabable_from
			has_vertical_button_style := True

			new_item_actions.extend (agent add_radio_button)
			remove_item_actions.extend (agent remove_radio_button)
		end

	set_parent_imp (a_container_imp: EV_CONTAINER_IMP)
			-- Set `parent_imp' to `a_container_imp'.
		do
			parent_imp := a_container_imp
		end

feature -- Status report

	has_vertical_button_style: BOOLEAN
			-- Is the `pixmap' displayed vertically above `text' for
			-- all buttons contained in `Current'? If `False', then
			-- the `pixmap' is displayed to left of `text'.

	is_vertical: BOOLEAN
			-- Are the buttons in `Current' arranged vertically?

feature -- Status setting

	enable_vertical_button_style
			-- Ensure `has_vertical_button_style' is `True'.
		do
			has_vertical_button_style := True
		end

	disable_vertical_button_style
			-- Ensure `has_vertical_button_style' is `False'.
		do
			has_vertical_button_style := False
		end

	enable_vertical
			-- Enable vertical toolbar style.
		do
			is_vertical := True
		end

	disable_vertical
			-- Disable vertical toolbar style (ie: Horizontal).
		do
			is_vertical := False
		end

feature -- Access

	insert_item (v: EV_ITEM_IMP; i: INTEGER_32)
		local
			l_view: detachable NS_VIEW
			l_ev_view: detachable EV_NS_VIEW
		do
			l_view ?= v.cocoa_view
			check l_view /= void end
			l_ev_view ?= v
			check l_ev_view /= Void end
			tool_bar.add_subview_ (l_view)

			l_ev_view.set_top_padding (0)
			l_ev_view.set_bottom_padding (0)

			if i - 1 >= 1 then
				check attached {EV_NS_VIEW} i_th (i-1).implementation as l_prev then
					attached_view.remove_constraint_ (l_prev.right_constraint)
					-- If one of the widgets is a separator, leave 4 pixels of padding
					if attached {EV_TOOL_BAR_SEPARATOR_IMP} v or attached {EV_TOOL_BAR_SEPARATOR_IMP} l_prev then
						set_horizontal_padding_constraints (l_prev.cocoa_view, v.cocoa_view, 4)
					else
						set_horizontal_padding_constraints (l_prev.cocoa_view, v.cocoa_view, 0)
					end
				end
			end
			if i + 1 <= count then
				check attached {EV_NS_VIEW} i_th (i+1).implementation as l_next then
					attached_view.remove_constraint_ (l_next.left_constraint)
					set_horizontal_padding_constraints (v.cocoa_view, l_next.cocoa_view, 0)
				end

			end

			if i = 1 then
				l_ev_view.set_left_padding (0)
			end
			if i = count then
				set_minimum_right_padding_constraint (l_ev_view, 2)
			end
		end

	remove_item (button: EV_ITEM_IMP)
			-- Remove `button' from `current'.
		do
			-- TODO remove
		end

feature {EV_DOCKABLE_SOURCE_I} -- Implementation (obsolete?)

	block_selection_for_docking
			--
		do
		end

	insertion_position: INTEGER
			-- `Result' is index - 1 of item beneath the
			-- current mouse pointer or count + 1 if over the toolbar
			-- and not over a button.
		do
		end


feature {EV_TOOL_BAR_IMP} -- Implementation
	-- TODO: is this the same for all radio-containers? (menu, toolbar, widget container)
	-- if so, share the code.

	radio_group: LINKED_LIST [EV_TOOL_BAR_RADIO_BUTTON_IMP]
			-- Radio items in `Current'.
			-- `Current' shares reference with merged containers.

	is_merged (other: EV_TOOL_BAR): BOOLEAN
			-- Is `Current' merged with `other'?
		require
			other_not_void: other /= Void
		local
			t_imp: detachable EV_TOOL_BAR_IMP
		do
			t_imp ?= other.implementation
			check t_imp /= Void end
			Result := t_imp.radio_group = radio_group
		end

	set_radio_group (rg: like radio_group)
			-- Set `radio_group' by reference. (Merge)
		do
			radio_group := rg
		end

	add_radio_button (w: EV_ITEM)
			-- Called when `w' has been added to `Current'.
		require
			w_not_void: w /= Void
			w_correct_type: (({EV_TOOL_BAR_ITEM}) #? w) /= Void
		local
			r: detachable EV_TOOL_BAR_RADIO_BUTTON_IMP
		do
			r ?= w.implementation
			if r /= Void then
				if not radio_group.is_empty then
					r.disable_select
				end
				r.set_radio_group (radio_group)
			end
		end

	add_button (w: EV_ITEM)
			-- Called when `w' has been added to `Current'.
		require
			w_not_void: w /= Void
			w_correct_type: (({EV_TOOL_BAR_ITEM}) #? w) /= Void
		local
			button_imp: detachable EV_TOOL_BAR_BUTTON_IMP -- was: EV_TOOL_BAR_ITEM_IMP
		do
			button_imp ?= w.implementation
			check
				implementation_not_void: button_imp /= Void
			end
			if not button_imp.is_sensitive then
				--disable_button (button_imp.id)
			end
		end

	remove_radio_button (w: EV_ITEM)
			-- Called when `w' has been removed from `Current'.
		require
			w_not_void: w /= Void
			w_correct_type: (({EV_TOOL_BAR_ITEM}) #? w) /= Void
		local
			r: detachable EV_TOOL_BAR_RADIO_BUTTON_IMP
		do
			r ?= w.implementation
			if r /= Void then
				r.remove_from_radio_group
				r.enable_select
			end
		end

feature {EV_ANY_I} -- Interface

	tool_bar: EV_FLIPPED_VIEW

feature {EV_ANY, EV_ANY_I} -- Interface

	interface: detachable EV_TOOL_BAR note option: stable attribute end;

end -- class EV_TOOL_BAR_IMP
