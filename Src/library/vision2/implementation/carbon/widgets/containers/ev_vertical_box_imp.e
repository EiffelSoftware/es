indexing
	description:
		"EiffelVision vertical box. Carbon implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "container, box, vertical"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_VERTICAL_BOX_IMP

inherit
	EV_VERTICAL_BOX_I
		undefine
			propagate_foreground_color,
			propagate_background_color
		redefine
			interface
		end

	EV_BOX_IMP
		redefine
			interface,
			make
		end
	CONTROLDEFINITIONS_FUNCTIONS_EXTERNAL

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Create a vertical box.
		local
			control_ptr : POINTER
			rect : RECT_STRUCT
			res : INTEGER
			a_null:POINTER
		do
			base_make( an_interface )
			create rect.make_new_unshared
			rect.set_top ( 50 )
			rect.set_left ( 50 )
			rect.set_right ( 240 )
			rect.set_bottom ( 240 )
			res := create_user_pane_control_external ( a_null, rect.item, {CONTROLS_ANON_ENUMS}.kControlSupportsEmbedding, $control_ptr )

			set_c_object ( control_ptr )
			id:=app_implementation.get_id (current)  --getting an id from the application
		end


feature {EV_ANY_I} -- Implementation

    interface: EV_VERTICAL_BOX;

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




end -- class EV_VERTICAL_BOX_IMP

