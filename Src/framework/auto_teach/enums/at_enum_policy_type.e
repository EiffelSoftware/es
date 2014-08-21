note
	description: "Enum type for policy types (default, global, local)."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_ENUM_POLICY_TYPE

inherit

	AT_ENUM
		redefine
			name
		end

feature -- Access

	name: STRING = "policy_type"
			-- <Precursor>

	value_type: AT_POLICY_TYPE
			-- <Precursor>
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
			-- Effective list of values.
		once ("PROCESS")
			Result := <<	[0, "not_set"],
							[1, "default"],
							[2, "global"],
							[3, "local"]		>>
		end

feature -- Values

	Pt_not_set: AT_POLICY_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (0)
		end

	Pt_default: AT_POLICY_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (1)
		end

	Pt_global: AT_POLICY_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (2)
		end

	Pt_local: AT_POLICY_TYPE
		once ("PROCESS")
			create Result.make_with_numerical_value (3)
		end

end
