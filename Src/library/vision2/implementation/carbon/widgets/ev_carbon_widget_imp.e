indexing
	description: "Objects that ..."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_CARBON_WIDGET_IMP

inherit
	EV_ANY_IMP
	HIVIEW_FUNCTIONS_EXTERNAL

feature {EV_GTK_DEPENDENT_INTERMEDIARY_ROUTINES} -- Implementation

	on_key_event (a_key: EV_KEY; a_key_string: STRING_32; a_key_press: BOOLEAN) is
			-- Used for key event actions sequences, redefined by descendants
		do
		end

feature {EV_INTERMEDIARY_ROUTINES} -- Implementation

	is_parentable: BOOLEAN is
			-- May Current be parented?
		do
		end

feature {NONE} -- Implementation

	initialize is
			-- Initialize `c_object'
		do
			set_is_initialized (True)
		end

feature {EV_ANY_I, EV_INTERMEDIARY_ROUTINES} -- Implementation

	widget_imp_at_pointer_position: EV_WIDGET_IMP is
			-- Widget implementation at current mouse pointer position (if any)
		do
		end

	minimum_width, real_minimum_width: INTEGER is
			-- Minimum width that the widget may occupy.
		do
			-- See hiview_get_size_constraints
			Result := 20
		end

	minimum_height, real_minimum_height: INTEGER is
			-- Minimum width that the widget may occupy.
		do
			-- See hiview_get_size_constraints
			Result := 20
		end

	set_pointer_style (a_cursor: like pointer_style) is
			-- Assign `a_cursor' to `pointer_style'.
		do
		end

	set_focus is
			-- Grab keyboard focus.
		do
		end

	internal_set_pointer_style (a_cursor: like pointer_style) is
			-- Assign `a_cursor' to `pointer_style', used for PND
		do
		end

	pointer_style: EV_CURSOR
			-- Cursor displayed when the pointer is over this widget.
			-- Position retrieval.

	frozen has_struct_flag (a_gtk_object: POINTER; a_flag: INTEGER): BOOLEAN is
			-- Has this widget the flag `a_flag' set in struct_flags?
		do
		end

	has_focus: BOOLEAN is
			-- Does widget have the keyboard focus?
		do
		end

	width: INTEGER is
			-- Horizontal size measured in pixels.
		local
			a_rect : CGRECT_STRUCT
			a_size : CGSIZE_STRUCT
			err : INTEGER
		do
			create a_rect.make_new_unshared
			err := hiview_get_frame_external ( c_object, a_rect.item )
			create a_size.make_shared ( a_rect.size )
			Result := a_size.width.rounded
		end

	height: INTEGER is
			-- Vertical size measured in pixels.
		local
			a_rect : CGRECT_STRUCT
			a_size : CGSIZE_STRUCT
			err : INTEGER
		do
			create a_rect.make_new_unshared
			err := hiview_get_frame_external ( c_object, a_rect.item )
			create a_size.make_shared ( a_rect.size )
			Result := a_size.height.rounded
		end

	aux_info_struct: POINTER is
			-- Pointer to the auxillary information struct used for retrieving when widget is unmapped
		do
		end

	show is
			-- Request that `Current' be displayed when its parent is.
		do
		end

feature -- Status report

	is_displayed: BOOLEAN is
			-- Is `Current' visible on the screen?
		do
		end

feature {NONE} -- Implementation

	aux_info_string: EV_CARBON_CF_STRING is
			-- String optimization for  "gtk-aux-info"
		once
		end

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




end -- class EV_GTK_WIDGET_IMP
