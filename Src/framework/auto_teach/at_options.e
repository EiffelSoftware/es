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
		end

feature -- Options

	hint_level: INTEGER assign set_hint_level

	output_path: detachable STRING assign set_output_path
		-- If Void, the output is printed to the console

feature {NONE} -- Setters

	set_hint_level (a_level: INTEGER)
		require
			valid_level: is_valid_hint_level (a_level)
		do
			hint_level := a_level
		ensure
			level_set: hint_level = a_level
		end

	set_output_path (a_path: STRING)
		require
			a_path = Void or else a_path.is_whitespace
		do
			output_path := a_path
		ensure
			path_set: output_path = a_path
		end

end
