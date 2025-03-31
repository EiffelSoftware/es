note
	description: "[
			Compute the sizeof C struct memory taking care of padding and alignment.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	STRUCT_SIZE

create
	make

convert
	size: {INTEGER_32}

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
			internal_size := 0
			alignment_size := {PLATFORM}.character_8_bytes
		end

feature -- Access

	size: INTEGER
		local
			pad: INTEGER
		do
			Result := internal_size
			pad := Result \\ alignment_size
			if pad /= 0 then
				pad := alignment_size - pad
				Result := Result + pad
			end
		end

	alignment_size: INTEGER

feature {NONE} -- Implementation

	internal_size: INTEGER

feature -- Change

	padding (a_byte_size: INTEGER): INTEGER
		do
			Result := internal_size \\ a_byte_size
			if Result /= 0 then
				Result := a_byte_size - Result
			end
		end

	put_padding (a_byte_size: INTEGER)
		local
			pad: INTEGER
		do
			pad := padding (a_byte_size)
			if pad > 0 then
				internal_size := internal_size + pad -- Padding
			end
		end

	put (a_byte_size: INTEGER)
		do
			put_padding (a_byte_size)
			internal_size := internal_size + a_byte_size
			alignment_size := alignment_size.max (a_byte_size)
		end

	put_inner_struct (a_byte_size: INTEGER; a_struct_alignment: INTEGER)
		do
			put_padding (a_struct_alignment)
			internal_size := internal_size + a_byte_size
			alignment_size := alignment_size.max (a_struct_alignment)
		end

	put_character
		do
			internal_size := internal_size + {PLATFORM}.character_8_bytes
--			alignment_size := alignment_size.max ({PLATFORM}.character_8_bytes)
		end

	put_characters (n: INTEGER)
		do
			internal_size := internal_size + n * {PLATFORM}.character_8_bytes
--			alignment_size := alignment_size.max ({PLATFORM}.character_8_bytes)
		end

	put_natural_8_array (n: INTEGER)
		do
			internal_size := internal_size + n * {PLATFORM}.natural_8_bytes
--			alignment_size := alignment_size.max ({PLATFORM}.natural_8_bytes)
		end

	put_natural_8
		do
			put ({PLATFORM}.natural_8_bytes)
		end

	put_integer_32
		do
			put ({PLATFORM}.integer_32_bytes)
		end

	put_integer_8
		do
			put ({PLATFORM}.integer_8_bytes)
		end

	put_integer_16
		do
			put ({PLATFORM}.integer_16_bytes)
		end

	put_integer_64
		do
			put ({PLATFORM}.integer_64_bytes)
		end

	put_pointer
		do
			put ({PLATFORM}.pointer_bytes)
		end


note
	copyright: "Copyright (c) 1984-2025, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
