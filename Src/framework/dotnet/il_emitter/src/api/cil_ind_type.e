note
	description: "Summary description for {CIL_IND_TYPE}."
	date: "$Date$"
	revision: "$Revision$"

once class
	CIL_IND_TYPE

create
	I1, I2, I4, I8, U1, U2, U4, U8, R4, R8, Int, Ref

feature {NONE} -- Creation Procedure

	I1 once end
	I2 once end
	I4 once end
	I8 once end
	U1 once end
	U2 once end
	U4 once end
	U8 once end
	R4 once end
	R8 once end
	Int once end
	Ref once end

feature -- Instances

	instances: ITERABLE [CIL_IND_TYPE]
			-- All knwon instances
		do
			Result := <<{CIL_IND_TYPE}.I1,
					{CIL_IND_TYPE}.I2,
					{CIL_IND_TYPE}.I4,
					{CIL_IND_TYPE}.I8,
					{CIL_IND_TYPE}.U1,
					{CIL_IND_TYPE}.U2,
					{CIL_IND_TYPE}.U4,
					{CIL_IND_TYPE}.U8,
					{CIL_IND_TYPE}.R4,
					{CIL_IND_TYPE}.R8,
					{CIL_IND_TYPE}.Int,
					{CIL_IND_TYPE}.Ref>>
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
