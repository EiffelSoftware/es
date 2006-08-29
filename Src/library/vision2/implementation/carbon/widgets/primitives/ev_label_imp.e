indexing

	description:
		"EiffelVision label, Carbon implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	id: "$Id$"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_LABEL_IMP

inherit
	EV_LABEL_I
		redefine
			interface
		end

	EV_PRIMITIVE_IMP
		redefine
			interface
		end

	EV_TEXTABLE_IMP
		redefine
			interface
		end

	EV_FONTABLE_IMP
		redefine
			interface
		end

	CONTROLDEFINITIONS_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end

	CARBONEVENTS_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Connect interface and initialize `c_object'.
		local
			ret: INTEGER
			rect: RECT_STRUCT
			ptr: POINTER
		do
			base_make (an_interface)
			create rect.make_new_unshared
			rect.set_left(60)
			rect.set_right(150)
			rect.set_bottom(90)
			rect.set_top (60)

			ret := create_static_text_control_external( null, rect.item, null, null, $ptr )
			set_c_object ( ptr )

			event_id := app_implementation.get_id (current)
		end

feature -- Access

	angle: REAL
		-- Amount text is rotated counter-clockwise from horizontal plane in radians.

	set_angle (a_angle: REAL) is
			--
		do
			angle := a_angle
		end

feature {EV_ANY_I} -- Implementation

	interface: EV_LABEL;

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end --class LABEL_IMP

