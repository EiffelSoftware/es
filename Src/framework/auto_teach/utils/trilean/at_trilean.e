note
	description: "Represents a variable which can assume the following values: True, False, Undefined"
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	AT_TRILEAN

inherit

	ANY
		redefine
			default_create,
			is_equal,
			out
		end

create
	default_create, make_undefined, make_defined

convert
	make_defined ({BOOLEAN})

feature {NONE} -- Initialization

	make_undefined, default_create
			-- Initialize `Current' in the undefined state.
		do
			is_defined := False
		end

	make_defined (a_value: BOOLEAN)
			-- Initialize `Current' to `a_value'.
		do
			is_defined := True
			internal_value := a_value
		end

feature -- Value

	value: BOOLEAN
			-- Boolean value of `Current'.
			-- Only callable if the value of `Current' is defined (i.e. not 'undefined').
		require
			is_defined
		do
			Result := internal_value
		end

	is_defined: BOOLEAN
			-- Is `Current' set to a boolean value?

	is_undefined: BOOLEAN
			-- Is `Current' Undefined?
		do
			Result := not is_defined
		end

	is_true: BOOLEAN
			-- Is `Current' True?
		do
			Result := is_defined and then value
		end

	is_false: BOOLEAN
			-- Is `Current' False?
		do
			Result := is_defined and then not value
		end

	out: STRING
			-- <Precursor>
		do
			if is_defined then
				Result := value.out
			else
				Result := "Undefined"
			end
		end

feature -- Assignment

	set_value (a_value: BOOLEAN)
			-- Set `Current' to `a_value'.
		do
			is_defined := True
			internal_value := a_value
		end

	set_true
			-- Set `Current' to True.
		do
			set_value (True)
		end

	set_false
			-- Set `Current' to False.
		do
			set_value (False)
		end

	set_undefined
			-- Set `Current' to Undefined.
		do
			is_defined := False
		end

	from_string (a_string: READABLE_STRING_GENERAL)
			-- Parse a string representation of a trilean and set `Current' accordingly.
		require
			valid_string: is_valid_string_value (a_string)
		local
			l_string: STRING
		do
			l_string := a_string.to_string_8.as_lower
			if (across true_strings as ic some ic.item.same_string (l_string) end) then
				set_true
			elseif (across false_strings as ic some ic.item.same_string (l_string) end) then
				set_false
			elseif (across undefined_strings as ic some ic.item.same_string (l_string) end) then
				set_undefined
			else
					-- Should be disallowed by precondition.
				check
					string_recognized: False
				end
			end
		end

	is_valid_string_value (a_string: READABLE_STRING_GENERAL): BOOLEAN
			-- Is `a_string' a valid string representation of a trilean?
		do
			if a_string = Void then
				Result := False
			else
				Result := all_strings.has (a_string.to_string_8.as_lower)
			end
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			-- Is `Current' equal to `other'?
		do
			Result := (not Current.is_defined and not other.is_defined) or else (Current.is_defined and other.is_defined and Current.value = other.value)
		end

feature -- Operations

	conjuncted alias "and", conjuncted_semistrict alias "and then" (other: like Current): like Current
			-- Boolean conjunction with `other'
		do
			if not Current.is_defined then
				Result := other
			elseif not other.is_defined then
				Result := Current
			else
					-- Both are defined
				create Result.make_defined (Current.value and other.value)
			end
		end

		-- Implication is not defined.

	negated alias "not": like Current
			-- Negation
		do
			if not is_defined then
				create Result.make_undefined
			else
				create Result.make_defined (not value)
			end
		end

	disjuncted alias "or", disjuncted_semistrict alias "or else" (other: like Current): like Current
			-- Boolean disjunction with `other'
		do
			if not Current.is_defined then
				Result := other
			elseif not other.is_defined then
				Result := Current
			else
					-- Both are defined
				create Result.make_defined (Current.value or other.value)
			end
		end

	disjuncted_exclusive alias "xor" (other: like Current): like Current
			-- Boolean exclusive or with `other'
		do
			if not Current.is_defined then
				Result := other
			elseif not other.is_defined then
				Result := Current
			else
					-- Both are defined
				create Result.make_defined (Current.value xor other.value)
			end
		end

	subjected_to (other: like Current): like Current
			-- If `other' is defined, Current. Otherwise `other'.
		do
			if other.is_defined then
				Result := other
			else
				Result := Current
			end
		end

	imposed_on (other: like Current): like Current
			-- If current is defined, Current. Otherwise `other'.
		do
			if is_defined then
				Result := Current
			else
				Result := other
			end
		end

		-- Even though `imposed_on' can be passed a BOOLEAN directly,
		-- the following operation has the advantage of directly
		-- returning a BOOLEAN instead of a TRILEAN.
	imposed_on_bool (other: BOOLEAN): BOOLEAN
			-- If current is defined, the value of Current. Otherwise `other'.
		do
			if is_defined then
				Result := value
			else
				Result := other
			end
		end

feature {NONE} -- Implementation

	internal_value: BOOLEAN
			-- Attribute storing the boolean value. Not exposed so that the boolean
			-- value is only readable from outside if `is_defined' is True.

feature {NONE} -- String representation

	all_strings: ARRAY [STRING]
			-- All the possible string representations for all possible values.
		local
			i: INTEGER
		once ("PROCESS")
			i := 1
			create Result.make_filled ("", 1, true_strings.count + false_strings.count + undefined_strings.count)
			Result.compare_objects

			Result.subcopy (true_strings, true_strings.lower, true_strings.upper, i)
			i := i + true_strings.count

			Result.subcopy (false_strings, false_strings.lower, false_strings.upper, i)
			i := i + true_strings.count

			Result.subcopy (undefined_strings, undefined_strings.lower, undefined_strings.upper, i)
		end

	true_strings: ARRAY [STRING]
			-- All the possible string representations for True (lowercase, case insensitive).
		once ("PROCESS")
			Result := << "true", "t", "yes", "y" >>
			Result.compare_objects
		end

	false_strings: ARRAY [STRING]
			-- All the possible string representations for False (lowercase, case insensitive).
		once ("PROCESS")
			Result := << "false", "f", "no", "n" >>
			Result.compare_objects
		end

	undefined_strings: ARRAY [STRING]
			-- All the possible string representations for Undefined (lowercase, case insensitive).
		once ("PROCESS")
			Result := << "undefined", "u", "?" >>
			Result.compare_objects
		end

end
