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
			is_equal,
			out
		end

	DKN_UTILITY
		undefine
			is_equal,
			out
		end

	DEBUG_OUTPUT
		undefine
			is_equal,
			out
		end

	HASHABLE
		undefine
			is_equal,
			out
		end

	DKN_SHARED_EQUALITY_TESTERS
		undefine
			is_equal,
			out
		end

create
	make_with_type,
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

			daikon_name := encoded_daikon_name (name)
			hash_code := daikon_name.hash_code
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

	class_name: STRING
			-- Name of the class to which the program point belongs.
			-- Return an empty string when class name is not available.
		do
			if class_name_cache = Void then
				parse_program_point_name
			end
			Result := class_name_cache
		ensure
			result_attached: Result /= Void
		end

	feature_name: STRING
			-- Name of the feature to which the program point belongs.
			-- Return an empty string when feature name is not available.
		do
			if feature_name_cache = VOid then
				parse_program_point_name
			end
			Result := feature_name_cache
		ensure
			result_attached: Result /= Void
		end

	bp_index: INTEGER
			-- Breakpoint index of the program point.
			-- When this information is not available from the name, return 0.
		do
			if bp_index_cache < 0 then
				parse_program_point_name
			end
			Result := bp_index_cache
		ensure
			valid_result: Result >= 0
		end

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

	is_equal (a_point: like Current): BOOLEAN
			-- <Precursor>
		do
			Result := a_point /= Void and then
				type ~ a_point.type and then name ~ a_point.name
		end

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

feature{NONE} -- Implementation

	parse_program_point_name
			-- Parse the program point name into `class_name', `feature_name', and `bp_index'.
		local
			l_ppt_name, l_class_name, l_feature_name, l_index_text: STRING
			l_start_index, l_end_index: INTEGER
		do
			class_name_cache := ""
			feature_name_cache := ""
			bp_index_cache := 0

			l_ppt_name := name
			l_start_index := l_ppt_name.index_of ('.', 1)
			if l_start_index > 1 then
				class_name_cache := l_ppt_name.substring (1, l_start_index - 1)

				l_end_index := l_ppt_name.substring_index ({DKN_CONSTANTS}.ppt_tag_separator, l_start_index)
				if l_end_index > 1 then
					feature_name_cache := l_ppt_name.substring (l_start_index + 1, l_end_index - 1)

					l_index_text := l_ppt_name.substring (l_end_index + {DKN_CONSTANTS}.ppt_tag_separator.count, l_ppt_name.count)
					if l_index_text.is_integer then
						bp_index_cache := l_index_text.to_integer
					end
				end
			end
		end

feature{NONE} -- Cache

	class_name_cache: STRING
			-- Cache for `class_name'.

	feature_name_cache: STRING
			-- Cache for `feature_name'.

	bp_index_cache: INTEGER
			-- Cache for `bp_index'.

end
