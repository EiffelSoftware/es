note
	description: "EiffelVision Split Area. Cocoa implementation."
	author: "Daniel Furrer"
	id: "$Id$"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_SPLIT_AREA_IMP

inherit
	EV_SPLIT_AREA_I
		undefine
			propagate_foreground_color,
			propagate_background_color
		redefine
			interface
		end

	EV_CONTAINER_IMP
		redefine
			interface,
			make
		end

feature -- Access

	make
		do
			initialize
			first_expandable := True
			second_expandable := True
		end

	set_first (v: attached like item)
			-- Make `an_item' `first'.
		local
			l_imp: detachable EV_WIDGET_IMP
		do
			l_imp ?= v.implementation
			check l_imp_not_void: l_imp /= Void end
			first := v
			l_imp.set_parent_imp (Current)
			disable_item_expand (v)

			if split_view.subviews.count > 0 then
				check attached {NS_VIEW} split_view.subviews.object_at_index_ (0) as l_old_view then
					split_view.replace_subview__with_ (l_old_view, l_imp.attached_view)
				end
			else
				split_view.add_subview_ (l_imp.attached_view)
			end
			l_imp.set_padding_constraints (0)

			if second_visible then
				set_split_position (minimum_split_position)
			else
				set_split_position (maximum_split_position)
			end
			new_item_actions.call ([v])
		end

	set_second (v: attached like item)
			-- Make `an_item' `second'.
		local
			l_imp: detachable EV_WIDGET_IMP
		do
			v.implementation.on_parented
			l_imp ?= v.implementation
			check l_imp_not_void: l_imp /= Void end
			l_imp.set_parent_imp (Current)
			second := v

			if split_view.subviews.count > 1 then
				check attached {NS_VIEW} split_view.subviews.object_at_index_ (1) as l_old_view then
					split_view.replace_subview__with_ (l_old_view, l_imp.attached_view)
				end
			else
				split_view.add_subview_ (l_imp.attached_view)
			end
			l_imp.set_padding_constraints (0)

			new_item_actions.call ([v])
		end

	prune (an_item: like item)
			-- Remove `an_item' if present from `Current'.
		local
			an_item_imp: detachable EV_WIDGET_IMP
		do
			if has (an_item) and then an_item /= Void then
				an_item_imp ?= an_item.implementation
				check an_item_imp_not_void: an_item_imp /= Void end
				an_item_imp.set_parent_imp (Void)
				if an_item = first then
					first_expandable := False
					first := Void
					set_split_position (0)
					if second /= Void then
						set_item_resize (second, True)
					end
				else
					second := Void
					second_expandable := True
					if first /= Void then
						set_item_resize (first, True)
					end
				end
				an_item_imp.attached_view.remove_from_superview
			end
		end

	enable_item_expand (an_item: attached like item)
			-- Let `an_item' expand when `Current' is resized.
		do
			set_item_resize (an_item, True)
		end

	disable_item_expand (an_item: attached like item)
			-- Make `an_item' non-expandable on `Current' resize.
		do
			set_item_resize (an_item, False)
		end

	split_position: INTEGER
			-- Position from the left/top of the splitter from `Current'.
		do
			--Result := internal_split_position
			Result := internal_split_position.max (minimum_split_position).min (maximum_split_position) -- enforce invariant
		end

	set_split_position (a_split_position: INTEGER)
			-- Set the position of the splitter.
		do
			internal_split_position := a_split_position
		ensure then
			split_position_set: split_position = a_split_position
		end

feature -- Widget relationships

	top_level_window_imp: detachable EV_WINDOW_IMP
			-- Top level window that contains `Current'.

	set_top_level_window_imp (a_window: detachable EV_WINDOW_IMP)
			-- Make `a_window' the new `top_level_window_imp'
			-- of `Current'.
		local
			widget_imp: detachable EV_WIDGET_IMP
		do
			top_level_window_imp := a_window
			if attached first as l_first then
				widget_imp ?= l_first.implementation
				check
					widget_implementation_not_void: widget_imp /= Void
				end
				widget_imp.set_top_level_window_imp (a_window)
			end
			if attached second as l_second then
				widget_imp ?= l_second.implementation
				check
					widget_implementation_not_void: widget_imp /= Void
				end
				widget_imp.set_top_level_window_imp (a_window)
			end
		end

feature {NONE} -- Implementation

	first_imp: detachable EV_WIDGET_IMP
			-- `Result' is implementation of first.
		do
			if attached first as l_first then
				Result ?= l_first.implementation
				check
					implementation_of_first_not_void: Result /= Void
				end
			end
		end

	second_imp: detachable EV_WIDGET_IMP
			-- `Result' is implementation of second.
		do
			if attached second as l_second then
				Result ?= l_second.implementation
				check
					implementation_of_second_not_void: Result /= Void
				end
			end
		end

	splitter_width: INTEGER
		do
			Result := split_view.divider_thickness.truncated_to_integer
		end

	internal_split_position: INTEGER
		-- Position of the splitter in pixels.
		-- For a vertical split area, the position is the top of the splitter.
		-- For a horizontal split area, the position is the left
		-- of the splitter.

	set_item_resize (an_item: like item; a_resizable: BOOLEAN)
			-- Set whether `an_item' is `a_resizable' when `Current' resizes.
		do
			if an_item = first then
				first_expandable := a_resizable
			else
				second_expandable := a_resizable
			end
		end

feature {EV_ANY_I} -- Implementation

	split_view: NS_SPLIT_VIEW

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_SPLIT_AREA note option: stable attribute end;

end -- class EV_SPLIT_AREA_IMP
