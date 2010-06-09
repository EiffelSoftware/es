note
	description: "Daikon program point, used both in declaration and trace files"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DKN_PROGRAM_POINT

inherit
	DKN_ELEMENT
		redefine
			out
		end

	DKN_UTILITY
		undefine
			out
		end

	DEBUG_OUTPUT
		undefine
			out
		end

	HASHABLE
		undefine
			out
		end

	DKN_SHARED_EQUALITY_TESTERS
		undefine
			out
		end

create
	make_as_enter,
	make_as_exit

feature{NONE} -- Initialization

	make_with_type (a_name: like name; a_type: like type)
			-- Initialize `name' with `a_name' and type with `a_type'.
		require
			not_a_name_is_empty: not a_name.is_empty
			a_type_is_valid: is_type_valid (a_type)
		do
			name := a_name.twin
			set_type (a_type)
			create variables.make (20)
			variables.set_equality_tester (daikon_variable_equality_tester)
		end

	make_as_enter (a_name: STRING)
			-- Initialize name with `a_name', and type as `enter_program_point'.
		do
			make_with_type (a_name, enter_program_point)
			daikon_name := encoded_daikon_name (name) + enter_program_point_suffix
			hash_code := daikon_name.hash_code
		end

	make_as_exit (a_name: STRING)
			-- Initialize name with `a_name', and type as `exit_program_point'.
		do
			make_with_type (a_name, exit_program_point)
			daikon_name := encoded_daikon_name (name) + exit_program_point_suffix
			hash_code := daikon_name.hash_code
		end

feature -- Access

	type: STRING
		 -- Type of current program type
		 -- See `is_type_valid' for the list of valid values
		 -- Default: `point_program_point'

	out, debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		local
			l_cursor: like variables.new_cursor
		do
			create Result.make (4096)

				-- Append program point name.
			Result.append (ppt_string)
			Result.append_character (' ')
			Result.append (daikon_name)
			Result.append_character ('%N')

				-- Append program point type.
			Result.append (ppt_type_string)
			Result.append_character (' ')
			Result.append (type)
			Result.append_character ('%N')

				-- Append variable declarations.
			from
				l_cursor := variables.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.append (l_cursor.item.out)
				l_cursor.forth
			end
			
			Result.append_character ('%N')
		end

	hash_code: INTEGER
			-- Hash code value

	variables: DS_HASH_SET [DKN_VARIABLE]
			-- Set of variables accessable at current program point

feature -- Status report

	is_type_valid (a_type: STRING): BOOLEAN
			-- Is `a_type' a valid program point type?
		do
			Result := progrm_point_types.has (a_type)
		end

feature -- Setting

	set_type (a_type: STRING)
			-- Set `type' with `a_type'.
			-- Make a copy from `a_type' to `type'.
		require
			a_type_valid: is_type_valid (a_type)
		do
			type := a_type.twin
		end

end
