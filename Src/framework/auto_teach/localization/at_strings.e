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

	at_custom_hint_tables: STRING = "-at-custom-hint-table"




feature -- Messages

	command_line_help: STRING_32
		do
			Result := locale.translation ("This should be a help message.")
		end

	welcome_message: STRING_32
		do
			Result := locale.translation ("Welcome to " + auto_teach + "!")
		end

	running_at_level (a_level: INTEGER): STRING_32
		do
			Result := locale.translation ("Running at hint level " + a_level.out.to_string_32 + ".")
		end

	processing_class (a_class: STRING): STRING_32
		do
			Result := locale.translation ("Processing class " + a_class + "...")
		end

feature -- Warnings

	unrecognized_meta_command: STRING_32
		do
			Result := locale.translation ("The following meta-command was not recognized or is incorrect, and was therefore ignored:%N")
		end

	no_custom_hint_table_loaded: STRING_32
		do
			Result := locale.translation ("Cannot switch to custom mode, as no custom hint table has been loaded.")
		end

	warning_no_level_subfolders_option: STRING_32
		do
			Result := locale.translation ("A hint level range was specified without also supplying the " + at_level_subfolders + " command line switch. This will lead to the same output file(s) being overwritten on every run. The final result will be the output of the last run, the result of the other runs will be lost. Unless you are doing this for testing, you might want to supply the " + at_level_subfolders + " switch as well.")
		end

	undefined_visibility (a_block_type_names: STRING): STRING_32
		do
			Result := locale.translation ("Warning: one or more occurrences of the following block types have been encountered for the visibility of which was undefined (neither in the hint table, nor with annotations):%N"
				+ a_block_type_names + "%N"
				+ "In these cases, the visibility is defaulted to true. However, a well-built hint table should never allow this situation.")
		end

feature -- Errors

	error_unrecognized_argument (a_argument: STRING): STRING_32
		do
			Result := locale.translation ("Syntax error. Unrecognized argument '" + a_argument + "'.")
		end

	error_no_class_list_specified: STRING_32
		do
			Result := locale.translation ("No list of classes to process was provided. Exiting.")
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
			Result := locale.translation ("Syntax error. Valid hint level or hint level range expected.")
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
			Result := locale.translation ("The specified output directory is not writable or it does not exist and could not be created.")
		end

feature -- Errors with custom hint table

	error_no_custom_hint_table_path: STRING_32
		do
			Result := locale.translation ("Syntax error. Path to the custom hint table expected.")
		end

	error_custom_hint_table_file_not_found: STRING_32
		do
			Result := locale.translation ("Could not load the custom hint table. The specified file does not exist.")
		end

	error_custom_hint_table_parse_error: STRING_32
		do
			Result := locale.translation ("Could not load the custom hint table.")
		end

	error_invalid_block_type_name (a_line_number: INTEGER; a_block_type_name: STRING): STRING_32
		do
			Result := locale.translation ("[line " + a_line_number.out + "] %'" + a_block_type_name + "%' is not a valid block type name.")
		end

	error_duplicate_entry (a_line_number: INTEGER; a_block_type_name: STRING): STRING_32
		do
			Result := locale.translation ("[line " + a_line_number.out + "] Block %'" + a_block_type_name + "%' appears for the second time for the same table. Each block can only appear once for the visibility table and once for the content visibility table")
		end

	error_empty_row (a_line_number: INTEGER): STRING_32
		do
			Result := locale.translation ("[line " + a_line_number.out + "] Lines in visibility tables cannot be empty.")
		end

	error_atomic_block_in_content_visibility_table (a_line_number: INTEGER; a_block_type_name: STRING): STRING_32
		do
			Result := locale.translation ("[line " + a_line_number.out + "] Block %'" + a_block_type_name + "%' is not a complex block and, as such, is not allowed into the content block visibility table.")
		end

	error_value_parse_error (a_line_number: INTEGER; a_value, a_type: STRING): STRING_32
		do
			Result := locale.translation ("[line " + a_line_number.out + "] '" + a_value + "%' is not a valid text representation of a " + a_type + ".")
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

	hint_command: STRING = "HINT"

	placeholder_command: STRING = "PLACEHOLDER"

	hint_mode_command: STRING = "HINT_MODE"
	unannotated_mode_command: STRING = "UNANNOTATED_MODE"
	custom_mode_command: STRING = "CUSTOM_MODE"


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
