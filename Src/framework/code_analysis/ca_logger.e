note
	description: "Writes to a log file."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_LOGGER

create
	make

feature {NONE} -- Initialization

	make (a_file_name: STRING)
			-- Initialization for `Current'. The logger will write to the file with name
			-- `a_file_name'.
		do
			create output_file.make_open_write (a_file_name)
			file_open := True
		ensure
			file_open
		end

feature -- Logging

	log (a_log_string: STRING)
			-- Writes `a_log_string' to the log file. A new line will be
			-- added automatically afterwards.
		require
			file_open
		do
			output_file.putstring (a_log_string + "%N")
		end

	close_log
			-- Closes the log file and forbids any further logging. (Non-reversible. Create
			-- new log class with same file name in order to append there again.)
		require
			file_open
		do
			output_file.close
			file_open := False
		ensure
			not file_open
		end

			-- Is the log file still open?
	file_open: BOOLEAN

feature {NONE} -- Implementation

			-- The file the log is written to.
	output_file: PLAIN_TEXT_FILE

end
