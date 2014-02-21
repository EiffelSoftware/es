note
	description: "{FILE_INPUT_STREAM} reads from a local file."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

class
	FILE_INPUT_STREAM

inherit
	INPUT_STREAM
		
		

create
	open

feature {NONE} -- Initialization
	open (a_path: ESTRING_8)
		do
			create fd.open_read (a_path)
		end

feature -- Access
	fd: PR_FILE_DESCRIPTOR

feature -- Status report
	is_closed: BOOLEAN
		do
			Result := not fd.is_readable
		end

feature -- Status setting
	close
		do
			fd.close
		end

feature -- Basic operation

	read_to_pointer (a_ptr: POINTER; a_count: INTEGER)
		do
			fd.read_to_pointer (a_ptr, a_count)
			bytes_read := fd.bytes_read
			if bytes_read = 0 then
				close
			end
		end
end
