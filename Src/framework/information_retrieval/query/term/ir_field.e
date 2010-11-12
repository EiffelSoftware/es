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

	IR_VALUE_TYPES
		undefine
			out
		end

create
	make,
	make_as_string,
	make_as_integer,
	make_as_double,
	make_as_boolean,
	make_with_raw_value

feature{NONE} -- Initialization

	make (a_name: like name; a_value: like value; a_boost: DOUBLE)
			-- Initialize Current.
		do
			name := a_name
			value := a_value
			boost := a_boost
			hash_code := full_text.hash_code
		end

	make_as_string (a_name: like name; a_string_value: STRING; a_boost: DOUBLE)
			-- Initialize Current as a string value.
		do
			make (a_name, create {IR_STRING_VALUE}.make (a_string_value), a_boost)
		end

	make_as_integer (a_name: like name; a_integer_value: INTEGER; a_boost: DOUBLE)
			-- Initialize Current as an integer value.
		do
			make (a_name, create {IR_INTEGER_VALUE}.make (a_integer_value), a_boost)
		end

	make_as_double (a_name: like name; a_double_value: DOUBLE; a_boost: DOUBLE)
			-- Initialize Current as a double value.
		do
			make (a_name, create {IR_DOUBLE_VALUE}.make (a_double_value), a_boost)
		end

	make_as_boolean (a_name: like name; a_boolean_value: BOOLEAN; a_boost: DOUBLE)
			-- Initialize Current as an boolean value.
		do
			make (a_name, create {IR_BOOLEAN_VALUE}.make (a_boolean_value), a_boost)
		end

	make_with_raw_value (a_name: like name; a_raw_value: STRING; a_type: INTEGER; a_boost: DOUBLE)
			-- Initialize with `a_raw_value', this value must have `a_type'.
		require
			a_type_valid: is_ir_value_type_valid (a_type)
		local
			l_parts: LIST [STRING]
		do
			if a_type = ir_boolean_value_type then
				make_as_boolean (a_name, a_raw_value.to_boolean, a_boost)
			elseif a_type = ir_integer_value_type then
				make_as_integer (a_name, a_raw_value.to_integer, a_boost)
			elseif a_type = ir_string_value_type then
				make_as_string (a_name, a_raw_value.twin, a_boost)
			elseif a_type = ir_integer_range_value_type then
				l_parts := a_raw_value.substring (2, a_raw_value.count - 1).split (',')
				l_parts.first.left_adjust
				l_parts.first.right_adjust
				l_parts.last.left_adjust
				l_parts.last.right_adjust
				make (
					a_name,
					create {IR_INTEGER_RANGE_VALUE}.make (l_parts.first.to_integer, l_parts.last.to_integer),
					a_boost)
			end
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

	value_text: STRING
			-- Text representation of `value'
		do
			Result := value.text
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
