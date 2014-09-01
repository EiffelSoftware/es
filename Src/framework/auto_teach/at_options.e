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

			hint_table := hint_tables.default_auto_hint_table
		end


feature -- AutoTeach options

	insert_code_placeholder: BOOLEAN assign set_insert_code_placeholder
			-- Shall AutoTeach insert a placeholder where code is removed?

	hint_level: NATURAL assign set_hint_level
			-- The current hint level for AutoTeach.

	min_hint_level: NATURAL
			-- The minimum hint level with which AutoTeach should be run.

	max_hint_level: NATURAL
			-- The maximum hint level with which AutoTeach should be run.

	create_level_subfolders: BOOLEAN assign set_create_level_subfolders
			-- If true, a subfolder will be created for each hint level, and
			-- the output of every run will be placed in the proper subfolder.

	output_directory: DIRECTORY assign set_output_directory
			-- Output directory for classes processed by AutoTeach.

	hint_table: AT_HINT_TABLE
			-- The table defining the policy for showing/hiding code blocks.

	set_hint_level_range (a_min_level, a_max_level: NATURAL)
			-- Set the hint level range for which AutoTeach should be run in the current execution.
		require
			valid_min: is_valid_hint_level (a_min_level)
			valid_max: is_valid_hint_level (a_max_level)
			ordering: a_min_level <= a_max_level
		do
			min_hint_level := a_min_level
			max_hint_level := a_max_level
		ensure
			min_set: min_hint_level = a_min_level
			max_set: max_hint_level = a_max_level
		end

	switch_to_mode (a_mode: AT_MODE)
			-- Switches to new mode `a_mode'.
		require
			initialized: a_mode.initialized
			must_be_possible: (a_mode = enum_mode.M_custom) implies attached hint_tables.custom_hint_table
		do
			if a_mode = enum_mode.M_auto then
				hint_table := hint_tables.default_auto_hint_table
			elseif a_mode = enum_mode.M_manual then
				hint_table := hint_tables.default_manual_hint_table
			elseif a_mode = enum_mode.M_custom then
				check precondition: attached hint_tables.custom_hint_table as l_hint_table then
					hint_table := l_hint_table
				end
			else
				check recognized: False end
			end
		end

feature {NONE} -- Setters

	set_insert_code_placeholder (a_bool: BOOLEAN)
			-- Set `insert_code_placeholder' to `a_bool'.
		do
			insert_code_placeholder := a_bool
		ensure
			insert_code_placeholder_set: insert_code_placeholder = a_bool
		end

	set_hint_level (a_level: NATURAL)
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

	set_create_level_subfolders (a_bool: BOOLEAN)
			-- Set `create_level_subfolders' to `a_bool'.
		do
			create_level_subfolders := a_bool
		ensure
			create_level_subfolders_set: create_level_subfolders = a_bool
		end

	set_hint_table (a_hint_table: AT_HINT_TABLE)
			-- Set `hint_table' to `a_hint_table'.
		do
			hint_table := a_hint_table
		ensure
			hint_table_set: hint_table = a_hint_table
		end

invariant

	level_ordering: min_hint_level <= max_hint_level
	valid_hint_level: is_valid_hint_level (hint_level)

end
