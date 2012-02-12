note
	description: "Eiffel Vision fixed. Cocoa implementation."
	author: "Daniel Furrer, Emanuele Rudel"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_FIXED_IMP

inherit
	EV_FIXED_I
		redefine
			interface
		end

	EV_WIDGET_LIST_IMP
		undefine
			propagate_background_color,
			propagate_foreground_color
		redefine
			interface,
			make,
			set_background_color
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
			create {EV_FLIPPED_VIEW}cocoa_view.make
			cocoa_view.set_translates_autoresizing_mask_into_constraints_ (False)
			Precursor {EV_WIDGET_LIST_IMP}
		end

feature -- Status setting

	set_item_position (a_widget: EV_WIDGET; a_x, a_y: INTEGER)
			-- Set `a_widget.x_position' to `a_x'.
			-- Set `a_widget.y_position' to `a_y'.
		do
			check attached {EV_WIDGET_IMP} a_widget.implementation as w_imp then
--				set_position_constraints (w_imp, a_x, a_y)
				-- Using constraints the grid is not drawn correctly
				w_imp.cocoa_move (a_x, a_y)
			end

		end

	set_item_size (a_widget: EV_WIDGET; a_width, a_height: INTEGER)
			-- Set `a_widget.width' to `a_width'.
			-- Set `a_widget.height' to `a_height'.
		do
			a_widget.set_minimum_size (a_width, a_height)
		end

feature -- Element change

	set_background_color (a_color: EV_COLOR)
		do
			Precursor {EV_WIDGET_LIST_IMP} (a_color)
			check attached {EV_FLIPPED_VIEW} attached_view as l_view then
				l_view.set_cocoa_background_color (a_color)
			end
		end

feature -- Implementation

	interface: detachable EV_FIXED note option: stable attribute end;
			-- Provides a common user interface to platform dependent
			-- functionality implemented by `Current'

end -- class EV_FIXED
