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

	meta_command: STRING
		do
			Result := locale.translation ("meta-command")
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

	meta_command_in_skipped_routine: STRING_32
		do
			Result := locale.translation ("This meta-command is located in skipped routine, and will be ignored. To suppress this warning, specify an appropriate hint level for the command so that it is only enabled when the outside routine is not skipped.")
		end

	no_custom_hint_table_loaded: STRING_32
		do
			Result := locale.translation ("Cannot switch to custom mode, as no custom hint table has been loaded.")
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

	code_standard_placeholder: STRING = "-- Your code here!"

	code_arguments_placeholder: STRING = "-- Your arguments here!"

feature -- Meta-commands

	meta_command_prefix: STRING = "#"

	hint_command: STRING = "HINT"

	show_all_command: STRING = "SHOW_ALL"

	hide_all_command: STRING = "HIDE_ALL"

	reset_all_command: STRING = "RESET_ALL"

	show_all_content_command: STRING = "SHOW_ALL_CONTENT"

	hide_all_content_command: STRING = "HIDE_ALL_CONTENT"

	reset_all_content_command: STRING = "RESET_ALL_CONTENT"

	show_next_command: STRING = "SHOW_NEXT"

	hide_next_command: STRING = "HIDE_NEXT"
			-- There is no reset_next command, why would one ever need it?

	show_next_content_command: STRING = "SHOW_NEXT_CONTENT"

	hide_next_content_command: STRING = "HIDE_NEXT_CONTENT"
			-- There is no reset_next_content command, why would one ever need it?

	commands_with_block: ARRAY [STRING]
			-- List of commands which must be followed by a block type. Useful for parsing.
		once ("PROCESS")
			Result := <<show_all_command, hide_all_command, reset_all_command, show_all_content_command, hide_all_content_command, reset_all_content_command, show_next_command, hide_next_command, show_next_content_command, hide_next_content_command>>
			Result.compare_objects
		end

	placeholder_command: STRING = "PLACEHOLDER"

	hint_mode_command: STRING = "HINT_MODE"

	unannotated_mode_command: STRING = "UNANNOTATED_MODE"

	custom_mode_command: STRING = "CUSTOM_MODE"

		-- TODO: mostrare then e else separatamente
		-- magari con SHOWNEXT branch

		-- TODO: non dimenticare di gestire i blocchi inspect

feature -- Block types

	bt_feature: STRING = "feature"

	bt_arguments: STRING = "arguments"

	bt_precondition: STRING = "precondition"

	bt_locals: STRING = "locals"

	bt_routine_body: STRING = "routine_body"

	bt_postcondition: STRING = "postcondition"

	bt_class_invariant: STRING = "class_invariant"

	bt_assertion: STRING = "assertion"

	bt_instruction: STRING = "instruction"

	bt_if: STRING = "if"
	bt_if_condition: STRING = "if_condition"
	bt_if_branch: STRING = "if_branch"

end
