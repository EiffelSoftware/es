indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_HOST_LOCALE_IMP
		inherit
			I18N_HOST_LOCALE

create
	make_from_user_locale,
	make_from_locale

feature -- Initialization

	make_from_user_locale is
			-- Creation procedure.
			-- create locale form the user locale
		do
			c_set_default_locale
		end

	make_from_locale (a_locale_id : I18N_LOCALE_ID) is
			-- Creation procedure
			-- Create locale with a_locale_id
		local
			l_c_string : C_STRING
		do
			create l_c_string.make (a_locale_id.name)
			c_set_locale (l_c_string.item)
		ensure then
			locale_set: locale_name.is_equal(a_locale_id.name)
		end

feature -- Informations

	is_available (a_locale_id : I18N_LOCALE_ID) : BOOLEAN is
			-- is 'a_locale' available?
		local
			l_c_string: C_STRING
		do
			create l_c_string.make (a_locale_id.name)
			Result := c_is_available (l_c_string.item)
		end

	available_locales : LINKED_LIST[I18N_LOCALE_ID] is
			-- get list of available locales
		local
			i, max : INTEGER
			l_string : STRING_32
			l_locale_id: I18N_LOCALE_ID
			l_pointer : POINTER
		do
			max := c_init_available_locales
			create l_string.make_empty
			from
				i := 1
				create Result.make
			variant
				max-i+1
			until
				i > max
			loop
				l_pointer := c_ith_locale (i-1)
				if l_pointer /= default_pointer then
					l_string.make_from_c (l_pointer)
					create l_locale_id.make (l_string)
					Result.extend (l_locale_id.twin)
				end
				i := i + 1
			end
		end


	current_locale_id : I18N_LOCALE_ID is
			-- current locale id
		do
			create Result.make (locale_name)
		end

	locale_name : STRING_32 is
			-- name of current locale
		do
			create Result.make_from_c (c_locale_name)
		end


feature -- Date and time formatting

	get_long_date_format: STRING_32 is
			-- get the long date format string
			-- according the current locale setting
		obsolete
			"UNTIL NOW, SAME RESULT AS%
			 %get_short_date_format"
		do
			create Result.make_from_c (c_date_pattern)
		end

	get_short_date_format: STRING_32 is
			-- get the short date format string
			-- according the current locale setting
		do
			create Result.make_from_c (c_date_pattern)
		end

	get_long_time_format: STRING_32 is
			-- get the long time format string
			-- according the current locale setting
		obsolete
			"UNTIL NOW, SAME RESULT AS%
			 %get_short_time_format"
		do
			create Result.make_from_c (c_time_pattern)
		end

	get_short_time_format: STRING_32 is
			-- get the short time format string
			-- according the current locale setting
		do
			create Result.make_from_c (c_time_pattern)
		end

	get_am_suffix : STRING_32 is
			-- get the am suffix
			-- if the not available: empty_string
		do
			create Result.make_from_c (c_am_designator)
		end

	get_pm_suffix : STRING_32 is
			-- get the pm suffix
			-- if the not available: empty_string
		do
			create Result.make_from_c (c_pm_designator)
		end

feature -- day/months names

	get_day_names: ARRAY[STRING_32] is
			-- array with the full weekday names
			-- according the current locale settings
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
			-- array with the full month names
			-- according the current locale settings
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
			-- array with the abbreviated weekday names
			-- according the current locale settings
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
			-- array with the abbreviated month names
			-- according the current locale settings
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
			-- get the decimal separator of numbers
			-- according the current locales setting
		do
			create Result.make_from_c (c_value_decimal_separator)
		end

	get_value_numbers_after_decimal_separator: INTEGER is
			-- get the decimal separator of numbers
			-- according the current locales setting
		obsolete
			"NOT IMPLEMENTED"
		do
			Result := c_value_numbers_after_decimal_separator.to_integer_32
		end

	get_value_group_separator: STRING_32 is
			-- get the group separator (the separator thousend sep.)
			-- according the current locales setting
		do
			create Result.make_from_c (c_value_group_separator)
		end

	get_value_number_list_separator: STRING_32 is
			-- get the symbol used to separate values
			-- according the current locales setting
		obsolete
			"NOT IMPLEMENTED"
		do
			Result := "NOT IMPLEMENTED"
--			create Result.make_from_c (c_value_number_list_separator)
		end

	get_value_grouping: ARRAY[INTEGER] is
			--
		obsolete
			"NOT IMPLEMENTED"
		do
			Result := <<3,3,0>>
		end


feature	-- currency formatting

	get_currency_symbol: STRING_32 is
			-- get the currency symbol
			-- according the current locales setting
		do
			create Result.make_from_c (c_currency_symbol)
			Result.remove_head (1)
		end

	get_currency_symbol_location : INTEGER is
			-- get the integer that represents
			-- the currency symbol localtion
		local
			l_string: STRING_32
		do
			create l_string.make_from_c (c_currency_symbol)
			if	l_string.item (1).is_equal ('-') then
				Result := {I18N_LOCALE_INFO}.currency_symbol_prefixed
			elseif l_string.item (1).is_equal ('+') then
				Result := {I18N_LOCALE_INFO}.currency_symbol_appended
			elseif l_string.item (1).is_equal ('.') then
				Result := {I18N_LOCALE_INFO}.currency_symbol_radix
			else
				-- Return as default value currency_symbol_prefixed
				Result := {I18N_LOCALE_INFO}.currency_symbol_prefixed
			end
		end

	get_currency_decimal_separator: STRING_32 is
			-- get the decimal separator of currency numbers
			-- according the current locales setting
		obsolete
			"NOT TESTED"
		do
			create Result.make_from_c (c_currency_decimal_separator)
		end

	get_currency_numbers_after_decimal_separator: INTEGER is
			-- numbers after the decimal separator for currencynumbers
			-- according the current locales setting
		do
			Result := c_currency_numbers_after_digit_sepatator.natural_32_code.to_integer_32
		end

	get_currency_group_separator: STRING_32 is
			-- get the decimal separator of numbers
			-- according the current locales setting
		obsolete
			"NOT IMPLEMENTED"
		do
			Result := ","
		end

	get_currency_number_list_separator: STRING_32 is
			-- get the symbol used to separate a list
			-- of currency numbers
			-- according the current locales setting
		obsolete
			"NOT IMPLEMENTED"
		do
			Result := "."
		end

	get_currency_grouping: ARRAY[INTEGER] is
			-- ?
		obsolete
			"NOT IMPLEMENTED"
		do
			Result := <<3,3,0>>
		end

feature {NONE} -- C functions

	c_set_locale ( a_pointer : POINTER) is
			-- set the locale to the locale
			-- represented by the string pointed by `a_pointer'
		require
			valid_a_pointer: a_pointer /= default_pointer
		external "C (EIF_POINTER)| %"ci18n.h%""
		alias "set_locale"
		end

	c_set_default_locale is
			-- set the locale to the user locale
		external "C ()| %"ci18n.h%""
		alias "set_default_locale"
		end


feature {NONE} -- C Informations

	c_is_available (a_pointer : POINTER) : BOOLEAN is
			-- see: `is_available'
		external "C (EIF_POINTER): EIF_BOOLEAN| %"ci18n.h%""
		alias "is_available"
		end

	c_ith_locale (a_integer : INTEGER) : POINTER is
			-- get i_th available locale name
		external "C (EIF_INTEGER): EIF_POINTER| %"ci18n.h%""
		alias "ith_locale"
		end

	c_init_available_locales : INTEGER is
			-- initialize available locales
			-- and returns the max amount of available locales
		external "C () : EIF_INTEGER| %"ci18n.h%""
		alias "init_available_locales"
		end

	c_locale_name : POINTER is
			-- see: `locale_name'
		external "C (): EIF_POINTER| %"ci18n.h%""
		alias "locale_name"
		end


feature {NONE} -- C date/time formatting

	c_date_pattern : POINTER is
			-- see: `get_date_pattern'
		external "C () : EIF_POINTER| %"ci18n.h%""
		end

	c_time_pattern : POINTER is
			-- see: `get_time_pattern'
		external "C () : EIF_POINTER| %"ci18n.h%""
		end

	c_am_designator : POINTER is
			-- see: `get_am_suffix'
		external "C () : EIF_POINTER| %"ci18n.h%""
		alias "am_designator"
		end

	c_pm_designator : POINTER is
			-- see: `get_pm_suffix'
		external "C () : EIF_POINTER| %"ci18n.h%""
		alias "pm_designator"
		end

feature {NONE} -- C days/months names

	c_get_abday (i_th : INTEGER) : POINTER is
			-- get i-th abbreviated day name of week
		external "C (EIF_INTEGER) : EIF_POINTER| %"ci18n.h%""
		alias "get_abday"
		end

	c_get_day (i_th : INTEGER) : POINTER is
			-- get i-th day name of week
		external "C (EIF_INTEGER) : EIF_POINTER| %"ci18n.h%""
		alias "get_day"
		end

	c_get_abmon (i_th : INTEGER) : POINTER is
			-- get i-th abbreviated month name
		external "C (EIF_INTEGER) : EIF_POINTER| %"ci18n.h%""
		alias "get_abmon"
		end

	c_get_mon (i_th : INTEGER) : POINTER is
			-- get i-th abbreviated month name
		external "C (EIF_INTEGER) : EIF_POINTER| %"ci18n.h%""
		alias "get_mon"
		end

feature {NONE} -- C numbers formatting

	c_value_decimal_separator: POINTER is
			-- Return radix character (decimal dot, decimal comma, etc.)
			-- see: `get_value_decimal_separator'
		external "C () : EIF_POINTER| %"ci18n.h%""
		alias "numeric_decimal_point"
		end

	c_value_numbers_after_decimal_separator: POINTER is
			-- see: `get_value_numbers_after_decimal_separator'
		obsolete
			"NOT IMPLEMENTED"
		do
		end

	c_value_group_separator: POINTER is
			--see: `get_value_group_separator'
		external "C () : EIF_POINTER| %"ci18n.h%""
		alias "numeric_group_separator"
		end

	c_value_number_list_separator: POINTER is
			-- see: `get_value_number_list_separator'
		obsolete
			"NOT IMPLEMENTED"
		do
		end

	c_value_grouping: POINTER is
			-- see: `get_value_grouping'
		external "C () : EIF_POINTER| %"ci18n.h%""
		alias "numeric_grouping"
		end

feature {NONE} -- C currency formatting

	c_currency_symbol: POINTER is
			-- see: `get_currency_symbol'
		external "C () : EIF_POINTER| %"ci18n.h%""
		alias "currency_symbol"
		end

	c_currency_int_symbol: POINTER is
			-- get the internationa currency representation
		external "C () : EIF_POINTER| %"ci18n.h%""
		alias "currency_int_symbol"
		end

	c_currency_decimal_separator : POINTER is
			-- see: `get_currency_decimal_separator'
		external "C () : EIF_POINTER| %"ci18n.h%""
		alias "currency_dec_point"
		end

	c_currency_thousend_sep: POINTER is
			-- see: `get_currency_thousend_sep'
		external "C () : EIF_POINTER| %"ci18n.h%""
		alias "currency_thousend_sep"
		end

	c_currency_numbers_after_digit_sepatator : CHARACTER is
			-- see: `get_currency_numbers_ager_digit_sepatator'
		external "C () : EIF_CHARACTER| %"ci18n.h%""
		alias "currency_numbers_after_dec_sepatator"
		end

	c_currency_int_numbers_after_digit_sepatator : CHARACTER is
			-- see: `get_currency_numbers_ager_digit_sepatator'
			-- (international)
		external "C () : EIF_CHARACTER| %"ci18n.h%""
		alias "currency_int_numbers_after_dec_sepatator"
		end

end
