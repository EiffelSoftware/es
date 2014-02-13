note
	description: "Summary description for {PR_FILE_INFO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PR_FILE_INFO

inherit
	PR_IO
	DISPOSABLE

create
	make,
	make_from_fd

feature {NONE} -- Initialization

	make (a_pathname: ESTRING_8)
		local
			l_cs: C_STRING
		do
			handle := handle.memory_alloc (sizeof_prfileinfo64)
			l_cs := a_pathname.to_c_string
			valid := -1 /= c.pr_getfileinfo64 (l_cs.item, handle)
			if not valid then
				set_error
			end
		end

	make_from_fd (a_fd: POINTER)
		do
			handle := handle.memory_alloc (sizeof_prfileinfo64)
			valid := -1 /= c.pr_getopenfileinfo64 (a_fd, handle)
			if not valid then
				set_error
			end
		end

feature -- Status report

	valid: BOOLEAN
		-- Is the information valid?

feature -- Access

	is_file: BOOLEAN
		require
			valid
		do
			Result := get_filetype (handle) = 1
		end

	is_directory: BOOLEAN
		require
			valid
		do
			Result := get_filetype (handle) = 2
		end

	size: NATURAL_64
		require
			valid
		do
			Result := get_size (handle)
		end

	creation_time: INTEGER_64
		require
			valid
		do
			Result := get_creation_time (handle)
		end

	modify_time: INTEGER_64
		require
			valid
		do
			Result := get_modify_time (handle)
		end

feature {NONE} -- Implementation
	dispose
		do
			if not handle.is_default_pointer then
				handle.memory_free
				create handle
				valid := False
			end
		end

	sizeof_prfileinfo64: INTEGER
		external
			"C inline use <nspr4/prio.h>"
		alias
			"return sizeof(PRFileInfo64);"
		end

	get_filetype (p: POINTER): INTEGER
		external
			"C inline use <nspr4/prio.h>"
		alias
			"return ((PRFileInfo64*)$p)->type;"
		end

	get_size (p: POINTER): NATURAL_64
		external
			"C inline use <nspr4/prio.h>"
		alias
			"return ((PRFileInfo64*)$p)->size;"
		end

	get_creation_time (p: POINTER): INTEGER_64
		external
			"C inline use <nspr4/prio.h>"
		alias
			"return ((PRFileInfo64*)$p)->creationTime;"
		end

	get_modify_time (p: POINTER): INTEGER_64
		external
			"C inline use <nspr4/prio.h>"
		alias
			"return ((PRFileInfo64*)$p)->modifyTime;"
		end
end
