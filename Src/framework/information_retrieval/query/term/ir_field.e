note
	description: "Class that represents a field"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IR_FIELD

inherit
	HASHABLE
		redefine
			out
		end

	DEBUG_OUTPUT
		undefine
			out
		end

create
	make

feature{NONE} -- Initialization

	make (a_name: like name; a_value: like value; a_boost: DOUBLE)
			-- Initialize Current.
		do
			name := a_name
			value := a_value
			boost := a_boost
			hash_code := full_text.hash_code
		end

feature -- Access

	name: STRING
			-- Name of Current field

	value: IR_VALUE
			-- Value of Current field

	type: INTEGER
			-- Type of `value'
		do
			Result := value.type
		end

	type_name: STRING
			-- Name of `type'
		do
			Result := value.type_name
		end

	boost: DOUBLE
			-- Boost of Current field

	text: STRING
			-- Text representation of Current, containing only `name' and `value'
		do
			create Result.make (64)
			Result.append (name)
			Result.append ({EPA_CONSTANTS}.query_value_separator)
			Result.append (value.text)
		end

	full_text: STRING
			-- Text representation of Current, containing `name', `value', `boost'
		do
			create Result.make (64)
			Result.append (name)
			Result.append ({EPA_CONSTANTS}.query_value_separator)
			Result.append (value.text)
			Result.append_character (',')
			Result.append (boost.out)
		end

	hash_code: INTEGER
			-- Hash code value

	out: STRING
			-- New string containing terse printable representation
			-- of current object
		do
			Result := string_representation
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := full_text
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

			Result.append (type_name)
			Result.append_character ('%N')

			Result.append (value.text)
			Result.append_character ('%N')
		end

end
