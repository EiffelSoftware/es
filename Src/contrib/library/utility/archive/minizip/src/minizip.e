note
	description: "[
			Zip directory and Unzip archive
			
			note: based on the miniz lib (https://github.com/richgel999/miniz)
			
			Miniz is a lossless, high performance data compression library in a single source file that implements the zlib (RFC 1950)
			and Deflate (RFC 1951) compressed data format specification standards. 
			It supports the most commonly used functions exported by the zlib library, but is a completely independent implementation 
			so zlib's licensing requirements do not apply. Miniz also contains simple to use functions for writing .PNG format image files 
			and reading/writing/appending .ZIP format archives. Miniz's compression speed has been tuned to be comparable to zlib's, 
			and it also has a specialized real-time compressor function designed to compare well against fastlz/minilzo.
		]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Miniz source", "protocol=URI", "src=https://github.com/richgel999/miniz"

class
	MINIZIP

feature -- Basic operations

	zip_to (dir: PATH; archive: PATH; a_output: detachable FILE)
			-- Zip directory `dir` to `archive` location.
			-- Any output will be written to `a_output` if set.
		local
			d: DIRECTORY
			cs1,cs2: C_STRING
			res: INTEGER
			l_output_ptr: POINTER
		do
			create d.make_with_path (dir)
			if d.exists then
				create cs1.make (dir.name)
				create cs2.make (archive.name)
				if a_output /= Void then
					l_output_ptr := a_output.file_pointer
				end
				res := zip_directory (cs1.item, cs2.item, l_output_ptr)
			end
		ensure
			class
		end

	unzip_into (archive: PATH; dir: PATH; a_output: detachable FILE)
			-- Unzip archive `archive` into directory `dir` location.
			-- Any output will be written to `a_output` if set.	
		local
			d: DIRECTORY
			cs1,cs2: C_STRING
			res: INTEGER
			l_output_ptr: POINTER
		do
			create cs1.make (archive.name)
			create cs2.make (dir.name)
			if a_output /= Void then
				l_output_ptr := a_output.file_pointer
			end
			res := unzip_archive (cs1.item, cs2.item, l_output_ptr)
		ensure
			class
		end

feature {NONE} -- Implementation		

	zip_directory (a_directory_path: POINTER; a_zip_file_path: POINTER; a_output: POINTER): INTEGER
			-- External call to library zip command.
		external
			"C inline use %"eif_miniz.h%""
		alias
			"zip_directory((const char*) $a_directory_path, (const char*) $a_zip_file_path, (FILE*) $a_output)"
		end

	unzip_archive (a_zip_file_path: POINTER; a_directory_path: POINTER; a_output: POINTER): INTEGER
			-- External call to library unzip command.
		external
			"C inline use %"eif_miniz.h%""
		alias
			"unzip_archive((const char*) $a_zip_file_path, (const char*) $a_directory_path, (FILE*) $a_output)"
 		end

note
	copyright: "Copyright (c) 1984-2025, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
