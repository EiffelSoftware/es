note
	description: "AutoTeach options"
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_OPTIONS

inherit

	AT_COMMON

create
	make_with_defaults

feature {NONE} -- Initialization

	make_with_defaults
			-- Initialization for `Current'.
		do
			hint_level := 2
			insert_code_placeholder := False
			create output_directory.make_with_path (create {PATH}.make_current)
		end

feature -- Hinter options

	should_run_hinter: BOOLEAN assign set_run_hinter
			-- The command line switch for running hinter was specified.

	insert_code_placeholder: BOOLEAN assign set_insert_code_placeholder
			-- Shall hinter insert a placeholder where code is removed?

	hint_level: INTEGER assign set_hint_level
			-- The current hint level for hinter.

	output_directory: DIRECTORY assign set_output_directory
			-- Output directory for classes processed by hinter.

		-- TODO: convert these to preferences

	hide_routine_arguments: BOOLEAN = True

	hide_locals: BOOLEAN = True

	hide_routine_bodies: BOOLEAN = True

	hide_preconditions: BOOLEAN = True

	hide_postconditions: BOOLEAN = True

	hide_class_invariants: BOOLEAN = True

feature {NONE} -- Setters

	set_run_hinter (a_bool: BOOLEAN)
			-- Set `should_run_hinter' to `a_bool'.
		do
			should_run_hinter := a_bool
		ensure
			run_hinter_set: should_run_hinter = a_bool
		end

	set_insert_code_placeholder (a_bool: BOOLEAN)
			-- Set `insert_code_placeholder' to `a_bool'.
		do
			insert_code_placeholder := a_bool
		ensure
			insert_code_placeholder_set: insert_code_placeholder = a_bool
		end

	set_hint_level (a_level: INTEGER)
			-- Set `hint_level' to `a_level'.
		require
			valid_level: is_valid_hint_level (a_level)
		do
			hint_level := a_level
		ensure
			level_set: hint_level = a_level
		end

	set_output_directory (a_dir: DIRECTORY)
			-- Set `output_directory' to `a_dir'.
		do
			output_directory := a_dir
		ensure
			directory_set: output_directory = a_dir
		end

end
