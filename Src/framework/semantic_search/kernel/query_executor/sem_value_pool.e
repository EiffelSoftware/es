note
	description: "Pool of values"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_VALUE_POOL

inherit
	DS_HASH_SET [IR_VALUE]
		redefine
			make
		end

	IR_SHARED_EQUALITY_TESTERS
		undefine
			is_equal,
			copy
		end

create
	make

feature{NONE} -- Initialization

	make (n: INTEGER)
			-- Create an empty container and allocate
			-- memory space for at least `n' items.
		do
			Precursor (n)
			set_equality_tester (ir_value_equality_tester)

			create integers.make (100)
			create booleans.make (2)
		end

feature -- Access

	integer_value (a_integer: INTEGER): IR_INTEGER_VALUE
			-- Integer value represneting `a_integer'
			-- If there is no such value in Current, create one, put it
			-- in Current and return it. Otherwise, return the exising one.
		local
			l_integers: like integers
		do
			l_integers := integers
			l_integers.search (a_integer)
			if l_integers.found then
				Result := l_integers.found_item
			else
				create Result.make (a_integer)
				force_last (Result)
				l_integers.extend (Result, a_integer)
			end
		end

	boolean_value (a_boolean: BOOLEAN): IR_BOOLEAN_VALUE
			-- Integer value represneting `a_boolean'
			-- If there is no such value in Current, create one, put it
			-- in Current and return it. Otherwise, return the exising one.
		local
			l_booleans: like booleans
		do
			l_booleans := booleans
			l_booleans.search (a_boolean)
			if l_booleans.found then
				Result := l_booleans.found_item
			else
				create Result.make (a_boolean)
				force_last (Result)
				l_booleans.extend (Result, a_boolean)
			end
		end

feature{NONE} -- Implementation

	integers: HASH_TABLE [IR_INTEGER_VALUE, INTEGER]
			-- All integer values in Current.

	booleans: HASH_TABLE [IR_BOOLEAN_VALUE, BOOLEAN]
			-- All boolean values in Current.

end
