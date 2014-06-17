note
	description: "Summary description for {AT_OPTIONS}."
	author: ""
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
		do
			hint_level := 2
			create output_directory.make_with_path (create {PATH}.make_current)
		end

feature -- Options

	run_hinter: BOOLEAN assign set_run_hinter

	hint_level: INTEGER assign set_hint_level

	output_directory: attached DIRECTORY assign set_output_directory

feature -- Access

	must_run_something: BOOLEAN
			-- Is there at least a tool/command set for execution?
		do
			Result := run_hinter
		end

feature {NONE} -- Setters

	set_run_hinter (a_bool: BOOLEAN)
		do
			run_hinter := a_bool
		ensure
			run_hinter_set: run_hinter = a_bool
		end

	set_hint_level (a_level: INTEGER)
		require
			valid_level: is_valid_hint_level (a_level)
		do
			hint_level := a_level
		ensure
			level_set: hint_level = a_level
		end

	set_output_directory (a_dir: attached DIRECTORY)
		do
			output_directory := a_dir
		ensure
			directory_set: output_directory = a_dir
		end

end
