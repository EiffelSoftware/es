note
	description: "Summary description for {PE_RESOURCE_HEADER}."
	date: "$Date$"
	revision: "$Revision$"

class
	PE_RESOURCE_HEADER

feature -- Access

	data_size: INTEGER_32 assign set_data_size
			-- `data_sIze'

	hrd_size: INTEGER_32 assign set_hrd_size
			-- `hrd_size'

feature -- Element change

	set_hrd_size (a_hrd_size: like hrd_size)
			-- Assign `hrd_size' with `a_hrd_size'.
		do
			hrd_size := a_hrd_size
		ensure
			hrd_size_assigned: hrd_size = a_hrd_size
		end

	set_data_size (a_data_size: like data_size)
			-- Assign `data_size' with `a_data_size'.
		do
			data_size := a_data_size
		ensure
			data_size_assigned: data_size = a_data_size
		end

feature -- Measurement

	size_of: INTEGER
		local
			l_internal: INTERNAL
			n: INTEGER
			l_obj: PE_RESOURCE_HEADER
		do
			create l_obj
			create l_internal
			n := l_internal.field_count (l_obj)
			across 1 |..| n as ic loop
				if attached l_internal.field (ic, l_obj) as l_field then
					if attached {INTEGER_32} l_field then
						Result := Result + {PLATFORM}.integer_32_bytes
					end
				end
			end
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
