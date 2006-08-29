indexing
	description:
		"Eiffel Vision Split Area, Carbon implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_HORIZONTAL_SPLIT_AREA_IMP

inherit
	EV_HORIZONTAL_SPLIT_AREA_I
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
			struct_ptr : POINTER
			err : INTEGER
		do
			base_make (an_interface)

			event_id := app_implementation.get_id (current)  --getting an id from the application
			set_c_object (struct_ptr)
		end


feature {EV_ANY_I} -- Implementation

	interface: EV_HORIZONTAL_SPLIT_AREA;
			-- Provides a common user interface to possibly dependent
			-- functionality implemented by `Current'.

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end -- class EV_HORIZONTAL_SPLIT_AREA_IMP

