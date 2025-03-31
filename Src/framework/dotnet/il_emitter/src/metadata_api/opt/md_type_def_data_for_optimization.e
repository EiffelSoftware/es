note
	description: "[
			Record MethodDef and Field token for a TypeDef
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MD_TYPE_DEF_DATA_FOR_OPTIMIZATION

feature -- Access

	method_def_list: detachable LIST [NATURAL_32]
			-- MethodDef tokens
	field_list: detachable LIST [NATURAL_32]
			-- Field tokens

feature -- Status report

	has_field: BOOLEAN
		do
			Result := attached field_list as lst and then lst.count > 0
		end

	has_method_def: BOOLEAN
		do
			Result := attached method_def_list as lst and then lst.count > 0
		end

feature -- Element change

	record_method_def (tok: NATURAL_32)
		local
			lst: like method_def_list
		do
			lst := method_def_list
			if lst = Void then
				create {ARRAYED_LIST [NATURAL_32]} lst.make (5)
				method_def_list := lst
			end
			lst.force (tok & 0x00FF_FFFF)
		end

	record_field (tok: NATURAL_32)
		local
			lst: like field_list
		do
			lst := field_list
			if lst = Void then
				create {ARRAYED_LIST [NATURAL_32]} lst.make (5)
				field_list := lst
			end
			lst.force (tok & 0x00FF_FFFF)
		end

feature -- Operation

	sort_method_def_list
		do
			if attached method_def_list as lst then
				sorter.sort (lst)
			end
		end

	sort_field_list
		do
			if attached field_list as lst then
				sorter.sort (lst)
			end
		end

feature {NONE} -- Implementation

	sorter: SORTER [NATURAL_32]
		once
			create {QUICK_SORTER [NATURAL_32]} Result.make (create {COMPARABLE_COMPARATOR [NATURAL_32]})
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
