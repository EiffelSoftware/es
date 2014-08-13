note
	description: "Enum type for code placeholders."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_ENUM_PLACEHOLDER

inherit

	AT_ENUM
		redefine
			name
		end

feature -- Access

	name: STRING = "placeholder"

	value_type: AT_PLACEHOLDER
			-- The value type of this enum. For typing only.
		do
			check
				callable: False
			end
		end

	value (a_value_name: STRING): like value_type
			-- The value with name `a_value_name'.
		do
			create Result.make_with_value_name (a_value_name)
		end

	value_from_number (a_numerical_value: INTEGER): like value_type
			-- The value with numerical value `a_numerical_value'.
		do
			create Result.make_with_numerical_value (a_numerical_value)
		end

feature {AT_ENUM} -- Value list

	value_list: ARRAY [TUPLE [numerical_value: INTEGER; name: STRING]]
		once ("PROCESS")
			Result := <<[1, "standard_placeholder"], [2, "arguments_placeholder"]>>
		end

feature -- Values

	ph_standard: AT_PLACEHOLDER
		once ("PROCESS")
			create Result.make_with_numerical_value (1)
		end

	ph_arguments: AT_PLACEHOLDER
		once ("PROCESS")
			create Result.make_with_numerical_value (2)
		end

end
