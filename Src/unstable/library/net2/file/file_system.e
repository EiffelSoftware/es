note
	description: "{FILE_SYSTEM} represents a local or remote file hierarchy."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	FILE_SYSTEM

feature -- Access
	exists (a_path: EPATH): BOOLEAN
		-- Does the file denoted by `a_path' exist?
		deferred
		end

--	file_type (a_path: EPATH): FILE_TYPE
--		-- The type of `a_path'
--		deferred
--		end

	open_read (a_path: EPATH): separate INPUT_STREAM
		-- Opens the file denoted by `a_path' for reading
		deferred
		end

	open_write (a_path: EPATH): separate OUTPUT_STREAM
		-- Opens the file denoted by `a_path' for writing
		deferred
		end

	move (a_old_path, a_new_path: EPATH)
		-- Moves the file denoted by `a_old_path' to `a_new_path'
		deferred
		end

	error: IO_ERROR
end
