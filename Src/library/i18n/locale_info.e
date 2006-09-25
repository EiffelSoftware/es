indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_LOCALE_INFO

creation
	make


feature --creation

		make is
				-- creates a I18N_LOCALE_INFO with default values
			do
				-- initialise to arbitrary default values so we can ensure
				-- that all fields will have valid/non-void contents


				--use iso 8601 date / time formats
				long_date_format := "yyyy-[0]mm-dd"
				short_date_format := "yy-[0]mm-dd"
				long_time_format := "hh:[0]mi:[0]ss"
				short_time_format := "hh:[0]mi"

				am_suffix := "am"
				pm_suffix := "pm"

				day_names := << "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" >>
				month_names :=  <<	"January", "February", "March",	"April", "May", "June",	"July",
									"August", "September", "October", "November", "December" >>
				abbreviated_day_names := <<	"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun" >>
				abbreviated_month_names := <<"Jan", "Feb", "Mar", "Apr", "May",	"Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"	>>

				value_decimal_separator := "."
				value_numbers_after_decimal_separator := 2
				value_group_separator := ","
				value_number_list_separator := ";"
				value_grouping := <<>> --need to define a format for this!

				currency_decimal_separator := "."
				currency_numbers_after_decimal_separator := 2
				currency_group_separator := ","
				currency_number_list_separator := ";"
				currency_grouping := <<>> --need to define a format for this!
			end



feature	--identification

		id: I18N_LOCALE_ID

feature	-- date and time formatting

		long_date_format: STRING_32

		short_date_format: STRING_32

		long_time_format: STRING_32
		short_time_format: STRING_32

		am_suffix: STRING_32
		pm_suffix: STRING_32



feature	-- day and month names

		day_names: ARRAY[STRING_32]
		month_names: ARRAY[STRING_32]

		abbreviated_day_names: ARRAY[STRING_32]
		abbreviated_month_names: ARRAY[STRING_32]

feature	-- number formatting

		value_decimal_separator: STRING_32
		value_numbers_after_decimal_separator: INTEGER
		value_group_separator: STRING_32
		value_number_list_separator: STRING_32
		value_grouping: ARRAY[STRING_32]

feature	-- currency formatting
		currency_symbol: STRING_32
		currency_decimal_separator: STRING_32
		currency_numbers_after_decimal_separator: INTEGER
		currency_group_separator: STRING_32
		currency_number_list_separator: STRING_32
		currency_grouping: ARRAY[STRING_32]

feature	-- modification

		set_id (an_id: I18N_LOCALE_ID) is
				-- set the locale id to  `an_id'
			require
				an_id_exists: an_id /= Void
			do
				id := an_id
			ensure
				id_set: id = an_id
			end


		set_day_names (a_day_names : ARRAY[STRING_32]) is
				-- set the day names
			require
				a_day_names_exist: day_names /= Void
			do
				day_names := a_day_names
			ensure
				day_names_set: day_names = a_day_names
			end

		set_abbreviated_day_names (a_abbreviated_day_names : ARRAY[STRING_32]) is
				-- set abbreviated day names
			require
				a_abbreviated_day_names_exists: a_abbreviated_day_names /= Void
			do
				abbreviated_day_names := a_abbreviated_day_names
			ensure
				abbreviated_day_names_set: abbreviated_day_names = a_abbreviated_day_names
			end

		set_month_names ( a_month_names : ARRAY[STRING_32]) is
				-- set month names
			require
				a_month_names_exists: a_month_names /= Void
			do
				month_names := a_month_names
			ensure
				minth_names_set: month_names = a_month_names
			end

		set_abbreviated_month_names (a_abbreviated_month_names : ARRAY[STRING_32]) is
				-- Set abbreviated month names
			require
				a_abbreviated_month_names_exists: a_abbreviated_month_names /= Void
			do
				abbreviated_month_names := a_abbreviated_month_names
			ensure
				abbreviated_day_names_set: abbreviated_day_names = a_abbreviated_month_names
			end



		set_long_date_format(format:STRING_GENERAL) is
				-- set the long date format string
			require
				argument_not_void: format /= Void
			do
				long_date_format := format.to_string_32
			ensure
				long_date_format_set: long_date_format.is_equal(format.as_string_32)
			end

		set_short_date_format(format:STRING_GENERAL) is
				-- set the short date format string
			require
				argument_not_void: format /= Void
			do
				short_date_format := format.to_string_32
			ensure
				short_date_format_set: short_date_format.is_equal(format.as_string_32)
			end

		set_long_time_format(format:STRING_GENERAL) is
				-- set the long time format string
			require
				argument_not_void: format /= Void
			do
				long_time_format := format.to_string_32
			ensure
				long_time_format_set: long_time_format.is_equal(format.as_string_32)
			end

		set_short_time_format(format:STRING_GENERAL) is
				-- set the short time format string
			require
				argument_not_void: format /= Void
			do
				short_time_format := format.to_string_32
			ensure
				short_time_format_set: short_time_format.is_equal(format.as_string_32)
			end

		set_am_suffix(suffix:STRING_GENERAL) is
				-- set the am suffix
			require
				argument_not_void: suffix /= Void
			do
				am_suffix := suffix.to_string_32
			ensure
				am_suffix_set: am_suffix.is_equal(suffix.as_string_32)
			end

		set_pm_suffix(suffix:STRING_GENERAL) is
				-- set the pm suffix
			require
				argument_not_void: suffix /= Void
			do
				pm_suffix := suffix.to_string_32
			ensure
				pm_suffix_set: am_suffix.is_equal(suffix.as_string_32)
			end



		set_value_decimal_separator(separator:STRING_GENERAL) is
				-- set the decimal separator for values
			require
				argument_not_void: separator /= Void
			do
				value_decimal_separator := separator.to_string_32
			ensure
				value_decimal_separator_set: value_decimal_separator.is_equal(separator.as_string_32)
			end

		set_value_numbers_after_decimal_separator(numbers:INTEGER) is
				-- set the amount of numbers after a decimal separator in a numeric value
			require
				numbers_positive: numbers >= 0
			do
				value_numbers_after_decimal_separator := numbers
			ensure
				value_numbers_after_decimal_separator_set: value_numbers_after_decimal_separator = numbers
			end

		set_value_group_separator(separator:STRING_GENERAL) is
				-- set the group separator for values - sometimes called "thousands separator"
			require
				argument_not_void: separator /= Void
			do
				value_group_separator := separator.to_string_32
			ensure
				value_group_separator_set: value_group_separator.is_equal(separator.as_string_32)
			end

		set_value_number_list_separator(separator:STRING_GENERAL) is
				-- set the  separator for lists of numbers
			require
				argument_not_void: separator /= Void
			do
				value_number_list_separator := separator.to_string_32
			ensure
				value_number_list_separator_set: value_number_list_separator.is_equal(separator.as_string_32)
			end

		set_currency_symbol (a_currency_simbol : STRING_GENERAL) is
				--
			require
				a_currency_simbol_exists: a_currency_simbol /= Void
			do
				currency_symbol := a_currency_simbol
			end



		set_currency_decimal_separator(separator:STRING_GENERAL) is
				-- set the decimal separator for currency values
			require
				argument_not_void: separator /= Void
			do
				currency_decimal_separator := separator.to_string_32
			ensure
				currency_decimal_separator_set: currency_decimal_separator.is_equal(separator.as_string_32)
			end

		set_currency_numbers_after_decimal_separator(numbers:INTEGER) is
				-- set the amount of numbers after a decimal separator in a currency value
			require
				numbers_positive: numbers >= 0
			do
				currency_numbers_after_decimal_separator := numbers
			ensure
				currency_numbers_after_decimal_separator_set: currency_numbers_after_decimal_separator = numbers
			end

		set_currency_group_separator(separator:STRING_GENERAL) is
				-- set the group separator for curency values - sometimes called "thousands separator"
			require
				argument_not_void: separator /= Void
			do
				currency_group_separator := separator.to_string_32
			ensure
				currency_group_separator_set: currency_group_separator.is_equal(separator.as_string_32)
			end

		set_currency_number_list_separator(separator:STRING_GENERAL) is
				-- set the  separator for lists of currency values
			require
				argument_not_void: separator /= Void
			do
				currency_number_list_separator := separator.to_string_32
			ensure
				currency_number_list_separator_set: currency_number_list_separator.is_equal(separator.as_string_32)
			end
end
