note
	description: "Summary description for {CIL_SEH}."
	date: "$Date$"
	revision: "$Revision$"

once class
	CIL_SEH

create
	seh_try, seh_catch, seh_finally, seh_fault, seh_filter, seh_filter_handler

feature {NONE} -- Creation

	seh_try once  end
	seh_catch once  end
	seh_finally once  end
	seh_fault once  end
	seh_filter once  end
	seh_filter_handler once  end

feature -- Access

	instances: ITERABLE [CIL_SEH]
			-- All known cil sehs
		do
			Result := <<{CIL_SEH}.seh_try, {CIL_SEH}.seh_catch, {CIL_SEH}.seh_finally, {CIL_SEH}.seh_fault, {CIL_SEH}.seh_filter, {CIL_SEH}.seh_filter_handler>>
		ensure
			instance_free: class
		end


	index_of (a_value: CIL_SEH): INTEGER
			-- Index of first occurrence of item identical to `a_value'.
			-- -1 if none.
		local
			l_area: SPECIAL [CIL_SEH]
		do
			l_area := (create {ARRAYED_LIST [CIL_SEH]}.make_from_iterable (instances)).area
			Result :=  l_area.index_of(a_value, l_area.lower)
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
