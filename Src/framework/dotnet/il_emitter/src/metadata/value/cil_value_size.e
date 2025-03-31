note
	description: "Size for enumerated values"
	date: "$Date$"
	revision: "$Revision$"

once class
	CIL_VALUE_SIZE
create
	i8, i16, i32, i64

feature {NONE} -- Creation

	i8 once end
	i16 once  end
	i32 once  end
	i64 once  end

feature -- Instances

	instances: ITERABLE[CIL_VALUE_SIZE]
			-- All known value sizes.
		do
			Result :=<<
				{CIL_VALUE_SIZE}.i8,
				{CIL_VALUE_SIZE}.i16,
				{CIL_VALUE_SIZE}.i32,
				{CIL_VALUE_SIZE}.i64
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
