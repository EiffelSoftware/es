note
	description: "{PR_IO_C} is a wrapper around NSPR I/O functions."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	PR_IO_C

feature -- Network Addresses
	PR_InitializeNetAddr(val: NATURAL; port: NATURAL_16; addr: POINTER): INTEGER
		external
			"C use <nspr4/prnetdb.h>"
		alias
			"PR_InitializeNetAddr"
		end

	PR_StringToNetAddr(string, addr: POINTER): INTEGER
		external
			"C use <nspr4/prnetdb.h>"
		alias
			"PR_StringToNetAddr"
		end

	PR_NetAddrToString(addr, string: POINTER; size: INTEGER_32): INTEGER
		external
			"C use <nspr4/prnetdb.h>"
		alias
			"PR_NetAddrToString"
		end

	PR_GetHostByName(hostname, buf: POINTER; bufsize: INTEGER; hostentry: POINTER): INTEGER
		external
			"C use <nspr4/prnetdb.h>"
		alias
			"PR_GetHostByName"
		end

	PR_GetHostByAddr(hostaddr, buf: POINTER; bufsize: INTEGER; hostentry: POINTER): INTEGER
		external
			"C use <nspr4/prnetdb.h>"
		alias
			"PR_GetHostByAddr"
		end

	PR_EnumerateHostEnt(enumIndex: INTEGER; hostEnt: POINTER; port: NATURAL_16; address: POINTER): INTEGER
		external
			"C use <nspr4/prnetdb.h>"
		alias
			"PR_EnumerateHostEnt"
		end

feature -- Sockets
	PR_OpenTCPSocket (af: INTEGER): POINTER
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_OpenTCPSocket"
		end

	PR_Connect (fd, addr: POINTER; timeout: NATURAL_64): INTEGER
		external
			"C blocking use <nspr4/prio.h>"
		alias
			"PR_Connect"
		end


	PR_Bind (fd, addr: POINTER): INTEGER
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_Bind"
		end

	PR_Listen (fd: POINTER; backlog: INTEGER): INTEGER
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_Listen"
		end

	PR_Accept (fd, addr: POINTER; timeout: NATURAL_64): POINTER
		external
			"C blocking use <nspr4/prio.h>"
		alias
			"PR_Accept"
		end

	PR_Recv (fd, buf: POINTER; amount: INTEGER_32; flags: INTEGER; timeout: NATURAL_64): INTEGER_32
		external
			"C blocking use <nspr4/prio.h>"
		alias
			"PR_Recv"
		end

	PR_Send (fd, buf: POINTER; amount: INTEGER_32; flags: INTEGER; timeout: NATURAL_64): INTEGER_32
		external
			"C blocking use <nspr4/prio.h>"
		alias
			"PR_Send"
		end

	PR_Shutdown (fd: POINTER; how: INTEGER): INTEGER
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_Shutdown"
		end

	PR_Close (fd: POINTER): INTEGER
			-- The file descriptor may represent a normal file, a socket, or an end point of a pipe.
			-- On successful return, `PR_Close' frees the dynamic memory and other resources identified
			-- by the `fd' parameter.
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_Close"
		end

	PR_GetSocketOption (fd, data: POINTER): INTEGER
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_GetSocketOption"
		end

feature -- Operations that work on path names
	PR_Open (name: POINTER; flags, mode: INTEGER): POINTER
			-- Creates a file descriptor (PRFileDesc) for the file with the pathname
			-- `name' and sets the file status flags of the file descriptor according
			-- to the value of `flags'. If a new file is created as a result of the
			-- `PR_Open' call, its file mode bits are set according to the `mode' parameter.
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_Open"
		end

	-- Flags
	PR_OPEN_RDONLY: INTEGER = 		0x01
		-- Open for reading only.
	PR_OPEN_WRONLY: INTEGER = 		0x02
		-- Open for writing only.
	PR_OPEN_RDWR: INTEGER =  		0x04
		-- Open for reading and writing.
	PR_OPEN_CREATE_FILE: INTEGER = 	0x08
		-- If the file does not exist, the file is created. If the file exists,
		-- this flag has no effect.
	PR_OPEN_APPEND: INTEGER =	 	0x10
		-- The file pointer is set to the end of the file prior to each write.
	PR_OPEN_TRUNCATE: INTEGER =  	0x20
		-- If the file exists, its length is truncated to 0.
	PR_OPEN_SYNC: INTEGER =		 	0x40
		-- If set, each write will wait for both the file data and file status
		-- to be physically updated.
	PR_OPEN_EXCL: INTEGER =		 	0x80
		-- With PR_CREATE_FILE, if the file does not exist, the file is created.
		-- If the file already exists, no action and NULL is returned.

	PR_GetFileInfo64 (fn, info: POINTER): INTEGER
			-- Stores information about the file with the specified pathname in the
			-- PRFileInfo64 structure pointed to by `info'.
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_GetFileInfo64"
		end

	PR_Delete (name: POINTER): INTEGER
			-- Deletes a file with the specified pathname `name'. If the function fails,
			-- the error code can then be retrieved via `PR_GetError'.
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_Delete"
		end

	PR_Rename (a_from, a_to: POINTER): INTEGER
			-- Renames a file from its old name (`a_from') to a new name (`a_to'). If a
			-- file with the new name already exists, `PR_Rename' fails with the error
			-- code `PR_FILE_EXISTS_ERROR'. In this case, `PR_Rename' does not overwrite
			-- the existing filename.
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_Rename"
		end

	PR_Access (name: POINTER; how: INTEGER): INTEGER
			-- Determines the accessibility of a file.
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_Access"
		end

	PR_ACCESS_EXISTS: INTEGER = 1
	PR_ACCESS_WRITE_OK: INTEGER = 2
	PR_ACCESS_READ_OK: INTEGER = 3

feature -- Operations on file descriptors
	PR_Read (fd, buf: POINTER; amount: INTEGER_32): INTEGER
			-- The thread invoking `PR_Read' blocks until it encounters an end-of-stream
			-- indication, some positive number of bytes (but no more than `amount' bytes)
			-- are read in, or an error occurs.
		external
			"C blocking use <nspr4/prio.h>"
		alias
			"PR_Read"
		end

	PR_Write (fd, buf: POINTER; amount: INTEGER_32): INTEGER
			-- The thread invoking `PR_Write' blocks until all the data is written or the
			-- write operation fails. Therefore, the return value is equal to either
			-- `amount' (success) or -1 (failure). Note that if `PR_Write' returns -1, some
			-- data (less than `amount' bytes) may have been written before an error
			-- occurred.
		external
			"C blocking use <nspr4/prio.h>"
		alias
			"PR_Write"
		end

	PR_GetOpenFileInfo64 (fd, info: POINTER): INTEGER
			-- Obtains the file type (normal file, directory, or other), file size
			-- (as a 64-bit integer), and the creation and modification times of the
			-- open file represented by the file descriptor.
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_GetOpenFileInfo64"
		end

	PR_Seek64 (fd: POINTER; offset: INTEGER_64; whence: INTEGER): INTEGER_64
			-- Moves the current read-write file pointer by an `offset' expressed as a 64-bit
			-- integer.
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_Seek64"
		end

	PR_SEEK_SET: INTEGER = 0
			-- Sets the file pointer to the value of the `offset' parameter.
	PR_SEEK_CUR: INTEGER = 1
			-- Sets the file pointer to its current location plus the value of the
			-- `offset' parameter.
	PR_SEEK_END: INTEGER = 2
			-- Sets the file pointer to the size of the file plus the value of the
			-- `offset' parameter.

	PR_Available64 (fd: POINTER): INTEGER_64
			-- Determines the number of bytes that are available for reading beyond the current
			-- read-write pointer in a specified file or socket.
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_Available64"
		end

	PR_Sync (fd: POINTER): INTEGER
			-- Synchronizes any buffered data for a file descriptor to its backing device (disk).
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_Sync"
		end

feature -- Directories
	PR_OpenDir (name: POINTER): POINTER
			-- Opens the directory specified by the pathname `name' and returns a pointer to a
			-- directory stream (a PRDir object) that can be passed to subsequent `PR_ReadDir'
			-- calls to get the directory entries (files and subdirectories) in the directory.
			-- The PRDir pointer should eventually be closed by a call to `PR_CloseDir'.
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_OpenDir"
		end

	PR_ReadDir (dir: POINTER; flags: INTEGER): POINTER
			-- Gets a pointer to the next entry in the directory.
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_ReadDir"
		end

	PR_SKIP_NONE: INTEGER    = 0x0
	PR_SKIP_DOT: INTEGER     = 0x1
	PR_SKIP_DOT_DOT: INTEGER = 0x2
	PR_SKIP_BOTH: INTEGER    = 0x3
	PR_SKIP_HIDDEN: INTEGER  = 0x4

	PR_CloseDir (dir: POINTER): INTEGER
			-- Closes the specified directory.
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_CloseDir"
		end

	PR_MkDir (name: POINTER; mode: INTEGER): INTEGER
			-- Creates a directory with a specified `name' and access `mode'.
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_MkDir"
		end

	PR_RmDir (name: POINTER): INTEGER
			-- Removes a directory with a specified `name'.
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_RmDir"
		end
end
