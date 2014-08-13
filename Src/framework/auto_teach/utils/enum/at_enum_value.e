note
	description: "Summary description for {AT_ENUM_VALUE}." -- TODO
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class -- Virtually deferred
	AT_ENUM_VALUE

inherit
	ANY
		redefine
			is_equal
		end

	HASHABLE
		undefine
			is_equal
		redefine
			hash_code
		end

feature -- Access

	enum_type: AT_ENUM
			-- The enum type of this value.
			-- Deferred, to be redefined
		require
			callable: False
		do
			check callable: False end
		end

	numerical_value: INTEGER

	value_name: STRING
		do
			Result := enum_type.value_name (numerical_value)
		end

	is_equal (a_other: like Current): BOOLEAN
		do
			Result := a_other.enum_type.is_equal (enum_type) and then a_other.numerical_value.is_equal (numerical_value)
		end

	hash_code: INTEGER
			-- Hash code value
		do
				-- As hash codes are always non-negative, the following operation
				-- can never result in an over/underflow. Think about it.
			Result := (enum_type.name.hash_code - numerical_value.abs).hash_code
		end

feature {NONE} -- Initialization - to be used by descendants

	make_with_numerical_value (a_numerical_value: INTEGER)
			-- Initialization for `Current'.
		require
			valid_numerical_value: enum_type.is_valid_numerical_value (a_numerical_value)
		do
			numerical_value := a_numerical_value
		end

	make_with_value_name (a_value_name: STRING)
			-- Initialization for `Current'.
		require
			valid_value_name: enum_type.is_valid_value_name (a_value_name)
		do
			numerical_value := enum_type.numerical_value (a_value_name)
		end

invariant

	valid_numerical_value: enum_type.is_valid_numerical_value (numerical_value)

end
