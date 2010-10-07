note
	description: "Field for a semantic search document"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_DOCUMENT_FIELD

inherit
	HASHABLE
		redefine
			out
		end

	DEBUG_OUTPUT
		undefine
			out
		end

	SEM_CONSTANTS
		undefine
			out
		end

create
	make,
	make_with_string_type

feature{NONE} -- Initialization

	make (a_name: like name; a_value: like value; a_type: INTEGER; a_boost: DOUBLE)
			-- Initialize Current.
		local
			l_hash_str: STRING
		do
			name := a_name
			value := a_value
			type := a_type
			boost := a_boost

				-- Calculate hash code.
			create l_hash_str.make (64)
			l_hash_str.append (name.hash_code.out)
			l_hash_str.append (value.hash_code.out)
			l_hash_str.append (type.hash_code.out)
			l_hash_str.append (boost.out)
			hash_code := l_hash_str.hash_code
		end

	make_with_string_type (a_name: like name; a_value: like value)
			-- Initialize Current as a string typed field with default boost.
		do
			make (a_name, a_value, string_field_type, default_boost_value)
		end

feature -- Access

	name: STRING
			-- Name of current field

	value: STRING
			-- Value of current field

	type: INTEGER
			-- Type of current field

	boost: DOUBLE
			-- Boost of current field

	out: STRING
			-- String representation of current
		do
			Result := string_representation
		end

feature -- Access

	hash_code: INTEGER
			-- Hash code value

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := out
		end

feature{NONE} -- Implementation

	string_representation: STRING
			-- String representation of Current.
		local
		do
			create Result.make (128)

			Result.append (name)
			Result.append_character ('%N')

			Result.append (boost.out)
			Result.append_character ('%N')

			Result.append (field_type_name (type))
			Result.append_character ('%N')

			Result.append (value)
			Result.append_character ('%N')
		end

end
