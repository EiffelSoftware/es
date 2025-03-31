note
	description: "Summary description for {MD_ITERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MD_ITERATOR

inherit
	MD_VISITOR
		redefine
			visit_emitter,
			visit_table,
			visit_table_entry,
			visit_index,
			visit_coded_index,
			visit_pointer_index
		end

feature -- Access

	visit_emitter (o: MD_EMIT)
		do
			across
				o.pe_writer.tables as t
			loop
				if attached {MD_TABLE} t as tb then
					tb.accepts (Current)
				end
			end
			across
				o.pdb_writer.tables as t
			loop
				if attached {MD_TABLE} t as tb then
					tb.accepts (Current)
				end
			end
		end

	visit_table (o: MD_TABLE)
		do
			across
				o as e
			loop
				e.accepts (Current)
			end
		end

	visit_table_entry (o: PE_TABLE_ENTRY_BASE)
		do
		end

	visit_index (o: PE_INDEX_BASE)
		do
		end

	visit_coded_index (o: PE_CODED_INDEX_BASE)
		do
		end

	visit_pointer_index (o: PE_POINTER_INDEX)
		do
		end

feature {NONE} -- Helpers		

	safe_accepts (o: detachable MD_VISITABLE)
		do
			if o /= Void then
				o.accepts (Current)
			end
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

