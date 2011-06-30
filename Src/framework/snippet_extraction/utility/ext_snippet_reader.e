note
	description: "Interface to read snippets from a medium."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EXT_SNIPPET_READER

feature -- Access

	last_snippet: EXT_SNIPPET
			-- Snippet read by last `read'
		deferred
		end

feature -- Basic operations

	read (a_medium: IO_MEDIUM)
			-- Read snippets from `a_medium', make results
			-- available in `last_snippets'.
		deferred
		end

	read_from_file (a_path: STRING)
			-- Read snippet from file whose absolute path
			-- is given by `a_path', make result
			-- available in `last_snippet'.
		deferred
		end

end
