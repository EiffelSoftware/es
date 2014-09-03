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

	error: STRING
		do
			Result := locale.translation ("Error")
		end

	warning: STRING
		do
			Result := locale.translation ("Warning")
		end

	meta_command: STRING
		do
			Result := locale.translation ("meta-command")
		end

feature -- Command line switches

	at_class: STRING = "-at-class"
	at_classes: STRING = "-at-classes"

	at_hint_level: STRING = "-at-hint-level"

	at_code_placeholder: STRING = "-at-code-placeholder"

	at_output_path: STRING = "-at-output-path"
	at_level_subfolders: STRING = "-at-level-subfolders"

	at_mode: STRING = "-at-mode"

	at_custom_hint_tables: STRING = "-at-custom-hint-table"


feature -- Messages

	command_line_help: STRING_32
		do
			Result := locale.translation ("This should be a help message.")
		end

	welcome_message: STRING_32
		do
			Result := locale.formatted_string ("Welcome to $1!", [auto_teach])
		end

	running_at_level (a_level: NATURAL): STRING_32
		do
			Result := locale.formatted_string ("Running at hint level $1.", [a_level.out.to_string_32])
		end

	processing_class (a_class: STRING): STRING_32
		do
			Result := locale.formatted_string ("Processing class $1...", [a_class])
		end

	valid_mode_list (a_valid_modes: STRING): STRING_32
		do
			Result := locale.formatted_string ("Valid modes are the following: $1", [a_valid_modes])
		end

feature -- Processing warnings (proc)

	proc_unparsable_meta_command: STRING_32
		do
			Result := locale.translation ("The following meta-command could not be parsed, and was therefore ignored:%N")
		end

	proc_unrecognized_meta_command: STRING_32
		do
			Result := locale.translation ("The following meta-command was not recognized or is incorrect, and was therefore ignored:%N")
		end

	proc_invalid_mode: STRING_32
		do
			Result := locale.translation ("The following meta-command specifies an invalid mode, and was therefore ignored:%N")
		end

	proc_invalid_hint_continuation: STRING_32
		do
			Result := locale.translation ("The following hint continuation command is not directly preceded by a hint command, and was therefore ignored:%N")
		end

	proc_invalid_block_type (a_block_type: STRING): STRING_32
		do
			Result := locale.formatted_string ("The following meta-command specifies an invalid block type ($1), which was ignored:%N", [a_block_type])
		end

	proc_no_custom_hint_table_loaded: STRING_32
		do
			Result := locale.translation ("Cannot switch to custom mode, as no custom hint table has been loaded. Meta-command:%N")
		end

	proc_undefined_visibility (a_block_type_names: STRING): STRING_32
		do
			Result := locale.formatted_string ("Warning: one or more occurrences of the following block types have been encountered for the visibility of which was undefined (neither in the hint table, nor with annotations):%N"
				+ "$1%N"
				+ "In these cases, the visibility is defaulted to true. However, a well-built hint table should never allow this situation.", [a_block_type_names])
		end

feature -- Initialization errors and warnings (init)

	init_unrecognized_argument (a_argument: STRING): STRING_32
		do
			Result := locale.formatted_string ("Syntax error. Unrecognized argument `$1'.", [a_argument])
		end

	init_no_class_list_specified: STRING_32
		do
			Result := locale.translation ("No list of classes to process was provided. Exiting.")
		end

	init_class_not_found (a_class_name: STRING): STRING_32
		do
			Result := locale.formatted_string ("Could not find class `$1'. Skipping.", [a_class_name])
		end

	init_class_not_compiled (a_class_name: STRING): STRING_32
		do
			Result := locale.formatted_string ("Class `$1' has not been compiled. Skipping.", [a_class_name])
		end

	init_argument_level_expected: STRING_32
		do
			Result := locale.translation ("Syntax error. Valid hint level or hint level range expected.")
		end

	init_boolean_value_expected: STRING_32
		do
			Result := locale.translation ("Syntax error. Valid boolean value expected.")
		end

	init_output_dir_expected: STRING_32
		do
			Result := locale.translation ("Syntax error. Output directory expected.")
		end

	init_class_list_expected: STRING_32
		do
			Result := locale.translation ("Syntax error. Class name (or list) expected.")
		end

	init_mode_expected (a_valid_modes: STRING_32): STRING_32
		do
			Result := locale.translation ("Syntax error. Mode expected. ") + valid_mode_list (a_valid_modes)
		end

	init_invalid_mode (a_mode, a_valid_modes: STRING_32): STRING_32
		do
			Result := locale.formatted_string ("`$1' is not a valid mode.", [a_mode]) + valid_mode_list (a_valid_modes)
		end

	init_invalid_output_dir: STRING_32
		do
			Result := locale.translation ("The specified output directory is not writable or it does not exist and could not be created.")
		end

	init_no_level_subfolders_option: STRING_32
		do
			Result := locale.formatted_string ("A hint level range was specified without also supplying the `$1' command line switch. This will lead to the same output file(s) being overwritten on every run. The final result will be the output of the last run, the result of the other runs will be lost. Unless you are doing this for testing, you might want to supply the `$1' switch as well.", at_level_subfolders)
		end

feature -- Errors with custom hint table (cht)

	cht_no_custom_hint_table_path: STRING_32
		do
			Result := locale.translation ("Syntax error. Path to the custom hint table expected.")
		end

	cht_file_not_found: STRING_32
		do
			Result := locale.translation ("Could not load the custom hint table. The specified file does not exist.")
		end

	cht_parse_error: STRING_32
		do
			Result := locale.translation ("Could not load the custom hint table.")
		end

	cht_invalid_block_type_name (a_line_number: INTEGER; a_block_type_name: STRING): STRING_32
		do
			Result := locale.formatted_string ("[line $1] `$2' is not a valid block type name.", [a_line_number, a_block_type_name])
		end

	cht_duplicate_entry (a_line_number: INTEGER; a_block_type_name: STRING): STRING_32
		do
			Result := locale.formatted_string ("[line $1] Block `$2' appears for the second time for the same table. Each block can only appear once for the visibility table and once for the content visibility table", [a_line_number, a_block_type_name])
		end

	cht_empty_row (a_line_number: INTEGER): STRING_32
		do
			Result := locale.formatted_string ("[line $1] Lines in visibility tables cannot be empty.", [a_line_number])
		end

	cht_atomic_block_in_content_visibility_table (a_line_number: INTEGER; a_block_type_name: STRING): STRING_32
		do
			Result := locale.formatted_string ("[line $1] Block `$2' is not a complex block and, as such, is not allowed into the content block visibility table.", [a_line_number, a_block_type_name])
		end

	cht_value_parse_error (a_line_number: INTEGER; a_value, a_type: STRING): STRING_32
		do
			Result := locale.formatted_string ("[line $1] `$2' is not a valid text representation of a $3.", [a_line_number, a_value, a_type])
		end


feature -- Code output

	standard_code_placeholder: STRING = "-- Your code here!"

	arguments_code_placeholder: STRING = "	-- Your arguments here!"

	if_condition_code_placeholder: STRING = "(%"Your condition%" = %"here!%")"

feature -- Meta-commands

	meta_command_prefix: STRING = "#"

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

	treat_all_as_atomic: STRING = "TREAT_ALL_AS_ATOMIC"
	treat_all_as_complex: STRING = "TREAT_ALL_AS_COMPLEX"

	treat_next_as_atomic: STRING = "TREAT_NEXT_AS_ATOMIC"
	treat_next_as_complex: STRING = "TREAT_NEXT_AS_COMPLEX"

	commands_with_block: ARRAY [STRING]
			-- List of commands which must be followed by a block type. Useful for parsing.
		once ("PROCESS")
			Result := <<show_all_command, hide_all_command, reset_all_command, show_all_content_command, hide_all_content_command, reset_all_content_command, show_next_command, hide_next_command, show_next_content_command, hide_next_content_command, treat_all_as_atomic, treat_all_as_complex, treat_next_as_atomic, treat_next_as_complex>>
			Result.compare_objects
		end

	comment_command: STRING = "#"
		-- That's right. In practice, meta-comments will start with a double hash,
		-- where the first one is the standard meta-command prefix and the second one
		-- denoting the meta-comment.

	hint_command: STRING = "HINT"
	hint_continuation_command: STRING = "-"
		-- This looks more like a prefix, but technically it is parsed exactly the same as
		-- the other commands. The only difference is that hint levels, if specified, are
		-- ignored for this command (the hint levels of the preceding hint command are considered).

	placeholder_command: STRING = "PLACEHOLDER"

	mode_command: STRING = "MODE"


feature -- Block types

	Bt_feature: STRING = "feature"

	Bt_arguments: STRING = "arguments"
	Bt_argument_declaration: STRING = "argument_declaration"

	Bt_precondition: STRING = "precondition"

	Bt_locals: STRING = "locals"
	Bt_local_declaration: STRING = "local_declaration"

	Bt_routine_body: STRING = "routine_body"

	Bt_postcondition: STRING = "postcondition"

	Bt_class_invariant: STRING = "class_invariant"

	Bt_assertion: STRING = "assertion"

	Bt_instruction: STRING = "instruction"

	Bt_if: STRING = "if"
	Bt_if_condition: STRING = "if_condition"
	Bt_if_branch: STRING = "if_branch"

	Bt_inspect: STRING = "inspect"
	Bt_inspect_branch: STRING = "inspect_branch"

	Bt_loop: STRING = "loop"
	Bt_loop_initialization: STRING = "loop_initialization"
	Bt_loop_invariant: STRING = "loop_invariant"
	Bt_loop_termination_condition: STRING = "loop_termination_condition"
	Bt_loop_body: STRING = "loop_body"
	Bt_loop_variant: STRING = "loop_variant"

end
