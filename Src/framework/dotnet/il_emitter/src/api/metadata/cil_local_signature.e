note
	description: "Object representing CIL Local variables."
	date: "$Date$"
	revision: "$Revision$"

class
	CIL_LOCAL_SIGNATURE

create
	make

feature {NONE} -- Initlization

	make
		do
			create locals.make (2)
		end

	locals: ARRAYED_LIST [CIL_LOCAL]
			-- loval variables


feature -- Element Change

	put (a_local: CIL_LOCAL)
			-- Add `local' to end of locals variables.
		do
			locals.force (a_local)
		end

feature -- Removal

	wipe_out
			-- Remove all elements
		do
			locals.wipe_out
		end

feature -- Access

	i_th (i: INTEGER): CIL_LOCAL
			-- Item at `i'-th position
		require
			valid_index: i > 0 and then i <= count
		do
			Result := locals.i_th (i)
		end

feature -- Status Report

	count: INTEGER
			-- Number of local variables.

;note
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
