note
	description: "Types for values"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IR_VALUE_TYPES


feature -- Type constants

	ir_integer_value_type: INTEGER = 1
			-- Integer type

	ir_boolean_value_type: INTEGER = 2
			-- Boolean value type

	ir_string_value_type: INTEGER = 3
			-- String value type

	ir_integer_range_value_type: INTEGER = 4
			-- Integer range value type

feature -- Value type names

	ir_integer_value_type_name: STRING = "INTEGER"
			-- Name for integer type

	ir_integer_range_value_type_name: STRING = "INTEGER_INTERVAL"
			-- Name for integer range type

	ir_boolean_value_type_name: STRING = "BOOLEAN"
			-- Name for boolean type

	ir_string_value_type_name: STRING = "STRING"
			-- Name for string type

feature -- Access

	ir_value_type_name (a_type: INTEGER): STRING
			-- Name of `a_type'
		require
			a_type_valid: is_ir_value_type_valid (a_type)
		do
			if a_type = ir_boolean_value_type then
				Result := ir_boolean_value_type_name
			elseif a_type = ir_integer_value_type then
				Result := ir_integer_range_value_type_name
			elseif a_type = ir_string_value_type then
				Result := ir_string_value_type_name
			elseif a_Type = ir_integer_range_value_type then
				Result := ir_integer_range_value_type_name
			end
		end

feature -- Status report

	is_ir_value_type_valid (a_type: INTEGER): BOOLEAN
			-- Is `a_type' a valid value type?
		do
			Result :=
				a_type = ir_integer_value_type or else
				a_type = ir_boolean_value_type or else
				a_type = ir_string_value_type or else
				a_type = ir_integer_range_value_type
		end
end
