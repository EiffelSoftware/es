note
	description: "Object which was decoded."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BINARY_DECODED

inherit
	GENERAL_DECODED 


create make

feature -- creation

	make(an_old_dtype,new_dtype:INTEGER;a_class_name:STRING)
			-- init with old dtype and a new dtype and a class name
		do
			generic_type := an_old_dtype
			dtype := new_dtype
			create attribute_values.make(10)
			create attribute_names.make
			create attribute_generic_types.make (10)
			has_non_base_type_attr := false
			name := a_class_name
			is_tuple := false
			is_special := false
			special_count := 0
			if a_class_name.has ('[') then
				is_generic := true
			end
		end

feature --access


	special_type: INTEGER
			-- special type

	attribute_generic_types: ARRAYED_LIST[TUPLE[dtype: INTEGER; name: STRING]]
			-- types for each attribute, required if the actual attribute is void

	header_tuple_array:HASH_TABLE[STRING,INTEGER]
			-- holds type_strings and old dtypes of original header in binary file
			-- is only set, if this is a root_object

feature -- basic operations

	set_header_tuple(a_table:HASH_TABLE[STRING,INTEGER])
			-- sets the header tuple
		require
			not_void: a_table /= void
			not_empty: not a_table.is_empty()
		do
			header_tuple_array := a_table
		end

	insert_actual_attribute(a_name:STRING;a_object:ANY; a_generic_type: INTEGER)
			-- insert an attribute
		require
			not_void: a_name /= void
		local
			tuple_value:TUPLE[object:ANY;name:STRING]
			tuple_type: TUPLE[gen_type:INTEGER;name:STRING]
			dummy:BINARY_DECODED
		do
			create tuple_value
			tuple_value.put (a_object, 1)
			tuple_value.put (a_name,2)

			create tuple_type
			tuple_type.put (a_generic_type, 1)
			tuple_type.put (a_name, 2)

			attribute_values.put_front(tuple_value)
			--attribute_values.extend (tuple_value)
			attribute_names.extend (a_name)
			attribute_generic_types.put_front(tuple_type)
			--attribute_generic_types.extend (tuple_type)
			dummy ?= a_object
			if  dummy /= void then
				has_non_base_type_attr := true
			end

		end



	set_special_type (a_dtype: INTEGER)
			-- sets the special type
		do
			special_type := a_dtype
		end


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
