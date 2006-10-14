indexing
	description: "Actions used by the various 'formatting' elements"
	date: "$Date$"
	revision: "$Revision$"

class I18N_FORMATTING_ACTIONS

inherit SHARED_I18N_FORMATTING_UTILITY


feature -- Time related actions

	hour_12_padded_action (a_time: TIME): STRING_32 is
		require
			a_time_exists: a_time /= Void
		do
			if a_time.hour > 12 then
				Result :=  fu.pad_with_0_left (a_time.hour-12, 2)
			else
				Result :=  fu.pad_with_0_left (a_time.hour, 2)
			end
		end

	hour_12_action (a_time: TIME): STRING_32 is
		require
			a_time_exists: a_time /= Void
		do
			if a_time.hour > 12 then
				Result :=  (a_time.hour-12).out
			else
				Result :=  a_time.hour.out
			end
		end

	hour_24_action (a_time: TIME): STRING_32 is
		require
			a_time_exists: a_time /= Void
		do
			Result := a_time.hour.out
		end

	hour_24_padded_action (a_time: TIME): STRING_32 is
		require
			a_time_exists: a_time /= Void
		do
			Result :=  fu.pad_with_0_left (a_time.hour, 2)
		end

	minutes_action (a_time: TIME): STRING_32 is
		require
			a_time_exists: a_time /= Void
		do
			Result := a_time.minute.out
		end

	minutes_padded_action (a_time: TIME): STRING_32 is
		require
			a_time_exists: a_time /= Void
		do
			Result :=  fu.pad_with_0_left (a_time.minute, 2)
		end

	seconds_action (a_time: TIME): STRING_32 is
		require
			a_time_exists: a_time /= Void
		do
			Result := a_time.second.out
		end

	seconds_padded_action (a_time: TIME): STRING_32 is
		require
			a_time_exists: a_time /= Void
		do
			Result :=  fu.pad_with_0_left (a_time.second, 2)
		end

	am_pm_1_action (a_time: TIME): STRING_32 is
		require
			a_time_exists: a_time /= Void
		do
			if a_time.hour > 12 then
				Result :=  "a"
			else
				Result :=  "p"
			end
		end

	am_pm_lowercase_action (a_time: TIME; a_locale_info: I18N_LOCALE_INFO): STRING_32 is
		require
			a_time_exists: a_time /= Void
		do
			if a_time.hour > 12 then
				Result :=  a_locale_info.pm_suffix
			else
				Result :=  a_locale_info.am_suffix
			end
			if Result.is_valid_as_string_8 then
				Result.to_lower
			end
		end

	am_pm_uppercase_action (a_time: TIME; a_locale_info: I18N_LOCALE_INFO): STRING_32 is
		require
			a_time_exists: a_time /= Void
		do
			if a_time.hour > 12 then
				Result :=  a_locale_info.pm_suffix
			else
				Result :=  a_locale_info.am_suffix
			end
			if Result.is_valid_as_string_8 then
				Result.to_upper
			end
		end

feature -- Date related actions

	day_of_month_action (a_date: DATE): STRING_32 is
		require
			a_date_exists: a_date /= Void
		do
			Result := a_date.day.out
		end

	day_of_month_padded_action (a_date: DATE): STRING_32 is
		require
			a_date_exists: a_date /= Void
		do
			Result := fu.pad_with_0_left (a_date.day, 2)
		end

	abbreviated_day_name_action (a_date: DATE; a_locale_info: I18N_LOCALE_INFO): STRING_32 is
		require
			a_date_exists: a_date /= Void
		do
			Result := a_locale_info.abbreviated_day_names.item (a_date.day_of_the_week)
		end

	day_name_action (a_date: DATE; a_locale_info: I18N_LOCALE_INFO): STRING_32 is
		require
			a_date_exists: a_date /= Void
		do
			Result := a_locale_info.day_names.item (a_date.day_of_the_week)
		end

	day_of_year_action (a_date: DATE): STRING_32 is
		require
			a_date_exists: a_date /= Void
		do
			Result := fu.pad_with_0_left(a_date.year_day,3)
		end

	day_of_week_action (a_date: DATE): STRING_32 is
		require
			a_date_exists: a_date /= Void
		do
			Result := (a_date.day_of_the_week+1).out
		end

	day_of_week_0_action (a_date: DATE): STRING_32 is
		require
			a_date_exists: a_date /= Void
		do
			Result := a_date.day_of_the_week.out
		end

	month_action (a_date: DATE): STRING_32 is
		require
			a_date_exists: a_date /= Void
		do
			Result := a_date.month.out
		end

	month_padded_action (a_date: DATE): STRING_32 is
		require
			a_date_exists: a_date /= Void
		do
			Result := fu.pad_with_0_left(a_date.month,2)
		end

	abbreviated_month_name_action (a_date: DATE; a_locale_info: I18N_LOCALE_INFO): STRING_32 is
		require
			a_date_exists: a_date /= Void
		do
			Result := a_locale_info.abbreviated_month_names.item (a_date.month)
		end

	month_name_action (a_date: DATE; a_locale_info: I18N_LOCALE_INFO): STRING_32 is
		require
			a_date_exists: a_date /= Void
		do
			Result := a_locale_info.month_names.item (a_date.month)
		end

	century_number_action (a_date: DATE): STRING_32 is
		require
			a_date_exists: a_date /= Void
		do
			Result := (a_date.year // 100).out
		end

	week_number_iso_action (a_date: DATE): STRING_32 is
		require
			a_date_exists: a_date /= Void
		do
			Result := fu.pad_with_0_left (a_date.week_of_year+1, 2)
		end

	week_number_sunday_as_first_action (a_date: DATE): STRING_32 is
		require
			a_date_exists: a_date /= Void
		do
			Result := fu.pad_with_0_left (a_date.week_of_year, 2)
		end

	week_number_monday_as_first_action (a_date: DATE): STRING_32 is
		-- Not supported, result is the same as `week_number_sunday_as_first_action'
		require
			a_date_exists: a_date /= Void
		do
			Result := fu.pad_with_0_left (a_date.week_of_year, 2)
		end

	iso_year_with_century_action (a_date: DATE): STRING_32 is
		require
			a_date_exists: a_date /= Void
		do
			Result := a_date.year.out
		end

	iso_year_without_century_action (a_date: DATE): STRING_32 is
		require
			a_date_exists: a_date /= Void
		do
			Result := fu.pad_with_0_left (a_date.year \\ 100,2)
		end

	year_1_action (a_date: DATE): STRING_32 is
		require
			a_date_exists: a_date /= Void
		do
			Result := fu.pad_with_0_left (a_date.year \\ 10,1)
		end

	year_2_action (a_date: DATE): STRING_32 is
		require
			a_date_exists: a_date /= Void
		do
			Result := fu.pad_with_0_left (a_date.year \\ 100,2)
		end

	year_4_action (a_date: DATE): STRING_32 is
		require
			a_date_exists: a_date /= Void
		do
			Result := a_date.year.out
		end






end
