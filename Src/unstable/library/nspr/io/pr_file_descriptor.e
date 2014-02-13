note
	description: "{PR_FILE_DESCRIPTOR} wraps a file descriptor to provide useful features."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

class
	PR_FILE_DESCRIPTOR

inherit
	DISPOSABLE

create {NONE}
	make_from_pointer

create
	open_read,
	open_write,
	open_rw,
	append,
	create_write,
	create_rw

feature {NONE} -- Initialization
	make_from_pointer (a_fd: POINTER)
		do
			fd := a_fd
		ensure
			fd = a_fd
		end

	open (a_path: ESTRING_8; a_flags, a_mode: INTEGER)
		local
			l_cstring: C_STRING
		do
			l_cstring := a_path.to_c_string
			fd := c.pr_open (l_cstring.item, a_flags, a_mode)
		end

	open_read (a_path: ESTRING_8)
			-- Open for reading only.
		do
			open (a_path, c.PR_OPEN_RDONLY, 0)
			if fd.is_default_pointer then
				create error
			else
				is_readable := True
			end
		ensure
			attached error xor is_readable and not is_closed
		end

	open_write (a_path: ESTRING_8)
			-- Open for writing only.
		do
			open (a_path, c.PR_OPEN_WRONLY, 0)
			if fd.is_default_pointer then
				create error
			else
				is_writable := True
			end
		ensure
			attached error xor is_writable and not is_closed
		end

	open_rw (a_path: ESTRING_8)
			-- Open for reading and writing.
		do
			open (a_path, c.PR_OPEN_RDWR, 0)
			if fd.is_default_pointer then
				create error
			else
				is_readable := True
				is_writable := True
			end
		ensure
			attached error xor is_writable and not is_closed
			attached error xor is_readable and not is_closed
		end

	append (a_path: ESTRING_8)
			-- The file pointer is set to the end of the file prior to each write.
		do
			open (a_path, c.PR_OPEN_APPEND, 0)
			if fd.is_default_pointer then
				create error
			else
				is_writable := True
			end
		ensure
			attached error xor is_writable and not is_closed
		end

	create_write (a_path: ESTRING_8)
			-- Open for writing only. If the file does not exist, the file is created.
		do
			open (a_path, c.PR_OPEN_WRONLY, 0)
			if fd.is_default_pointer then
				create error
			else
				is_writable := True
			end
		ensure
			attached error xor is_writable and not is_closed
		end

	create_rw (a_path: ESTRING_8)
			-- Open for reading and writing. If the file does not exist, the file is
			-- created.
		do
			open (a_path, c.PR_OPEN_RDWR, 0)
			if fd.is_default_pointer then
				create error
			else
				is_readable := True
				is_writable := True
			end
		ensure
			attached error xor is_writable and not is_closed
			attached error xor is_readable and not is_closed
		end

feature -- Access
	fd: POINTER

feature -- Status report
	use_exceptions: BOOLEAN assign set_use_exceptions

	error: detachable PR_ERROR

	is_closed: BOOLEAN
		do
			Result := fd.is_default_pointer
		end

	is_readable: BOOLEAN

	is_writable: BOOLEAN

feature -- Status setting
	set_use_exceptions (a_val: BOOLEAN)
		do
			use_exceptions := a_val
		ensure
			use_exceptions = a_val
		end

	close
			-- Close the file descriptor
		do
			dispose
		end

	detach
			-- Detach  the file descriptor from Eiffel, leaving it perpetually open.
		require
			not is_closed
		do
			create fd
			is_readable := False
			is_writable := False
		ensure
			is_closed
		end

feature -- Input
	read_to_pointer (a_ptr: POINTER; a_count: INTEGER_32)
		-- Read data and put it in memory where `a_ptr' points to. The amount of data read is
		-- available from `bytes_read'.
		require
			not a_ptr.is_default_pointer
			a_count > 0
			not is_closed
		local
			l_error: PR_ERROR
			l_amount: INTEGER_32
		do
			error := Void

			l_amount := c.pr_read (fd, a_ptr, a_count)

			if l_amount = -1 then
				create error.make
				if use_exceptions then
					(create {PR_EXCEPTION}.make).raise
				end
			else
				bytes_read := l_amount
			end
		ensure
			bytes_read <= a_count
		end

	bytes_read: INTEGER

feature -- Output
	write_from_pointer (a_ptr: POINTER; a_count: INTEGER_32)
		-- Write `a_count' bytes of data from where `a_ptr' points to.
		require
			not a_ptr.is_default_pointer
			a_count > 0
			not is_closed
		local
			l_error: PR_ERROR
			l_amount: INTEGER_32
		do
			error := Void

			l_amount := c.pr_write (fd, a_ptr, a_count)

			if l_amount = -1 then
				create error.make
				if use_exceptions then
					(create {PR_EXCEPTION}.make).raise
				end
			end
		end

feature {NONE} -- Implementation
	c: PR_IO_C

	dispose
		local
			l_status: INTEGER
		do
			if not fd.is_default_pointer then
				l_status := c.pr_close (fd)
				create fd
				is_readable := False
				is_writable := False
			end
		end

end
