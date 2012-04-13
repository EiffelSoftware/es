note
	description: "Facility for decoding used by the binary deserializer"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_DECODE_FACILITY

inherit
	SED_STORABLE_FACILITIES
		redefine
			retrieved
		end
create
	make

feature --init

	make
			-- init
		do
			has_error := false
			has_information := false
		end


feature -- access

	has_information:BOOLEAN
			-- has information to display to the user

	info_message:STRING
			-- message to display to user

	has_error:BOOLEAN
			-- error occured

	error_message:STRING
			-- provided error message for user

	last_header_tuple:HASH_TABLE[STRING,INTEGER]
			-- last header tuple of decoded binary file




feature -- implementation constants

	eiffel_session_store_msg:STRING = "Decoding objects stored via eiffel session store mechanism is not supported."

	eiffel_basic_store_msg:STRING = "Decoding objects stored via eiffel basic store mechanism is not supported."

	unknown_type_msg:STRING = "Unknown serialization type of object.%NSupported type is eiffel independent object storage."

feature -- basic operations


	retrieved (a_reader: SED_READER_WRITER; a_is_gc_enabled: BOOLEAN): ANY
			-- Deserialization of object from `a_reader'.
			-- Garbage collection will be enabled if `a_is_gc_enabled'.
		require else
			a_reader_not_void: a_reader /= Void
			a_reader_ready: a_reader.is_ready_for_reading
		local
			l_deserializer: ES_EBBRO_TYPE_INDEPENDENT_DESERIALIZER
			l_has_error: BOOLEAN
		do
			a_reader.read_header
			--l_int := a_reader.read_natural_32
			inspect
				a_reader.read_natural_32
			when eiffel_session_store then
				has_information := true
				create info_message.make_from_string(eiffel_session_store_msg)
				l_has_error := True
			when eiffel_basic_store then
				has_information := true
				create info_message.make_from_string(eiffel_basic_store_msg)
				l_has_error := True
			when eiffel_independent_store then
				create l_deserializer.make(a_reader)
			else
				-- Incorrect type
				l_has_error := True
				create error_message.make_from_string(unknown_type_msg)
			end


			if not l_has_error then
				l_deserializer.decode (a_is_gc_enabled)
				if not l_deserializer.has_error then
					Result := l_deserializer.last_decoded_object
					last_header_tuple := l_deserializer.last_header_tuple
					a_reader.read_footer
				end
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
