note
	description: "Summary description for {AUT_ABSTRACT_RANGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_ABSTRACT_RANGE [G -> AUT_ABSTRACT_VALUE]

inherit
	ARRAYED_LIST [G]

create
	make,
	make_with_values

feature{NONE} -- Initialization

	make_with_values (a_name: like name; a_values: ARRAY [G]) is
			-- Extend `a_values' into Current.
			-- Set name of current range with `a_name'.
		require
			a_name_attached: a_name /= Void
			a_values_attached: a_values /= Void
		do
			make (a_values.count)
			name_internal := a_name.twin
			a_values.do_all (agent extend)
		end

feature -- Access

	name: STRING is
			-- Name of current value
		do
			if name_internal = Void then
				Result := ""
			else
				Result := name_internal
			end
		ensure
			result_attached: Result /= Void
		end

feature{NONE} -- Implementation

	name_internal: like name;
			-- Implementation of `name'

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
