note
	description: "Object deserializes objects stored via the eiffel binary serialization mechanism."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_BINARY_DESERIALIZER

inherit
	ES_EBBRO_DESERIALIZER

create
	make

feature -- init

	make
			-- creation
		do
			create store_handler.make
			create already_decoded.make (10)
		end



feature -- basic operations

	retrieve_object(medium:IO_MEDIUM)
			-- retrieve object which was stored by independent serialization mechanism
		local
			l_obj:ANY
		do
			create serializer.make(medium)
			serializer.set_for_reading
			l_obj ?= store_handler.retrieved (serializer, false)
			decoded_object ?= l_obj
			if decoded_object /= void then
				decoded_object.set_header_tuple (store_handler.last_header_tuple)
				generate_displayable_object
			elseif l_obj /= void then
				-- really simple base type was stored -> wrap it into a displayable object
				generate_display_wrap(l_obj)
			else
				if store_handler.has_error and store_handler.error_message /= void then
					has_error := true
					error_message := store_handler.error_message
				elseif store_handler.has_information and store_handler.info_message /= void then
					has_information := true
					info_message := store_handler.info_message
				else
					has_error := true
				end

				last_decoded_object := void
			end
		end

	on_user_file_open(file_name,file_path:STRING)
			-- user request to decode a object stored in file
		local
			l_raw_file:RAW_FILE
			retried:BOOLEAN
		do
			if not retried then
				create l_raw_file.make(file_name)
				l_raw_file.open_read
				retrieve_object(l_raw_file)
				if last_decoded_object /= void and not has_error and not has_information then
					on_object_decoded
				else
					if has_information and info_message /= void then
						on_information
					elseif has_error and error_message /= void then
						on_decode_error
					else
						has_error := true
						create error_message.make_from_string (default_error_string)
						on_decode_error
					end
				end
			end
			clean_up
		rescue
			retried := true
			has_error := true
			create error_message.make_from_string (default_error_string)
			on_decode_error
			retry
		end


feature {NONE} -- Implementation

	store_handler: ES_EBBRO_DECODE_FACILITY
			-- decode facility

	serializer: SED_MEDIUM_READER_WRITER
			-- serializer

	decoded_object:BINARY_DECODED
			-- decoded root object

feature {NONE} -- Display Helpers

	already_decoded:HASH_TABLE[ES_EBBRO_DISPLAYABLE,INTEGER] --dtype,count (dtype - key)
			-- objects which were already decoded

	generate_display_wrap(a_obj:ANY)
			-- generates a displayable object, which wrapps a base type object
		do
			create last_decoded_object.make_wrapping (a_obj.generating_type)
			last_decoded_object.set_is_wrapper
			last_decoded_object.set_wrapped_object (a_obj)
			last_decoded_object.set_format_id(binary_format_id)
		end


	generate_displayable_object
			-- generates the displayable root object
		require
			not_void: decoded_object /= void
		do
			last_decoded_object := convert_object(decoded_object)
			last_decoded_object.set_format_id (binary_format_id)
			already_decoded.wipe_out
		ensure
			not_void: last_decoded_object /= void
		end

	convert_object(a_obj:GENERAL_DECODED):ES_EBBRO_DISPLAYABLE
			-- converts a decoded object into a displayable object
		require
			not_void: a_obj /= void
		local
			l_attr:ARRAYED_LIST [TUPLE [object: ANY; name: STRING_8]]
			l_obj:ES_EBBRO_DISPLAYABLE
			l_dec:BINARY_DECODED
			l_dtype:INTEGER
		do
			l_dtype := a_obj.dtype
			if not already_decoded.has(l_dtype) then
				create l_obj.make (a_obj.name, a_obj)
				already_decoded.put (l_obj, l_dtype)

				if a_obj.is_tuple then
					l_obj.set_is_tuple
				elseif a_obj.is_special then
					l_obj.set_is_container
				elseif a_obj.name.index_of ('[',1) > 0 then
					l_obj.set_is_container
				end

				l_attr := a_obj.attribute_values.twin()
				if a_obj.has_non_base_type_attr then
					from
						l_attr.start
					until
						l_attr.after
					loop
						l_dec ?= l_attr.item.object
						if  l_dec /= void then
							l_obj.insert_attr (l_attr.item.name, convert_object(l_dec))
						else
							l_obj.insert_attr_tuple (l_attr.item)
						end
						l_attr.forth
					end
				else
					l_obj.insert_attr_seq (a_obj.attribute_values)
				end

				result := l_obj
			else
				result := already_decoded.item (l_dtype)
			end
		end

note
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
