indexing
	description: "Objects that..."
	author: "Etienne"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_DOTNET_LOCALE
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
			create culture_info.make_from_name (a_locale_id.name)
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
		obsolete
			"To test if it is always true"
		do
			Result := True
		end

	available_locales : LINKED_LIST[I18N_LOCALE_ID] is
			-- get list of available locales
		obsolete
			"NOT IMPLEMENTED"
		do
		end

feature -- Date and time formatting

	get_long_date_format: STRING_32_32 is
		do
			Result := culture_info.date_time_format.long_date_pattern.to_string_32
		end
		
	get_long_time_format : STRING_32 is
			--
		do
			Result := culture_info.date_time_format.long_time_pattern.to_string_32
		end
	
	get_short_time_format : STRING_32 is
			-- 
		do
			Result := culture_info.date_time_format.short_time_pattern.to_string_32
		end
		
	get_short_date_format : STRING_32 is		
			-- 
		do
			Result := culture_info.date_time_format.short_date_pattern.to_string_32
		end
	
	get_am_suffix  : STRING_32 is
			-- 
		do
			Result := culture_info.date_time_format.am_designator.to_string_32
		end
	
	get_pm_suffix : STRING_32 is
			-- No description
		do
			Result := culture_info.date_time_format.pm_designator.to_string_32
		end
		
feature -- day/months names

	get_day_names: ARRAY[STRING_32_32] is
			--
		local
			l_array : NATIVE_ARRAY[SYSTEM_STRING_32]
			i : INTEGER
		do
			l_array := culture_info.date_time_format.day_names
			Result.make (l_array.lower, l_array.upper)
			from
				i := 1
			until
				i > l_array.count
			loop
				Result.put (l_array.item (i).to_string_32,i)
				i := i + 1
			end
		end

	get_month_names: ARRAY[STRING_32] is
			--
		local
			l_array : NATIVE_ARRAY[SYSTEM_STRING_32]
			i : INTEGER
		do
			l_array := culture_info.date_time_format.month_names
			Result.make (l_array.lower, l_array.upper)
			from
				i := 1
			until
				i > l_array.count
			loop
				Result.put (l_array.item (i).to_string_32,i)
				i := i + 1
			end
		end

	get_abbreviated_day_names: ARRAY[STRING_32] is
			--
		local
			l_array : NATIVE_ARRAY[SYSTEM_STRING_32]
			i : INTEGER
		do
			l_array := culture_info.date_time_format.abbreviated_day_names
			Result.make (l_array.lower, l_array.upper)
			from
				i := 1
			until
				i > l_array.count
			loop
				Result.put (l_array.item (i).to_string_32,i)
				i := i + 1
			end
		end

	get_abbreviated_month_names: ARRAY[STRING_32] is
			--
		local
			l_array : NATIVE_ARRAY[SYSTEM_STRING_32]
			i : INTEGER
		do
			l_array := culture_info.date_time_format.abbreviated_month_names
			Result.make (l_array.lower, l_array.upper)
			from
				i := 1
			until
				i > l_array.count
			loop
				Result.put (l_array.item (i).to_string_32,i)
				i := i + 1
			end
		end

feature	-- number formatting

	get_value_decimal_separator: STRING_32 is
		do
			Result := culture_info.number_format.number_decimal_separator.to_string_32
		end

	get_value_numbers_after_decimal_separator: INTEGER is
			--
		do
			Result := culture_info.number_format.number_decimal_digits.to_string_32
		end

	get_value_group_separator: STRING_32 is
			--
		do
			Result := culture_info.number_format.number_group_separator.to_string_32
		end

	get_value_number_list_separator: STRING_32 is
			--
		obsolete
			"NOT IMPLEMENTED"
		do
--			Result := culture_info.number_format.
		end

	get_value_grouping: ARRAY[STRING_32] is
			--
		obsolete
			"NOT IMPLEMENTED"
		local
			l_array : ARRAY[INTEGER]
		do
--			l_array := culture_info.number_format.number_group_sizes
--			l_array.do_all ((?).out)
--			Result := culture_info.number_format.number_group_sizes
		end

feature	-- currency formatting

	get_currency_symbol: STRING_32 is
			--
		do
			Result := culture_info.number_format.currency_symbol.to_string_32
		end

	get_currency_decimal_separator: STRING_32 is
			--
		do
			Result := culture_info.number_format.currency_decimal_separator.to_string_32
		end

	get_currency_numbers_after_decimal_separator: INTEGER is
			--
		do
			Result := culture_info.number_format.currency_decimal_digits.to_string_32
		end

	get_currency_group_separator: STRING_32 is
			--
		do
			Result := culture_info.number_format.currency_group_separator.to_string_32
		end

	get_currency_number_list_separator: STRING_32 is
			--
		obsolete
			"NOT IMPLEMENTED"
		do
--			Result := culture_info.number_format.
		end

	get_currency_grouping: ARRAY[STRING_32] is
			--
		obsolete
			"NOT IMPLEMENTED"
		do
		end


feature {NONE} -- NOT USED Symbols

	date_separator : STRING_32 is
			-- separator in the date pattern
		do
			Result := culture_info.date_time_format.date_separator.to_string_32
		end
		
	time_separator : STRING_32 is
			-- separator in the time pattern
		do
			Result := culture_info.date_time_format.time_separator.to_string_32
		end
		
	decimal_separator : STRING_32 is
			-- decimal point separator
		do
			Result := culture_info.number_format.number_decimal_separator.to_string_32
		end
	
	group_separator : STRING_32 is
			-- separator between the groups
		do
			Result := culture_info.number_format.number_group_separator.to_string_32
		end
		
feature {NONE} -- NOT USED Names

	
	get_ith_abbreviated_day (a_int : INTEGER) : STRING_32 is
			-- get the i_th day of the week, abbreviated
		do
			Result := culture_info.date_time_format.abbreviated_day_names.item ((first_day+a_int-1) \\ 7).to_string_32
		end

	get_ith_day (a_int : INTEGER) : STRING_32 is	
			-- get the i_th day of the week
		do
			Result := culture_info.date_time_format.day_names.item ((first_day+a_int-1) \\ 7).to_string_32
		end
		

	get_ith_abbreviated_month (a_number : INTEGER) : STRING_32 is
			-- get the i_th month, abbreviated
		do
			Result := culture_info.date_time_format.abbreviated_month_names.item (a_number).to_string_32
		end
		
	get_ith_month (a_number : INTEGER) : STRING_32 is
			-- get the i_th month
		do
			Result := culture_info.date_time_format.get_month_name (a_number).to_string_32
		end

	
feature {NONE} -- NOT USED Short Pattern

	short_time_pattern : STRING_32 is
			-- short time pattern
		do
			Result := culture_info.date_time_format.short_time_pattern.to_string_32
		end

	short_date_pattern : STRING_32 is
			-- short date pattern
		do
			Result := culture_info.date_time_format.short_date_pattern.to_string_32
		end

feature {NONE} -- NOT USED Long Pattern
	
	long_date_pattern : STRING_32 is
			-- long date pattern
		do
			Result := culture_info.date_time_format.long_date_pattern.to_string_32
		end	

feature {NONE} -- NOT USED Other Pattern

	full_date_time_pattern : STRING_32 is
			-- full date time pattern
		do
			Result := culture_info.date_time_format.full_date_time_pattern.to_string_32
		end

	month_day_pattern : STRING_32 is
			-- pattern with month and day
		do
			Result := culture_info.date_time_format.month_day_pattern.to_string_32
		end
	
	year_month_pattern : STRING_32 is
			-- pattern with year and month
		do
			Result := culture_info.date_time_format.month_day_pattern.to_string_32
		end

	rfc1123_pattern : STRING_32 is
			-- rfc1123 is: ddd, dd MMM yyyy HH':'mm':'ss 'GMT'
		do
			Result := culture_info.date_time_format.rfc1123_pattern.to_string_32
		end
		
	sortable_date_time_pattern: STRING_32 is
			-- a sortable time pattern
			-- yyyy'-'MM'-'dd'T'HH':'mm':'ss
		do
			Result := culture_info.date_time_format.sortable_date_time_pattern.to_string_32
		end
	
	universal_sortable_date_time_pattern: STRING_32 is
			-- a sortable pattern
			-- yyyy'-'MM'-'dd HH':'mm':'ss'Z'
		do
			Result := culture_info.date_time_format.universal_sortable_date_time_pattern.to_string_32
		end
		
feature {NONE} -- NOT USED Currency information

	currency_symbol : STRING_32 is
			-- currency symbol of current locale
		do
			Result := culture_info.number_format.currency_symbol.to_string_32
		end
	
	currency_decimal_digits : INTEGER is
			-- number of digits in the current currency
		do
			Result := culture_info.number_format.currency_decimal_digits
		end
	
	currency_decimal_separator : STRING_32 is
			-- decimal separator of current currency
		do
			Result := culture_info.number_format.currency_decimal_separator.to_string_32
		end
		
	currency_group_separator : STRING_32 is
			-- group separator of current currency
		do
			Result := culture_info.number_format.currency_group_separator.to_string_32
		end
		
	currency_group_sizes : ARRAY[INTEGER] is
			-- 
		do
			Result := culture_info.number_format. currency_group_sizes
		end


feature -- General Information

	name : STRING_32 is
			-- name of current locale
		do
			Result := culture_info.name.to_string_32
		end
		
		


feature {NONE} -- Implementation
		
	culture_info : CULTURE_INFO
	
	first_day : INTEGER is
			-- first day of the week
		do
			Result := culture_info.date_time_format.first_day_of_week.to_integer
		end
end
