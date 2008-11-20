indexing
	description:
		"[
			TODO
		]"
	date: "$Date$"
	revision: "$Revision$"

deferred class EP_ERROR

inherit

	FEATURE_ERROR
		export
			{ANY} set_feature, set_class
		redefine
			build_explain,
			trace,
			trace_single_line
		end

inherit {NONE}

	ERROR_CONTEXT_PRINTER
		export {NONE} all end

feature {NONE} -- Initialization

	make (a_message: STRING)
			-- Initialize error with message `a_message'.
		do
			message := a_message
		end

feature -- Access

	message: STRING
			-- Error message

	code: STRING_8 is "EVE"
			-- Error code

feature -- Output

	build_explain (a_text_formatter: TEXT_FORMATTER)
			-- Build specific explanation image for current error
			-- in `error_window'.
		do
			a_text_formatter.add ("build explain")
			a_text_formatter.add_new_line
		end

	trace (a_text_formatter: TEXT_FORMATTER) is
			-- Display full error message in `a_text_formatter'.
		do
			a_text_formatter.add ("trace")
			a_text_formatter.add_new_line
		end

	trace_single_line (a_text_formatter: TEXT_FORMATTER) is
			-- Display short error, single line message in `a_text_formatter'.
		do
			a_text_formatter.add (message)
		end

end
