note
	description: "Enum value for policy types (default, global, local)."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	AT_POLICY_TYPE

inherit

	AT_ENUM_VALUE
		redefine
			enum_type
		end

create
	default_create, make_with_numerical_value, make_with_value_name

feature -- Enum type

	enum_type: AT_ENUM_POLICY_TYPE
			-- <Precursor>
		once ("PROCESS")
			create Result
		end

end
