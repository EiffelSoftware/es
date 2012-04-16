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
		local
			l_transformer: EXT_TEXT_SNIPPET_TRANSFORMER
			l_output: ETR_AST_STRING_OUTPUT
		do
			a_medium.put_string (a_snippet.source.out)
			a_medium.put_new_line
			a_medium.put_string (a_snippet.variable_context.debug_output)

			a_medium.put_string ("---%N---")
			a_medium.put_new_line
			create l_output.make
			create l_transformer.make_with_output (l_output)
			l_transformer.transform (a_snippet)
			a_medium.put_string (l_output.string_representation)

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
