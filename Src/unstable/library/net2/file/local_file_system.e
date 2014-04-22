note
	description: "{LOCAL_FILE_SYSTEM} is the file system containing the local disks."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

class
	LOCAL_FILE_SYSTEM

inherit
	FILE_SYSTEM

create {FILE_SYSTEM_ACCESS}
	default_create

feature
	exists (a_path: EPATH): BOOLEAN
		local
			l_path: C_STRING
		do
			error := error.no_error
			create l_path.make (a_path.internal)
			Result := c.pr_access (l_path.item, c.pr_access_exists) = {PR_CONSTANTS}.pr_success
		end

--	file_type (a_path: EPATH): FILE_TYPE
--		do
--			-- Todo
--			check false end
--		end

	open_read (a_path: EPATH): separate INPUT_STREAM
		do
			create {separate FILE_INPUT_STREAM} Result.open (a_path.internal)
		end

	open_write (a_path: EPATH): separate OUTPUT_STREAM
		do
			create {separate FILE_OUTPUT_STREAM} Result.open (a_path.internal)
		end

	move (a_old_path, a_new_path: EPATH)
		-- Moves the file denoted by `a_old_path' to `a_new_path'
		local
			l_old, l_new: C_STRING
			l_error: PR_ERROR
		do
			error := error.no_error
			create l_old.make (a_old_path.internal)
			create l_new.make (a_new_path.internal)
			if c.pr_rename (l_old.item, l_new.item) = {PR_CONSTANTS}.pr_failure then
				create l_error.make
				error := error.from_nspr (l_error)
			end

		end

feature {NONE} -- Implementation
	c: PR_IO_C

end
