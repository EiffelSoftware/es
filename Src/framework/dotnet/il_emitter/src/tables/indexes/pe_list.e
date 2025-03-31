note
	description: "Define a type of possible index type that occur in the tables we are interested in."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PE_LIST

inherit
	PE_INDEX_BASE
		redefine
			make_with_index,
			update_index,
			has_index_overflow,
			is_ready_for_render,
			debug_output
		end

feature {NONE} -- Initialization

	make_with_index (a_index: NATURAL_32)
		do
			Precursor (a_index)
			is_list_index_set := True
			is_null_index := index = 0
		ensure then
			is_list_index_set
		end

	make_default
		do
			make_with_index (default_index)
			is_list_index_set := False
			is_null_index := True
		end

feature -- Access

	associated_table_index: NATURAL_32
		deferred
		end

	default_index: NATURAL_32 = 1
			-- Index value for uninitialized `index`.

feature -- Operations

	update_index (idx: like index)
		do
			Precursor (idx)
			is_list_index_set := True
			is_null_index := idx = 0
		ensure then
			is_list_index_set
		end

	update_missing_index (idx: like index)
		do
			update_index (idx)
			is_null_index := True
		ensure then
			is_list_index_set
		end

	set_null_index
		do
			is_list_index_set := False
			is_null_index := True
			index := 0
		end

feature -- Status report

	is_null_index: BOOLEAN

	is_list_index_set: BOOLEAN
			-- Is first index of Current list set ?

	is_ready_for_render: BOOLEAN
		do
			Result := Precursor and is_list_index_set
		end

	debug_output: STRING
		do
			Result := Precursor
			if not is_list_index_set then
				Result := Result + "?"
			end
		end

feature -- Access

	has_index_overflow (a_sizes: SPECIAL [NATURAL_32]): BOOLEAN
		do
			Result := large (a_sizes, associated_table_index)
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
