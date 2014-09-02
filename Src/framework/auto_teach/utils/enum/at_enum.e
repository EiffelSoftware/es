note
	description: "An enumeration type."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AT_ENUM [G -> AT_ENUM_VALUE]

inherit

	ANY
		redefine
			is_equal
		end

feature -- Access

	name: STRING
			-- The name of this enumeration.
		deferred
		end

	values: ARRAY [G]
			-- List of all the values of the enumeration.
		local
			l_value: G
			i1, i2: INTEGER
		once ("OBJECT")
			create Result.make_filled (default_value, 1, value_list.count)

				-- The two indices are necessary as, theoretically,
				-- `value_list' might not be 1-based. We don't know
				-- what our descendants might think of doing.
			from
				i1 := value_list.lower
				i2 := 1
			until
				i1 > value_list.upper
			loop
				check valid_index: i2 <= Result.upper end
				Result [i2] := value_from_number (value_list [i1].numerical_value)
				i1 := i1 + 1
				i2 := i2 + 1
			end
		end

	is_valid_numerical_value (a_numerical_value: INTEGER): BOOLEAN
			-- Is `a_numerical_value' a valid numerical value in this enumeration?
		do
			Result := numerical_values_table.has_key (a_numerical_value)
		end

	is_valid_value_name (a_value_name: STRING): BOOLEAN
			-- Is `a_value_name' a valid value name in this enumeration?
		do
			Result := value_names_table.has_key (a_value_name)
		end

	value (a_value_name: STRING): G
			-- The value with name `a_value_name'.
		deferred
		end

	value_from_number (a_numerical_value: INTEGER): G
			-- The value with numerical value `a_numerical_value'.
		deferred
		end

	textual_value_list: STRING
			-- String listing all the enum values, separated by commas.
		once ("OBJECT")
			create Result.make (128)
			across value_list as ic loop
				Result.append (ic.item.value_name + ", ")
			end
			if not Result.is_empty then
				Result.remove_tail (2)
			end
		end

feature -- Equality

	is_equal (other: like Current): BOOLEAN
			-- <Precursor>
		local
			l_this_value_list, l_other_value_list: like value_list
			i: INTEGER
		do
			if other = Current then
					-- Shallow equality always implies deep equality.
				Result := True
			else
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
						Result := Result and (tuples_content_equal (l_this_value_list [i], l_other_value_list [i]))
						i := i + 1
					end
				end
			end
		end

feature {AT_ENUM} -- Value list

	value_list: ARRAY [TUPLE [numerical_value: INTEGER; value_name: STRING]]
			-- List of all the valid values of this enumeration under the form of tuples.
			-- To be redefined by subclasses. This is where the values are defined for real.
		deferred
		end

feature {AT_ENUM_VALUE} -- Used by values

	numerical_value (a_value_name: STRING): INTEGER
			-- The numerical value of the value with name `a_value_name'.
		require
			valid_value_name: is_valid_value_name (a_value_name)
		local
			l_index_in_value_list: INTEGER
		do
			check item_present: value_names_table.has_key (a_value_name) end
			l_index_in_value_list := value_names_table [a_value_name]

			check index_valid: value_list.valid_index (l_index_in_value_list) end
			Result := value_list [l_index_in_value_list].numerical_value
		end

	value_name (a_numerical_value: INTEGER): STRING
			-- The name of the value with numerical value `a_numerical_value'.
		require
			valid_numerical_value: is_valid_numerical_value (a_numerical_value)
		local
			l_index_in_value_list: INTEGER
		do
			check item_present: numerical_values_table.has_key (a_numerical_value) end
			l_index_in_value_list := numerical_values_table [a_numerical_value]

			check index_valid: value_list.valid_index (l_index_in_value_list) end
			Result := value_list [l_index_in_value_list].value_name
		end

feature {NONE} -- Implementation

	tuples_content_equal (a_first, a_second: TUPLE): BOOLEAN
			-- Are tuples `a_first' and `a_second' equal by content comparison?
		local
			l_first, l_second: TUPLE
		do
			l_first := a_first.twin
			l_second := a_second.twin

			l_first.compare_objects
			l_second.compare_objects

			Result := l_first ~ l_second
		end

	default_value: G
			-- Trick learned from the Eiffel code base, somewhere: this works both for reference and expanded types.

	numerical_values_table: HASH_TABLE [INTEGER, INTEGER]
			-- Table mapping numerical values (key) to the index of the
			-- corresponding value in the value_list array (value).
		local
			i: INTEGER
		once ("OBJECT")
			create Result.make_equal (value_list.count * 2)
			from
				i := value_list.lower
			until
				i > value_list.upper
			loop
				Result.put (i, value_list [i].numerical_value)
				i := i + 1
			end
		ensure
			correct:
				across Result as ic all ic.key = value_list [ic.item].numerical_value end
		end

	value_names_table: HASH_TABLE [INTEGER, STRING]
			-- Table mapping value names (key) to the index of the
			-- corresponding value in the value_list array (value).
		local
			i: INTEGER
		once ("OBJECT")
			create Result.make_equal (value_list.count * 2)
			from
				i := value_list.lower
			until
				i > value_list.upper
			loop
				Result.put (i, value_list [i].value_name)
				i := i + 1
			end
		ensure
			correct:
				across Result as ic all ic.key ~ value_list [ic.item].value_name end
		end

end
