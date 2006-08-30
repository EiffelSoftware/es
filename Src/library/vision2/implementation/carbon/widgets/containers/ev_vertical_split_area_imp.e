indexing
	description:
		"Eiffel Vision Split Area, Carbon implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_VERTICAL_SPLIT_AREA_IMP

inherit
	EV_VERTICAL_SPLIT_AREA_I
		undefine
			propagate_foreground_color,
			propagate_background_color
		redefine
			interface
		end

	EV_SPLIT_AREA_IMP
		redefine
			interface
		end

	HIOBJECT_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end

	CONTROLDEFINITIONS_FUNCTIONS_EXTERNAL

create
	make

feature -- initialization

	make (an_interface: like interface) is
			-- Connect interface and initialize `c_object'.
		local
			control_ptr : POINTER
			rect : RECT_STRUCT
			err : INTEGER
		do
			base_make( an_interface )
			create rect.make_new_unshared
			rect.set_top ( 0)
			rect.set_left ( 0 )
			rect.set_right ( 0 )
			rect.set_bottom ( 0 )
			err := create_user_pane_control_external ( null, rect.item, {CONTROLS_ANON_ENUMS}.kControlSupportsEmbedding, $control_ptr )

			event_id := app_implementation.get_id (current)  --getting an id from the application
			set_c_object (control_ptr)
		end

feature {EV_ANY_I} -- Implementation

	interface: EV_VERTICAL_SPLIT_AREA;
			-- Provides a common user interface to possibly dependent
			-- functionality implemented by `Current'.

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end -- class EV_VERTICAL_SPLIT_AREA_IMP

