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
			is_integer: a_string.is_integer
		local
			i,k : INTEGER
			l_string: STRING_32
		do
			create Result.make_empty
			from
				i := grouping.lower
				k := a_string.count
			until
				i > grouping.upper or k < 1
			loop
				if not (grouping.item (i) = 0) then
					if k - grouping.item (i) > 0 then
						Result.prepend (a_string.substring (k-grouping.item (i)+1,k))
						Result.prepend (group_separator)
						k := k-grouping.item (i)
					else
						Result.prepend (a_string.substring (1, k))
						k := 0
					end
				else
					from until
						k < 1
					loop
						if k - grouping.item (i-1) > 0 then
							Result.prepend (a_string.substring (k-grouping.item (i-1)+1, k))
							Result.prepend (group_separator)
							k := k-grouping.item (i-1)
						else
							Result.prepend (a_string.substring (1,k))
							k := 0
						end
					end
					i := grouping.upper
				end
				i := i + 1
			end
		end

	format_real_part (a_string: STRING_32): STRING_32 is
			--
		require
			is_integer: a_string.is_integer
		do
			create Result.make_empty
			Result := a_string.substring (1,numbers_after_decimal_separator)
		end

end
