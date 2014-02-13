note
	description: "{PR_PATH} represents a directory."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

class
	PR_PATH

inherit
	PR_IO

create
	make

feature {NONE} -- Initialization
	make (a_path: ESTRING_8)
		do
			path := a_path
			cstring := path.to_c_string
			handle := cstring.item
		end

feature -- Access
	path: ESTRING_8

feature -- Basic Operations
	make_directory
		local
			l_status: INTEGER
		do
			l_status := c.pr_mkdir (handle, 0)
			if l_status = -1 then
				set_error
			end
		end

	delete_directory
		local
			l_status: INTEGER
		do
			l_status := c.pr_rmdir (handle)
			if l_status = -1 then
				set_error
			end
		end

	rename_file (a_new_name: ESTRING_8)
		local
			l_status: INTEGER
			l_newcstr: C_STRING
		do
			l_newcstr := a_new_name.to_c_string
			l_status := c.pr_rename (handle, l_newcstr.item)
			if l_status = -1 then
				set_error
			end
		end

	directory_listing (a_skip_hidden: BOOLEAN): PR_DIRECTORY_CURSOR
		do
			create Result.open (path, a_skip_hidden)
		end

	retrieve_file_info: PR_FILE_INFO
		do
			create Result.make (path)
		end

feature {NONE} -- Implementation
	cstring: C_STRING

end
