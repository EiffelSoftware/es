note
	description: "Class to read snippets in a binary serialized format from a medium."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_BINARY_SNIPPET_READER

inherit
	EXT_SNIPPET_READER

feature -- Access

	last_snippet: detachable EXT_SNIPPET
			-- Snippet read by last `read'

feature -- Basic operations

	read (a_medium: IO_MEDIUM)
			-- Read snippets from `a_medium', make results
			-- available in `last_snippets'.
		local
			l_storable: STORABLE
		do
			create l_storable
			if attached {EXT_SNIPPET} l_storable.retrieved (a_medium) as l_snippet then
				last_snippet := l_snippet
			else
				last_snippet := Void
			end
		rescue
			last_snippet := Void
		end

	read_from_file (a_path: STRING)
			-- Read snippet from file whose absolute path
			-- is given by `a_path', make result
			-- available in `last_snippet'.
		local
			l_storable: STORABLE
		do
			create l_storable
			if attached {EXT_SNIPPET} l_storable.retrieve_by_name (a_path) as l_snippet then
				last_snippet := l_snippet
			else
				last_snippet := Void
			end
		rescue
			last_snippet := Void
		end

end
