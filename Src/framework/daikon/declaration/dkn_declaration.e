note
	description: "Daikon declarations"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DKN_DECLARATION

inherit
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

	make (n: INTEGER) is
			-- Create an empty container and allocate
			-- memory space for at least `n' items.
			-- Use `daikon_program_point_equality_tester' for equality test.
		do
			Precursor (n)
			set_equality_tester (daikon_program_point_equality_tester)
		end

feature -- Access

	out, debug_output: STRING
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



end
