note
	description: "Enum type for AutoTeach modes (auto, manual, custom)."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_ENUM_MODE

inherit

	AT_ENUM [AT_MODE]
		redefine
			name
		end

feature -- Access

	name: STRING = "mode"
		-- <Precursor>

	value (a_value_name: STRING): AT_MODE
			-- The value with name `a_value_name'.
		do
			create Result.make_with_value_name (a_value_name)
		end

	value_from_number (a_numerical_value: INTEGER): AT_MODE
			-- The value with numerical value `a_numerical_value'.
		do
			create Result.make_with_numerical_value (a_numerical_value)
		end

feature {AT_ENUM} -- Value list

	value_list: ARRAY [TUPLE [numerical_value: INTEGER; value_name: STRING]]
			-- Effective list of values.
		once ("PROCESS")
			Result := <<	[1, "auto"],
							[2, "manual"],
							[3, "custom"]		>>
		end

feature -- Values

	M_auto: AT_MODE
		once ("PROCESS")
			create Result.make_with_numerical_value (1)
		end

	M_manual: AT_MODE
		once ("PROCESS")
			create Result.make_with_numerical_value (2)
		end

	M_custom: AT_MODE
		once ("PROCESS")
			create Result.make_with_numerical_value (3)
		end

end
