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

create
	make

feature -- initialization

	make (an_interface: like interface) is
			-- Connect interface and initialize `c_object'.
		local
			split_view : EV_CARBON_SPLIT_VIEW
			struct_ptr : POINTER
			err : INTEGER
		do
			base_make (an_interface)
			create split_view
			err := hiobject_create_external (split_view.get_split_view_class.item, default_pointer, $struct_ptr )

			event_id := app_implementation.get_id (current)  --getting an id from the application
			set_c_object (struct_ptr)
		end

feature {EV_ANY_I} -- Implementation

	interface: EV_VERTICAL_SPLIT_AREA;
			-- Provides a common user interface to possibly dependent
			-- functionality implemented by `Current'.

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end -- class EV_VERTICAL_SPLIT_AREA_IMP

