note
	description: "Class that representing input data to Daikon"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DKN_INPUT_DATA


feature -- Basic operations

	to_medium (a_medium: IO_MEDIUM)
			-- Store Current into `a_medium' in text format.
		do
			a_medium.put_string (out)
		end

	to_file (a_path: STRING)
			-- Store Current into a file whose absolute path is given by `a_path'.
			-- Create a new file for `a_path'.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_create_read_write (a_path)
			to_medium (l_file)
			l_file.close
		end

end
