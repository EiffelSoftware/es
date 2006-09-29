indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_SYSTEM_LOCALES


feature -- Informations

	available_locales : LINEAR[I18N_LOCALE_ID] is
			-- list of available locales
		do
			Result := host_locale.available_locales
		ensure
			correct_result: Result = host_locale.available_locales
		end

	has_locale (a_locale_id : I18N_LOCALE_ID) : BOOLEAN is
			-- is the locale with a_locale_id available?
		do
			Result := host_locale.is_available (a_locale_id)
		ensure
			correct_result: Result = host_locale.is_available (a_locale_id)
		end

	get_locale_info (a_locale_id: I18N_LOCALE_ID): I18N_LOCALE_INFO is
			--
		do
			create Result.make
			host_locale.make_from_locale (a_locale_id)
			initialize_locale (Result)
		ensure
			Result_exists: Result /= Void
		end

	get_user_locale_info: I18N_LOCALE_INFO is
			-- get the default locale info
		do
			create Result.make
			host_locale.make_from_user_locale
			initialize_locale (Result)
		end


feature {NONE} -- Implementation

	host_locale : I18N_HOST_LOCALE is
			--
		once
			create {I18N_HOST_LOCALE_IMP} Result.make_from_user_locale
		end

	initialize_locale (a_locale_info: I18N_LOCALE_INFO) is
			-- fill all fields of a_locale_info
		require
			a_locale_info_exists: a_locale_info /= Void
		do
			-- Set ID
			a_locale_info.set_id (host_locale.current_locale_id)
			-- Set all date/time formatting fields
			a_locale_info.set_long_date_format (host_locale.get_long_date_format)
			a_locale_info.set_short_date_format (host_locale.get_short_date_format)
			a_locale_info.set_long_time_format (host_locale.get_long_time_format)
			a_locale_info.set_long_date_format (host_locale.get_long_date_format)
			a_locale_info.set_am_suffix (host_locale.get_am_suffix)
			a_locale_info.set_pm_suffix (host_locale.get_pm_suffix)
			-- Set all day/months names fields
			a_locale_info.set_day_names (host_locale.get_day_names)
			a_locale_info.set_abbreviated_day_names (host_locale.get_abbreviated_day_names)
			a_locale_info.set_month_names (host_locale.get_month_names)
			a_locale_info.set_abbreviated_month_names (host_locale.get_abbreviated_month_names)
			-- Set number formatting fields
			a_locale_info.set_value_decimal_separator (host_locale.get_value_decimal_separator)
			a_locale_info.set_value_group_separator (host_locale.get_value_group_separator)
			a_locale_info.set_value_number_list_separator (host_locale.get_value_number_list_separator)
			a_locale_info.set_value_numbers_after_decimal_separator (host_locale.get_value_numbers_after_decimal_separator)
				-- TODO: value Grouping?
			-- Set currency formatting fields
			a_locale_info.set_currency_symbol (host_locale.get_currency_symbol)
			a_locale_info.set_currency_decimal_separator (host_locale.get_currency_decimal_separator)
			a_locale_info.set_currency_numbers_after_decimal_separator (host_locale.get_currency_numbers_after_decimal_separator)
			a_locale_info.set_currency_group_separator (host_locale.get_currency_group_separator)
			a_locale_info.set_currency_number_list_separator (host_locale.get_currency_number_list_separator)
				-- TODO: currency Grouping?
		end


end
