indexing
	description: "Display constants used in Ebbro grid"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_DISPLAY_CONST


feature -- consants

	void_type:STRING is "NONE"

	ref_type_value:STRING is ""

	void_value:STRING is "void"

	void_addr:STRING is ""

	root_object_name:STRING is "Root Object"

feature -- messages

	update_value_error_msg:STRING is "Updating of this field failed."

feature -- root object

	root_red_color:INTEGER is 28

	root_green_color:INTEGER is 134

	root_blue_color:INTEGER is 238

feature -- compare highlight colors

	compare_diff_color:EV_COLOR is
			--
		once
			create result.make_with_8_bit_rgb (238,0,0)
		end

	compare_diff_parents_color:EV_COLOR is
			--
		once
			create result.make_with_8_bit_rgb (255,106,106)
		end

	compare_missing_on_left_color:EV_COLOR is
			--
		once
			create result.make_with_8_bit_rgb (0,0,238)
		end

	compare_missing_on_right_color:EV_COLOR is
			--
		once
			create result.make_with_8_bit_rgb (255,215,0)
		end

	compare_identical_color:EV_COLOR is
			--
		once
			create result.make_with_8_bit_rgb (0,238,0)
		end

feature -- style ids

	style_container:INTEGER is 1

	style_tuple:INTEGER is 2

	style_reference:INTEGER is 3

	style_expanded:INTEGER is 4

	style_void:INTEGER is 5

	style_cycle:INTEGER is 6

	style_pointer:INTEGER is 7

feature -- item tooltips

	tooltip_cycle:STRING is "Cycle reference"

	tooltip_root:STRING is "Root object"

feature -- pixmap

	pixmap_base:INTEGER is 1
	pixmap_boolean:INTEGER is 2
	pixmap_container:INTEGER is 3
	pixmap_numeric:INTEGER is 4
	pixmap_pointer:INTEGER is 5
	pixmap_reference:INTEGER is 6
	pixmap_string:INTEGER is 7
	pixmap_tuple:INTEGER is 8
	pixmap_void:INTEGER is 9
	pixmap_cycle_reference:INTEGER is 10

	pixmap_hashtable:HASH_TABLE[EV_PIXMAP,INTEGER] is
			--
		once
			create result.make(15)
		end



feature -- base types

	base_types:ARRAY[STRING] is
			-- types which have concrete values -> use .out
		once
			result := <<"BIT_REF","BOOLEAN","CHARACTER_8","CHARACTER_32","CHARACTER","INTEGER_8","INTEGER_16","INTEGER_32","INTEGER_64","INTEGER","NATURAL","NATURAL_8","NATURAL_16","NATURAL_32","NATURAL_64","REAL_32","REAL_64","STRING_8","STRING_32","POINTER","POINTER_REF">>
		end

	base_string_types:ARRAY[STRING] is
			-- types which are string types...chars,strings
		once
			result := <<"CHARACTER_8","CHARACTER_32","CHARACTER","STRING_8","STRING_32">>
		end

	base_numeric_types:ARRAY[STRING] is
			-- types which are numeric
		once
			result := <<"INTEGER_8","INTEGER_16","INTEGER_32","INTEGER_64","INTEGER","NATURAL","NATURAL_8","NATURAL_16","NATURAL_32","NATURAL_64","REAL_32","REAL_64">>
		end

	base_boolean_type:STRING is "BOOLEAN"
			-- boolean type string

feature -- main grid constants

	column_width_1:INTEGER is 200

	column_width_2:INTEGER is 100

	column_width_3:INTEGER is 150

	column_width_4:INTEGER is 100

feature -- main grid

	column_title_1:STRING is "Name"

	column_title_2:STRING is "Value"

	column_title_3:STRING is "Type"

	column_title_4:STRING is "Address"

feature -- right click menu on root objects

	menu_right_click_remove:STRING is "&Remove"
			-- Remove for right click menu

	menu_right_click_move_right:STRING is "&Move"
			-- Move for right click menu

	menu_right_click_move_left:STRING is "&Move"
			-- Move for right click menu

	Menu_filter_item: STRING is "&Filters"
			-- String for menu "Filters"

	Menu_filter_none_item:STRING is "None"
			--String for menu item "Filter/Void"

	Menu_filter_void_item:STRING is "Void"
			--String for menu item "Filter/Void"

	Menu_filter_cycle_item:STRING is "Cycle"
			--String for menu item "Filter/Cycle"

	Menu_right_click_save:STRING is "Save"

	Menu_right_click_save_as:STRING is "Save as..."

feature -- filter ids

	none_filter_id:INTEGER is 0
			--filter id for no filter

	void_filter_id:INTEGER is 1
			-- filter id for void filter

	cycle_filter_id:INTEGER is 2
			-- cycle filter id

;indexing
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			 Eiffel Software
			 5949 Hollister Ave., Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"
end
