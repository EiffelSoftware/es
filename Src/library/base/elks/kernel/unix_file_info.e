note
	description: "Internal file information"
	library: "Free implementation of ELKS library"
	copyright: "Copyright (c) 1986-2006, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class UNIX_FILE_INFO inherit

	TO_SPECIAL [CHARACTER]
		rename
			area as buffered_file_info,
			make_empty_area as make_buffered_file_info
		end

create

	make

feature -- Initialization

	make
			-- Creation procedure
		do
			make_filled_area ('%/000/', stat_size)
			is_following_symlinks := True
			exists := False
		ensure
			not_exists: not exists
			is_following_symlinks_set: is_following_symlinks
		end

feature -- Access

	protection: INTEGER
			-- Protection mode of file (12 lower bits)
		require
			exists: exists
		do
			Result := file_info ($buffered_file_info, 0)
		end

	type: INTEGER
			-- File type (4 bits, 12 lowest bits zeroed)
		require
			exists: exists
		do
			Result := file_info ($buffered_file_info, 11)
		end

	inode: INTEGER
			-- Inode number
		require
			exists: exists
		do
			Result := file_info ($buffered_file_info, 1)
		end

	size: INTEGER
			-- File size, in bytes
		require
			exists: exists
		do
			Result := file_info ($buffered_file_info, 6)
		end

	user_id: INTEGER
			-- UID of the file owner
		require
			exists: exists
		do
			Result := file_info ($buffered_file_info, 4)
		end

	group_id: INTEGER
			-- GID of the file
		require
			exists: exists
		do
			Result := file_info ($buffered_file_info, 5)
		end

	date: INTEGER
			-- Last modification date
		require
			exists: exists
		do
			Result := file_info ($buffered_file_info, 7)
		end

	access_date: INTEGER
			-- Date of last access
		require
			exists: exists
		do
			Result := file_info ($buffered_file_info, 8)
		end

	change_date: INTEGER
			-- Date of last status change
		require
			exists: exists
		do
			Result := file_info ($buffered_file_info, 9)
		end

	device: INTEGER
			-- Device number on which inode resides
		require
			exists: exists
		do
			Result := file_info ($buffered_file_info, 2)
		end

	device_type: INTEGER
			-- Device type on which inode resides
		require
			exists: exists
		do
			Result := file_info ($buffered_file_info, 3)
		end

	links: INTEGER
			-- Number of links
		require
			exists: exists
		do
			Result := file_info ($buffered_file_info, 10)
		end

	owner_name: STRING
			-- Name of the file owner, if available from /etc/passwd.
			-- Otherwise, the UID
		require
			exists: exists
		do
			Result := file_owner (user_id)
		end

	group_name: STRING
			-- Name of the file group, if available from /etc/group.
			-- Otherwise, the GID
		require
			exists: exists
		do
			Result := file_group (group_id)
		end

	file_name: detachable STRING
			-- File name to which information applies

feature -- Status report

	exists: BOOLEAN
			-- Does current file exists?

	is_following_symlinks: BOOLEAN
			-- Does current follow symbolic links when retrieving properties?

	is_plain: BOOLEAN
			-- Is file a plain file?
		require
			exists: exists
		do
			Result := file_info ($buffered_file_info, 13) /= 0
		end

	is_device: BOOLEAN
			-- Is file a device?
		require
			exists: exists
		do
			Result := file_info ($buffered_file_info, 14) /= 0
		end

	is_directory: BOOLEAN
			-- Is file a directory?
		require
			exists: exists
		do
			Result := file_info ($buffered_file_info, 12) /= 0
		end

	is_symlink: BOOLEAN
			-- Is file a symbolic link?
		require
			exists: exists
		do
			Result := file_info ($buffered_file_info, 18) /= 0
		end

	is_fifo: BOOLEAN
			-- Is file a named pipe?
		require
			exists: exists
		do
			Result := file_info ($buffered_file_info, 17) /= 0
		end

	is_socket: BOOLEAN
			-- Is file a named socket?
		require
			exists: exists
		do
			Result := file_info ($buffered_file_info, 19) /= 0
		end

	is_block: BOOLEAN
			-- Is file a device block special file?
		require
			exists: exists
		do
			Result := file_info ($buffered_file_info, 16) /= 0
		end

	is_character: BOOLEAN
			-- Is file a character block special file?
		require
			exists: exists
		do
			Result := file_info ($buffered_file_info, 15) /= 0
		end

	is_readable: BOOLEAN
			-- Is file readable by effective UID?
		require
			exists: exists
		do
			Result := file_eaccess ($buffered_file_info, 0)
		end

	is_writable: BOOLEAN
			-- Is file writable by effective UID?
		require
			exists: exists
		do
			Result := file_eaccess ($buffered_file_info, 1)
		end

	is_executable: BOOLEAN
			-- Is file executable by effective UID?
		require
			exists: exists
		do
			Result := file_eaccess ($buffered_file_info, 2)
		end

	is_setuid: BOOLEAN
			-- Is file setuid?
		require
			exists: exists
		do
			Result := file_eaccess ($buffered_file_info, 3)
		end

	is_setgid: BOOLEAN
			-- Is file setgid?
		require
			exists: exists
		do
			Result := file_eaccess ($buffered_file_info, 4)
		end

	is_sticky: BOOLEAN
			-- Is file sticky?
		require
			exists: exists
		do
			Result := file_eaccess ($buffered_file_info, 5)
		end

	is_owner: BOOLEAN
			-- Is file owned by effective UID?
		require
			exists: exists
		do
			Result := file_eaccess ($buffered_file_info, 6)
		end

	is_access_owner: BOOLEAN
			-- Is file owned by real UID?
		require
			exists: exists
		do
			Result := file_eaccess ($buffered_file_info, 7)
		end

	is_access_readable: BOOLEAN
			-- Is file readable by real UID?
		require
			file_name_attached: file_name /= Void
		local
			ext_name: ANY
			f: detachable STRING
		do
			f := file_name
			if f /= Void then
				ext_name := f.to_c
				Result := file_access ($ext_name, 3)
			end
		end

	is_access_writable: BOOLEAN
			-- Is file writable by real UID?
		require
			file_name_attached: file_name /= Void
		local
			ext_name: ANY
			f: detachable STRING
		do
			f := file_name
			if f /= Void then
				ext_name := f.to_c
				Result := file_access ($ext_name, 2)
			end
		end

	is_access_executable: BOOLEAN
			-- Is file executable by real UID?
		require
			file_name_attached: file_name /= Void
		local
			ext_name: ANY
			f: detachable STRING
		do
			f := file_name
			if f /= Void then
				ext_name := f.to_c
				Result := file_access ($ext_name, 1)
			end
		end

feature -- Element change

	update (f_name: STRING)
			-- Update information buffer: fill it in with information
			-- from the inode of `f_name'.
		local
			ext_name: ANY
		do
			ext_name := f_name.to_c
			exists := eif_file_stat ($ext_name, $buffered_file_info, is_following_symlinks) = 0
				-- Do not duplicate the file name. That way, if the file is
				-- renamed, the name here will change accordingly and access()
				-- based calls will continue to work properly.
			file_name := f_name
		end

	set_is_following_symlinks (v: BOOLEAN)
			-- Should `update' follow symlinks or not?
		do
			is_following_symlinks := v
		ensure
			is_following_symlinks_set: is_following_symlinks = v
		end

feature {NONE} -- Implementation

	stat_size: INTEGER
			-- Get size of 'struct stat' (in bytes)
		external
			"C use %"eif_file.h%""
		end

	file_stat (name, stat_buf: POINTER)
			-- Get information from file `name' into `stat_buf'
		obsolete
			"Obsoleted on 2011_04_12: Use `eif_file_stat' C external instead."
		external
			"C inline use %"eif_file.h%""
		alias
			"file_stat ((char *) $name, (struct stat *) $stat_buf);"
		end

	eif_file_stat (name, stat_buf: POINTER; follow_symlinks: BOOLEAN): INTEGER
			-- Get information from file `name' into `stat_buf'
		external
			"C inline use %"eif_file.h%""
		alias
			"return eif_file_stat ((char *) $name, (struct stat *) $stat_buf, (int) $follow_symlinks);"
		end

	file_access (f_name: POINTER; which: INTEGER): BOOLEAN
			-- Perform access test `which' on `f_name' using real ID.
		external
			"C signature (char *, EIF_INTEGER): EIF_BOOLEAN use %"eif_file.h%""
		end

	file_eaccess (stat_buf: POINTER; which: INTEGER): BOOLEAN
			-- Perform access tests using effective ID.
		external
			"C signature (struct stat *, int): EIF_BOOLEAN use %"eif_file.h%""
		end

	file_info (stat_buf: POINTER; which: INTEGER): INTEGER
			-- Extract information `which' from information buffer
		external
			"C signature (struct stat *, int): EIF_INTEGER use %"eif_file.h%""
		end

	file_owner (uid: INTEGER): STRING
			-- Convert UID to login name if possible
		external
			"C signature (int): EIF_REFERENCE use %"eif_file.h%""
		end

	file_group (gid: INTEGER): STRING
			-- Convert GID to group name if possible
		external
			"C signature (int): EIF_REFERENCE use %"eif_file.h%""
		end

end
