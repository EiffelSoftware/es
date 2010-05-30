note
	description: "Logger which outputs messages into a file"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_FILE_LOGGER

inherit
	EPA_LOGGER

create
	make

feature{NONE} -- Initialization

	make (a_file: like file)
			-- Initialize `file' with `a_file'.
		do
			file := a_file
		ensure
			file_set: file = a_file
		end

feature -- Access

	file: FILE
			-- File where messaged are output

feature -- Access

	put_string (a_string: STRING)
			-- Log `a_string'.
		do
			file.put_string (a_string)
			file.flush
		end

end
