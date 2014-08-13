note
	description: "Enum value for code placeholderds."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	AT_PLACEHOLDER

inherit

	AT_ENUM_VALUE
		redefine
			enum_type
		end

create
	default_create, make_with_numerical_value, make_with_value_name

feature -- Enum type

	enum_type: AT_ENUM_PLACEHOLDER
		once ("PROCESS")
			create Result
		end

feature -- Placeholder text

	text: STRING
			-- Placeholder text
		do
			if Current = enum_type.ph_standard then
				Result := at_strings.code_standard_placeholder
			elseif Current = enum_type.ph_arguments then
				Result := at_strings.code_arguments_placeholder
			else
					-- The class invariant of `AT_VALUE_TYPE' guarantees
					-- that we always have a valid value. This means that
					-- this can only happen if a new placeholder type is added
					-- and we forget to add the respective if branch here.
				check value_recognized: False end
			end
		end

feature {NONE} -- Implementation

	at_strings: AT_STRINGS
			-- Strings
		once ("PROCESS")
			create Result
		end

end
