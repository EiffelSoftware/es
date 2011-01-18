note
	description: "[
		Automatically generated class for EiffelStudio 16x16 icons.
	]"
	generator: "Eiffel Matrix Generator"
	command_line: "emcgen.exe c:\eiffel\eve\Delivery\studio\bitmaps\png\eve16x16.ini -f c:\eiffel\eve\tools\eiffel_matrix_code_generator\frames\studio.e.frame"
	status: "See notice at end of class."
	legal: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	ES_PIXMAPS_EVE16X16

inherit
	ES_PIXMAPS
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

	width: NATURAL_8 = 8
			-- <Precursor>

	height: NATURAL_8 = 2
			-- <Precursor>

feature {NONE} -- Access

	matrix_pixel_border: NATURAL_8 = 1
			-- <Precursor>

feature -- Icons
	
	frozen weights_tiny_icon: EV_PIXMAP
			-- Access to 'tiny' pixmap.
		require
			has_named_icon: has_named_icon (weights_tiny_name)
		once
			Result := named_icon (weights_tiny_name)
		ensure
			weights_tiny_icon_attached: Result /= Void
		end

	frozen weights_tiny_icon_buffer: EV_PIXEL_BUFFER
			-- Access to 'tiny' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (weights_tiny_name)
		once
			Result := named_icon_buffer (weights_tiny_name)
		ensure
			weights_tiny_icon_buffer_attached: Result /= Void
		end

	frozen weights_small_icon: EV_PIXMAP
			-- Access to 'small' pixmap.
		require
			has_named_icon: has_named_icon (weights_small_name)
		once
			Result := named_icon (weights_small_name)
		ensure
			weights_small_icon_attached: Result /= Void
		end

	frozen weights_small_icon_buffer: EV_PIXEL_BUFFER
			-- Access to 'small' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (weights_small_name)
		once
			Result := named_icon_buffer (weights_small_name)
		ensure
			weights_small_icon_buffer_attached: Result /= Void
		end

	frozen weights_normal_icon: EV_PIXMAP
			-- Access to 'normal' pixmap.
		require
			has_named_icon: has_named_icon (weights_normal_name)
		once
			Result := named_icon (weights_normal_name)
		ensure
			weights_normal_icon_attached: Result /= Void
		end

	frozen weights_normal_icon_buffer: EV_PIXEL_BUFFER
			-- Access to 'normal' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (weights_normal_name)
		once
			Result := named_icon_buffer (weights_normal_name)
		ensure
			weights_normal_icon_buffer_attached: Result /= Void
		end

	frozen weights_large_icon: EV_PIXMAP
			-- Access to 'large' pixmap.
		require
			has_named_icon: has_named_icon (weights_large_name)
		once
			Result := named_icon (weights_large_name)
		ensure
			weights_large_icon_attached: Result /= Void
		end

	frozen weights_large_icon_buffer: EV_PIXEL_BUFFER
			-- Access to 'large' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (weights_large_name)
		once
			Result := named_icon_buffer (weights_large_name)
		ensure
			weights_large_icon_buffer_attached: Result /= Void
		end

	frozen weights_huge_icon: EV_PIXMAP
			-- Access to 'huge' pixmap.
		require
			has_named_icon: has_named_icon (weights_huge_name)
		once
			Result := named_icon (weights_huge_name)
		ensure
			weights_huge_icon_attached: Result /= Void
		end

	frozen weights_huge_icon_buffer: EV_PIXEL_BUFFER
			-- Access to 'huge' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (weights_huge_name)
		once
			Result := named_icon_buffer (weights_huge_name)
		ensure
			weights_huge_icon_buffer_attached: Result /= Void
		end

	frozen notused_notused_icon: EV_PIXMAP
			-- Access to 'notused' pixmap.
		require
			has_named_icon: has_named_icon (notused_notused_name)
		once
			Result := named_icon (notused_notused_name)
		ensure
			notused_notused_icon_attached: Result /= Void
		end

	frozen notused_notused_icon_buffer: EV_PIXEL_BUFFER
			-- Access to 'notused' pixmap pixel buffer.
		require
			has_named_icon: has_named_icon (notused_notused_name)
		once
			Result := named_icon_buffer (notused_notused_name)
		ensure
			notused_notused_icon_buffer_attached: Result /= Void
		end

feature -- Icons: Animations
	
	-- No animation frames detected.

feature -- Constants: Icon names

	weights_tiny_name: STRING = "weights tiny"
	weights_small_name: STRING = "weights small"
	weights_normal_name: STRING = "weights normal"
	weights_large_name: STRING = "weights large"
	weights_huge_name: STRING = "weights huge"
	notused_notused_name: STRING = "notused notused"

feature {NONE} -- Basic operations

	populate_coordinates_table (a_table: HASH_TABLE [TUPLE [x: NATURAL_8; y: NATURAL_8], STRING])
			-- <Precursor>
		do
			a_table.put ([{NATURAL_8} 1, {NATURAL_8} 1], weights_tiny_name)
			a_table.put ([{NATURAL_8} 2, {NATURAL_8} 1], weights_small_name)
			a_table.put ([{NATURAL_8} 3, {NATURAL_8} 1], weights_normal_name)
			a_table.put ([{NATURAL_8} 4, {NATURAL_8} 1], weights_large_name)
			a_table.put ([{NATURAL_8} 5, {NATURAL_8} 1], weights_huge_name)
			a_table.put ([{NATURAL_8} 1, {NATURAL_8} 2], notused_notused_name)
		end

;note
	copyright:	"Copyright (c) 1984-2009, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
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
