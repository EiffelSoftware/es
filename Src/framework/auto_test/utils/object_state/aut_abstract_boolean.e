note
	description: "Summary description for {AUT_ABSTRACT_BOOLEAN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_ABSTRACT_BOOLEAN

inherit
	AUT_ABSTRACT_VALUE

create
	make

feature{NONE} -- Initialization

	make (a_value: like value) is
			-- Set `value' with `a_value'.
		do
			value := a_value
		ensure
			value_set: value = a_value
		end

feature -- Access

	value: BOOLEAN
			-- Value of Current abstract value

	out: STRING
			-- New string containing terse printable representation
			-- of current object
		do
			Result := value.out.as_lower
		end

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
