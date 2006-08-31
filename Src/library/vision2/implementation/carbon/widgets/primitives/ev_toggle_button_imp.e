indexing
	description: "EiffelVision toggle button, Carbon implementation."
	legal: "See notice at end of class.";
	status: "See notice at end of class.";
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
			interface
		end

	CONTROLDEFINITIONS_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Create a Carbon toggle button.
		local
			ret: INTEGER
			rect: RECT_STRUCT
			ptr: POINTER
		do
			base_make (an_interface)
			create rect.make_new_unshared
			rect.set_bottom (20)
			rect.set_right (100)
			ret := create_bevel_button_control_external ( null, rect.item,
				null, -- text
				{CONTROLDEFINITIONS_ANON_ENUMS}.kControlBevelButtonNormalBevel, -- size/thickness
				{CONTROLDEFINITIONS_ANON_ENUMS}.kControlBehaviorToggles, -- the behaviour: we want a toggle-button
				null, 0, 0, 0, $ptr )
			set_c_object ( ptr )

			event_id := app_implementation.get_id (current)
		end

feature -- Status setting

	enable_select is
			-- Set `is_selected' `True'.
		do
		end

	disable_select is
				-- Set `is_selected' `False'.
		do
		end

feature -- Status report

	is_selected: BOOLEAN is
			-- Is toggle button pressed?
		do
		end

feature {EV_ANY_I}

	interface: EV_TOGGLE_BUTTON;

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end -- class EV_TOGGLE_BUTTON_IMP

