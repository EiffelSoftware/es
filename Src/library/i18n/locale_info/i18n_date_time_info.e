indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class I18N_DATE_TIME_INFO

create make

feature -- Initialization

	make is
			-- initialize all attributes
		do
			set_long_date_format (default_long_time_format)
			set_short_date_format (default_short_date_format)
			set_long_time_format (default_long_time_format)
			set_short_time_format (default_short_time_format)
			set_am_suffix (default_am_suffix)
			set_pm_suffix (default_pm_suffix)
			set_day_names (default_day_names)
			set_month_names (default_month_names)
			set_abbreviated_day_names (default_abbreviated_day_names)
			set_abbreviated_month_names (default_abbreviated_month_names)
		end


feature -- Date and time formatting

	date_time_format: STRING_32

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


feature -- Element change

	set_day_names (a_day_names : ARRAY[STRING_32]) is
			-- set the day names
		require
			a_day_names_exist: a_day_names /= Void
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

	set_date_time_format(format:STRING_GENERAL) is
			-- set the long date format string
		require
			argument_not_void: format /= Void
		do
			date_time_format := format.to_string_32
		ensure
			long_date_format_set: date_time_format.is_equal(format.as_string_32)
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

feature -- Default Values

	default_date_time_format: STRING_32 is
		once
			Result := "hh:[0]mi:[0]ss yyyy-[0]mm-dd"
		end

	default_long_date_format: STRING_32 is
		once
			Result := "yyyy-[0]mm-dd"
		end

	default_short_date_format: STRING_32 is
		once
			Result := "yy-[0]mm-dd"
		end
	default_long_time_format: STRING_32 is
		once
			Result := "hh:[0]mi:[0]ss"
		end
	default_short_time_format: STRING_32 is
		once
			Result := "hh:[0]mi"
		end

	default_am_suffix: STRING_32 is
		once
			Result := "am"
		end
	default_pm_suffix: STRING_32 is
		once
			Result := "pm"
		end

	default_day_names: ARRAY[STRING_32] is
		once
			Result := <<("Monday").to_string_32,
						("Tuesday").to_string_32,
						("Wednesday").to_string_32,
						("Thursday").to_string_32,
						("Friday").to_string_32,
						("Saturday").to_string_32,
						("Sunday").to_string_32>>
		end

	default_month_names: ARRAY[STRING_32] is
		once
			Result := <<("January").to_string_32,
						("February").to_string_32,
						("March").to_string_32,
						("April").to_string_32,
						("May").to_string_32,
						("June").to_string_32,
						("July").to_string_32,
						("August").to_string_32,
						("September").to_string_32,
						("October").to_string_32,
						("November").to_string_32,
						("December").to_string_32 >>
		end
	default_abbreviated_day_names: ARRAY[STRING_32] is
		once
			Result := <<("Mon").to_string_32,
						("Tue").to_string_32,
						("Wed").to_string_32,
						("Thu").to_string_32,
						("Fri").to_string_32,
						("Sat").to_string_32,
						("Sun").to_string_32 >>
		end

	default_abbreviated_month_names: ARRAY[STRING_32] is
		once
			Result := <<("Jan").to_string_32,
						("Feb").to_string_32,
						("Mar").to_string_32,
						("Apr").to_string_32,
						("May").to_string_32,
						("Jun").to_string_32,
						("Jul").to_string_32,
						("Aug").to_string_32,
						("Sep").to_string_32,
						("Oct").to_string_32,
						("Nov").to_string_32,
						("Dec").to_string_32>>
		end
end
