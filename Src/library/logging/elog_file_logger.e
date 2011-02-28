note
	description: "Logger which outputs messages to a file"
	author: "Jason Yi Wei"
	date: "$Date$"
	revision: "$Revision$"

class
	ELOG_FILE_LOGGER

inherit
	ELOG_LOGGER

	DISPOSABLE

create
	make,
	make_with_path

feature{NONE} -- Initialization

	make (a_file: like file)
			-- Initialize `file' with `a_file'.
		do
			file := a_file
			if not file.is_open_write then
				file.open_append
			end
		ensure
			file_set: file = a_file
		end

	make_with_path (a_path: STRING)
			-- Initialize `file' pointing to a location given
			-- by `a_path'.
		do
			create {PLAIN_TEXT_FILE} file.make_open_append (a_path)
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

feature -- Disposal

	dispose
			-- <Precursor>
		do
			if not file.is_closed then
				file.close
			end
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
