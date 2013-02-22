note
	description: "Objects that decides which serialization mechanism to use, then serializes an object to a file"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_ENCODE_FACILITY

inherit
	ES_EBBRO_PERSISTENCE_CONSTANTS

create
	make


feature -- creation

	make(a_controller: ES_EBBRO_CONTROLLER)
			-- create a new ENCODE_FACILITY with a controller
		do
			controller := a_controller
			controller.encoding_object_actions.extend (agent on_encode_object(?,?,?,?))
		end



feature -- Implementation

	controller: ES_EBBRO_CONTROLLER

feature -- basic operations

	serialize_object(a_displayable: ES_EBBRO_DISPLAYABLE;a_format:INTEGER; a_filename:STRING; a_filepath:STRING)
			-- write an object back to the file with all updated fields
		require
			a_displayable_not_void: a_displayable /= Void
			a_filename_not_void: a_filename /= Void
		local
			l_writer: SED_MEDIUM_READER_WRITER
			l_file: RAW_FILE
			l_type_ind_ser: ES_EBBRO_TYPE_INDEPENDENT_SERIALIZER
			l_store_handler: SED_STORABLE_FACILITIES
	--		l_dadl_persistence_manager: DADL_PERSISTENCE_MANAGER

		do
			-- use independent store mechanism
			create l_file.make_create_read_write (a_filename)
			l_file.open_write
			create l_writer.make (l_file)
			create l_store_handler
			--l_writer.set_for_writing
			--l_writer.set_is_pointer_value_stored (true)

			--we have a regular object, so use the TYPE_INDEPENDENT_SERIALIZER
			create l_type_ind_ser.make (l_writer)
			check
				l_writer.is_ready_for_writing
			end

			if a_displayable.is_wrapper then
				-- object that was displayed is attached as a standard object, so serialize it directly
				if a_format = binary_format_id then
					l_store_handler.independent_store (a_displayable.wrapped_object, l_writer, false)
		--		elseif a_format = dadl_format_id then

		--			create l_dadl_persistence_manager.make(a_filename)
		--			l_dadl_persistence_manager.serialize_type_information(true)
		--			l_dadl_persistence_manager.format.store (a_displayable.wrapped_object, l_dadl_persistence_manager.medium)
				else
					check
						unknown_format:false
					end
				end

			else
				if a_format = binary_format_id and then attached {BINARY_DECODED} a_displayable.original_decoded as l_bin_dec then
			--	if a_format = binary_format_id and then {l_bin_dec:BINARY_DECODED} a_displayable.original_decoded then
					-- object that was displayed is attached as a `BINARY_DECODED' object, use the `TYPE_INDEPENDENT_SERIALIZER'

					l_writer.write_header
					l_writer.write_natural_32 ({SED_STORABLE_FACILITIES}.eiffel_independent_store)

					l_type_ind_ser.set_root_object (l_bin_dec)
					l_type_ind_ser.encode
					l_writer.write_footer
--				elseif a_format = dadl_format_id then
--
--					create l_dadl_persistence_manager.make(a_filename)
--					l_dadl_persistence_manager.serialize_type_information(true)
--					l_dadl_persistence_manager.format.store (a_displayable.original_decoded, l_dadl_persistence_manager.medium)
				else
					check
						false
					end
				end
			end
			l_file.close
		end


feature -- Actions for Controller

	on_encode_object(a_displayable: ES_EBBRO_DISPLAYABLE;a_format:INTEGER; a_filename:STRING; a_filepath:STRING)
			-- encode an object
		do
			serialize_object(a_displayable,a_format, a_filename, a_filepath)
		end

note
	copyright: "Copyright (c) 1984-2013, Eiffel Software"
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
