note
	description: "[
			Compute the size of the expected memory.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	CLI_MANAGED_POINTER_SIZE

create
	make

convert
	size: {INTEGER_32}

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
			internal_size := 0
		end

feature -- Access

	size: INTEGER
		do
			Result := internal_size
		end

feature {NONE} -- Implementation

	internal_size: INTEGER

feature -- Change

	put_padding (pad: INTEGER)
		do
			internal_size := internal_size + pad
		end

	put_character
		do
			internal_size := internal_size + {PLATFORM}.character_8_bytes
		end

	put_natural_8_array (n: INTEGER)
		do
			internal_size := internal_size + n * {PLATFORM}.natural_8_bytes
		end

	put_natural_8
		do
			internal_size := internal_size + {PLATFORM}.natural_8_bytes
		end

	put_natural_32
		do
			internal_size := internal_size + {PLATFORM}.natural_32_bytes
		end

	put_integer_32
		do
			internal_size := internal_size + {PLATFORM}.integer_32_bytes
		end

	put_integer_8
		do
			internal_size := internal_size + {PLATFORM}.integer_8_bytes
		end

	put_integer_16
		do
			internal_size := internal_size + {PLATFORM}.integer_16_bytes
		end

	put_integer_64
		do
			internal_size := internal_size + {PLATFORM}.integer_64_bytes
		end

	put_pointer
		do
			internal_size := internal_size + {PLATFORM}.pointer_bytes
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
