note
	description:
		"A common class for Vision/Cocoa containers with one child without%N%
		%commitment to a Cocoa control."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_SINGLE_CHILD_CONTAINER_IMP

inherit
	EV_CONTAINER_IMP
		redefine
			enable_sensitive,
			disable_sensitive,
			propagate_foreground_color,
			propagate_background_color
		end

feature -- Access

	item: detachable EV_WIDGET
			-- The child of `Current'.

feature -- Status setting

	enable_sensitive
			-- Set `item' sensitive to user actions.
		do
			if attached item_imp as l_item_imp and then not l_item_imp.internal_non_sensitive then
				l_item_imp.enable_sensitive
			end
			Precursor {EV_CONTAINER_IMP}
		end

	disable_sensitive
			-- Set `item' insensitive to user actions.
		do
			if attached item_imp as l_item_imp then
				l_item_imp.disable_sensitive
			end
			Precursor {EV_CONTAINER_IMP}
		end

feature -- Element change

	remove
			-- Remove `item' from `Current' if present.
		local
			v_imp: detachable EV_WIDGET_IMP
		do
			if attached item as l_item then
				remove_item_actions.call ([l_item])
				v_imp ?= item_imp
				check
					v_imp_not_void: v_imp /= Void
				end
				item := Void
				v_imp.set_parent_imp (Void)
				v_imp.on_orphaned
				v_imp.attached_view.remove_from_superview
			end
		end

	insert (v: like item)
			-- Assign `v' to `item'.
		local
			v_imp: detachable EV_WIDGET_IMP
		do
			if attached v then
				check
					has_no_item: item = Void
				end
				v.implementation.on_parented
				v_imp ?= v.implementation
				check
					v_imp_not_void: v_imp /= Void
				end
				v_imp.set_parent_imp (current)
				item := v
				new_item_actions.call ([v])
				attached_view.add_subview_ (v_imp.attached_view)
				-- make the item stick to `attached_view'
				v_imp.set_padding_constraints (0)
			end
		end

	put, replace (v: like item)
			-- Replace `item' with `v'.
		do
			remove
			if v /= Void then
				insert (v)
			end
		end

feature -- Basic operations

	propagate_background_color
			-- Propagate the current background color of `Current'
			-- to the children.
		do
			if attached item as l_item then
				l_item.set_background_color (background_color)
				if attached {EV_CONTAINER} l_item as c then
					c.propagate_background_color
				end
			end
		end

	propagate_foreground_color
			-- Propagate the current foreground color of `Current'
			-- to the children.
		do
			if attached item as l_item then
				l_item.set_foreground_color (foreground_color)
				if attached {EV_CONTAINER} l_item as c then
					c.propagate_foreground_color
				end
			end
		end

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"
end -- class EV_SINGLE_CHILD_CONTAINER_IMP
