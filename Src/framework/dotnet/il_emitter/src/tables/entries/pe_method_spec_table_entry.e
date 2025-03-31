note
	description: "Object representig the The MethodSpec table"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=MethodSpec", "src=https://www.ecma-international.org/wp-content/uploads/ECMA-335_6th_edition_june_2012.pdf#page=264&zoom=100,116,876", "protocol=uri"

class
	PE_METHOD_SPEC_TABLE_ENTRY

inherit

	PE_TABLE_ENTRY_BASE
		redefine
			same_as
		end

create
	make_with_data

feature {NONE} -- Implementation

	make_with_data (a_method: PE_METHOD_DEF_OR_REF; a_instantiation: NATURAL_32)
		do
			method := a_method
			create instantiation.make_with_index (a_instantiation)
		end

feature -- Status

	same_as (e: like Current): BOOLEAN
			-- Is `e` same as `Current`?
			-- note: used to detect if an entry is already recorded.
			--| There shall be no duplicate rows based upon Method +I nstantiation.
		do
			Result := Precursor (e)
				or else (
					e.method.is_equal (method) and then
					e.instantiation.is_equal (instantiation)
				)
		end

feature -- Access

	method: PE_METHOD_DEF_OR_REF
			-- an index into the MethodDef or MemberRef table, specifying to which
			-- generic method this row refers; that is, which generic method this row is an
			-- instantiation of; more precisely, a MethodDefOrRef

	instantiation: PE_BLOB
			-- an index into the Blob heap
			-- holding the signature of this instantiation.

feature -- Operations

	table_index: NATURAL_32
		once
			Result := {PE_TABLES}.tMethodSpec
		end

	render (a_sizes: SPECIAL [NATURAL_32]; a_dest: ARRAY [NATURAL_8]): NATURAL_32
		local
			l_bytes: NATURAL_32
		do
			l_bytes := method.render (a_sizes, a_dest, 0)
			l_bytes := l_bytes + instantiation.render (a_sizes, a_dest, l_bytes)

			Result := l_bytes
		end

	rendering_size (a_sizes: SPECIAL [NATURAL_32]): NATURAL_32
		local
			l_bytes: NATURAL_32
		do
			l_bytes := method.rendering_size (a_sizes)
			l_bytes := l_bytes + instantiation.rendering_size (a_sizes)

			Result := l_bytes
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

