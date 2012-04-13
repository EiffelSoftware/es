note
	description: "Summary description for {ITEM_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_ITEM_FACTORY

create
	make

feature -- Creation

	make
			-- standard creation, add all primitive types
		do

			primitive_types := create {LINKED_SET[STRING]}.make
			primitive_types.compare_objects

			primitive_types.put ("STRING_8")
			primitive_types.put ("STRING_32")
			primitive_types.put ("INTEGER_8")
			primitive_types.put ("INTEGER_16")
			primitive_types.put ("INTEGER_32")
			primitive_types.put ("INTEGER_64")
			primitive_types.put ("BOOLEAN")
			primitive_types.put ("NATURAL_8")
			primitive_types.put ("NATURAL_16")
			primitive_types.put ("NATURAL_32")
			primitive_types.put ("NATURAL_64")
			primitive_types.put ("REAL_32")
			primitive_types.put ("REAL_64")
			primitive_types.put ("CHARACTER")
			primitive_types.put ("CHARACTER_8")
			primitive_types.put ("CHARACTER_32")

		end



feature -- Access

	create_item (a_text: STRING; a_type: STRING;is_parent_cyclic:BOOLEAN) : EV_GRID_ITEM
			-- create either a EV_LABEL_ITEM, or a EDITABLE_PRIMITIVE_ITEM depending on the type
		do
			if is_primitive_type (a_type) and not is_parent_cyclic then
				Result := create {ES_EBBRO_EDITABLE_PRIMITIVE_ITEM}.make_with_text_and_type (a_text, a_type)
			else
				Result := create {EV_GRID_LABEL_ITEM}.make_with_text (a_text)
			end
		end


	is_primitive_type (a_type: STRING): BOOLEAN
			-- is a_type a primitive type? Note: here STRINGS are also handled as primitive types,
			-- though they are actually extended types
		do
			Result := primitive_types.has (a_type)
		end


feature {NONE} -- Implementation

	primitive_types: SET[STRING]

note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
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
