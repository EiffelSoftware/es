indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_LINUX_LOCALE
		inherit
			I18N_HOST_LOCALE

create
	make_from_user_locale,
	make_from_locale

feature -- Initialization

	make_from_user_locale is
			-- Creation procedure.
		do
			c_set_default_locale
		end

	make_from_locale (a_locale_id : I18N_LOCALE_ID) is
			--
		local
			l_c_string : C_STRING
		do
			create l_c_string.make (a_locale_id.name)
			c_set_locale (l_c_string.item)
		end

feature -- Informations

	is_available (a_locale_id : I18N_LOCALE_ID) : BOOLEAN is
			-- is 'a_locale' avaiable?
		local
			l_c_string: C_STRING
		do
			create l_c_string.make (a_locale_id.name)
			Result := c_is_available (l_c_string.item)
		end

	available_locales : LINKED_LIST[STRING_32] is
			-- get list of available locales
		local
			i, max : INTEGER
			l_string : STRING_32
			l_pointer : POINTER
		do
			max := c_init_available_locales
			create l_string.make_empty
			from
				i := 1
				create Result.make
			until
				i > max
			loop
				l_pointer := c_ith_locale (i-1)
				if l_pointer /= default_pointer then
					l_string.make_from_c (l_pointer)
					Result.extend (l_string.twin)
				end
				i := i + 1
			end

		end


feature -- Date and time formatting

	get_long_date_format: STRING_32 is
		obsolete
			"UNTIL NOW, SAME RESULT AS%
			 %get_short_date_format"
		do
			create Result.make_from_c (c_date_pattern)
		end

	get_short_date_format: STRING_32 is
			--
		do
			create Result.make_from_c (c_date_pattern)
		end

	get_long_time_format: STRING_32 is
		obsolete
			"UNTIL NOW, SAME RESULT AS%
			 %get_short_time_format"
		do
			create Result.make_from_c (c_time_pattern)
		end

	get_short_time_format: STRING_32 is
			--
		do
			create Result.make_from_c (c_time_pattern)
		end

	get_am_suffix : STRING_32 is
			--
		do
			create Result.make_from_c (c_am_designator)
		end

	get_pm_suffix : STRING_32 is
			--
		do
			create Result.make_from_c (c_pm_designator)
		end

feature -- day/months names

	get_day_names: ARRAY[STRING_32] is
			--
		local
			i : INTEGER
			l_string : STRING_32
		do
			create Result.make(1,{DATE_CONSTANTS}.Days_in_week)
			from
				i := Result.lower
			variant
				Result.count - i + 1
			until
				i > Result.upper
			loop
				create l_string.make_from_c (c_get_day (i))
				Result.put (l_string, i)
				i := i + 1
			end
		end

	get_month_names: ARRAY[STRING_32] is
			--
		local
			i : INTEGER
			l_string : STRING_32
		do
			create Result.make(1,{DATE_CONSTANTS}.Months_in_year)
			from
				i := Result.lower
			variant
				Result.count - i + 1
			until
				i > Result.upper
			loop
				create l_string.make_from_c (c_get_mon (i))
				Result.put (l_string, i)
				i := i + 1
			end
		end

	get_abbreviated_day_names: ARRAY[STRING_32] is
			--
		local
			i : INTEGER
			l_string : STRING_32
		do
			create Result.make(1,{DATE_CONSTANTS}.Days_in_week)
			from
				i := Result.lower
			variant
				Result.count - i + 1
			until
				i > Result.upper
			loop
				create l_string.make_from_c (c_get_abday (i))
				Result.put (l_string, i)
				i := i + 1
			end
		end

	get_abbreviated_month_names: ARRAY[STRING_32] is
			--
		local
			i : INTEGER
			l_string : STRING_32
		do
			create Result.make(1,{DATE_CONSTANTS}.Months_in_year)
			from
				i := Result.lower
			variant
				Result.count - i + 1
			until
				i > Result.upper
			loop
				create l_string.make_from_c (c_get_abmon (i))
				Result.put (l_string, i)
				i := i + 1
			end
		end


feature	-- number formatting

	get_value_decimal_separator: STRING_32 is
		do
			create Result.make_from_c (c_value_decimal_separator)
		end

	get_value_numbers_after_decimal_separator: INTEGER is
			--
		obsolete
			"NOT IMPLEMENTED"
		do
			Result := c_value_numbers_after_decimal_separator.to_integer_32
		end

	get_value_group_separator: STRING_32 is
			--
		do
			create Result.make_from_c (c_thousend_sep)
		end

	get_value_number_list_separator: STRING_32 is
			--
		obsolete
			"NOT IMPLEMENTED"
		do
			Result := "NOT IMPLEMENTED"
--			create Result.make_from_c (c_value_number_list_separator)
		end

	get_value_grouping: ARRAY[STRING_32] is
			--
		obsolete
			"NOT IMPLEMENTED"
		do
--			Result := to_string (c_thousend_step)
		end


feature	-- currency formatting

	get_currency_symbol: STRING_32 is
			--
		obsolete
			"NEED CONVERTIONS...%
			%Returns the currency symbol, preceded by%
			% '-' if the symbol should appear before the value,%
			% '+' if the symbol should appear after the value,%
			% '.' if the symbol should replace the radix character. "
		do
			create Result.make_from_c (c_currency_symbol)
		end

	get_currency_decimal_separator: STRING_32 is
			--
		obsolete
			"NOT TESTED"
		do
			create Result.make_from_c (c_currency_decimal_separator)
		end

	get_currency_numbers_after_decimal_separator: INTEGER is
			--
		obsolete
			"DOES NOT WORK%
			% it strangely returns a poiter to the currency symbol"
		do
			Result := c_currency_numbers_after_digit_sepatator.to_integer_32
			Result := 0
		end

	get_currency_group_separator: STRING_32 is
			--
		obsolete
			"NOT IMPLEMENTED"
		do
			Result := ","
		end

	get_currency_number_list_separator: STRING_32 is
			--
		obsolete
			"NOT IMPLEMENTED"
		do
			Result := "."
		end

	get_currency_grouping: ARRAY[STRING_32] is
			--
		obsolete
			"NOT IMPLEMENTED"
		do
			Result := <<"E","R","R","o","r">>
		end

feature {NONE} -- C functions

	c_set_locale ( a_pointer : POINTER) is
			--
		external "C (EIF_POINTER)| %"/home/etienner/Project/es-i18n/Src/library/i18n/include/main.h%""
		alias "set_locale"
		end

	c_set_default_locale is
			--
		external "C ()| %"/home/etienner/Project/es-i18n/Src/library/i18n/include/main.h%""
		alias "set_default_locale"
		end

feature {NONE} -- C Informations

	c_is_available (a_pointer : POINTER) : BOOLEAN is
			--
		external "C (EIF_POINTER): EIF_BOOLEAN| %"/home/etienner/Project/es-i18n/Src/library/i18n/include/main.h%""
		alias "is_available"
		end

	c_ith_locale (a_integer : INTEGER) : POINTER is
			-- get i_th available locale name
		external "C (EIF_INTEGER): EIF_POINTER| %"/home/etienner/Project/es-i18n/Src/library/i18n/include/main.h%""
		alias "ith_locale"
		end

	c_init_available_locales : INTEGER is
			-- initialize available locales
			-- and returns the max amount of available locales
		external "C () : EIF_INTEGER| %"/home/etienner/Project/es-i18n/Src/library/i18n/include/main.h%""
		alias "init_available_locales"
		end


feature {NONE} -- C date/time formatting

	c_date_pattern : POINTER is
			--
		external "C () : EIF_POINTER| %"/home/etienner/Project/es-i18n/Src/library/i18n/include/main.h%""
		end

	c_time_pattern : POINTER is
			--
		external "C () : EIF_POINTER| %"/home/etienner/Project/es-i18n/Src/library/i18n/include/main.h%""
		end

	c_am_designator : POINTER is
			-- get the am designator
		external "C () : EIF_POINTER| %"/home/etienner/Project/es-i18n/Src/library/i18n/include/main.h%""
		alias "am_designator"
		end

	c_pm_designator : POINTER is
			-- get the pm designator
		external "C () : EIF_POINTER| %"/home/etienner/Project/es-i18n/Src/library/i18n/include/main.h%""
		alias "pm_designator"
		end

feature {NONE} -- C days/months names

	c_get_abday (i_th : INTEGER) : POINTER is
			-- get i-th abbreviated day name of week
		external "C (EIF_INTEGER) : EIF_POINTER| %"/home/etienner/Project/es-i18n/Src/library/i18n/include/main.h%""
		alias "get_abday"
		end

	c_get_day (i_th : INTEGER) : POINTER is
			-- get i-th day name of week
		external "C (EIF_INTEGER) : EIF_POINTER| %"/home/etienner/Project/es-i18n/Src/library/i18n/include/main.h%""
		alias "get_day"
		end

	c_get_abmon (i_th : INTEGER) : POINTER is
			-- get i-th abbreviated month name
		external "C (EIF_INTEGER) : EIF_POINTER| %"/home/etienner/Project/es-i18n/Src/library/i18n/include/main.h%""
		alias "get_abmon"
		end

	c_get_mon (i_th : INTEGER) : POINTER is
			-- get i-th abbreviated month name
		external "C (EIF_INTEGER) : EIF_POINTER| %"/home/etienner/Project/es-i18n/Src/library/i18n/include/main.h%""
		alias "get_mon"
		end

feature {NONE} -- C numbers formatting

	c_value_decimal_separator: POINTER is
			-- Return radix character (decimal dot, decimal comma, etc.)
		external "C () : EIF_POINTER| %"/home/etienner/Project/es-i18n/Src/library/i18n/include/main.h%""
		alias "radix_char"
		end

	c_value_numbers_after_decimal_separator: POINTER is
			--
		obsolete
			"NOT IMPLEMENTED"
		do
		end

	c_value_group_separator: POINTER is
			--
		obsolete
			"NOT IMPLEMENTED"
		external "C () : EIF_POINTER| %"/home/etienner/Project/es-i18n/Src/library/i18n/include/main.h%""
		alias "monetary_thousend_sep"
		end

	c_value_number_list_separator: POINTER is
			--
		obsolete
			"NOT IMPLEMENTED"
		do
		end

feature {NONE} -- C currency formatting

	c_currency_decimal_separator : POINTER is
			--
		external "C () : EIF_POINTER| %"/home/etienner/Project/es-i18n/Src/library/i18n/include/main.h%""
		alias "monetary_dec_point"
		end

	c_currency_numbers_after_digit_sepatator : POINTER is
			--
		external "C () : EIF_POINTER| %"/home/etienner/Project/es-i18n/Src/library/i18n/include/main.h%""
		alias "currency_numbers_after_dec_sepatator"
		end


	c_thousend_sep: POINTER is
			-- thousend step separator
		external "C () : EIF_POINTER| %"/home/etienner/Project/es-i18n/Src/library/i18n/include/main.h%""
		alias "thousend_sep"
		end

	c_currency_symbol : POINTER is
			--
		external "C () : EIF_POINTER| %"/home/etienner/Project/es-i18n/Src/library/i18n/include/main.h%""
		alias "currency_symbol"
		end
end
