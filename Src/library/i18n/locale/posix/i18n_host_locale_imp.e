indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_HOST_LOCALE_IMP
		inherit
			I18N_HOST_LOCALE
			I18N_POSIX_CONSTANTS
				export
					{NONE} all
				end
			I18N_UNIX_C_FUNCTIONS
			I18N_LOCALE_CONV
			IMPORTED_UTF8_READER_WRITER

create
	make_from_user_locale,
	make_from_locale

feature -- Initialization

	make_from_user_locale is
			-- Creation procedure.
			-- create locale form the user locale
		local
			l_c_string : C_STRING
		do
			create l_c_string.make ("")
			set_locale (l_c_string.item)
		end

	make_from_locale (a_locale_id : I18N_LOCALE_ID) is
			-- Creation procedure
			-- Create locale with a_locale_id
		local
			l_c_string : C_STRING
		do
			create l_c_string.make (a_locale_id.language + "_" + a_locale_id.region)
			set_locale (l_c_string.item)
		ensure then
			locale_set: locale_name.is_equal(a_locale_id.language + "_" + a_locale_id.region)
		end



feature -- Informations

	is_available (a_locale_id : I18N_LOCALE_ID) : BOOLEAN is
			-- is 'a_locale' available?
		local
			l_c_string: C_STRING
		do
			create l_c_string.make (a_locale_id.language + "_" + a_locale_id.region)
			Result := c_is_available (l_c_string.item)
		end

	available_locales : LINKED_LIST[I18N_LOCALE_ID] is
			-- get list of available locales
		local
			l_locale_id: I18N_LOCALE_ID
			directory: DIRECTORY
			dir_entries: ARRAYED_LIST[STRING]
		do
			create directory.make_open_read ("/usr/share/i18n/locales/")
			dir_entries := directory.linear_representation
			from
				create Result.make
				dir_entries.start
			until
				dir_entries.after
			loop
				create l_locale_id.make_from_string (dir_entries.item)
				if is_available (l_locale_id) then
					Result.extend (l_locale_id)
				end
				dir_entries.forth
			end
		end


	current_locale_id : I18N_LOCALE_ID is
			-- current locale id
		do
			create Result.make_from_string (locale_name)
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
			create Result.make_from_c (get_locale_info (D_fmt))
			Result.replace_substring_all ("%%","&")
		end

	get_short_date_format: STRING_32 is
			-- get the short date format string
			-- according the current locale setting
		do
			create Result.make_from_c (get_locale_info (D_fmt))
			Result.replace_substring_all ("%%","&")
		end

	get_long_time_format: STRING_32 is
			-- get the long time format string
			-- according the current locale setting
		obsolete
			"UNTIL NOW, SAME RESULT AS%
			 %get_short_time_format"
		do
			create Result.make_from_c (get_locale_info (T_fmt))
			Result.replace_substring_all ("%%","&")
		end

	get_short_time_format: STRING_32 is
			-- get the short time format string
			-- according the current locale setting
		do
			create Result.make_from_c (get_locale_info (T_fmt))
			Result.replace_substring_all ("%%","&")
		end

	get_am_suffix : STRING_32 is
			-- get the am suffix
			-- if the not available: empty_string
		do
			create Result.make_from_c (get_locale_info (Am_str))
		end

	get_pm_suffix : STRING_32 is
			-- get the pm suffix
			-- if the not available: empty_string
		do
			create Result.make_from_c (get_locale_info (Pm_str))
		end

	get_date_time_format: STRING_32 is
			-- time and date in a locale-specific way.
		do
			create Result.make_from_c (get_locale_info (D_t_fmt))
		end


feature -- day/months names

	get_day_names: ARRAY[STRING_32] is
			-- array with the full weekday names
			-- according the current locale settings
		local
			i,upper : INTEGER
			l_string : STRING_32
		do
			upper := {DATE_CONSTANTS}.Days_in_week
			create Result.make(1,upper)
			from
				i := Result.lower
			variant
				Result.count - i + 1
			until
				i > Result.upper
			loop
				create l_string.make_from_c (get_locale_info (Day_1 +((i-1)\\upper)))
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
				create l_string.make_from_c (get_locale_info (Mon_1 +i-1))
				Result.put (l_string, i)
				i := i + 1
			end
		end

	get_abbreviated_day_names: ARRAY[STRING_32] is
			-- array with the abbreviated weekday names
			-- according the current locale settings
		local
			i, upper : INTEGER
			l_string : STRING_32
		do
			upper := {DATE_CONSTANTS}.Days_in_week
			create Result.make(1,upper)
			create Result.make(1,7)
			from
				i := Result.lower
			variant
				Result.count - i + 1
			until
				i > Result.upper
			loop
				create l_string.make_from_c (get_locale_info (Abday_1 +((i-1)\\upper)))
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
				create l_string.make_from_c (get_locale_info (Abmon_1 +i-1))
				Result.put (l_string, i)
				i := i + 1
			end
		end


feature	-- number formatting

	get_value_decimal_separator: STRING_32 is
			-- get the decimal separator of numbers
			-- according the current locales setting
		do
			create Result.make_from_c (decimal_point (localeconv))
		end

	get_value_numbers_after_decimal_separator: INTEGER is
			-- get the decimal separator of numbers
			-- according the current locales setting
		obsolete
			"NOT IMPLEMENTED"
		do
			Result := 2
		end

	get_value_group_separator: STRING_32 is
			-- get the group separator (the separator thousend sep.)
			-- according the current locales setting
		do
			create Result.make_from_c (thousands_sep (localeconv))
		end

	get_value_number_list_separator: STRING_32 is
			-- get the symbol used to separate values
			-- according the current locales setting
		obsolete
			"NOT IMPLEMENTED"
		do
			 Result := ";"
		end

	get_value_grouping: ARRAY[INTEGER] is
			--
		local
			l_string: STRING_32
			i, t: INTEGER
		do
			Result := pointer_to_array (grouping (localeconv))
		end


feature	-- currency formatting

	get_currency_symbol: STRING_32 is
			-- get the currency symbol
			-- according the current locales setting
		do
			create Result.make_from_c (get_locale_info (Crncystr))
			Result.remove_head (1)
				-- could use:
				-- create Result.make_from_c (currency_symbol (localeconv))
				-- but it would need a character set convertion...
		end

	get_int_currency_symbol: STRING_32 is
			-- ISO 4217 currency code
		do
			create Result.make_from_c (int_curr_symbol (localeconv))
		end


	get_currency_symbol_location : INTEGER is
			-- get the integer that represents
			-- the currency symbol localtion
		local
			l_string: STRING_32
		do
			create l_string.make_from_c (get_locale_info (CRNCYSTR))
			if	l_string.item (1).is_equal ('-') then
				Result := {I18N_LOCALE_INFO}.Currency_symbol_prefixed
			elseif l_string.item (1).is_equal ('+') then
				Result := {I18N_LOCALE_INFO}.Currency_symbol_appended
			elseif l_string.item (1).is_equal ('.') then
				Result := {I18N_LOCALE_INFO}.Currency_symbol_radix
			else
				-- Return as default value currency_symbol_prefixed
				Result := {I18N_LOCALE_INFO}.Currency_symbol_prefixed
			end
		end

	get_currency_decimal_separator: STRING_32 is
			-- get the decimal separator of currency numbers
			-- according the current locales setting
		do
			create Result.make_from_c (currency_symbol (localeconv))
		end

	get_currency_numbers_after_decimal_separator: INTEGER is
			-- numbers after the decimal separator for currencynumbers
			-- according the current locales setting
		obsolete
			"TO CHOOSE WHICH"
		do
			Result := frac_digits (localeconv).natural_32_code.to_integer_32
			Result := int_frac_digits (localeconv).natural_32_code.to_integer_32
			if Result = {CHARACTER_8}.Max_value then
				Result := {I18N_CURRENCY_INFO}.Default_currency_numbers_after_decimal_separator
			end
		end

	get_currency_group_separator: STRING_32 is
			-- get the decimal separator of numbers
			-- according the current locales setting
		do
			create Result.make_from_c(mon_decimal_point (localeconv))
		end

	get_currency_number_list_separator: STRING_32 is
			-- NOT IMPLEMENTED, I did not find this inf. on unix
			-- get the symbol used to separate a list
			-- of currency numbers
			-- according the current locales setting
		do
			Result := ","
--			Result := {I18N_CURRENCY_INFO}.Default_currency_number_list_separator
		end

	get_currency_grouping: ARRAY[INTEGER] is
			-- ?
		local
			l_str: STRING_32
		do
			Result := pointer_to_array (mon_grouping (localeconv))
		end

feature {NONE} --Implementation

	pointer_to_array (a_pointer: POINTER): ARRAY[INTEGER] is
			--
		local
			l_string: STRING_32
			i, t: INTEGER
		do
			create l_string.make_from_c (a_pointer)
			create Result.make (1, l_string.count)
			from
				i := 1
			until
				i > l_string.count
			loop
				t := (l_string.item (i)).natural_32_code.as_integer_32
				if t = {CHARACTER}.Max_value then
					-- finished with the string
					i := l_string.count
				else
					Result.put (t, i)
				end
				i := i + 1
			end
			if t /= {CHARACTER}.Max_value then
				Result.force (0, i)
			end
		end


end
