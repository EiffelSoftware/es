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
			on_removed_item,
			initialize
		end

	CONTROLDEFINITIONS_FUNCTIONS_EXTERNAL

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
			rect.set_top ( 50 )
			rect.set_left ( 50 )
			rect.set_right ( 2000)
			rect.set_bottom (2000)
			res := create_user_pane_control_external ( null, rect.item, {CONTROLS_ANON_ENUMS}.kControlSupportsEmbedding, $control_ptr )

			set_c_object ( control_ptr )
			id:=app_implementation.get_id (current)  --getting an id from the application
		end

	initialize is
			-- Initialize `Current'.
		do

			Precursor
		end

feature -- Status setting




	set_item_position (a_widget: EV_WIDGET; an_x, a_y: INTEGER) is
			-- Set `a_widget.x_position' to `an_x'.
			-- Set `a_widget.y_position' to `a_y'.
		local
			w_imp : EV_WIDGET_IMP
		do
			w_imp ?= a_widget.implementation
			check
				w_imp_not_void : w_imp /= Void
			end
			move_control_external( w_imp.c_object , an_x, a_y )
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

feature {EV_ANY_I} -- Implementation

	on_removed_item (a_widget_imp: EV_WIDGET_IMP) is
			-- Reset minimum size.
		do
		end

	x_position_of_child (a_widget_imp: EV_WIDGET_IMP): INTEGER is
			-- X position of `a_widget_imp' within `Current'.
		local
			rect : RECT_STRUCT
			dummy : POINTER
		do
			create rect.make_new_unshared
			dummy := get_control_bounds_external ( a_widget_imp.c_object, rect.item )
			Result := rect.get_left
		end

	y_position_of_child (a_widget_imp: EV_WIDGET_IMP): INTEGER is
			-- Y position of `a_widget_imp' within `Current'.
		local
			rect : RECT_STRUCT
			dummy : POINTER
		do
			create rect.make_new_unshared
			dummy := get_control_bounds_external ( a_widget_imp.c_object, rect.item )
			Result := rect.get_top
		end

	i_th_fixed_child (i: INTEGER): POINTER is
			-- `i-th' fixed child of `Current'.
		do
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

