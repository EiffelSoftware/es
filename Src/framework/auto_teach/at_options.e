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

			hide_routine_arguments := True
			hide_preconditions := True
			hide_locals := True
			hide_routine_bodies := True
			hide_postconditions := True
			hide_class_invariants := true
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

	hide_routine_arguments: BOOLEAN assign set_hide_routine_arguments
			-- Should routine arguments be hidden?

	hide_preconditions: BOOLEAN assign set_hide_preconditions
			-- Should preconditions be hidden?

	hide_locals: BOOLEAN assign set_hide_locals
			-- Should locals be hidden?

	hide_routine_bodies: BOOLEAN assign set_hide_routine_bodies
			-- Should routine bodies be hidden?

	hide_postconditions: BOOLEAN assign set_hide_postconditions
			-- Should postconditions be hidden?

	hide_class_invariants: BOOLEAN assign set_hide_class_invariants
			-- Should class invariants be hidden?


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

	set_hide_routine_arguments (a_bool: BOOLEAN)
			-- Set `hide_routine_arguments' to `a_bool'.
		do
			hide_routine_arguments := a_bool
		ensure
			hide_routine_arguments_set: hide_routine_arguments = a_bool
		end

	set_hide_preconditions (a_bool: BOOLEAN)
			-- Set `hide_preconditions' to `a_bool'.
		do
			hide_preconditions := a_bool
		ensure
			hide_preconditions_set: hide_preconditions = a_bool
		end

	set_hide_locals (a_bool: BOOLEAN)
			-- Set `hide_locals' to `a_bool'.
		do
			hide_locals := a_bool
		ensure
			hide_locals_set: hide_locals = a_bool
		end

	set_hide_routine_bodies (a_bool: BOOLEAN)
			-- Set `hide_routine_bodies' to `a_bool'.
		do
			hide_routine_bodies := a_bool
		ensure
			hide_routine_bodies_set: hide_routine_bodies = a_bool
		end

	set_hide_postconditions (a_bool: BOOLEAN)
			-- Set `hide_postconditions' to `a_bool'.
		do
			hide_postconditions := a_bool
		ensure
			hide_postconditions_set: hide_postconditions = a_bool
		end

	set_hide_class_invariants (a_bool: BOOLEAN)
			-- Set `hide_class_invariants' to `a_bool'.
		do
			hide_class_invariants := a_bool
		ensure
			hide_class_invariants_set: hide_class_invariants = a_bool
		end

end
