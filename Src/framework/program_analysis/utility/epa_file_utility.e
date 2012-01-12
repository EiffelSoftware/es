note
	description: "Utilities for file management"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_FILE_UTILITY

feature -- Basic operations

	copy_file (a_file_name: STRING; a_source_folder: STRING; a_destination_folder: STRING)
			-- Copy file named `a_file_name' from `a_source_folder' to `a_destination_folder'.
		local
			l_source_path: FILE_NAME
			l_source_file: PLAIN_TEXT_FILE
			l_dest_path: FILE_NAME
			l_dest_file: PLAIN_TEXT_FILE
		do
			create l_source_path.make_from_string (a_source_folder)
			l_source_path.set_file_name (a_file_name)

			create l_dest_path.make_from_string (a_destination_folder)
			l_dest_path.set_file_name (a_file_name)

			create l_source_file.make_open_read (l_source_path)
			create l_dest_file.make_create_read_write (l_dest_path)
			l_source_file.copy_to (l_dest_file)
			l_source_file.close
			l_dest_file.close
		end

	base_eiffel_file_name_from_full_path (a_full_path: STRING): STRING
			-- File base name from its full path.
		local
			l_reg: RX_PCRE_REGULAR_EXPRESSION
		do
			create l_reg.make
			l_reg.compile ("([^/\\]+).e$")
			l_reg.match (a_full_path)
			check l_reg.has_matched then
				Result := l_reg.captured_substring (1)
			end
		end

end
