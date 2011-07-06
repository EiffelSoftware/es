note
	description: "Class to write snippets into a medium in a textual readable format."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_TEXTUAL_SNIPPET_WRITER

inherit
	EXT_SNIPPET_WRITER

feature -- Basic operations

	write (a_snippet: EXT_SNIPPET; a_medium: IO_MEDIUM)
			-- Write `a_snippet' into `a_medium'.
		do
			a_medium.put_string (a_snippet.source)
			a_medium.put_new_line
			a_medium.put_string (a_snippet.variable_context.debug_output)

			a_medium.put_string ("---%N---")
			a_medium.put_new_line
			a_medium.put_string (a_snippet.content)

			if attached a_snippet.content_original then
				a_medium.put_string ("---%N---")
				a_medium.put_new_line
				a_medium.put_string (a_snippet.content_original)
			end
		end

	write_to_file (a_snippet: EXT_SNIPPET; a_path: STRING)
			-- Write each of `a_snippets' to a file whose absolute path is given by `a_path'.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_create_read_write (a_path)
			write (a_snippet, l_file)
			l_file.close
		end

end
