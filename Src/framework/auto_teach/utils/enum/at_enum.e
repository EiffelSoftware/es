note
	description: "Summary description for {AT_ENUM}." -- TODO
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AT_ENUM

feature -- Access

	-- TODO: feature comments

	name: STRING

	numerical_values: ARRAY [INTEGER]
		local
			i: INTEGER
		once ("OBJECT")
			create Result.make_filled (-1, 1, values.count)

			from
				i := 1
			until
				i > Result.count
			loop
				Result [i] := values [i].numerical_value
				i := i + 1
			end
		end

	value_names: ARRAY [STRING]
		local
			i: INTEGER
		once ("OBJECT")
			create Result.make_filled (Void, 1, values.count)

			from
				i := 1
			until
				i > Result.count
			loop
				Result [i] := values [i].name
				i := i + 1
			end
		end

	values: ARRAY [like tuple_type]
		deferred
		end

	value_type: AT_ENUM_VALUE
			-- The value type of this enum. For typing only.
		require
			callable: False
		deferred
		end

	tuple_type: TUPLE [numerical_value: INTEGER; name: STRING]
			-- For typing only.
		require
			callable: False
		do
			check callable: False end
		end

	numerical_value (a_value_name: STRING): INTEGER
		require
			valid_value_name: is_valid_value_name (a_value_name)
		local
			l_generic_tuple: detachable TUPLE
			l_tuple: like tuple_type
		do
			l_generic_tuple := find_tuple (values, a_value_name, 2)
			check attached {TUPLE [numerical_value: INTEGER; name: STRING]} l_generic_tuple end
			if attached {TUPLE [numerical_value: INTEGER; name: STRING]} l_generic_tuple as l_checked_tuple then
					-- We do this just to make sure that the type is really "like tuple_type".
					-- Unfortunately it is not possible to make an object test to "like tuple_type".
				l_tuple := l_checked_tuple
				Result := l_tuple.numerical_value
			end
		end

	value_name (a_numerical_value: INTEGER): STRING
		require
			valid_numerical_value: is_valid_numerical_value (a_numerical_value)
		local
			l_generic_tuple: detachable TUPLE
			l_tuple: like tuple_type
		do
			l_generic_tuple := find_tuple (values, a_numerical_value, 1)
			check attached {TUPLE [numerical_value: INTEGER; name: STRING]} l_generic_tuple end
			if attached {TUPLE [numerical_value: INTEGER; name: STRING]} l_generic_tuple as l_checked_tuple then
					-- We do this just to make sure that the type is really "like tuple_type".
					-- Unfortunately it is not possible to make an object test to "like tuple_type".
				l_tuple := l_checked_tuple
				Result := l_tuple.name
			end
		end

	is_valid_numerical_value (a_numerical_value: INTEGER): BOOLEAN
		do
			Result := find_tuple (values, a_numerical_value, 1) /= Void
		end

	is_valid_value_name (a_value_name: STRING): BOOLEAN
		do
			Result := find_tuple (values, a_value_name, 2) /= Void
		end

	value (a_value_name: STRING): like value_type
			-- The value with name `a_value_name'.
		deferred
		end

	value_from_number (a_numerical_value: INTEGER): like value_type
			-- The value with numerical value `a_numerical_value'.
		deferred
		end

feature {NONE} -- Implementation

	find_tuple (a_tuples: ITERABLE [TUPLE]; a_value: ANY; a_position: INTEGER): detachable TUPLE
		require
			valid_index:
				across a_tuples as ic all ic.item.valid_index (a_position) end
		do
			across a_tuples as ic loop
				if Result = Void and then ic.item [a_position].is_equal (a_value) then
					Result := ic.item
				end
			end
		end

end
