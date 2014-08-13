note
	description: "Summary description for {AT_ENUM}." -- TODO
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AT_ENUM

inherit

	ANY
		redefine
			is_equal
		end

feature -- Access

		-- TODO: feature comments

	name: STRING
		deferred
		end

	numerical_values: ARRAY [INTEGER]
		local
			i: INTEGER
		once ("OBJECT")
			create Result.make_filled (-1, 1, value_list.count)
			from
				i := 1
			until
				i > Result.count
			loop
				Result [i] := value_list [i].numerical_value
				i := i + 1
			end
		end

	value_names: ARRAY [STRING]
		local
			i: INTEGER
		once ("OBJECT")
			create Result.make_filled (Void, 1, value_list.count)
			from
				i := 1
			until
				i > Result.count
			loop
				Result [i] := value_list [i].name
				i := i + 1
			end
		end

	value_type: AT_ENUM_VALUE
			-- The value type of this enum. For typing only.
		require
			callable: False
		deferred
		end

	values: ARRAY [like value_type]
		local
			l_numerical_values: like numerical_values
			l_value: like value_type
			i: INTEGER
		do
				-- As 'once' routines do not support type anchors, we will handle
				-- lazy initialization by ourselves.
			if attached lazy_values as l_lazy_values then
				Result := l_lazy_values
			else
				l_numerical_values := numerical_values
				create Result.make_filled (default_value, 1, l_numerical_values.count)
				from
					i := 1
				until
					i > l_numerical_values.count
				loop
					Result [i] := value_from_number (l_numerical_values [i])
					i := i + 1
				end
				lazy_values := Result
			end
		end

	is_valid_numerical_value (a_numerical_value: INTEGER): BOOLEAN
		do
			Result := find_tuple (value_list, a_numerical_value, 1) /= Void
		end

	is_valid_value_name (a_value_name: STRING): BOOLEAN
		do
			Result := find_tuple (value_list, a_value_name, 2) /= Void
		end

	value (a_value_name: STRING): like value_type
			-- The value with name `a_value_name'.
		deferred
		end

	value_from_number (a_numerical_value: INTEGER): like value_type
			-- The value with numerical value `a_numerical_value'.
		deferred
		end

feature -- Equality

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		local
			l_this_value_list, l_other_value_list: like value_list
			i: INTEGER
		do
			Result := True
			Result := Result and other.name.same_string (name)
			l_this_value_list := value_list
			l_other_value_list := other.value_list
			if l_this_value_list.count /= l_other_value_list.count then
				Result := False
			else
				from
					i := 1
				until
					i > l_this_value_list.count
				loop
					Result := Result and (l_this_value_list [i] ~ l_other_value_list [i])
					i := i + 1
				end
			end
			Result := Result
		end

feature {AT_ENUM} -- Value list

	value_list: ARRAY [TUPLE [numerical_value: INTEGER; name: STRING]]
		deferred
		end

feature {AT_ENUM_VALUE} -- Used by values

	numerical_value (a_value_name: STRING): INTEGER
		require
			valid_value_name: is_valid_value_name (a_value_name)
		local
			l_generic_tuple: detachable TUPLE
		do
			l_generic_tuple := find_tuple (value_list, a_value_name, 2)
			check
				attached {TUPLE [numerical_value: INTEGER; name: STRING]} l_generic_tuple
			end
			if attached {TUPLE [numerical_value: INTEGER; name: STRING]} l_generic_tuple as l_tuple then
				Result := l_tuple.numerical_value
			end
		end

	value_name (a_numerical_value: INTEGER): STRING
		require
			valid_numerical_value: is_valid_numerical_value (a_numerical_value)
		local
			l_generic_tuple: detachable TUPLE
		do
			l_generic_tuple := find_tuple (value_list, a_numerical_value, 1)
			check
				attached {TUPLE [numerical_value: INTEGER; name: STRING]} l_generic_tuple
			end
			if attached {TUPLE [numerical_value: INTEGER; name: STRING]} l_generic_tuple as l_tuple then
				Result := l_tuple.name
			end
		end

feature {NONE} -- Implementation

	default_value: like value_type
			-- Trick learned from the Eiffel code base, somewhere: this works both for reference and expanded types.

	lazy_values: detachable ARRAY [like value_type]

	find_tuple (a_tuples: ITERABLE [TUPLE]; a_value: ANY; a_position: INTEGER): detachable TUPLE
		require
			valid_index: across a_tuples as ic all ic.item.valid_index (a_position) end
		do
			across
				a_tuples as ic
			loop
				if Result = Void and then ic.item [a_position].is_equal (a_value) then
					Result := ic.item
				end
			end
		end

end
