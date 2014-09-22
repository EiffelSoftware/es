note
	description: "Enum value for block types."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	AT_BLOCK_TYPE

inherit

	AT_ENUM_VALUE
		redefine
			enum_type
		end

create
	default_create, make_with_numerical_value, make_with_value_name

feature -- Enum type

	enum_type: AT_ENUM_BLOCK_TYPE
			-- <Precursor>
		once ("PROCESS")
			create Result
		end

feature -- Block classification

	is_atomic: BOOLEAN
			-- Is `Current' an atomic block type?
		do
			Result := enum_type.is_atomic_block_type (Current)
		end

	is_complex: BOOLEAN
			-- Is `Current' a complex block type?
		do
			Result := enum_type.is_complex_block_type (Current)
		end

end
