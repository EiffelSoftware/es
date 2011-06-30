note
	description: "Class to write snippets into a medium in a binary serialized format."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_BINARY_SNIPPET_WRITER

inherit
	EXT_SNIPPET_WRITER

feature -- Basic operations

	write (a_snippet: EXT_SNIPPET; a_medium: IO_MEDIUM)
			-- Write `a_snippet' into `a_medium'.
		do
			a_snippet.independent_store (a_medium)
		end

	write_to_file (a_snippet: EXT_SNIPPET; a_path: STRING)
			-- Write each of `a_snippets' to a file whose absolute path is given by `a_path'.
		do
			a_snippet.store_by_name (a_path)
		end

end
