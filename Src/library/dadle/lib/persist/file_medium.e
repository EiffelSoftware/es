indexing
	description: "Summary description for {FILE_MEDIUM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FILE_MEDIUM

inherit
	PERSISTENCE_MEDIUM

create
	make

feature -- Initialization

	make (a_file_name:STRING)
		require
			a_file_name_exists:a_file_name /= Void
		do
			create raw_file.make (a_file_name)
			file_name:=a_file_name
		ensure
			raw_file_exists: raw_file /=Void
			file_name_set: file_name = a_file_name
		end

feature -- Access

	raw_file: RAW_FILE
	file_name: STRING

feature -- Status report

	exists: BOOLEAN
		do
			Result:= raw_file.exists
		end

feature -- Basic operations

	reopen_write (a_file_name:STRING)
			-- reopens the file named 'a_file_name' for writing
		require
			a_file_name_exists:a_file_name /= Void
		do
			raw_file.reopen_write (a_file_name)
		end

	open_write
			-- opens the current file for writing
		require
			a_file_to_open_exists:raw_file /= Void
		do
			raw_file.open_write
		end

	open_read
			-- opens the current file for reading
		do
			raw_file.open_read
		end

	close
			-- closes file
		do
			raw_file.close
		end

end
