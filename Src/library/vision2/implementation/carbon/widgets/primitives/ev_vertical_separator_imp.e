indexing
	description:
		"EiffelVision vertical separator, Carbon implementation"
	legal: "See notice at end of class.";
	status: "See notice at end of class."
	date: "$Date$";
	revision: "$Revision$"

class
	EV_VERTICAL_SEPARATOR_IMP

inherit
	EV_VERTICAL_SEPARATOR_I
		redefine
			interface
		end

	EV_SEPARATOR_IMP
		redefine
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
				-- Create a horizontal carbon separator.
		local
			ret: INTEGER
			rect: RECT_STRUCT
			ptr: POINTER
		do
			base_make (an_interface)
			create rect.make_new_unshared
			ret := create_separator_control_external ( null, rect.item, $ptr )
			set_c_object ( ptr )
		end

feature {EV_ANY_I} -- Implementation

	interface: EV_VERTICAL_SEPARATOR;

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"

end -- class EV_VERTICAL_SEPARATOR_IMP

