indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	I18N_HOST_LOCALE

feature -- Initialization

	make_from_user_locale is
			-- Creation procedure.
			-- create locale form the user locale
		deferred
		end

	make_from_locale (a_locale_id : I18N_LOCALE_ID) is
			-- Creation procedure
			-- Create locale with a_locale_id
		require
			a_locale_not_void: a_locale_id /= Void
			a_locale_exists: is_available(a_locale_id)
		deferred
		end

feature -- Informations

	is_available (a_locale_id : I18N_LOCALE_ID) : BOOLEAN is
			-- is 'a_locale' avaiable?
		require
			a_locale_id_exists: a_locale_id /= Void
		deferred
		end

	available_locales : LINEAR[I18N_LOCALE_ID] is
			-- list af all available locales
		deferred
		ensure
			result_exists: Result /= Void
		end

	current_locale_id: I18N_LOCALE_ID is
			-- current locale id
		deferred
		end


feature -- Date and time formatting

	get_long_date_format: STRING_32 is
			-- get the long date format string
			-- according the current locale setting
		deferred
		ensure
			result_exists: Result /= Void
		end


	get_short_date_format: STRING_32 is
			-- get the short date format string
			-- according the current locale setting
		deferred
		ensure
			result_exists: Result /= Void
		end

	get_long_time_format: STRING_32 is
			-- get the long time format string
			-- according the current locale setting
		deferred
		ensure
			result_exists: Result /= Void
		end

	get_short_time_format: STRING_32 is
			-- get the short time format string
			-- according the current locale setting
		deferred
		ensure
			result_exists: Result /= Void
		end

	get_am_suffix: STRING_32 is
			-- get the am suffix
			-- if the not available: empty_string
		deferred
		ensure
			result_exists: Result /= Void
		end

	get_pm_suffix: STRING_32 is
			-- get the pm suffix
			-- if the not available: empty_string
		deferred
		ensure
			result_exists: Result /= Void
		end

feature -- day/months names

	get_day_names: ARRAY[STRING_32] is
			-- array with the full weekday names
			-- according the current locale settings
		deferred
		ensure
			result_exists: Result /= Void
			correct_size: Result.count = {DATE_CONSTANTS}.Days_in_week
		end

	get_month_names: ARRAY[STRING_32] is
			-- array with the full month names
			-- according the current locale settings
		deferred
		ensure
			result_exists: Result /= Void
			correct_size: Result.count = {DATE_CONSTANTS}.Months_in_year
		end

	get_abbreviated_day_names: ARRAY[STRING_32] is
			-- array with the abbreviated weekday names
			-- according the current locale settings
		deferred
		ensure
			result_exists: Result /= Void
			correct_size: Result.count = {DATE_CONSTANTS}.Days_in_week
		end

	get_abbreviated_month_names: ARRAY[STRING_32] is
			-- array with the abbreviated month names
			-- according the current locale settings
		deferred
		ensure
			result_exists: Result /= Void
			correct_size: Result.count = {DATE_CONSTANTS}.Months_in_year
		end


feature	-- number formatting

	get_value_decimal_separator: STRING_32 is
			-- get the decimal separator of numbers
			-- according the current locales setting
		deferred
		ensure
			result_exists: Result /= Void
		end

		get_value_numbers_after_decimal_separator: INTEGER is
			-- get the decimal separator of numbers
			-- according the current locales setting
		deferred
		ensure
			result_exists: Result /= Void
		end

	get_value_group_separator: STRING_32 is
			-- get the group separator (the separator thousend sep.)
			-- according the current locales setting
		deferred
		ensure
			result_exists: Result /= Void
		end

	get_value_number_list_separator: STRING_32 is
			-- get the symbol used to separate values
			-- according the current locales setting
		deferred
		ensure
			result_exists: Result /= Void
		end

	get_value_grouping: ARRAY[STRING_32] is
			-- ?
		deferred
		ensure
			result_exists: Result /= Void
		end


feature	-- currency formatting

	get_currency_symbol: STRING_32 is
			-- get the currency symbol
			-- according the current locales setting
		deferred
		ensure
			result_exists: Result /= Void
		end

	get_currency_decimal_separator: STRING_32 is
			-- get the decimal separator of currency numbers
			-- according the current locales setting
		deferred
		ensure
			result_exists: Result /= Void
		end

	get_currency_numbers_after_decimal_separator: INTEGER is
			-- numbers after the decimal separator for currencynumbers
			-- according the current locales setting
		deferred
		ensure
			non_negative: Result >= 0
		end

	get_currency_group_separator: STRING_32 is
			-- get the decimal separator of numbers
			-- according the current locales setting
		deferred
		ensure
			result_exists: Result /= Void
		end

	get_currency_number_list_separator: STRING_32 is
			-- get the symbol used to separate a list
			-- of currency numbers
			-- according the current locales setting
		deferred
		ensure
			result_exists: Result /= Void
		end

	get_currency_grouping: ARRAY[STRING_32] is
			-- ?
		deferred
		ensure
			result_exists: Result /= Void
		end
end
