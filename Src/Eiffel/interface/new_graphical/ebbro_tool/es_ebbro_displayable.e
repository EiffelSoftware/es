indexing
	description: "An object which was deserialized and can be displayed by an ebbro grid."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_DISPLAYABLE

create
	--make,
	make_wrapping

feature -- creation

--	make (a_class_name:STRING; a_decoded:GENERAL_DECODED) is
			-- init
--		require
--			class_name_not_void: a_class_name /= void
--			a_decoded_not_void: a_decoded /= Void
--		do
--			class_name := a_class_name
--			original_decoded := a_decoded
--			create attributes.make(10)
--			create history.make
--		end

	make_wrapping (a_class_name:STRING) is
			-- wrap a base type
		require
			class_name_not_void: a_class_name /= void
		do
			class_name := a_class_name
			create attributes.make(10)
			set_is_wrapper
			create history.make
		end



feature -- access

	attributes:ARRAYED_LIST[TUPLE[object:ANY;name:STRING]]
			-- actual values/objects of attributes

	class_name:STRING
			-- name of class

	is_tuple:BOOLEAN
			-- is a tuple

	is_container:BOOLEAN
			-- is a container type

	is_wrapper:BOOLEAN
			-- just a wrapper for a base type object

	wrapped_object:ANY
			-- object which is wrapped

--	original_decoded: GENERAL_DECODED
			-- 'DECODED' object which was converted to this 'DISPLAYABLE' object.

	is_cyclic:BOOLEAN
			-- flag which is set when cyclic browsing is enabled, and this displayable object is cyclic
			-- meaining that this object is already displayed and is now displayed again...

	format_id:INTEGER
			-- format id - which corresponds to the format (dADL,binary...)

	history:ES_EBBRO_EDIT_HISTORY
			-- edit history of this object


feature -- basic operation

	set_is_cyclic is
			-- sets the cyclic flag
		do
			is_cyclic := true
		end

	set_format_id(a_id:INTEGER) is
			-- sets the format id to a_id
		do
			format_id := a_id
		end


	set_wrapped_object(an_obj:ANY) is
			-- sets the wrapped object
		require
			not_void: an_obj /= void
		do
			wrapped_object := an_obj
		end

	set_is_wrapper is
			-- sets the wrapper flag
		do
			is_wrapper := true
		end

	insert_attr_seq(a_seq:SEQUENCE[TUPLE[ANY,STRING]]) is
			-- insert a whole attribute sequence
		require
			not_void: a_seq /= void
		do
			attributes.append (a_seq)
		end

	insert_attr(a_name:STRING;a_object:ANY) is
			-- insert a single attribute
		require
			not_void: a_name /= void
		local
			tuple:TUPLE[object:ANY;name:STRING]
		do
			create tuple
			tuple.put (a_object, 1)
			tuple.put (a_name,2)
			attributes.extend(tuple)
		end

	insert_attr_tuple(a_tuple:TUPLE[ANY,STRING]) is
			-- insert a tuple (a_object,attr_name)
		require
			not_void: a_tuple /= void
		do
			attributes.extend(a_tuple)
		end

	attr_cout:INTEGER is
			-- returns the actual number of attributes to display
		do
			result := attributes.count
		end

	set_is_tuple is
			-- is representing a tuple type
		do
			is_tuple := true
		end

	set_is_container is
			-- is representing a container structure
		do
			is_container := true
		end

	reset_history is
			-- reset the history
		do
			history.reset
		end



indexing
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
