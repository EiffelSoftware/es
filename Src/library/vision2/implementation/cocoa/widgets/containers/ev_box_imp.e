note
	description: "EiffelVision box. Cocoa implementation."
	author: "Daniel Furrer"
	id: "$Id$"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_BOX_IMP

inherit
	EV_BOX_I
		undefine
			propagate_foreground_color,
			propagate_background_color
		redefine
			interface
		end

	EV_WIDGET_LIST_IMP
		redefine
			interface,
			set_background_color,
			make,
			dispose
		end

	EV_FLIPPED_VIEW
		rename
			item as cocoa_item
		undefine
			copy,
			is_equal
		redefine
			make,
			dispose,
			view_did_move_to_superview
		end

feature -- Initialization

	make
			-- Initialize `Current'
		do
			cocoa_view := Current
			add_objc_callback ("viewDidMoveToSuperview", agent view_did_move_to_superview)
			Precursor {EV_FLIPPED_VIEW}
			set_translates_autoresizing_mask_into_constraints_ (False)
			Precursor {EV_WIDGET_LIST_IMP}

			is_homogeneous := Default_homogeneous
			padding := Default_spacing
			border_width := Default_border_width

			set_is_initialized (True)
		end

feature {EV_ANY, EV_ANY_I} -- expandable

	is_item_expanded (child: EV_WIDGET): BOOLEAN
			-- Is the `child' expandable. ie: does it
			-- allow the parent to resize or move it.
		do
			if attached {EV_WIDGET_IMP} child.implementation as w then
				Result := w.is_expandable
			end
		end

	set_child_expandable (child: EV_WIDGET; flag: BOOLEAN)
			-- Make `child' expandable if `flag',
			-- not expandable otherwise.
		do
			if attached {EV_WIDGET_IMP} child.implementation as w then
				w.set_expandable (flag)
			end
		end

feature -- Access

	is_homogeneous: BOOLEAN
			-- Are all children restricted to be the same size?

	border_width: INTEGER
			-- Width of border around container in pixels.

	padding: INTEGER
			-- Space between children in pixels.	

feature {EV_ANY, EV_ANY_I} -- Status settings

	set_homogeneous (flag: BOOLEAN)
			-- Set whether every child is the same size.
		do
			is_homogeneous := flag
		end

	set_border_width (value: INTEGER)
			 -- Assign `value' to `border_width'.
		do
			border_width := value
			if attached superview as l_superview then
--				set_padding_constraints (border_width)
			end
		end

	view_did_move_to_superview
		do
			if attached superview as l_superview then
				-- Warning: we cannot assume there is just `Current' in the
				-- superview.
--				set_padding_constraints (border_width)
			end
		end

feature -- Dispose

	dispose
		do
			Precursor {EV_FLIPPED_VIEW}
			Precursor {EV_WIDGET_LIST_IMP}
		end

feature -- Color

	set_background_color (a_color: EV_COLOR)
			-- Assign `a_color' to `background_color'
		do
			Precursor {EV_WIDGET_LIST_IMP} (a_color)
			set_cocoa_background_color (a_color)
		end

feature {EV_ANY_I, EV_ANY} -- Implementation

	interface: detachable EV_BOX note option: stable attribute end;
			-- Provides a common user interface to platform dependent
			-- functionality implemented by `Current'

end -- class EV_BOX_IMP
