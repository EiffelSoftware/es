note
	description: "{PR_DIRECTORY_CURSOR} wraps a NSPR directory handle."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

class
	PR_DIRECTORY_CURSOR

inherit
	PR_IO
	DISPOSABLE
	ITERATION_CURSOR [ESTRING_8]

create
	open,
	open_from_c

feature {NONE} -- Intialization
	open (a_path: ESTRING_8; a_skip_hidden: BOOLEAN)
		local
			l_cstring: C_STRING
		do
			l_cstring := a_path.to_c_string
			open_from_c (l_cstring.item, a_skip_hidden)
		ensure
			skip_hidden = a_skip_hidden
		end

	open_from_c (a_path: POINTER; a_skip_hidden: BOOLEAN)
		do
			handle := c.pr_opendir (a_path)
			if handle.is_default_pointer then
				set_error
			end
			skip_hidden := a_skip_hidden
		ensure
			skip_hidden = a_skip_hidden
		end

feature -- Access

	item: ESTRING_8

feature -- Status report	

	after: BOOLEAN

	skip_hidden: BOOLEAN assign set_skip_hidden

feature -- Status setting

	set_skip_hidden (a_value: BOOLEAN)
		do
			skip_hidden := a_value
		ensure
			skip_hidden = a_value
		end

feature -- Cursor movement

	forth
			-- Move to next position.
		local
			l_dirent: POINTER
			l_error: PR_ERROR
			l_strp: POINTER
		do
			if skip_hidden then
				l_dirent := c.PR_ReadDir (handle, c.pr_skip_dot + c.pr_skip_dot_dot + c.pr_skip_hidden)
			else
				l_dirent := c.PR_ReadDir (handle, c.pr_skip_dot + c.pr_skip_dot_dot)
			end
			if l_dirent.is_default_pointer then
				create l_error
				if l_error.code /= l_error.c.PR_NO_MORE_FILES_ERROR then
					set_error
				end
				after := True
			else
				create item.make_from_c (dereference(l_dirent))
			end
		end

feature {NONE} -- Implementation

	dispose
		local
			l_success: INTEGER
		do
			if not handle.is_default_pointer then
				l_success := c.pr_closedir (handle)
				create handle
			end
		end

	dereference (a_ptr: POINTER): POINTER
		external
			"C inline"
		alias
			"return *$a_ptr;"
		end

end
