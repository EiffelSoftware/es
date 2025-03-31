note
	description: "[
			Hash utilities.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	MD_HASH_UTILITIES

feature -- Hash SHA1

	sha1_string_for_file (a_file: FILE): STRING_8
			-- Compute the SHA-1 hash of a file `a_file' and return it as a string.
		local
			sha: SHA1
			b: BOOLEAN
		do
			debug ("il_emitter")
				print ("sha1 of " + a_file.path.utf_8_name + " (count:"+ a_file.count.out +") -> %N")
				{MD_DBG_CHRONO}.start ("sha1_string_for_file")
			end
			b := {ISE_RUNTIME}.check_assert (False)
			create sha.make
			sha.update_from_io_medium (a_file)
			Result := sha.digest_as_string
			sha.reset
			b := {ISE_RUNTIME}.check_assert (b)
			debug ("il_emitter")
				{MD_DBG_CHRONO}.stop ("sha1_string_for_file")
				print ({MD_DBG_CHRONO}.report_line ("sha1_string_for_file"))
				{MD_DBG_CHRONO}.remove ("sha1_string_for_file")
			end
		ensure
			class
		end

	sha1_bytes_for_file (a_file: FILE): ARRAY [NATURAL_8]
			-- Compute the SHA-1 hash of a file `a_file' and return it as a bytes.
		local
			l_converter: BYTE_ARRAY_CONVERTER
		do
			create l_converter.make_from_string (sha1_string_for_file (a_file))
			Result := l_converter.to_natural_8_array
		ensure
			class
		end

	sha1_string_for_file_name (a_file_name: READABLE_STRING_GENERAL): STRING_8
			-- Compute the SHA-1 hash of a file `a_file_name' and return it as a string.
		local
			f: RAW_FILE
		do
			create f.make_open_read (a_file_name)
			Result := sha1_string_for_file (f)
			f.close
		ensure
			class
		end

	sha1_bytes_for_file_name (a_file_name: READABLE_STRING_GENERAL): ARRAY [NATURAL_8]
			-- Compute the SHA-1 hash of a file `a_file_name' and return it as a bytes.
		local
			f: RAW_FILE
		do
			create f.make_open_read (a_file_name)
			Result := sha1_bytes_for_file (f)
			f.close
		ensure
			class
		end

feature -- Hash SHA256

	sha256_string_for_file (a_file: FILE): STRING_8
			-- Compute the SHA-256 hash of a file `a_file' and return it as a string.
		local
			sha: SHA256
			b: BOOLEAN
		do
			debug ("il_emitter")
				print ("sha256 of " + a_file.path.utf_8_name + " (count:"+ a_file.count.out +") -> %N")
				{MD_DBG_CHRONO}.start ("sha256_string_for_file")
			end
			b := {ISE_RUNTIME}.check_assert (False)
			create sha.make
			sha.update_from_io_medium (a_file)
			Result := sha.digest_as_hexadecimal_string.as_lower
			sha.reset
			b := {ISE_RUNTIME}.check_assert (b)
			debug ("il_emitter")
				{MD_DBG_CHRONO}.stop ("sha256_string_for_file")
				print ({MD_DBG_CHRONO}.report_line ("sha256_string_for_file"))
				{MD_DBG_CHRONO}.remove ("sha256_string_for_file")
			end
		ensure
			class
		end

	sha256_bytes_for_file (a_file: FILE): ARRAY [NATURAL_8]
			-- Compute the SHA-256 hash of a file `a_file' and return it as a bytes.
		local
			l_converter: BYTE_ARRAY_CONVERTER
		do
			create l_converter.make_from_hex_string (sha256_string_for_file (a_file))
			Result := l_converter.to_natural_8_array
		ensure
			class
		end

	sha256_string_for_file_name (a_file_name: READABLE_STRING_GENERAL): STRING_8
			-- Compute the SHA-256 hash of a file `a_file_name' and return it as a string.
		local
			f: RAW_FILE
		do
			create f.make_open_read (a_file_name)
			Result := sha256_string_for_file (f)
			f.close
		ensure
			class
		end

	sha256_bytes_for_file_name (a_file_name: READABLE_STRING_GENERAL): ARRAY [NATURAL_8]
			-- Compute the SHA-256 hash of a file `a_file_name' and return it as a bytes.
		local
			f: RAW_FILE
		do
			create f.make_open_read (a_file_name)
			Result := sha256_bytes_for_file (f)
			f.close
		ensure
			class
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
