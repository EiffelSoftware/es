note
	description: "Summary description for {CIL_TO_TYPE}."
	date: "$Date$"
	revision: "$Revision$"

once class
	CIL_TO_TYPE

create
	ToI1, ToI2, ToI4, ToI8, ToR4, ToR8, ToU1, ToU2, ToU4, ToU8, ToInt, ToUint, ToRun

feature {NONE} -- Creation procedures

	ToI1 once end
	ToI2 once end
	ToI4 once end
	ToI8 once end
	ToR4 once end
	ToR8 once end
	ToU1 once end
	ToU2 once end
	ToU4 once end
	ToU8 once end
	ToInt once end
	ToUint once end
	ToRun once end

feature -- Instances

	instances: ITERABLE [CIL_TO_TYPE]
			-- All known instances CIL to type
		do
			Result := <<{CIL_TO_TYPE}.ToI1,
					{CIL_TO_TYPE}.ToI2,
					{CIL_TO_TYPE}.ToI4,
					{CIL_TO_TYPE}.ToI8,
					{CIL_TO_TYPE}.ToR4,
					{CIL_TO_TYPE}.ToR8,
					{CIL_TO_TYPE}.ToU1,
					{CIL_TO_TYPE}.ToU2,
					{CIL_TO_TYPE}.ToU4,
					{CIL_TO_TYPE}.ToU8,
					{CIL_TO_TYPE}.ToInt,
					{CIL_TO_TYPE}.ToUint,
					{CIL_TO_TYPE}.ToRun>>
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
