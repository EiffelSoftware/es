indexing
	description: "Eiffel Vision vertical range. Carbon implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_VERTICAL_RANGE_IMP

inherit
	EV_VERTICAL_RANGE_I
		redefine
			interface
		end

	EV_RANGE_IMP
		redefine
			interface,
			make
		end

	CONTROLDEFINITIONS_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
				-- Create a horizontal carbon range
		local
			ret: INTEGER
			rect: RECT_STRUCT
			ptr: POINTER
		do
			base_make (an_interface)
			create rect.make_new_unshared
			ret := create_slider_control_external ( null, rect.item, 0, 0, 100, {CONTROLDEFINITIONS_ANON_ENUMS}.kControlSliderPointsDownOrRight, 10, 0, null, $ptr )
			set_c_object ( ptr )
		end


feature {EV_ANY_I} -- Implementation

	interface: EV_VERTICAL_RANGE;

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end -- class EV_HORIZONTAL_RANGE_IMP

