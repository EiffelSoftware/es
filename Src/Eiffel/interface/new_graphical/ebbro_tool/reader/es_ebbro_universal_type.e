note
	description: "Description of an universal type of an object. Attribute names, types..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_UNIVERSAL_TYPE

create
	make

feature -- creation

	make(an_old_dtype:INTEGER;a_class_name:STRING)
			-- init generic type
		do
			old_dtype := an_old_dtype
			name := a_class_name
			create attributes.make(10)
		end

feature -- access

	old_dtype:INTEGER
			-- data type identifier in system which stored this object

	name:STRING
			-- name of class

	attributes:ARRAYED_LIST[TUPLE[INTEGER,STRING]]
			-- attributes (old_dtype,attr_name)

feature -- basic operations


	insert_attribute(a_dtype:INTEGER;a_name:STRING)
			-- insert an attribute
		local
			tuple:TUPLE[INTEGER,STRING]
		do
			create tuple
			tuple.put_integer (a_dtype, 1)
			tuple.put(a_name,2)
			attributes.extend(tuple)
		end

	attribute_count:INTEGER 
			-- how many attributes
		do
			result := attributes.count
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
