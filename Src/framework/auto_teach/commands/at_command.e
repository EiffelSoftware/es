note
	description: "Summary description for {AT_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AT_COMMAND

inherit
	AT_COMMON

create
	make_from_line

feature -- Access

	original_line: STRING
			-- The full text of the original line containing the command.

	valid: BOOLEAN
			-- Is `Current' a valid command?

	min_level: INTEGER
			-- The minimum hint level for the command to be processed.

	max_level: INTEGER
			-- The maximum hint level for the command to be processed.

	command_word: STRING
			-- The command keyword.

	payload: STRING
			-- The payload of the command, if any.

feature {NONE} -- Initialization

	fail
			-- Throws a parsing exception.
		local
			l_exception: DEVELOPER_EXCEPTION
		do
			create l_exception
			l_exception.set_description ("Command parsing failed.")
			l_exception.raise
		end

	parse (a_line: STRING)
		local
			l_line, l_level_string, l_block_type_string: STRING
			l_min_max: TUPLE [min: INTEGER; max: INTEGER]
			l_index: INTEGER
			l_space_index, l_tab_index, l_colon_index: INTEGER
		do
			original_line := a_line.twin
			l_line := a_line.twin

				-- Default level values: the command is always applicable.
			min_level := 0
			max_level := {INTEGER}.max_value


				-- Check prefixes.
			l_line.adjust
			if not l_line.starts_with ("--") then
				fail
			end
			l_line.remove_head (2)
			l_line.left_adjust
			if not l_line.starts_with (at_strings.meta_command_prefix) then
				fail
			end
			l_line.remove_head (at_strings.meta_command_prefix.count)
			l_line.left_adjust

				-- Parse hint level range.
			if l_line [1] = '[' then
				l_line.remove_head (1)
				l_index := l_line.index_of (']', 1)
				if l_index >= 2 then
					l_level_string := l_line.substring (1, l_index - 1)
					l_min_max := parse_natural_range_string (l_level_string, max_level)
					if attached l_min_max then
						min_level := l_min_max.min
						max_level := l_min_max.max
					else
						fail
					end
					l_line.remove_head (l_index)
				else
					fail
				end
			end

				-- Determine where the first word ends (it can be terminated by
				-- a space, a tab character or a colon), then extract it.
			l_line.left_adjust
			l_space_index := l_line.index_of (' ', 1)
			if l_space_index = 0 then
				l_space_index := l_line.count + 1
			end
			l_tab_index := l_line.index_of ('%T', 1)
			if l_tab_index = 0 then
				l_tab_index := l_line.count + 1
			end
			l_colon_index := l_line.index_of ('%T', 1)
			if l_colon_index = 0 then
				l_colon_index := l_line.count + 1
			end
			l_index := l_tab_index.min (l_space_index).min (l_colon_index)
			command_word := l_line.head (l_index - 1).as_upper
			l_line.remove_head (l_index)
			l_line.left_adjust

			payload := l_line


		end

	make_from_line (a_line: STRING)
			-- Initialization for `Current'.
		local
			l_failed: BOOLEAN
		do
			if not l_failed then
				parse (a_line)
			else
				valid := False
			end
			valid := True
		rescue
			l_failed := True
			retry
		end

end
