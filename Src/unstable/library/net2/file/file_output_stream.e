note
	description: "A {FILE_OUTPUT_STREAM} writes to a local file."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

class
	FILE_OUTPUT_STREAM

inherit
	OUTPUT_STREAM
		
		

create
	open,
	open_create,
	append

feature {NONE} -- Initialization
	open (path: ESTRING_8)
		do
			create fd.open_write (path)
		end

	open_create (path: ESTRING_8)
		do
			create fd.create_write (path)
		end

	append (path: ESTRING_8)
		do
			create fd.append (path)
		end

feature -- Access
	fd: PR_FILE_DESCRIPTOR

feature -- Status report

	is_closed: BOOLEAN
		do
			Result := not fd.is_writable
		end

feature -- Status setting

	close
		do
			fd.close
		end

feature -- Basic operations

	put_pointer (a_ptr: POINTER; a_count: INTEGER)
		do
			fd.write_from_pointer (a_ptr, a_count)
		end

end
