class
	JSC_ERROR

inherit

	FEATURE_ERROR
		export
			{ANY} set_feature, set_class, set_position
		redefine
			build_explain,
			trace,
			trace_single_line,
			has_associated_file,
			is_defined
		end

	ERROR_CONTEXT_PRINTER
		export {NONE} all end

	SHARED_JSC_CONTEXT
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make (a_message: attached STRING; a_description: attached STRING)
			-- Initialize error with message `a_message'.
		do
			message := a_message
			description := a_description
		end

feature -- Status report

	is_defined: BOOLEAN
			-- Is error fully defined?
		once
			Result := true
		end


	has_associated_file: BOOLEAN
			-- Does error have an associated file?
		once
			Result := false
		end

feature -- Access

	message: attached STRING
			-- Error message

	description: attached STRING
			-- Description of error

	code: STRING_8 = "JavaScript"
			-- Error code

feature -- Element change

	use_data_from_context
			-- Use data from `ev_context' to set `class_c', `e_feature', `line', and `column'.
		do
			if jsc_context.has_current_class then
				set_class (jsc_context.current_class)
			end
			if jsc_context.has_current_feature then
				set_feature (jsc_context.current_feature)
			end
			set_position (jsc_context.current_line_number, 0)
		ensure
			class_set: class_c = jsc_context.current_class
			--feature_set:
			line_set: line = jsc_context.current_line_number
			column_set: column = 0
		end

feature -- Output

	build_explain (a_text_formatter: TEXT_FORMATTER)
			-- <Precursor>
		do
			a_text_formatter.add (description)
			a_text_formatter.add_new_line
			a_text_formatter.add_new_line

			if attached class_c as safe_class_c then
				a_text_formatter.add ("Class: ")
				safe_class_c.append_name (a_text_formatter)
				a_text_formatter.add_new_line
			end
			if attached e_feature as safe_e_feature then
				a_text_formatter.add ("Feature: ")
				safe_e_feature.append_name (a_text_formatter)
				a_text_formatter.add_new_line
			end
			a_text_formatter.add_new_line
		end

	trace (a_text_formatter: TEXT_FORMATTER)
			-- <Precursor>
		do
			build_explain (a_text_formatter)
			a_text_formatter.add_new_line
		end

	trace_single_line (a_text_formatter: TEXT_FORMATTER)
			-- <Precursor>
		do
			a_text_formatter.add_error (Current, code)
			a_text_formatter.add (":")
			a_text_formatter.add_space
			a_text_formatter.add (message)
		end

	trace_single_line_message (a_text_formatter: attached TEXT_FORMATTER)
			-- Display single line message in `a_text_formatter'.
		do
			a_text_formatter.add (message)
		end

end
