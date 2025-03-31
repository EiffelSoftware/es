note
	description: "Summary description for {PE_EVENT_TABLE_ENTRY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PE_EVENT_TABLE_ENTRY

inherit

	PE_TABLE_ENTRY_BASE

create
	make_with_data

feature {NONE} -- Initialization

	make_with_data (a_flags: NATURAL_16; a_name: NATURAL; a_event_type: PE_TYPEDEF_OR_REF)
		do
			flags := a_flags
			create name.make_with_index (a_name)
			event_type := a_event_type
		end

feature -- Access

	flags: NATURAL_16
		-- defined as word two bytes.

	name: PE_STRING

	event_type: PE_TYPEDEF_OR_REF

feature -- Enum: Flags

	SpecialName: INTEGER = 0x200
	ReservedMask: INTEGER = 0x400
	RTSpecialName: INTEGER = 0x400

feature -- Status report

feature -- Operations

	table_index: NATURAL_32
		once
			Result := {PE_TABLES}.tEvent
		end

	render (a_sizes: SPECIAL [NATURAL_32]; a_dest: ARRAY [NATURAL_8]): NATURAL_32
		local
			l_bytes: NATURAL_32
		do
				-- Write falgs to the destination buffer `a_dest`.
			{BYTE_ARRAY_HELPER}.put_natural_16 (a_dest, flags, 0)

				-- Intialize the number of bytes written
			l_bytes := 2

				-- Write name and event_type to the buffer and update the number of bytes.
			l_bytes := l_bytes + name.render (a_sizes, a_dest, l_bytes)
			l_bytes := l_bytes + event_type.render (a_sizes, a_dest, l_bytes)

				-- Return the number of bytes written
			Result := l_bytes
		end


	rendering_size (a_sizes: SPECIAL [NATURAL_32]): NATURAL_32
		local
			l_bytes: NATURAL_32
		do
				-- Set the flags (from a_src)  to action
			l_bytes := 2

				-- Read name and event_type from the buffer and update the number of bytes.
			l_bytes := l_bytes + name.rendering_size (a_sizes)
			l_bytes := l_bytes + event_type.rendering_size (a_sizes)

				-- Return the number of bytes readed
			Result := l_bytes
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

