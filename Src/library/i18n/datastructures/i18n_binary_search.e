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

feature
	search (a_string : STRING_32; i_th : INTEGER) : STRING_32 is
			-- search string in base_array
			-- and return the i_th translated plural form of it
			-- void if not found
		require else
			string_exists: a_string /= Void
		local
			left, right, middle, i: INTEGER
			found: BOOLEAN
			t_string: STRING_32
		do
			--Binary search the string
			-- in the table
			from
				left := base_array.lower
				right := base_array.upper
			invariant
				right >= base_array.lower
						implies base_array.item(right + 1).get_original(1) >= base_array.item(base_array.upper).get_original(1)
				left <= base_array.upper and left > base_array.lower
						implies base_array.item(left - 1).get_original(1) <= base_array.item(base_array.upper).get_original(1)
			--variant
			--	right - left + 1
			-- The invariant must decrease by 1 every iteration
			-- Should try with a log_2(right - left) + 1
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
				end
			end
		end

	initialize is
			-- Initialize the datastructure.
		do
			-- !! We can't guarantee that the strings in base_array are ordered!
		end

end
