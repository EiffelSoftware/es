note
	description: "Summary description for {DADLE_DESERIALIZER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_DADL_DESERIALIZER

inherit
	ES_EBBRO_DESERIALIZER


create
	make


feature --creation

	make
			-- creation
		do
			create already_decoded.make (10)
		end

feature -- basic operations

	retrieve_object(a_medium:IO_MEDIUM)
			-- retrieve a object stored in the DADL format and store it in last decoded object.
		local
			l_obj: ANY
		--	l_dadl_dec: DADL_DECODED
			l_internal: INTERNAL
		do
			create l_internal
		--	l_obj := persistence_manager.format.retrieve (persistence_manager.medium)

		--	l_dadl_dec ?= l_obj
	--		if l_dadl_dec /= void then

	--			generate_displayable_object (l_dadl_dec)

	--		elseif l_obj /= void then
				--simple base type?
	--			generate_display_wrap (l_obj)
	--		else
	--			has_error := true
			--	error_message := persistence_manager.format.error_message
	--			last_decoded_object := void

	--		end

		end



feature -- actions

	on_user_file_open(file_name,file_path:STRING)
			-- user request to decode a object stored in file
		local
			l_text_file:PLAIN_TEXT_FILE
			retried:BOOLEAN
		do
			if not retried then
				create l_text_file.make(file_name)
				--l_text_file.open_read
			--	create persistence_manager.make(file_name)
				-- TODO: refactor, l_text_file never used by persistence_manager!
				retrieve_object(l_text_file)

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

--	persistence_manager: DADL_PERSISTENCE_MANAGER

feature {NONE} -- Display Helpers

	already_decoded:HASH_TABLE[ES_EBBRO_DISPLAYABLE,INTEGER] --dtype,count (dtype - key)
			-- objects which were already decoded


	generate_display_wrap(a_obj:ANY)
			-- generates a displayable object, which wrapps a base type object
		do
			create last_decoded_object.make_wrapping (a_obj.generating_type)
			last_decoded_object.set_is_wrapper
			last_decoded_object.set_wrapped_object (a_obj)
			last_decoded_object.set_format_id (dadl_format_id)
		end


--	generate_displayable_object (a_decoded: DADL_DECODED)
			-- generates the displayable root object
--		require
--			not_void: a_decoded /= void
--		do
--			last_decoded_object := convert_object(a_decoded)
--			last_decoded_object.set_format_id (dadl_format_id)
--			already_decoded.wipe_out
--		ensure
--			not_void: last_decoded_object /= void
--		end


--	convert_object(a_obj:DADL_DECODED):ES_EBBRO_DISPLAYABLE
--			-- converts a decoded object into a displayable object
--		require
--			not_void: a_obj /= void
--		local
--			l_attr:ARRAYED_LIST [TUPLE [object: ANY; name: STRING_8]]
--			l_obj:ES_EBBRO_DISPLAYABLE
--			l_dec:DADL_DECODED
--			l_dtype:INTEGER
--		do
--			l_dtype := a_obj.dtype
--			if not already_decoded.has(l_dtype) then
--				create l_obj.make (a_obj.name, a_obj)
--				already_decoded.put (l_obj, l_dtype)
--
--				if a_obj.is_tuple then
--					l_obj.set_is_tuple
--				elseif a_obj.is_special then
--					l_obj.set_is_container
--				elseif a_obj.name.index_of ('[',1) > 0 then
--					l_obj.set_is_container
--				end

--				l_attr := a_obj.attribute_values.twin()
--				if a_obj.has_non_base_type_attr then
--					from
--						l_attr.start
--					until
--						l_attr.after
--					loop
			--			l_dec ?= l_attr.item.object
			--			if  l_dec /= void then
			--				l_obj.insert_attr (l_attr.item.name, convert_object(l_dec))
			--			else
			--				l_obj.insert_attr_tuple (l_attr.item)
			--			end
--						l_attr.forth
--					end
--				else
--					l_obj.insert_attr_seq (a_obj.attribute_values)
--				end

--				result := l_obj
--			else
--				result := already_decoded.item (l_dtype)
--			end
--		end


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
