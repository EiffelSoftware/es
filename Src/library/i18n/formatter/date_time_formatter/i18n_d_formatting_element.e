class I18N_D_FORMATTING_ELEMENT

inherit
	I18N_FORMATTING_ELEMENT
	I18N_FORMATTING_UTILITY

create
	make,
	make_as_modified_1,
	make_as_modified_2

feature --

	make (a_format_code: CHARACTER; a_locale_info: I18N_LOCALE_INFO) is
			--
		do
			current_format_char := a_format_code
			locale_info := a_locale_info
		end

	make_as_modified_1 (a_modified_format_code: CHARACTER; a_locale_info: I18N_LOCALE_INFO) is
			--
		do
			locale_info := a_locale_info
			is_modified_1 := True
		end

	make_as_modified_2 (a_modified_format_code: CHARACTER; a_locale_info: I18N_LOCALE_INFO) is
			--
		do
			locale_info := a_locale_info
			is_modified_2 := True
		end



	output (a_time: TIME; a_date: DATE): STRING_32 is
			--
		do
			create Result.make_empty
			inspect
				current_format_char
			when day_of_month then
				Result := a_date.day.out
			when day_of_month_padded then
				Result := padd_with_0_left (a_date.day, 2)
			when abbreviated_day_name then
				Result := locale_info.abbreviated_day_names.item (a_date.day)
			when day_name then
				Result := locale_info.day_names.item (a_date.day)
			when day_of_year then
				Result := padd_with_0_left(a_date.year_day,3)
			when day_of_week then
				Result := (a_date.day_of_the_week+1).out
			when day_of_week_0 then
				Result := a_date.day_of_the_week.out
			when month then
				Result := a_date.month.out
			when month_padded then
				Result := padd_with_0_left(a_date.month,2)
			when abbreviated_month_name1, abbreviated_month_name2 then
				Result := locale_info.abbreviated_month_names.item (a_date.month)
			when month_name then
				Result := locale_info.month_names.item (a_date.month)
			when century_number then
				Result := (a_date.year // 100).out
			when week_number_iso then
				Result := padd_with_0_left (a_date.week_of_year+1, 2)
			when week_number_sunday_as_first then
				Result := padd_with_0_left (a_date.week_of_year+1, 2)
			when week_number_monday_as_first then
				Result := a_date.day_of_the_week.out
			when century_number_iso then
				Result := a_date.year.out
			when century_number_iso_2 then
				Result := a_date.year.out
			when year_1 then
				Result := (a_date.year \\ 10).out
			when year_2 then
				Result := (a_date.year \\ 100).out
			when year_4 then
				Result := a_date.year.out
			else
				Result := "ERROR dfor%N"
			end
		end

end
