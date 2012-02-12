note
	description: "EiffelVision toggle button, Cocoa implementation."
	author: "Daniel Furrer"
	id: "$Id$";
	date: "$Date$";
	revision: "$Revision$"

class
	EV_TOGGLE_BUTTON_IMP

inherit
	EV_TOGGLE_BUTTON_I
		redefine
			interface
		end

	EV_BUTTON_IMP
		redefine
			make,
			interface,
			set_pixmap,
			remove_pixmap
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor {EV_BUTTON_IMP}
				-- NSRoundedBezelStyle = 1
			set_bezel_style_ (1)
				-- NSPushOnPushOffButton = 1
			set_button_type_ (1)
			align_text_left
			set_is_initialized (True)
		end

feature -- Status setting

	enable_select
			-- Set `is_selected' `True'.
		do
				-- NSOnState = 1
			set_state_ (1)
		end

	disable_select
				-- Set `is_selected' `False'.
		do
				-- NSOffState = 0
			set_state_ (0)
		end

feature -- Status report

	is_selected: BOOLEAN
			-- Is toggle button pressed?
		do
				-- NSOnState = 1
			Result := (state = 1)
		end

feature -- Element change

	set_pixmap (a_pixmap: EV_PIXMAP)

			-- Display image of `a_pixmap' on `Current'.
			-- Image of `pixmap' will be a copy of `a_pixmap'.
			-- Image may be scaled in some descendents, i.e EV_TREE_ITEM
			-- See EV_TREE.set_pixmaps_size.

		do
			-- Then move the text to the right
			align_text_right

		end

	remove_pixmap
			-- Remove image displayed on `Current'.
		do
			-- Then put the text into the center
			align_text_center
		end


feature {EV_ANY, EV_ANY_I}

	interface: detachable EV_TOGGLE_BUTTON note option: stable attribute end;

end -- class EV_TOGGLE_BUTTON_IMP
