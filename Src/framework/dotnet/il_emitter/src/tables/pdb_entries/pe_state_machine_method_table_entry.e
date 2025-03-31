note
	description: "[
					Class describing the StateMachineMethod table.
					The StateMachineMethod table has several columns and specific requirements.
			
					The table is required to be sorted by MoveNextMethod column.
					There shall be no duplicate rows in the StateMachineMethod table, based upon MoveNextMethod.
					There shall be no duplicate rows in the StateMachineMethod table, based upon KickoffMethod.
		]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=StateMachineMethod", "src=https://github.com/dotnet/runtime/blob/main/docs/design/specs/PortablePdb-Metadata.md#statemachinemethod-table-0x36", "protocol=uri"

class
	PE_STATE_MACHINE_METHOD_TABLE_ENTRY

inherit
	PE_TABLE_ENTRY_BASE
		redefine
			same_as
		end

create
	make_with_data

feature {NONE} -- Implementation

	make_with_data (a_move_next_method_row_id: NATURAL_32; a_kickoff_method_row_id: NATURAL_32)
		do
			create move_next_method_row_id.make_with_tag_and_index ({PE_METHOD_DEF_OR_REF}.methoddef, a_move_next_method_row_id)
			create kickoff_method_row_id.make_with_tag_and_index ({PE_METHOD_DEF_OR_REF}.methoddef,a_kickoff_method_row_id)
		end

feature -- Status

	same_as (e: like Current): BOOLEAN
			-- Is `e` same as `Current`?
			-- note: used to detect if an entry is already recorded.
			--| There shall be no duplicate rows in the StateMachineMethod table, based upon MoveNextMethod.

		do
			Result := Precursor (e)
				or else (
					e.move_next_method_row_id.is_equal (move_next_method_row_id) and then
					e.kickoff_method_row_id.is_equal (kickoff_method_row_id)
				)
		end

feature -- Access

	move_next_method_row_id: PE_METHOD_DEF_OR_REF
			-- MethodDef row id.

	kickoff_method_row_id: PE_METHOD_DEF_OR_REF
			-- MethodDef row id.

feature -- Operations

	table_index: NATURAL_32
		once
			Result := {PDB_TABLES}.tStateMachineMethod
		end

	render (a_sizes: SPECIAL [NATURAL_32]; a_dest: ARRAY [NATURAL_8]): NATURAL_32
			-- <Precursor>
		local
			l_bytes_written: NATURAL_32
		do
				-- Initialize the number of bytes written to 0
			l_bytes_written := 0

				-- Render the move_next_method_row_id and add the number of bytes written to l_bytes_written
			l_bytes_written := l_bytes_written + move_next_method_row_id.render (a_sizes, a_dest, l_bytes_written)

				-- Render the kickoff_method_row_id and add the number of bytes written to l_bytes_written
			l_bytes_written := l_bytes_written + kickoff_method_row_id.render (a_sizes, a_dest, l_bytes_written)

				-- Return the total number of bytes written
			Result := l_bytes_written
		end

	rendering_size (a_sizes: SPECIAL [NATURAL_32]): NATURAL_32
			-- <Precursor>
		local
			l_bytes: NATURAL_32
		do
				-- Initialize the number of bytes read to 0
			l_bytes := 0

				-- Read the move_next_method_row_id
			l_bytes := l_bytes + move_next_method_row_id.rendering_size (a_sizes)

				-- Read the kickoff_method_row_id
			l_bytes := l_bytes + kickoff_method_row_id.rendering_size (a_sizes)

				-- Return the total number of bytes read
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
