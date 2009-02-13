indexing
	description:
		"[
			Parent class for errors of EVE Proofs.
		]"
	date: "$Date$"
	revision: "$Revision$"

deferred class EP_ERROR

inherit

	FEATURE_ERROR
		export
			{ANY} set_feature, set_class, set_position
		redefine
			build_explain,
			trace,
			trace_single_line
		end

	ERROR_CONTEXT_PRINTER
		export {NONE} all end

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

	SHARED_EP_CONTEXT
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

	description: STRING
			-- Description of error

	code: STRING_8 is "EVE Proofs"
			-- Error code

feature -- Element change

	set_description (a_text: STRING)
			-- Set `description' to `a_text'.
		require
			a_text_not_void: a_text /= Void
		do
			description := a_text
		ensure
			description_set: description.is_equal (a_text)
		end

	set_from_context
			-- Use data from `ev_context'.
		do
			set_class (ep_context.current_class)
			set_feature (ep_context.current_feature)
			set_position (ep_context.line_number, ep_context.column_number)
		end

feature -- Output

	build_explain (a_text_formatter: TEXT_FORMATTER)
			-- <Precursor>
		do
			if description /= Void then
				a_text_formatter.add (description)
			else
				a_text_formatter.add (names.description_no_description)
			end
			a_text_formatter.add_new_line
			a_text_formatter.add_new_line

			if class_c /= Void then
				a_text_formatter.add ("Class: ")
				class_c.append_name (a_text_formatter)
				a_text_formatter.add_new_line
			end
			if e_feature /= Void then
				a_text_formatter.add ("Feature: ")
				e_feature.append_name (a_text_formatter)
				a_text_formatter.add_new_line
			end
			a_text_formatter.add_new_line
		end

	trace (a_text_formatter: TEXT_FORMATTER) is
			-- Display full error message in `a_text_formatter'.
		do
			build_explain (a_text_formatter)
			a_text_formatter.add_new_line
		end

	trace_single_line (a_text_formatter: TEXT_FORMATTER) is
			-- Display short error, single line message in `a_text_formatter'.
		do
			a_text_formatter.add_error (Current, code)
			a_text_formatter.add (":")
			a_text_formatter.add_space
			a_text_formatter.add (message)
		end

end
