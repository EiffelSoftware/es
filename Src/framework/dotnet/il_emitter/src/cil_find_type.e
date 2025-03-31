note
	description: "Summary description for {CIL_FIND_TYPE}."
	date: "$Date$"
	revision: "$Revision$"

once class
	CIL_FIND_TYPE

create
	s_notFound,
	s_ambiguous,
	s_namespace,
	s_class,
	s_enum,
	s_field,
	s_property,
	s_method

feature {NONE} -- Creation procedures

	s_notFound once end
	s_ambiguous once end
	s_namespace once end
	s_class once end
	s_enum once end
	s_field once end
	s_property once end
	s_method once end

feature -- Instances

	instances: ITERABLE [CIL_FIND_TYPE]
			-- All known find_types's.
		do
			Result := <<
					{CIL_FIND_TYPE}.s_notFound,
					{CIL_FIND_TYPE}.s_ambiguous,
					{CIL_FIND_TYPE}.s_namespace,
					{CIL_FIND_TYPE}.s_class,
					{CIL_FIND_TYPE}.s_enum,
					{CIL_FIND_TYPE}.s_field,
					{CIL_FIND_TYPE}.s_property,
					{CIL_FIND_TYPE}.s_method
				>>
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
