indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	I18N_VALUE_FORMATTER

feature -- Initialization

	make (a_locale_info: I18N_LOCALE_INFO) is
			-- create value formatter according
			-- values in `a_locale_info'
		deferred
		end

feature -- Formatting functions

	format_integer_32 (a_integer_32: INTEGER_32): STRING_32 is
		local
		do
			create Result.make_from_string (format_integer_part (a_integer_32.out) +
											decimal_separator +
											format_real_part ((10^numbers_after_decimal_separator).out))
		ensure
			Result_exists: Result /= Void
		end

	format_real_32 (a_real_32: REAL_32): STRING_32 is
		local
			integer_part,
			fractional_part: INTEGER
		do
			integer_part := a_real_32.truncated_to_integer
			fractional_part := ((a_real_32 - integer_part)*10^numbers_after_decimal_separator).rounded
			create Result.make_from_string (format_integer_part (integer_part.out) +
											decimal_separator +
											format_real_part (fractional_part.out))
		ensure
			Result_exists: Result /= Void
		end

	format_real_64 (a_real_64: REAL_64): STRING_32 is
		local
			integer_part,
			fractional_part: INTEGER
		do
			integer_part := a_real_64.truncated_to_integer
			fractional_part := ((a_real_64 - integer_part)*10^numbers_after_decimal_separator).rounded
			create Result.make_from_string (format_integer_part (integer_part.out) +
											decimal_separator +
											format_real_part (fractional_part.out))
		ensure
			Result_exists: Result /= Void
		end


feature -- Informations

	decimal_separator: STRING_32

	numbers_after_decimal_separator: INTEGER

	group_separator: STRING_32
			-- separator character for thousands
			--(groups of three digits)

	grouping: ARRAY[INTEGER]
			-- how the value are grouped

feature {NONE} -- Implementation

	format_integer_part (a_string: STRING_32): STRING_32 is
			--
		require
			a_string_exists: a_string /= Void
			is_integer: a_string.is_integer
		local
			i,pos: INTEGER
			l_string: STRING_32
		do
			create Result.make_empty
			from
				i := grouping.lower
				pos := a_string.count
			variant
				 grouping.upper - i + 1
			until
				i > grouping.upper or pos < 1
			loop
				if not (grouping.item (i) = 0) then
					-- Current item is the number of digits that comprise the current group.
					if pos - grouping.item (i) > 0 then
						-- there are enougth elements for a new group
						Result.prepend (a_string.substring (pos-grouping.item (i)+1,pos))
						Result.prepend (group_separator)
						pos := pos-grouping.item (i)
					else
						--run out of digits, append rest and finish
						Result.prepend (a_string.substring (1, pos))
						pos := 0
					end
				elseif i-1 >= grouping.lower then
					-- The previous element is to be repeatedly used for the remainder of the digits.
					from
					variant
						pos
					until
						pos < 1	-- no more digits
					loop
						if pos - grouping.item (i-1) > 0 then
							-- there are enougth elements for a new group
							Result.prepend (a_string.substring (pos-grouping.item (i-1)+1, pos))
							Result.prepend (group_separator)
							pos := pos-grouping.item (i-1)
						else
							--run out of digits, append rest and finish
							Result.prepend (a_string.substring (1,pos))
							pos := 0
						end
					end
					i := grouping.upper -- to terminate loop
				else	-- grouping.item (i) = 0 and i-1 < grouping.lower
						-- i.e. no valid grouping array. Append rest to result and finish
					Result.prepend (a_string.substring (1,pos))
					i := grouping.upper -- to terminate loop
				end
				i := i + 1
			end
		ensure
			Result_exists: Result /= Void
		end

	format_real_part (a_string: STRING_32): STRING_32 is
			--
		require
			a_string_exists: a_string /= Void
			is_integer: a_string.is_integer
		do
			create Result.make_empty
			Result := a_string.substring (1,numbers_after_decimal_separator)
		ensure
			Result_exists: Result /= Void
		end

invariant
	decimal_separator_exists: decimal_separator /= Void
	reasonable_numbers_after_decimal_separator: numbers_after_decimal_separator >= 0
	group_separator_exists: group_separator  /= Void
	valid_grouping: grouping /= Void and then grouping.count > 0	
end
