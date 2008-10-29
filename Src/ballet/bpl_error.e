indexing
	description: "An error reported by Ballet"
	author: "Bernd Schoeller and others"
	date: "$Date$"
	revision: "$Revision$"

class
	BPL_ERROR

inherit
	COMPILER_ERROR
		redefine
			out,
			trace,
			trace_single_line,
			trace_primary_context
		end

create
	make

feature{NONE} -- Initialization

	make (a_text:STRING) is
			-- Create an error message with `a_text' as message
		do
				-- TODO: this should be an argument
			short_error_message := "Internal error"
			message := a_text
		ensure
			text_set: message = a_text
		end

feature -- Access

	short_error_message: STRING
			-- Short error message

	message: STRING
			-- Error message

	code: STRING_8 is "Ballet"
			-- Error code

	file_name: STRING
			-- Path to file involved in error.
			-- Could be Void if not a file specific error.

feature -- Output

	trace (a_text_formatter: TEXT_FORMATTER) is
			-- Display full error message in `a_text_formatter'.
		do
			a_text_formatter.add_error (Current, code)
			a_text_formatter.add (":")
			a_text_formatter.add_space
			a_text_formatter.add (short_error_message)
			a_text_formatter.add_new_line

			build_explain (a_text_formatter)
		end

	trace_single_line (a_text_formatter: TEXT_FORMATTER) is
			-- Display short error, single line message in `a_text_formatter'.
		do
			a_text_formatter.add_error (Current, code)
			a_text_formatter.add (":")
			a_text_formatter.add_space
			a_text_formatter.add (short_error_message)
		end

	trace_primary_context (a_text_formatter: TEXT_FORMATTER) is
			-- Build the primary context string so errors can be navigated to
		do
			if has_associated_file then
				a_text_formatter.add (file_name)
			else
				a_text_formatter.add ("context")
			end
		end

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
			a_text_formatter.add (message)
			a_text_formatter.add_new_line
		end

end
