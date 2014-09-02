note
	description: "Enum type for code placeholders."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_ENUM_PLACEHOLDER

inherit

	AT_ENUM [AT_PLACEHOLDER]
		redefine
			name
		end

feature -- Access

	name: STRING = "placeholder"
			-- <Precursor>

	value (a_value_name: STRING): AT_PLACEHOLDER
			-- The value with name `a_value_name'.
		do
			create Result.make_with_value_name (a_value_name)
		end

	value_from_number (a_numerical_value: INTEGER): AT_PLACEHOLDER
			-- The value with numerical value `a_numerical_value'.
		do
			create Result.make_with_numerical_value (a_numerical_value)
		end

feature {AT_ENUM} -- Value list

	value_list: ARRAY [TUPLE [numerical_value: INTEGER; value_name: STRING]]
			-- Effective list of values.
		once ("PROCESS")
			Result := <<	[0, "no_placeholder"],
							[1, "standard_placeholder"],
							[2, "arguments_placeholder"],
							[3, "if_condition_placeholder"]		>>
		end

	inline_placeholders: ARRAY [AT_PLACEHOLDER]
			-- List of placeholders that must be inserted inline.
		once ("PROCESS")
			Result := <<Ph_none, Ph_if_condition>>
		end

feature -- Values

	Ph_none: AT_PLACEHOLDER
		once ("PROCESS")
			create Result.make_with_numerical_value (0)
		end

	Ph_standard: AT_PLACEHOLDER
		once ("PROCESS")
			create Result.make_with_numerical_value (1)
		end

	Ph_arguments: AT_PLACEHOLDER
		once ("PROCESS")
			create Result.make_with_numerical_value (2)
		end

	Ph_if_condition: AT_PLACEHOLDER
		once ("PROCESS")
			create Result.make_with_numerical_value (3)
		end

feature -- Properties

	placeholder_text (a_placeholder: AT_PLACEHOLDER): STRING
			-- Text of `a_placeholder'.
		do
			if a_placeholder = Ph_none then
				Result := ""
			elseif a_placeholder = Ph_standard then
				Result := at_strings.standard_code_placeholder
			elseif a_placeholder = Ph_arguments then
				Result := at_strings.arguments_code_placeholder
			elseif a_placeholder = Ph_if_condition then
				Result := at_strings.if_condition_code_placeholder
			else
					-- The class invariant of `AT_VALUE_TYPE' guarantees
					-- that we always have a valid value. This means that
					-- this can only happen if a new placeholder type is added
					-- and we forget to add the respective if branch here.
				check
					value_recognized: False
				end
				Result := ""
			end
		end

	is_inline (a_placeholder: AT_PLACEHOLDER): BOOLEAN
			-- Is `a_placeholder' an inline placeholder?
		do
			Result := inline_placeholders.has (a_placeholder)
		end

feature {NONE} -- Implementation

	at_strings: AT_STRINGS
			-- Strings
		once ("PROCESS")
			create Result
		end

end
