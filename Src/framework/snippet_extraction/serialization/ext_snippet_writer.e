note
	description: "Interface to write snippets into a medium."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EXT_SNIPPET_WRITER

feature -- Basic operations

	write (a_snippet: EXT_SNIPPET; a_medium: IO_MEDIUM)
			-- Write `a_snippet' into `a_medium'.
		deferred
		end

	write_to_file (a_snippet: EXT_SNIPPET; a_path: STRING)
			-- Write each of `a_snippets' to a file whose absolute path is given by `a_path'.
		deferred
		end

end
