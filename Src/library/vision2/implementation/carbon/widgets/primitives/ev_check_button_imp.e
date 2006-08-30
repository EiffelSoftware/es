indexing
	description: "EiffelVision check button, Carbon implementation."
	legal: "See notice at end of class.";
	status: "See notice at end of class.";
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
			set_text,
			interface,
			initialize
		end

	CONTROLDEFINITIONS_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Create a gtk check button.
		local
			ret: INTEGER
			rect: RECT_STRUCT
			ptr: POINTER
		do
			base_make (an_interface)
			create rect.make_new_unshared
			ret := create_check_box_control_external ( null, rect.item, null, 0, 1, $ptr )
			set_c_object ( ptr )

			event_id := app_implementation.get_id (current)
		end

	initialize is
			-- Initialize 'Current'
		do
			Precursor {EV_TOGGLE_BUTTON_IMP}
			align_text_left
		end

feature -- Element change

	set_text (txt: STRING_GENERAL) is
			-- Set current button text to `txt'.
			-- Redefined because we want the text to be left-aligned.
		do
			precursor {EV_TOGGLE_BUTTON_IMP}(txt)
		end

feature {EV_ANY_I}

	interface: EV_CHECK_BUTTON;

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end -- class EV_CHECK_BUTTON_IMP

