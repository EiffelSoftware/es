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
			Result := enum_type.placeholder_text (Current)
		end

	is_inline: BOOLEAN
			-- Is this an inline placeholder?
		do
			Result := enum_type.is_inline (Current)
		end

end
