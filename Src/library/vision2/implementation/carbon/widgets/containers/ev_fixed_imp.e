
indexing
	description:
		"Eiffel Vision fixed. Carbon implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_FIXED_IMP

inherit
	EV_FIXED_I
		redefine
			interface
		end

	EV_WIDGET_LIST_IMP
		undefine
			propagate_background_color,
			propagate_foreground_color
		redefine
			interface,
			insert_i_th,
			initialize
		end

	CONTROLDEFINITIONS_FUNCTIONS_EXTERNAL
	HIVIEW_FUNCTIONS_EXTERNAL

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Create the fixed container.
		local
			control_ptr : POINTER
			rect : RECT_STRUCT
			res : INTEGER
		do
			base_make( an_interface )
			create rect.make_new_unshared
			rect.set_top ( 0 )
			rect.set_left ( 0 )
			rect.set_right ( 0 )
			rect.set_bottom ( 0 )
			res := create_user_pane_control_external ( default_pointer, rect.item, {CONTROLS_ANON_ENUMS}.kControlSupportsEmbedding, $control_ptr )

			set_c_object ( control_ptr )
		end

	initialize is
			-- Initialize `Current'.
		do
			Precursor
			event_id := app_implementation.get_id (current)
		end

feature -- Status setting

	set_item_position (a_widget: EV_WIDGET; an_x, a_y: INTEGER) is
			-- Set `a_widget.x_position' to `an_x'.
			-- Set `a_widget.y_position' to `a_y'.
		local
			w_imp : EV_WIDGET_IMP
			err : INTEGER
		do
			w_imp ?= a_widget.implementation
			check
				w_imp_not_void : w_imp /= Void
			end
			err := hiview_place_in_superview_at_external ( w_imp.c_object, an_x, a_y )
		end

	set_item_size (a_widget: EV_WIDGET; a_width, a_height: INTEGER) is
			-- Set `a_widget.width' to `a_width'.
			-- Set `a_widget.height' to `a_height'.
		local
			w_imp : EV_WIDGET_IMP
		do
			w_imp ?= a_widget.implementation
			check
				w_imp_not_void : w_imp /= Void
			end
			size_control_external( w_imp.c_object, a_width, a_height )
		end

feature -- Measurement

	minimum_width: INTEGER is
			-- Item edge with highest x value
		do
			from
				start
				Result := 0
			until
				off
			loop
				Result := Result.max ( item.x_position + item.width )
				forth
			end
		end

	minimum_height: INTEGER is
			-- Item edge with highest y value
		do
			from
				start
				Result := 0
			until
				off
			loop
				Result := Result.max ( item.y_position + item.height )
				forth
			end
		end

feature {EV_ANY_I} -- Implementation

	insert_i_th (v: like item; i: INTEGER) is
			-- Insert `v' at position `i'.
		do
			Precursor ( v, i )
			set_item_position ( v, 0, 0 )
			set_item_size ( v, v.minimum_width, v.minimum_height )
		end

	x_position_of_child (a_widget_imp: EV_WIDGET_IMP): INTEGER is
			-- X position of `a_widget_imp' within `Current'.
		local
			rect : CGRECT_STRUCT
			origin : CGPOINT_STRUCT
			err : INTEGER
		do
			create rect.make_new_unshared
			create origin.make_shared ( rect.origin )
			err := hiview_get_frame_external ( a_widget_imp.c_object, rect.item )
			Result := origin.x.rounded
		end

	y_position_of_child (a_widget_imp: EV_WIDGET_IMP): INTEGER is
			-- Y position of `a_widget_imp' within `Current'.
		local
			rect : CGRECT_STRUCT
			origin : CGPOINT_STRUCT
			err : INTEGER
		do
			create rect.make_new_unshared
			create origin.make_shared ( rect.origin )
			err := hiview_get_frame_external ( a_widget_imp.c_object, rect.item )
			Result := origin.y.rounded
		end

	interface: EV_FIXED;
			-- Provides a common user interface to platform dependent
			-- functionality implemented by `Current'

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




end -- class EV_FIXED

