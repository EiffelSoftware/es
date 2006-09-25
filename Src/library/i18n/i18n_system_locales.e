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

	get_locale_info (a_locale_id : I18N_LOCALE_ID) : I18N_LOCALE_INFO is
			--
		do
			create Result.make
			host_locale.make_from_locale (a_locale_id)
			-- Set ID
			Result.set_id (a_locale_id)
			-- Set all date/time formatting fields
			Result.set_long_date_format (host_locale.get_long_date_format)
			Result.set_short_date_format (host_locale.get_short_date_format)
			Result.set_long_time_format (host_locale.get_long_time_format)
			Result.set_long_date_format (host_locale.get_long_date_format)
			Result.set_am_suffix (host_locale.get_am_suffix)
			Result.set_pm_suffix (host_locale.get_pm_suffix)
			-- Set all day/months names fields
			Result.set_day_names (host_locale.get_day_names)
			Result.set_abbreviated_day_names (host_locale.get_abbreviated_day_names)
			Result.set_month_names (host_locale.get_month_names)
			Result.set_abbreviated_month_names (host_locale.get_abbreviated_month_names)
			-- Set number formatting fields
			Result.set_value_decimal_separator (host_locale.get_value_decimal_separator)
			Result.set_value_group_separator (host_locale.get_value_group_separator)
			Result.set_value_number_list_separator (host_locale.get_value_number_list_separator)
			Result.set_value_numbers_after_decimal_separator (host_locale.get_value_numbers_after_decimal_separator)
				-- TODO: value Grouping?
			-- Set currency formatting fields
			Result.set_currency_symbol (host_locale.get_currency_symbol)
			Result.set_currency_decimal_separator (host_locale.get_currency_decimal_separator)
			Result.set_currency_numbers_after_decimal_separator (host_locale.get_currency_numbers_after_decimal_separator)
			Result.set_currency_group_separator (host_locale.get_currency_group_separator)
			Result.set_currency_number_list_separator (host_locale.get_currency_number_list_separator)
				-- TODO: currency Grouping?
		ensure
			Result_exists: Result /= Void
		end




feature {NONE} -- Implementation

	host_locale : I18N_HOST_LOCALE is
			--
		once
--			if {PLATFORM}.is_unix then
--				create {I18N_LINUX_LOCALE} Result.make_from_user_locale
--			elseif {PLATFORM}.is_dotnet then
--				create {I18N_DOTNET_LOCALE} Result.make_from_user_locale
--			elseif {PLATFORM}.is_windows then
--				create {I18N_WINDOWS_LOCALES} Result.make_from_user_locale
--			else
--				-- we do not support VMS
--			end
			create {I18N_LINUX_LOCALE} Result.make_from_user_locale
		end


end
