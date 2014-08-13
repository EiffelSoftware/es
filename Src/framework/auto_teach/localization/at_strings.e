note
	description: "Localized strings for AutoTeach."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

frozen class
	AT_STRINGS

inherit

	SHARED_LOCALE

feature -- General

	auto_teach: STRING_32
		do
			Result := locale.translation ("AutoTeach")
		end

	hinter: STRING_32
		do
			Result := locale.translation ("Hinter")
		end

	error: STRING
		do
			Result := locale.translation ("Error")
		end

feature -- Messages

	command_line_help: STRING_32
		do
			Result := locale.translation ("This should be a help message.")
		end

	welcome_message: STRING_32
		do
			Result := locale.translation ("Welcome to " + auto_teach + "!")
		end

feature -- Warnings

	nothing_to_do: STRING_32
		do
			Result := locale.translation ("No mode for " + auto_teach + " specified (e.g. " + hinter + "), exiting.")
		end

	unrecognized_meta_command: STRING_32
		do
			Result := locale.translation ("The following meta-command was not recognized, and therefore ignored:%N")
		end

feature -- Errors

	error_unrecognized_argument (a_argument: STRING): STRING_32
		do
			Result := locale.translation ("Syntax error: unrecognized argument '" + a_argument + "'.")
		end

	error_class_not_found (a_class_name: STRING): STRING_32
		do
			Result := locale.translation ("Could not find class " + a_class_name + ". Skipping.")
		end

	error_class_not_compiled (a_class_name: STRING): STRING_32
		do
			Result := locale.translation ("Class " + a_class_name + " has not been compiled. Skipping.")
		end

	error_argument_level: STRING_32
		do
			Result := locale.translation ("Syntax error. Valid hint level expected.")
		end

	error_boolean_value: STRING_32
		do
			Result := locale.translation ("Syntax error. Valid boolean value expected.")
		end

	error_no_output_dir: STRING_32
		do
			Result := locale.translation ("Syntax error. Output directory expected.")
		end

	error_no_class_list: STRING_32
		do
			Result := locale.translation ("Syntax error. Class name (or list) expected.")
		end

	error_invalid_output_dir: STRING_32
		do
			Result := locale.translation ("The specified output directory does not exist or is not writable.")
		end

feature -- Code output

	code_placeholder: STRING = "-- Your code here!"

	arguments_placeholder: STRING = "(replace_this_with_your_arguments: ANY)"

feature -- Command prefixes

	hint_command: STRING = "-- #HINT"

	show_command: STRING = "-- #SHOW"

	hide_command: STRING = "-- #HIDE"

	show_content_command: STRING = "-- #SHOWCONTENT"

	hide_content_command: STRING = "-- #HIDECONTENT"

	placeholder_command: STRING = "-- #PLACEHOLDER"

end
