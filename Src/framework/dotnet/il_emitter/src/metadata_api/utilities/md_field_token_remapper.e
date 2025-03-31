note
	description: "[
		Visitor to update metadata tables using Field token...
		
		Usage of Field token:
			TypeDef (Fields)
			CustomAttributes (Parent)
			Constant (Parent)
			FieldMarshal (Parent)
			ImplMap (MemberForwarded)
			FieldLayout (Not Used)
			FieldRVA (Not Used)
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MD_FIELD_TOKEN_REMAPPER

inherit
	MD_ITERATOR
		redefine
			visit_table,
			visit_table_entry,
			visit_index,
			visit_coded_index,
			visit_pointer_index
		end

create
	make,
	make_using_pointer_table

feature {NONE} -- Initialization

	make (a_remapper: MD_REMAP_TOKEN_MANAGER)
		do
			remapper := a_remapper
		end

	make_using_pointer_table (a_remapper: MD_REMAP_TOKEN_MANAGER)
		do
			remapper := a_remapper
			is_using_field_pointer_table := True
		end

feature -- Access

	remapper: MD_REMAP_TOKEN_MANAGER

	is_using_field_pointer_table: BOOLEAN
			-- Is using FieldPointer table?

feature -- Visitor

	visit_table (tb: MD_TABLE)
		do
			last_table_id := tb.table_id
			last_table_entry_index := 0
			if is_using_field_pointer_table then
					-- FIXME: review why some tables should be remapped, and other not. [2023-07-19]				
				inspect
					tb.table_id
				when
					{PE_TABLES}.ttypedef
--					, {PE_TABLES}.tcustomattribute -- EXCLUDED by experience
					, {PE_TABLES}.tconstant
--					, {PE_TABLES}.tfieldmarshal -- Not Implemented
--					, {PE_TABLES}.timplmap 		-- Not Implemented
--					, {PE_TABLES}.tfieldlayout 	-- Not Used
--					, {PE_TABLES}.tfieldrva    	-- Not Used
				then
					Precursor (tb)
				else
					-- Table not impacted
				end
			else
				inspect
					tb.table_id
				when
					{PE_TABLES}.ttypedef
					,{PE_TABLES}.tcustomattribute
					,{PE_TABLES}.tconstant
--					, {PE_TABLES}.tfieldmarshal -- Not Implemented
--					, {PE_TABLES}.timplmap 		-- Not Implemented
--					, {PE_TABLES}.tfieldlayout 	-- Not Used
--					, {PE_TABLES}.tfieldrva    	-- Not Used
				then
					Precursor (tb)
				else
					-- Table not impacted
				end
			end
		end

	last_table_id: NATURAL_32
	last_table_entry_index: NATURAL_32
	last_table_entry_token: NATURAL_32

	visit_table_entry (e: PE_TABLE_ENTRY_BASE)
		do
			last_table_entry_index := last_table_entry_index + 1
			last_table_entry_token := (last_table_id |<< 24) | last_table_entry_index

			if attached {PE_TYPE_DEF_TABLE_ENTRY} e as l_typedef then
				safe_accepts (l_typedef.fields)
			elseif attached {PE_CUSTOM_ATTRIBUTE_TABLE_ENTRY} e as l_ca then
				safe_accepts (l_ca.parent_index)
			elseif attached {PE_CONSTANT_TABLE_ENTRY} e as l_cst then
				safe_accepts (l_cst.parent_index)
--			elseif attached {PE_FIELD_MARSHAL_TABLE_ENTRY} e as l_fm then
--				safe_accepts (l_fm.parent_index)
			elseif attached {PE_IMPL_MAP_TABLE_ENTRY} e as l_impl then
				safe_accepts (l_impl.method_index)
			else
				Precursor (e)
			end
		end

	visit_index (idx: PE_INDEX_BASE)
		do
			remapper.remap_index (idx, {PE_TABLES}.tfield, last_table_entry_token)
		end

	visit_coded_index (idx: PE_CODED_INDEX_BASE)
		do
			remapper.remap_index (idx, {PE_TABLES}.tfield, last_table_entry_token)
		end

	visit_pointer_index (idx: PE_POINTER_INDEX)
		do
			remapper.remap_index (idx, {PE_TABLES}.tfield, last_table_entry_token)
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
