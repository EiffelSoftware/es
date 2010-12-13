note
	description: "Daikon declarations"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DKN_DECLARATION

inherit
	DKN_INPUT_DATA
		undefine
			out,
			copy,
			is_equal
		end

	DS_HASH_SET [DKN_PROGRAM_POINT]
		redefine
			make,
			out
		end

	DKN_SHARED_EQUALITY_TESTERS
		undefine
			out,
			copy,
			is_equal
		end

	DKN_CONSTANTS
		undefine
			out,
			copy,
			is_equal
		end

	DEBUG_OUTPUT
		undefine
			out,
			copy,
			is_equal
		end

create
	make

feature{NONE} -- Initialization

	make (n: INTEGER)
			-- Create an empty container and allocate
			-- memory space for at least `n' items.
			-- Use `daikon_program_point_equality_tester' for equality test.
		do
			Precursor (n)
			set_equality_tester (daikon_program_point_equality_tester)
		end

feature -- Access

	out: STRING
			-- String representation of current
		local
			l_cursor: like new_cursor
		do
			create Result.make (4096)
			Result.append (daikon_version_string)
			do_all (
				agent (a_ppt: DKN_PROGRAM_POINT; a_result: STRING)
					do
						a_result.append (a_ppt.out)
					end (?, Result))
		end

	debug_output: STRING
			-- Debug output
		do
			Result := out
		end

	item_by_name (a_ppt_name: STRING): detachable DKN_PROGRAM_POINT
			-- Program point in Current, which has name `a_ppt_name'
			-- Void if no such program point exists.
		local
			l_cursor: like new_cursor
		do
			from
				l_cursor := new_cursor
				l_cursor.start
			until
				l_cursor.after or Result /= Void
			loop
				if l_cursor.item.name ~ a_ppt_name then
					Result := l_cursor.item
				end
				l_cursor.forth
			end
		end

	item_by_daikon_name (a_ppt_name: STRING): detachable DKN_PROGRAM_POINT
			-- Program point in Current, which has daikon_name `a_ppt_name'
			-- Void if no such program point exists.
		local
			l_cursor: like new_cursor
		do
			from
				l_cursor := new_cursor
				l_cursor.start
			until
				l_cursor.after or Result /= Void
			loop
				if l_cursor.item.daikon_name ~ a_ppt_name then
					Result := l_cursor.item
				end
				l_cursor.forth
			end
		end

feature -- Status report

	has_program_point_by_name (a_ppt_name: STRING): BOOLEAN
			-- Does current have a program point named `a_ppt_name'?
		do
			Result := there_exists (agent (a_ppt: DKN_PROGRAM_POINT; a_name: STRING): BOOLEAN do Result := a_ppt.name ~ a_name end (?, a_ppt_name))
		end

end
