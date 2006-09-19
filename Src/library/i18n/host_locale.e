indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	I18N_HOST_LOCALE

feature -- Initialization

	make_from_user_locale is
			--
		deferred
		end

	make_from_locale (a_locale_id : I18N_LOCALE_ID) is
			--
		require
			a_locale_not_void: a_locale_id /= Void
			a_locale_exists: is_available(a_locale_id)
		deferred
		end

feature -- Informations

	is_available (a_locale_id : I18N_LOCALE_ID) : BOOLEAN is
			-- is 'a_locale' avaiable?
		deferred
		end

	available_locales : LINEAR[STRING_32] is
			-- list af all available locales
		deferred
		end


feature -- Date and time formatting

	get_long_date_format: STRING_32 is
			--
		deferred
		end


	get_short_date_format: STRING_32 is
			--
		deferred
		end

	get_long_time_format: STRING_32 is
			--
		deferred
		end

	get_short_time_format: STRING_32 is
			--
		deferred
		end

	get_am_suffix: STRING_32 is
			--
		deferred
		end

	get_pm_suffix: STRING_32 is
			--
		deferred
		end

feature -- day/months names

		get_day_names: ARRAY[STRING_32] is
			--
		deferred
		ensure
			result_exists: Result /= Void
			correct_size: Result.count = {DATE_CONSTANTS}.Days_in_week
		end

		get_month_names: ARRAY[STRING_32] is
			--
		deferred
		ensure
			result_exists: Result /= Void
			correct_size: Result.count = {DATE_CONSTANTS}.Months_in_year
		end

		get_abbreviated_day_names: ARRAY[STRING_32] is
			--
		deferred
		ensure
			result_exists: Result /= Void
			correct_size: Result.count = {DATE_CONSTANTS}.Days_in_week
		end

		get_abbreviated_month_names: ARRAY[STRING_32] is
			--
		deferred
		ensure
			result_exists: Result /= Void
			correct_size: Result.count = {DATE_CONSTANTS}.Months_in_year
		end


feature	-- number formatting

		get_value_decimal_separator: STRING_32 is
			--
		deferred
		end

		get_value_numbers_after_decimal_separator: INTEGER is
			--
		deferred
		end

		get_value_group_separator: STRING_32 is
			--
		deferred
		end

		get_value_number_list_separator: STRING_32 is
			--
		deferred
		end

		get_value_grouping: ARRAY[STRING_32] is
			--
		deferred
		end


feature	-- currency formatting

		get_currency_symbol: STRING_32 is
			--
		deferred
		end

		get_currency_decimal_separator: STRING_32 is
			--
		deferred
		end

		get_currency_numbers_after_decimal_separator: INTEGER is
			--
		deferred
		end

		get_currency_group_separator: STRING_32 is
			--
		deferred
		end

		get_currency_number_list_separator: STRING_32 is
			--
		deferred
		end

		get_currency_grouping: ARRAY[STRING_32] is
			--
		deferred
		end
end
