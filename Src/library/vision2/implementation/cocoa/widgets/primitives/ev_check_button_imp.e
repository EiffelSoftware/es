note
	description: "EiffelVision check button. Cocoa implementation."
	author:	"Daniel Furrer, Emanuele Rudel"
	id: "$Id$";
	date: "$Date$";
	revision: "$Revision$"

class
	EV_CHECK_BUTTON_IMP

inherit
	EV_CHECK_BUTTON_I
		redefine
			interface
		end

	EV_TOGGLE_BUTTON_IMP
		undefine
			default_alignment
		redefine
			make,
			interface
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize 'Current'
		do
			Precursor {EV_TOGGLE_BUTTON_IMP}
				-- NSRoundedBezelStyle = 1
			set_bezel_style_ (1)
				-- NSSwitchButton = 3
			set_button_type_ (3)

			align_text_left
		end

feature {EV_ANY, EV_ANY_I}

	interface: detachable EV_CHECK_BUTTON note option: stable attribute end;

end -- class EV_CHECK_BUTTON_IMP
