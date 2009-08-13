indexing
	description: "[
		Automatically generated class for EiffelStudio 16 x16  tool icons.
	]"
	status: "See notice at end of class."
	legal: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_TOOL_ICONS

inherit
	ES_TOOL_PIXMAPS
		redefine
			matrix_pixel_border
		end

create
	make

feature -- Access

	icon_width: NATURAL_8 = 16
			-- <Precursor>

	icon_height: NATURAL_8 = 16
			-- <Precursor>

	width: NATURAL_8 = 10
			-- <Precursor>

	height: NATURAL_8 = 5
			-- <Precursor>

feature {NONE} -- Access

	matrix_pixel_border: NATURAL_8 = 0
			-- <Precursor>

feature -- Icons

	frozen object_type_base_icon: !EV_PIXMAP
			-- Access to 'routine' pixmap.
		require
			has_named_icon: has_named_icon (object_type_base_name)
		once
			Result := named_icon (object_type_base_name)
		end

	frozen object_type_base_icon_buffer: !EV_PIXEL_BUFFER
			-- Access to 'routine' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (object_type_base_name)
		once
			Result := named_icon_buffer (object_type_base_name)
		end

	frozen object_type_boolean_icon: !EV_PIXMAP
			-- Access to 'routine' pixmap.
		require
			has_named_icon: has_named_icon (object_type_boolean_name)
		once
			Result := named_icon (object_type_boolean_name)
		end

	frozen object_type_boolean_icon_buffer: !EV_PIXEL_BUFFER
			-- Access to 'routine' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (object_type_boolean_name)
		once
			Result := named_icon_buffer (object_type_boolean_name)
		end

	frozen object_type_container_icon: !EV_PIXMAP
			-- Access to 'container' pixmap.
		require
			has_named_icon: has_named_icon (object_type_container_name)
		once
			Result := named_icon (object_type_container_name)
		end

	frozen object_type_container_icon_buffer: !EV_PIXEL_BUFFER
			-- Access to 'container' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (object_type_container_name)
		once
			Result := named_icon_buffer (object_type_container_name)
		end

	frozen object_type_numeric_icon: !EV_PIXMAP
			-- Access to 'numeric' pixmap.
		require
			has_named_icon: has_named_icon (object_type_numeric_name)
		once
			Result := named_icon (object_type_numeric_name)
		end

	frozen object_type_numeric_icon_buffer: !EV_PIXEL_BUFFER
			-- Access to 'numeric' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (object_type_numeric_name)
		once
			Result := named_icon_buffer (object_type_numeric_name)
		end

	frozen object_type_pointer_icon: !EV_PIXMAP
			-- Access to 'pointer' pixmap.
		require
			has_named_icon: has_named_icon (object_type_pointer_name)
		once
			Result := named_icon (object_type_pointer_name)
		end

	frozen object_type_pointer_icon_buffer: !EV_PIXEL_BUFFER
			-- Access to 'pointer' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (object_type_pointer_name)
		once
			Result := named_icon_buffer (object_type_pointer_name)
		end

	frozen object_type_reference_icon: !EV_PIXMAP
			-- Access to 'reference' pixmap.
		require
			has_named_icon: has_named_icon (object_type_reference_name)
		once
			Result := named_icon (object_type_reference_name)
		end

	frozen object_type_reference_icon_buffer: !EV_PIXEL_BUFFER
			-- Access to 'reference' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (object_type_reference_name)
		once
			Result := named_icon_buffer (object_type_reference_name)
		end

	frozen object_type_string_icon: !EV_PIXMAP
			-- Access to 'string' pixmap.
		require
			has_named_icon: has_named_icon (object_type_string_name)
		once
			Result := named_icon (object_type_string_name)
		end

	frozen object_type_string_icon_buffer: !EV_PIXEL_BUFFER
			-- Access to 'string' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (object_type_string_name)
		once
			Result := named_icon_buffer (object_type_string_name)
		end

	frozen object_type_tuple_icon: !EV_PIXMAP
			-- Access to 'tuple' pixmap.
		require
			has_named_icon: has_named_icon (object_type_tuple_name)
		once
			Result := named_icon (object_type_tuple_name)
		end

	frozen object_type_tuple_icon_buffer: !EV_PIXEL_BUFFER
			-- Access to 'tuple' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (object_type_tuple_name)
		once
			Result := named_icon_buffer (object_type_tuple_name)
		end

	frozen object_type_void_icon: !EV_PIXMAP
			-- Access to 'void' pixmap.
		require
			has_named_icon: has_named_icon (object_type_void_name)
		once
			Result := named_icon (object_type_void_name)
		end

	frozen object_type_void_icon_buffer: !EV_PIXEL_BUFFER
			-- Access to 'void' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (object_type_void_name)
		once
			Result := named_icon_buffer (object_type_void_name)
		end

	frozen grid_cycle_reference_icon: !EV_PIXMAP
			-- Access to 'cycle_reference' pixmap.
		require
			has_named_icon: has_named_icon (grid_cycle_reference_name)
		once
			Result := named_icon (grid_cycle_reference_name)
		end

	frozen grid_cycle_reference_icon_buffer: !EV_PIXEL_BUFFER
			-- Access to 'cycle_reference' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (grid_cycle_reference_name)
		once
			Result := named_icon_buffer (grid_cycle_reference_name)
		end

	frozen gui_move_left_icon: !EV_PIXMAP
			-- Access to 'move_left' pixmap.
		require
			has_named_icon: has_named_icon (gui_move_left_name)
		once
			Result := named_icon (gui_move_left_name)
		end

	frozen gui_move_left_icon_buffer: !EV_PIXEL_BUFFER
			-- Access to 'move_left' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (gui_move_left_name)
		once
			Result := named_icon_buffer (gui_move_left_name)
		end

	frozen gui_move_right_icon: !EV_PIXMAP
			-- Access to 'move_right' pixmap.
		require
			has_named_icon: has_named_icon (gui_move_right_name)
		once
			Result := named_icon (gui_move_right_name)
		end

	frozen gui_move_right_icon_buffer: !EV_PIXEL_BUFFER
			-- Access to 'move_right' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (gui_move_right_name)
		once
			Result := named_icon_buffer (gui_move_right_name)
		end

	frozen gui_filter_icon: !EV_PIXMAP
			-- Access to 'filter' pixmap.
		require
			has_named_icon: has_named_icon (gui_filter_name)
		once
			Result := named_icon (gui_filter_name)
		end

	frozen gui_filter_icon_buffer: !EV_PIXEL_BUFFER
			-- Access to 'filter' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (gui_filter_name)
		once
			Result := named_icon_buffer (gui_filter_name)
		end

	frozen gui_ebbro_icon: !EV_PIXMAP
			-- Access to 'ebbro' pixmap.
		require
			has_named_icon: has_named_icon (gui_ebbro_name)
		once
			Result := named_icon (gui_ebbro_name)
		end

	frozen gui_ebbro_icon_buffer: !EV_PIXEL_BUFFER
			-- Access to 'ebbro' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (gui_ebbro_name)
		once
			Result := named_icon_buffer (gui_ebbro_name)
		end

	frozen gui_custom_serialization_icon: !EV_PIXMAP
			-- Access to 'custom serialization' pixmap.
		require
			has_named_icon: has_named_icon (gui_custom_serialization_name)
		once
			Result := named_icon (gui_custom_serialization_name)
		end

	frozen gui_custom_serialization_icon_buffer: !EV_PIXEL_BUFFER
			-- Access to 'custom serialization' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (gui_custom_serialization_name)
		once
			Result := named_icon_buffer (gui_custom_serialization_name)
		end

	frozen gui_comparer_icon: !EV_PIXMAP
			-- Access to 'comparer' pixmap.
		require
			has_named_icon: has_named_icon (gui_comparer_name)
		once
			Result := named_icon (gui_comparer_name)
		end

	frozen gui_comparer_icon_buffer: !EV_PIXEL_BUFFER
			-- Access to 'comparer' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (gui_comparer_name)
		once
			Result := named_icon_buffer (gui_comparer_name)
		end



feature -- Constants: Icon names

	object_type_base_name: !STRING = "object_type_base"
	object_type_boolean_name: !STRING = "object_type_boolean"
	object_type_container_name: !STRING = "object_type_container"
	object_type_numeric_name: !STRING = "object_type_numeric"
	object_type_pointer_name: !STRING = "object_type_pointer"
	object_type_reference_name: !STRING = "object_type_reference"
	object_type_string_name: !STRING = "object_type_string"
	object_type_tuple_name: !STRING = "object_type_tuple"
	object_type_void_name: !STRING = "object_type_void"
	grid_cycle_reference_name: !STRING = "grid_cycle_reference"
	gui_move_left_name: !STRING = "gui_move_left"
	gui_move_right_name: !STRING = "gui_move_right"
	gui_filter_name: !STRING = "gui_filter"
	gui_ebbro_name: !STRING = "gui_ebbro"
	gui_custom_serialization_name: !STRING = "gui_custom_serialization"
	gui_comparer_name: !STRING = "gui_comparer"



feature {NONE} -- Basic operations

	populate_coordinates_table (a_table: HASH_TABLE [TUPLE [x: NATURAL_8; y: NATURAL_8], STRING])
			-- <Precursor>
		do
			a_table.put ([{NATURAL_8}1, {NATURAL_8}1], object_type_base_name)
			a_table.put ([{NATURAL_8}2, {NATURAL_8}1], object_type_boolean_name)
			a_table.put ([{NATURAL_8}3, {NATURAL_8}1], object_type_container_name)
			a_table.put ([{NATURAL_8}4, {NATURAL_8}1], object_type_numeric_name)
			a_table.put ([{NATURAL_8}5, {NATURAL_8}1], object_type_pointer_name)
			a_table.put ([{NATURAL_8}6, {NATURAL_8}1], object_type_reference_name)
			a_table.put ([{NATURAL_8}7, {NATURAL_8}1], object_type_string_name)
			a_table.put ([{NATURAL_8}8, {NATURAL_8}1], object_type_tuple_name)
			a_table.put ([{NATURAL_8}9, {NATURAL_8}1], object_type_void_name)
			a_table.put ([{NATURAL_8}1, {NATURAL_8}3], grid_cycle_reference_name)
			a_table.put ([{NATURAL_8}1, {NATURAL_8}4], gui_ebbro_name)
			a_table.put ([{NATURAL_8}2, {NATURAL_8}4], gui_move_left_name)
			a_table.put ([{NATURAL_8}3, {NATURAL_8}4], gui_move_right_name)
			a_table.put ([{NATURAL_8}4, {NATURAL_8}4], gui_custom_serialization_name)
			a_table.put ([{NATURAL_8}5, {NATURAL_8}4], gui_filter_name)
			a_table.put ([{NATURAL_8}6, {NATURAL_8}4], gui_comparer_name)
		end

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
