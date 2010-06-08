indexing
	description: "Summary description for {JS_OUTPUT_BUFFER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_OUTPUT_BUFFER

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize empty buffer.
		do
			reset
		end

feature -- Access

	string: !STRING
			-- Output string
		do
			if {l_string: STRING} buffer.string then
				Result := l_string
			end
		end

	indentation: !STRING
			-- String used for indentation

feature -- Element change

	set_indentation (a_string: !STRING)
			-- Set `indentation' to `a_string'.
		do
			indentation := a_string
		ensure
			indentation_set: indentation.is_equal (a_string)
		end

feature -- Basic operations

	reset
			-- Reset output buffer.
		do
			create buffer.make_empty
			create indentation.make_empty
		end

	put (a_string: STRING)
			-- Put `a_string' to output buffer.
		require
			a_string_not_void: a_string /= Void
		do
			buffer.put_string (a_string)
		end

	put_line (a_line: STRING)
			-- Put `a_line' to output buffer.
			-- The line is indented using `indentation' and a new line is appended.
		require
			a_line_not_void: a_line /= Void
		do
			buffer.put_string (indentation)
			buffer.put_string (a_line)
			buffer.put_new_line
		end

	put_comment_line (a_line: STRING)
			-- Put `a_line' to output buffer as a comment.
			-- The line is indented using `indentation' and a new line is appended.
		require
			a_line_not_void: a_line /= Void
		do
			buffer.put_string (indentation)
			buffer.put_string ("// ")
			buffer.put_string (a_line)
			buffer.put_new_line
		end

	put_new_line
			-- Put a new line to output buffer.
		do
			buffer.put_new_line
		end

	put_indentation
			-- Put a new line to output buffer.
		do
			buffer.put_string (indentation)
		end

	indent
			-- Increase indentation.
		do
			indentation.append_string ("%T")
		end

	unindent
			-- Decreasee indentation.
		do
			indentation.remove_tail (1)
		end

	append_lines (s: STRING)
			-- Append the newline-separated lines in `s'.
		local
			l: LIST [STRING]
		do
			if not s.is_equal ("") then
				s.right_adjust
				l := s.split ('%N')
				from
					l.start
				until
					l.off
				loop
					put_line(l.item)
					l.forth
				end
			end
		end

feature {NONE} -- Implementation

	buffer: KL_STRING_OUTPUT_STREAM
			-- Buffer that stores output

end
