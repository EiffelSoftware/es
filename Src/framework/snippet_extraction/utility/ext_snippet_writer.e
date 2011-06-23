note
	description: "Class to write snippets into a medium."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_SNIPPET_WRITER

inherit
	REFACTORING_HELPER

feature -- Basic operations

	write (a_snippets: LINKED_LIST [EXT_SNIPPET]; a_medium: IO_MEDIUM)
			-- Write `a_snippets' into `a_medium'.
		do
			to_implement ("To implement.")
			across a_snippets as l_snippet_cursor loop
				if attached {EXT_SNIPPET} l_snippet_cursor.item as l_snippet then
					a_medium.put_string (l_snippet.source)
					a_medium.put_new_line
					a_medium.put_string (l_snippet.variable_context.debug_output)

					a_medium.put_string ("---%N---")
					a_medium.put_new_line
					a_medium.put_string (l_snippet.content)

					if attached l_snippet.content_original then
						a_medium.put_string ("---%N---")
						a_medium.put_new_line
						a_medium.put_string (l_snippet.content_original)
					end

					a_medium.put_new_line
					a_medium.put_new_line
					a_medium.put_new_line
				end
			end
		end

	write_to_file (a_snippets: LINKED_LIST [EXT_SNIPPET]; a_path: STRING)
			-- Write `a_snippets' to a file whose absolute path is given by `a_path'.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_create_read_write (a_path)
			write (a_snippets, l_file)
			l_file.close
		end

end
