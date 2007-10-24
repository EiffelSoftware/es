indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CDD_PRINTER

feature {NONE} -- Basic class text output

	append_text (a_text: STRING) is
			-- Append 'a_text' to 'output_file'.
		require
			file_writable: output_file /= Void
			a_text_not_void: a_text /= Void
		do
			output_file.put_string (a_text)
		end

	append_instruction (a_text: STRING) is
			-- Append 'a_text' to 'output_file' with correct indentation.
		require
			file_writable: output_file /= Void
			a_text_not_void: a_text /= Void
		do
			append_text (indent + a_text + "%N")
		end

	append_comment (a_text: STRING) is
			-- Append 'a_text' to 'output_file' as comment with correct indentation.
		require
			file_writable: output_file /= Void
			a_text_not_void: a_text /= Void
		do
			append_text (indent + "%T-- " + a_text + "%N")
		end

feature {NONE} -- Implementation

	indent: STRING is "%T%T%T"
			-- Indentation for instruction text

	output_file: KL_OUTPUT_FILE
			-- File class text is written

invariant
	correct_output_file_status: output_file /= Void implies output_file.is_open_write

end
