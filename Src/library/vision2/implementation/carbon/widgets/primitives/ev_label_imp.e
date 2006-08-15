indexing

	description:
		"EiffelVision label, gtk implementation."
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
			interface,
			needs_event_box
		end

	EV_TEXTABLE_IMP
		redefine
			interface,
			set_text
		end

	EV_FONTABLE_IMP
		redefine
			interface
		end
	CONTROLDEFINITIONS_FUNCTIONS_EXTERNAL
	CARBONEVENTS_FUNCTIONS_EXTERNAL

create
	make

feature {NONE} -- Initialization

	needs_event_box: BOOLEAN is True

	make (an_interface: like interface) is
			-- Connect interface and initialize `c_object'.
		local
			err : INTEGER
			rect : RECT_STRUCT
			struct_ptr : POINTER
			target: POINTER
			c_str: C_STRING
			ptr: POINTER
			res: INTEGER
		do
			base_make (an_interface)
			create rect.make_new_unshared
			rect.set_left(60)
			rect.set_right(150)
			rect.set_bottom(90)
			rect.set_top (60)

			err := create_static_text_control_external( null, rect.item, null,null,$struct_ptr )

			set_c_object ( struct_ptr )
			id:=app_implementation.get_id (current)  --getting an id from the application

			textable_imp_initialize
		end

		set_text (a_text: STRING_GENERAL) is
			-- Assign `a_text' to `text'.
		local
			c_str: C_STRING
			ptr: POINTER
			res: INTEGER
		do
			Precursor {EV_TEXTABLE_IMP} (a_text)
			create c_str.make (a_text)
			res := set_control_data_external(c_object, {controls_anon_enums}.kControlEntireControl , {CONTROLDEFINITIONS_ANON_ENUMS}.kControlStaticTextTextTag, c_str.bytes_count ,c_str.item)
			show
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
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end --class LABEL_IMP

