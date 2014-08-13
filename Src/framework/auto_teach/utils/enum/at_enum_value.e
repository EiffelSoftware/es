note
	description: "Summary description for {AT_ENUM_VALUE}." -- TODO
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
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
		deferred
		end

	numerical_value: INTEGER
			-- The numerical value of this enum value. Immutable.

	value_name: STRING
			-- The name of this enum value.
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
			initializing := True

			numerical_value := a_numerical_value
			initializing := False
		end

	make_with_value_name (a_value_name: STRING)
			-- Initialization for `Current'.
		require
			valid_value_name: enum_type.is_valid_value_name (a_value_name)
		do
			initializing := True

			numerical_value := enum_type.numerical_value (a_value_name)
			initializing := False
		end

	initializing: BOOLEAN
		-- Disables the invariant

invariant

		-- 'Dented' invariant, disabled during initialization.
	valid_numerical_value: initializing or else enum_type.is_valid_numerical_value (numerical_value)

end
