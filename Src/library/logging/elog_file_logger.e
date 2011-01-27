note
	description: "Logger which outputs messages to a file"
	author: "Jason Yi Wei"
	date: "$Date$"
	revision: "$Revision$"

class
	ELOG_FILE_LOGGER

inherit
	ELOG_LOGGER

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
			-- Log file where messages are output.

feature -- Basic Operations.

	put_string (a_string: STRING)
			-- Log `a_string'.
		do
			file.put_string (a_string)
			file.flush
		end

--	put_string_with_level (a_string: STRING; a_level: INTEGER)
			-- Log `a_string' with `a_level'.
--		local
--			l_str: STRING
--		do
--			create l_str.make (a_string.count + 32)
--			l_str.append ("[" + logging_level_as_string (a_level) + "] ")
--			l_str.append (a_string)
--			file.put_string (l_str)
--			file.flush
--		end
end
