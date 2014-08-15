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
			hint_level := 0
			insert_code_placeholder := True
			create output_directory.make_with_path (create {PATH}.make_current)

			hint_table := hint_tables.default_unannotated_hint_table
		end

feature -- Copying

	restore_from, replace_with (a_other: like Current)
			-- Replaces the value of all options from the values of `a_other'
		do
			insert_code_placeholder := a_other.insert_code_placeholder
			hint_level := a_other.hint_level
			output_directory := a_other.output_directory
		end

feature -- AutoTeach options

	insert_code_placeholder: BOOLEAN assign set_insert_code_placeholder
			-- Shall AutoTeach insert a placeholder where code is removed?

	hint_level: INTEGER assign set_hint_level
			-- The current hint level for AutoTeach.

	output_directory: DIRECTORY assign set_output_directory
			-- Output directory for classes processed by AutoTeach.

	hint_table: AT_HINT_TABLE assign set_hint_table
			-- The table defining the policy for showing/hiding code blocks.


feature {NONE} -- Setters

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

	set_hint_table (a_hint_table: AT_HINT_TABLE)
			-- Set `hint_table' to `a_hint_table'.
		do
			hint_table := a_hint_table
		ensure
			hint_table_set: hint_table = a_hint_table
		end

end
