note
	description: "Object representing the Metadata Root"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "nmae=Metadata Root", "src=https://www.ecma-international.org/wp-content/uploads/ECMA-335_6th_edition_june_2012.pdf#page=297&zoom=100,116,308", "protocol=uri"
class
	PE_DOTNET_META_HEADER

inherit
	ANY

create
	default_create,
	make_from_other

feature {NONE} -- Initialization

	make_from_other (a_other: PE_DOTNET_META_HEADER)
		do

		end

feature -- Access

	META_SIG: NATURAL_32 = 0x424A5342 -- BSJB

	signature: NATURAL_32

	major: NATURAL_16

	minor: NATURAL_16

	reserved: NATURAL_32

feature -- Element Change

	set_signature (a_val: NATURAL)
			-- Set `signature` with `a_val`.
		do
			signature := a_val
		ensure
			signature_set: signature = a_Val
		end

	set_major (a_val: NATURAL_16)
			-- Set `major` with `a_val`.
		do
			major := a_val
		ensure
			major_set: major = a_val
		end

	set_minor (a_val: NATURAL_16)
			-- Set 	`minor` with `a_val`
		do
			minor := a_val
		ensure
			minor_set: minor = a_val
		end

	set_reserved (a_val: NATURAL)
			-- Set `reserved` with `a_val`
		do
			reserved := a_val
		ensure
			reserved_set: reserved = a_val
		end

feature -- Managed Pointer

	managed_pointer: MANAGED_POINTER
		local
			l_pos: INTEGER
		do
			create Result.make (size_of)
			l_pos := 0

				--signature
			Result.put_natural_32_le (signature, l_pos)
			l_pos := l_pos + {PLATFORM}.natural_32_bytes

				--major
			Result.put_natural_16_le (major, l_pos)
			l_pos := l_pos + {PLATFORM}.natural_16_bytes

				--minor
			Result.put_natural_16_le (minor, l_pos)
			l_pos := l_pos + {PLATFORM}.natural_16_bytes

				--reserved
			Result.put_natural_32_le (reserved, l_pos)
		end

feature -- Measurement

	size_of: INTEGER
		do
			Result := {PLATFORM}.natural_32_bytes
				+ {PLATFORM}.natural_16_bytes
				+ {PLATFORM}.natural_16_bytes
				+ {PLATFORM}.natural_32_bytes
		ensure
			instance_free: class
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
