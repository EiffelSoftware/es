indexing
	description: "An error reported by the verifier."
	author: "Raphael Mack"
	date: "$Date$"
	revision: "$Revision$"

class
	BPL_VERIFICATION_ERROR

inherit
	BPL_ERROR
		redefine
			out, build_explain,
			trace_primary_context
		end

	SHARED_WORKBENCH
		redefine
			out
		end

create
	make_verification

feature{NONE} -- Initialization

	make_verification (a_text: STRING; a_class_name: STRING; a_line: INTEGER; a_tag: STRING) is
			-- Create an error message with `a_text' as message and
			-- which is originated in class a_class_name at line
			-- `a_line'
		require
			a_text_not_void: a_text /= Void
			class_name_not_void: a_class_name /= Void
		do
			make(a_text)
			short_error_message := "Verification error"
			class_name := a_class_name
			line := a_line
			tag := a_tag
			file_name := universe.classes_with_name (a_class_name).first.file_name.string
		ensure
			text_set: message = a_text
			line_start: line = a_line
			cls_name: class_name = a_class_name
			tag_set: tag = a_tag
		end

feature -- Access
	-- all line/column specifications are within the eiffel file
	line_end: INTEGER
	column_end: INTEGER
	class_name: STRING
	tag : STRING

feature -- Output

	out: STRING is
		do
			Result := message + " (" + line.out + ")"
			if tag /= Void then
				Result := Result + " at tag " + tag
			end
		end

	build_explain (a_text_formatter: TEXT_FORMATTER) is
			-- Print the error message.
		do
			a_text_formatter.add (error_string)
			a_text_formatter.add (" code: ")
			a_text_formatter.add_error (Current, code)
			a_text_formatter.add_new_line
			a_text_formatter.add_class (universe.classes_with_name (class_name).first)

			a_text_formatter.add (" (line ")
			a_text_formatter.add_int (line)
			a_text_formatter.add (")")
			a_text_formatter.add_new_line
			a_text_formatter.add (message)
			if tag /= Void then
				a_text_formatter.add (" (Tag: ")
				a_text_formatter.add (tag)
				a_text_formatter.add (")")
			end
			a_text_formatter.add_new_line
		end

	trace_primary_context (a_text_formatter: TEXT_FORMATTER)
			-- TODO
		do
			a_text_formatter.add ("Class: ")
			a_text_formatter.add_class (universe.classes_with_name (class_name).first)
		end

end
