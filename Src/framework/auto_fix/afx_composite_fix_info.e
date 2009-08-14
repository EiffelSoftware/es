note
	description: "Summary description for {AFX_COMPOSITE_FIX_INFO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_COMPOSITE_FIX_INFO

inherit
    AFX_FIX_INFO_I

create
    make

feature -- Creation

	make
			-- Initialization
		do
			set_id
		end

feature -- Access

	fixes: DS_ARRAYED_LIST [AFX_FIX_INFO_I]
			-- simple fixes consisted in the `multi_fix_info'

	is_valid: BOOLEAN
			-- is this fix a valid one?

feature -- operation

	involved_classes: DS_LINEAR [CLASS_C]
			-- <Precursor>
		do
		    create {DS_ARRAYED_LIST[CLASS_C]}Result.make (5)
		end

;note
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
