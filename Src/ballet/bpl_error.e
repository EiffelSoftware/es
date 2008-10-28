indexing
	description: "An error reported by Ballet"
	author: "Bernd Schoeller and others"
	date: "$Date$"
	revision: "$Revision$"

class
	BPL_ERROR

inherit

	ERROR
		redefine
			out
		end

create

	make

feature{NONE} -- Initialization

	make (a_text:STRING) is
			-- Create an error message with `a_text' as message
		do
			message := a_text
		ensure
			text_set: message = a_text
		end

feature -- Access

	message: STRING
			-- Error message

	code: STRING_8 is
			-- Code error
		once
			Result := "BALLET"
		end

	file_name: STRING
			-- Path to file involved in error.
			-- Could be Void if not a file specific error.

	out: STRING_8 is
		do
			Result := "[["+message+"]]"
		end

feature -- Features from ERROR

	build_explain (a_text_formatter: TEXT_FORMATTER)
			-- Build specific explanation image for current error
			-- in `error_window'.
		do
			-- TODO
		end

	print_error_message (a_text_formatter: TEXT_FORMATTER) is
			-- Print the error message.
		do
			a_text_formatter.add (error_string)
			a_text_formatter.add (" code: ")
			a_text_formatter.add_error (Current, code)
			a_text_formatter.add (" (")
			a_text_formatter.add_int (line)
			a_text_formatter.add (",")
			a_text_formatter.add_int (column)
			a_text_formatter.add (")")
			a_text_formatter.add_new_line
			a_text_formatter.add (message)
			a_text_formatter.add_new_line
		end

feature -- Visitor

	process (a_visitor: ERROR_VISITOR) is
		do
			a_visitor.process_error (Current)
		end

end
