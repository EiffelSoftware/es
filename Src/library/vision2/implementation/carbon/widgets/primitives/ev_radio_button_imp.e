indexing
	description: "Eiffel Vision radio button. Carbon implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_RADIO_BUTTON_IMP

inherit
	EV_RADIO_BUTTON_I
		redefine
			interface
		end

	EV_BUTTON_IMP
		export
			{NONE}
				c_object
			{EV_CONTAINER_IMP}
				visual_widget
		undefine
			default_alignment
		redefine
			interface,
			make,
			initialize
		end

	EV_RADIO_PEER_IMP
		redefine
			interface,
			widget_object
		end

	CONTROLDEFINITIONS_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Create radio button.
		local
			ret: INTEGER
			rect: RECT_STRUCT
			ptr: POINTER
		do
			base_make (an_interface)
			create rect.make_new_unshared
			ret := create_radio_button_control_external ( null, rect.item, null, 0, 1, $ptr )
			set_c_object ( ptr )

			event_id := app_implementation.get_id (current)  --getting an id from the application
		end

	initialize is
			-- Initialize `Current'
		do
		end

feature -- Status report

	is_selected: BOOLEAN is
			-- Is toggle button pressed?
		do
		end

feature -- Status setting

	enable_select is
			-- Set `is_selected' `True'.
		do
		end

feature {EV_ANY_I} -- Implementation

	widget_object (a_list: POINTER): POINTER is
			-- Returns c_object relative to a_list data.
		do
		end

	radio_group: POINTER is
		do
		end

feature {EV_ANY_I} -- Implementation

	interface: EV_RADIO_BUTTON;

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end -- class EV_RADIO_BUTTON_IMP

