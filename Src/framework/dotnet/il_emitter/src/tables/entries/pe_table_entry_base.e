note
	description: "Base class for the metadata tables"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PE_TABLE_ENTRY_BASE

inherit
	PE_META_BASE

	MD_VISITABLE

feature -- Access

	table_index: NATURAL_32
		deferred
		end

feature -- Status

	token_from_table (tb: MD_TABLE): NATURAL_32
			-- If Current was already defined in `tb` return the associated token.
			-- It may not be implemented, this is mainly used to avoid duplicated entries.
		local
			n: NATURAL_32
		do
			n := 0
			across
				tb as i
			until
				Result /= {NATURAL_32} 0
			loop
				n := n + 1
				if
					attached {like Current} i as e and then
					same_as (e)
				then
					Result := n
				end
			end
		end

	same_as (e: like Current): BOOLEAN
			-- Is `e` same as `Current`?
			-- note: used to detect if an entry is already recorded.
		do
			Result := (e = Current)
		end

feature -- Operations

	render (a_sizes: SPECIAL [NATURAL_32]; a_dest: ARRAY [NATURAL_8]): NATURAL_32
			-- Write the Current table entry to the given destination buffer `a_dest`.
			-- and returns the number of bytes written to the buffer.
		deferred

		end

	rendering_size (a_sizes: SPECIAL [NATURAL_32]): NATURAL_32
			-- Bytes needed to `render` Current using the global information on MD table sizes `a_sizes`.
		deferred
		end

feature -- Visitor

	accepts (vis: MD_VISITOR)
		do
			vis.visit_table_entry (Current)
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
