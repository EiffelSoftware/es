note
	description: "Value for an enumeration type."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AT_ENUM_VALUE

inherit

	HASHABLE
		undefine
			is_equal
		redefine
			hash_code
		end

	COMPARABLE
		redefine
			is_equal,
			is_less
		end


feature -- Access

	enum_type: AT_ENUM [like Current]
			-- The enumeration type of this value.
		deferred
		end

	initialized: BOOLEAN
			-- Was `Current' initialized to a meaningful value?

	numerical_value: INTEGER
			-- The numerical value of this enumeration value. Immutable.
		require
			initialized: initialized
		do
			Result := internal_numerical_value
		end

	value_name: STRING
			-- The name of this enumeration value.
		require
			initialized: initialized
		do
			Result := enum_type.value_name (numerical_value)
		end

feature -- Comparison

	-- The following features must be callable even if the value has not been initialized.
	-- The first reason is that we cannot enforce a stricter precondition than the ancestor
	-- version, the second reason is that we cannot prevent them from being called on
	-- uninitialized values by data structures such as HASH_TABLE [AT_ENUM_VALUE, SOMETHING]

	is_equal (a_other: like Current): BOOLEAN
			-- <Precursor>
		do
			Result := a_other.enum_type.is_equal (enum_type) and then a_other.internal_numerical_value.is_equal (numerical_value)
		end

	is_less alias "<" (a_other: like Current): BOOLEAN
			-- <Precursor>
		do
			Result := internal_numerical_value < a_other.internal_numerical_value
		end

	hash_code: INTEGER
			-- <Precursor>
		do
				-- As hash codes are always non-negative, the following operation
				-- can never result in an over/underflow. Think about it.
			Result := (enum_type.name.hash_code - internal_numerical_value.abs).hash_code
		end


feature {AT_ENUM_VALUE} -- Implementation

	internal_numerical_value: INTEGER
			-- The numerical value of this enumeration value. Immutable.

feature {NONE} -- Initialization - to be used by descendants

	make_with_numerical_value (a_numerical_value: INTEGER)
			-- Initialization for `Current'.
		require
			valid_numerical_value: enum_type.is_valid_numerical_value (a_numerical_value)
		do
			internal_numerical_value := a_numerical_value
			initialized := True
		end

	make_with_value_name (a_value_name: STRING)
			-- Initialization for `Current'.
		require
			valid_value_name: enum_type.is_valid_value_name (a_value_name)
		do
			internal_numerical_value := enum_type.numerical_value (a_value_name)
			initialized := True
		end

invariant

		-- 'Dented' invariant, disabled during initialization.
		-- This is necessary because inheriting classes will be expanded, thus must have a default_create
		-- initialization feature, and we don't want to force descendants to redefine it and specify
		-- a default value (there are cases where no default value would be meaningful).
		-- At least, we make sure through the use of contracts that nobody ever reads an uninitialized value.
	valid_numerical_value: not initialized or else enum_type.is_valid_numerical_value (numerical_value)

end
