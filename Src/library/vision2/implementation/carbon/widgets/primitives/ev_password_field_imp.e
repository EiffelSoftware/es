indexing
	description:
		"Eiffel Vision password field. GTK+ implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_PASSWORD_FIELD_IMP

inherit
	EV_PASSWORD_FIELD_I
		undefine
			hide_border
		redefine
			interface
		end

	EV_TEXT_FIELD_IMP
		redefine
			initialize,
			interface,
			make,
			text
		end

create
	make

feature {NONE} -- Initialization
		make (an_interface: like interface) is
			-- Create a gtk entry.
		local
			ret: INTEGER
			struct_ptr: POINTER
			buffer: C_STRING
			point : CGPOINT_STRUCT
			size : CGSIZE_STRUCT
			rect : CGRECT_STRUCT
			a_string: C_STRING
		do
			base_make (an_interface)

			create point.make_new_unshared
			create rect.make_new_unshared
			create size.make_new_unshared

			size.set_height(18)
			size.set_width (100)
			point.set_x (0)
			point.set_y (0)
			rect.set_origin (point.item)
			rect.set_size (size.item)

			ret := create_edit_unicode_text_control_external (null,rect.item, null,1, NULL, $c_object)
			ret := set_control_data_boolean (c_object, {CONTROLDEFINITIONS_ANON_ENUMS}.kcontrolentirecontrol, {CONTROLDEFINITIONS_ANON_ENUMS}.kcontroledittextsinglelinetag, true)



			io.put_string ("create:" +ret.out)

			ret := hiview_set_visible_external (c_object, 1)
			ret := hiview_set_frame_external (c_object, rect.item)

			event_id := app_implementation.get_id (current)  --getting an id from the application

		end

feature -- Access

	text: STRING_32 is
			-- Text displayed in field.
		local
			ret, size: INTEGER
			str: EV_CARBON_CF_STRING
			ptr: POINTER
		do

			ret := get_control_data_size_external (c_object, {CONTROLDEFINITIONS_ANON_ENUMS}.kcontrolentirecontrol, {CONTROLDEFINITIONS_ANON_ENUMS}.kControlEditTextPasswordCFStringTag, $size)
			io.put_string("size: " + size.out)
			ret := get_control_data_external (c_object, {CONTROLDEFINITIONS_ANON_ENUMS}.kcontrolentirecontrol, {CONTROLDEFINITIONS_ANON_ENUMS}.kControlEditTextPasswordCFStringTag, size, $ptr, $size)
			io.put_string ("ret :" + ret.out)
			create str.	make_unshared (ptr)
			REsult := str.string
		end


	initialize is
			-- Create password field with `*'.
		do
			set_password (entry_widget)
		end
	set_password (obj: POINTER) is
	external
		"C inline use <Carbon/Carbon.h>"
	alias

			"[
				{	
					TXNEchoMode($obj, '*',kTextEncodingUnicodeDefault, true);
				}
			]"
	end


feature {NONE} -- Implementation

	interface: EV_PASSWORD_FIELD;

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




end -- class EV_PASSWORD_FIELD_IMP

