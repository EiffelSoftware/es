note
	description: "Class to read snippets from a medium"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_SNIPPET_READER

inherit
	REFACTORING_HELPER

feature -- Access

	last_snippets: LINKED_LIST [EXT_SNIPPET]
			-- Snippet read by last `read'

feature -- Basic operations

	read (a_medium: IO_MEDIUM)
			-- Read snippets from `a_medium', make results
			-- available in `last_snippets'.
		do
			to_implement ("To implement.")
		end

	read_from_file (a_path: STRING)
			-- Read snippets from file whose absolute path
			-- is given by `a_path', make results
			-- available in `last_snippets'.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_open_read (a_path)
			read (l_file)
			l_file.close
		end

end
