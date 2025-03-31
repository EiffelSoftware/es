note
	description: "Mode for the initialized value"
	date: "$Date$"
	revision: "$Revision$"

once class
	CIL_VALUE_MODE
create
	None,
	Enum,
	Bytes

feature {NONE} -- Creation

	None
			-- No initialized value
		once end

	Enum
			--  Enumerated value, goes into the constant table
		once end

	Bytes
			-- Byte stream, goes into the sdata
		once end

feature -- Instances

	instances: ITERABLE [CIL_VALUE_MODE]
			-- All known value modes.
		do
			Result := <<
					{CIL_VALUE_MODE}.None,
					{CIL_VALUE_MODE}.Enum,
					{CIL_VALUE_MODE}.Bytes
				>>
		ensure
			is_class: class
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
