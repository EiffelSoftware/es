indexing
	description: "Search string using binary search"
	status: "NOTE: This class has NEVER been tested, don't use it in production environments!"
	author: "i18n Team, ETH Zurich"
	date: "$Date$"

class
	I18N_BINARY_SEARCH

inherit
	I18N_DATASTRUCTURE

create {I18N_DATASTRUCTURE_FACTORY}

	make,
	make_with_datasource

feature {NONE} -- Basic operations

	search (a_string : STRING_32; i_th : INTEGER) : STRING_32 is
			-- search string in base_array
			-- and return the i_th translated plural form of it
			-- void if not found
		require else
			string_exists: a_string /= Void
		local
			left, right, middle: INTEGER
			found: BOOLEAN
			t_string: STRING_32
		do
			--Binary search the string
			-- in the table
			from
				left := base_array.lower
				right := base_array.upper
			invariant
				right < base_array.upper
						implies base_array.item(right + 1).get_original(1) <= base_array.item(base_array.upper).get_original(1)
				left <= base_array.upper and left > base_array.lower
						implies base_array.item(left - 1).get_original(1) <= base_array.item(base_array.upper).get_original(1)
			variant
				right - left + 1
			until
				left > right or found
			loop
				middle := ((left + right).as_natural_32 |>> 1).as_integer_32
				t_string := base_array.item(middle).get_original(1).as_string_32
				if a_string < t_string then
					right := middle - 1
				elseif a_string > t_string then
					left := middle + 1
				else
					-- Found
					found := True
					Result := base_array.item(middle).get_translated(i_th)
					left := left + 1 -- not nice but required to decrease variant
				end
			end
		end

	initialize is
			-- Initialize the datastructure.
		do
			bubble_sort
		end

feature {NONE} --implementation

	bubble_sort is
			-- Sort `base_array'
			-- I use bubble sort because it is efficent
			-- when the array is already sorted, which is
			-- the case when the datasource is a MO file
		require
			base_array_exists: base_array /= Void
		local
			sorted: BOOLEAN
			t_string: I18N_STRING
			i,j: INTEGER
		do
			from
				j := 0
				sorted := False
			invariant
				j >= 0
			variant
				base_array.upper - j + 1
			until
				sorted
			loop
				from
					i := 1
					sorted := True
				invariant
					i >= 1
				variant
					base_array.upper - j - i + 1
				until
					i >= base_array.upper - j
				loop
					if base_array.item(i+1).get_original(1) <  base_array.item(i).get_original(1) then
						t_string := base_array.item(i)
						base_array.put(base_array.item(i+1), i)
						base_array.put(t_string, i+1)
						sorted := False
					end
					i := i + 1
				end
				j := j + 1
			end
		end

end
