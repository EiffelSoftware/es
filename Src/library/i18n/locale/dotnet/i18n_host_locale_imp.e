indexing
	description: "Objects that..."
	author: "Etienne"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_HOST_LOCALE_IMP
		inherit
			I18N_HOST_LOCALE

create make_from_user_locale, make_from_locale

feature -- Initialization

	make_from_user_locale is
			-- Creation procedure,
			-- uses user defined locale
		local
			t_culture_info : CULTURE_INFO
		do
			create t_culture_info.make_from_culture (1)
			create culture_info.make_from_name (t_culture_info.current_culture.name)
		ensure then
			culture_info_exists: culture_info /= Void
		end

	make_from_locale (a_locale_id : I18N_LOCALE_ID) is
			-- Creation procedure
			-- create from name
		do
			create culture_info.make_from_name (a_locale_id.language+"-"+a_locale_id.region)
		ensure then
			culture_info_exists : culture_info /= Void
		end


feature -- Element change

	set_locale (a_locale_name : STRING_32) is
			-- set current locale to `a_locale_name'
		do
			create culture_info.make_from_name (a_locale_name)
		end

feature -- Informations

	is_available (a_locale_id : I18N_LOCALE_ID) : BOOLEAN is
			-- I guess it is always true
		local
			l_culture_type : CULTURE_TYPES
		do
			Result := True
		end

	available_locales : LINKED_LIST[I18N_LOCALE_ID] is
			-- get list of available locales
		local
			l_culture_type : CULTURE_TYPES
			l_list: NATIVE_ARRAY [CULTURE_INFO]
			i : INTEGER
			l_locale_id: I18N_LOCALE_ID
		do
			create l_culture_type
			l_list := culture_info.get_cultures (l_culture_type.specific_cultures)
			from
				create Result.make
				i := l_list.lower
			variant
				l_list.count-i+1
			until
				i > l_list.upper
			loop
				io.put_string (l_list.item (i).name+"%N")
				create l_locale_id.make_from_string (l_list.item (i).name)
				Result.extend (l_locale_id.twin)
				i := i + 1
			end
		end

	current_locale_id : I18N_LOCALE_ID is
			-- return the current locale info
		do
			create Result.make_from_string (culture_info.current_culture.name)
		end


feature -- Date and time formatting

	get_long_date_format: STRING_32 is
		do
			Result := culture_info.date_time_format.long_date_pattern
		end

	get_long_time_format : STRING_32 is
			--
		do
			Result := culture_info.date_time_format.long_time_pattern
		end

	get_short_time_format : STRING_32 is
			--
		do
			Result := culture_info.date_time_format.short_time_pattern
		end

	get_short_date_format : STRING_32 is
			--
		do
			Result := culture_info.date_time_format.short_date_pattern
		end

	get_am_suffix  : STRING_32 is
			--
		do
			Result := culture_info.date_time_format.am_designator
		end

	get_pm_suffix : STRING_32 is
			-- No description
		do
			Result := culture_info.date_time_format.pm_designator
		end

feature -- day/months names

	get_day_names: ARRAY[STRING_32] is
			--
		local
			l_array: ARRAY[SYSTEM_STRING]
			i : INTEGER
		do
			l_array := culture_info.date_time_format.month_names
			create Result.make (l_array.lower, l_array.upper)
			from
				i := l_array.lower
			until
				i > l_array.upper
			loop
				Result.put (l_array.item (i),i)
				i := i + 1
			end
		end

	get_month_names: ARRAY[STRING_32] is
			--
		local
			l_array : NATIVE_ARRAY[SYSTEM_STRING]
			i : INTEGER
		do
			l_array := culture_info.date_time_format.month_names
			create Result.make (l_array.lower, l_array.upper)
			from
				i := l_array.lower
			until
				i > l_array.upper
			loop
				Result.put (l_array.item (i),i)
				i := i + 1
			end
		end

	get_abbreviated_day_names: ARRAY[STRING_32] is
			--
		local
			l_array : NATIVE_ARRAY[SYSTEM_STRING]
			i : INTEGER
		do
			l_array := culture_info.date_time_format.abbreviated_day_names
			create Result.make (l_array.lower, l_array.upper)
			from
				i := l_array.lower
			until
				i > l_array.upper
			loop
				Result.put (l_array.item (i),i)
				i := i + 1
			end
		end

	get_abbreviated_month_names: ARRAY[STRING_32] is
			--
		local
			l_array : NATIVE_ARRAY[SYSTEM_STRING]
			i : INTEGER
		do
			l_array := culture_info.date_time_format.abbreviated_month_names
			create Result.make (l_array.lower, l_array.upper)
			from
				i := l_array.lower
			until
				i > l_array.upper
			loop
				Result.put (l_array.item (i),i)
				i := i + 1
			end
		end

feature	-- number formatting

	get_value_decimal_separator: STRING_32 is
		do
			Result := culture_info.number_format.number_decimal_separator
		end

	get_value_numbers_after_decimal_separator: INTEGER is
			--
		do
			Result := culture_info.number_format.number_decimal_digits
		end

	get_value_group_separator: STRING_32 is
			--
		do
			Result := culture_info.number_format.number_group_separator
		end

	get_value_number_list_separator: STRING_32 is
			--
		obsolete
			"NOT IMPLEMENTED"
		do
--			Result := culture_info.number_format.
		end

	get_value_grouping: ARRAY[INTEGER_32] is
			--
		local
			l_array : ARRAY[INTEGER]
		do
--			Result := culture_info.number_format.number_group_sizes
		end

feature	-- currency formatting

	get_currency_symbol: STRING_32 is
			--
		do
			Result := culture_info.number_format.currency_symbol
		end

	get_int_currency_symbol: STRING_32 is
			--
		do
			Result := culture_info.invariant_culture.number_format.currency_symbol
		end

	get_currency_decimal_separator: STRING_32 is
			--
		do
			Result := culture_info.number_format.currency_decimal_separator
		end

	get_currency_numbers_after_decimal_separator: INTEGER is
			--
		do
			Result := culture_info.number_format.currency_decimal_digits
		end

	get_currency_group_separator: STRING_32 is
			--
		do
			Result := culture_info.number_format.currency_group_separator
		end

	get_currency_number_list_separator: STRING_32 is
			--
		obsolete
			"NOT IMPLEMENTED"
		do
			Result := ";"
		end

	get_currency_grouping: ARRAY[INTEGER_32] is
			--
		do
			Result := culture_info.number_format.currency_group_sizes
		end


feature {NONE} -- NOT USED Symbols

	date_separator : STRING_32 is
			-- separator in the date pattern
		do
			Result := culture_info.date_time_format.date_separator
		end

	time_separator : STRING_32 is
			-- separator in the time pattern
		do
			Result := culture_info.date_time_format.time_separator
		end

	decimal_separator : STRING_32 is
			-- decimal point separator
		do
			Result := culture_info.number_format.number_decimal_separator
		end

	group_separator : STRING_32 is
			-- separator between the groups
		do
			Result := culture_info.number_format.number_group_separator
		end

feature {NONE} -- NOT USED Short Pattern

	short_time_pattern : STRING_32 is
			-- short time pattern
		do
			Result := culture_info.date_time_format.short_time_pattern
		end

	short_date_pattern : STRING_32 is
			-- short date pattern
		do
			Result := culture_info.date_time_format.short_date_pattern
		end

feature {NONE} -- NOT USED Long Pattern

	long_date_pattern : STRING_32 is
			-- long date pattern
		do
			Result := culture_info.date_time_format.long_date_pattern
		end

feature {NONE} -- NOT USED Other Pattern

	full_date_time_pattern : STRING_32 is
			-- full date time pattern
		do
			Result := culture_info.date_time_format.full_date_time_pattern
		end

	month_day_pattern : STRING_32 is
			-- pattern with month and day
		do
			Result := culture_info.date_time_format.month_day_pattern
		end

	year_month_pattern : STRING_32 is
			-- pattern with year and month
		do
			Result := culture_info.date_time_format.month_day_pattern
		end

	rfc1123_pattern : STRING_32 is
			-- rfc1123 is: ddd, dd MMM yyyy HH':'mm':'ss 'GMT'
		do
			Result := culture_info.date_time_format.rfc1123_pattern
		end

	sortable_date_time_pattern: STRING_32 is
			-- a sortable time pattern
			-- yyyy'-'MM'-'dd'T'HH':'mm':'ss
		do
			Result := culture_info.date_time_format.sortable_date_time_pattern
		end

	universal_sortable_date_time_pattern: STRING_32 is
			-- a sortable pattern
			-- yyyy'-'MM'-'dd HH':'mm':'ss'Z'
		do
			Result := culture_info.date_time_format.universal_sortable_date_time_pattern
		end

feature -- General Information

	name : STRING_32 is
			-- name of current locale
		do
			Result := culture_info.name
		end




feature {NONE} -- Implementation

	culture_info : CULTURE_INFO

	first_day : INTEGER is
			-- first day of the week
		do
			Result := culture_info.date_time_format.first_day_of_week.to_integer
		end
end
