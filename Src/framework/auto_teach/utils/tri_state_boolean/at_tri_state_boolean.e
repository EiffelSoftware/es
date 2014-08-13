note
	description: "Summary description for {AT_TRI_STATE_BOOLEAN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	AT_TRI_STATE_BOOLEAN

inherit

	ANY
		redefine
			default_create,
			is_equal,
			out
		end

create
	default_create, make_undefined, make_defined

feature -- Value

	value: BOOLEAN
		require
			defined
		do
			Result := internal_value
		end

	defined: BOOLEAN	 -- TODO: rename to is_defined

	is_undefined: BOOLEAN
		do
			Result := not defined
		end

	is_true: BOOLEAN
		do
			Result := defined and then value
		end

	is_false: BOOLEAN
		do
			Result := defined and then not value
		end

	out: STRING
		do
			if defined then
				Result := value.out
			else
				Result := "Undefined"
			end
		end

feature -- Assignment

	set_value (a_value: BOOLEAN)
		do
			defined := True
			internal_value := a_value
		end

	set_true
		do
			set_value (True)
		end

	set_false
		do
			set_value (False)
		end

	set_undefined
		do
			defined := False
		end

	from_string (a_string: READABLE_STRING_GENERAL)
		require
			valid_string: is_valid_string_value (a_string)
		local
			l_string: READABLE_STRING_GENERAL
		do
			l_string := a_string.as_lower
			if l_string.same_string ("undefined") then
				set_undefined
			elseif l_string.same_string ("true") then
				set_true
			elseif l_string.same_string ("false") then
				set_false
			else
					-- Should be disallowed by precondition.
				check
					string_recognized: False
				end
			end
		end

	is_valid_string_value (a_string: READABLE_STRING_GENERAL): BOOLEAN
		local
			l_string: READABLE_STRING_GENERAL
		do
			if a_string = Void then
				Result := False
			else
				l_string := a_string.as_lower
				Result := l_string.same_string ("undefined") or l_string.same_string ("true") or l_string.same_string ("false")
			end
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			-- Is `Current' equal to `other'?
		do
			Result := (not Current.defined and not other.defined) or else (Current.defined and other.defined and Current.value = other.value)
		end

feature -- Operations

	conjuncted alias "and", conjuncted_semistrict alias "and then" (other: like Current): like Current
			-- Boolean conjunction with `other'
		do
			if not Current.defined then
				Result := other
			elseif not other.defined then
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
			if not defined then
				create Result.make_undefined
			else
				create Result.make_defined (not value)
			end
		end

	disjuncted alias "or", disjuncted_semistrict alias "or else" (other: like Current): like Current
			-- Boolean disjunction with `other'
		do
			if not Current.defined then
				Result := other
			elseif not other.defined then
				Result := Current
			else
					-- Both are defined
				create Result.make_defined (Current.value or other.value)
			end
		end

	disjuncted_exclusive alias "xor" (other: like Current): like Current
			-- Boolean exclusive or with `other'
		do
			if not Current.defined then
				Result := other
			elseif not other.defined then
				Result := Current
			else
					-- Both are defined
				create Result.make_defined (Current.value xor other.value)
			end
		end

	subjected_to (other: like Current): like Current
			-- If `other' is defined, Current. Otherwise `other'.
		do
			if other.defined then
				Result := other
			else
				Result := Current
			end
		end

	imposed_on (other: like Current): like Current
			-- If current is defined, Current. Otherwise `other'.
		do
			if defined then
				Result := Current
			else
				Result := other
			end
		end

	imposed_on_bool (other: BOOLEAN): BOOLEAN
			-- If current is defined, the value of Current. Otherwise `other'.
		do
			if defined then
				Result := value
			else
				Result := other
			end
		end

feature {NONE} -- Initialization

	internal_value: BOOLEAN

	make_undefined, default_create
			-- Initialize `Current' in the undefined state.
		do
			defined := False
		end

	make_defined (a_value: BOOLEAN)
			-- Initialize `Current' to `a_value'.
		do
			defined := True
			internal_value := a_value
		end

end
