class I18N_FORMAT_STRING_PARSER

inherit
	I18N_FORMATTING_CHARACTERS

create make

feature -- Parser

	make (a_locale_info: I18N_LOCALE_INFO) is
			--
		do
			locale_info := a_locale_info
		end

	locale_info: I18N_LOCALE_INFO


	parse (a_string: STRING_32): LINKED_LIST[I18N_FORMATTING_ELEMENT] is
			--
		local
			i : INTEGER
			next_escape_char: INTEGER
			l_format_code: I18N_FORMATTING_ELEMENT
			t_char: CHARACTER
		do
			create Result.make
			from
				i := 1
			until
				i > a_string.count
			loop
				next_escape_char := a_string.index_of (escape_caracter,i)
				if next_escape_char = 0 or next_escape_char = a_string.count then
					-- no more escape_character's
					create {I18N_U_FORMATTING_ELEMENT} l_format_code.make_with_string (a_string.substring (i, a_string.count))
					i := a_string.count +1
					Result.extend (l_format_code)
				else
					if (next_escape_char-i) > 0 then
						-- there was a user string inbetween
						create {I18N_U_FORMATTING_ELEMENT} l_format_code.make_with_string (a_string.substring (i,next_escape_char-1))
						Result.extend (l_format_code)
					end
					t_char := a_string.item (next_escape_char+1).to_character_8
					inspect
						t_char
					when 	day_of_month,
							day_of_month_padded,
							abbreviated_day_name,
							day_name,
							day_of_year,
							day_of_week,
							day_of_week_0,
							month,
							month_padded,
							abbreviated_month_name1,
							abbreviated_month_name2,
							month_name,
							century_number,
							week_number_iso,
							week_number_sunday_as_first,
							week_number_monday_as_first,
							century_number_iso,
							century_number_iso_2,
							year_1,
							year_2,
							year_4
					then
						-- date related item
						create {I18N_D_FORMATTING_ELEMENT} l_format_code.make (t_char, locale_info)
						i := next_escape_char + 2
					when	hour_12_padded,
							hour_12,
							hour_24,
							hour_24_padded,
							minutes,
							minutes_padded,
							seconds,
							seconds_padded,
							second_fraction_padded,
							second_fraction,
							am_pm_1,
							am_pm_lowercase,
							am_pm_uppercase
					then
						-- time related item
						create {I18N_T_FORMATTING_ELEMENT} l_format_code.make (t_char, locale_info)
						i := next_escape_char + 2
					when 	local_date_time,
							usa_date,
							iso_date,
							am_pm_time,
							short_time_24h,
							time_24h,
							local_date,
							locale_time
					then
						-- format string
						create {I18N_FORMAT_STRING} l_format_code.make_from_predefined_format_char (t_char, locale_info)
						i := next_escape_char + 2
					when escape_caracter then

					when 	era,
							time_zone_offset,
							time_zone_name
					then
						-- Not yet
						i := next_escape_char + 2
					when	new_line,
							tab
					then
						-- special character
						create {I18N_U_FORMATTING_ELEMENT} l_format_code.make_with_string (t_char.out)
						i := next_escape_char + 2
					when modifier_character_1 then
						l_format_code := parse_modified_1 (t_char)
						i := next_escape_char + 3
					when modifier_character_2 then
						l_format_code := parse_modified_2 (t_char)
						i := next_escape_char + 3
					else
						create {I18N_U_FORMATTING_ELEMENT} l_format_code.make_with_string (t_char.out)
						i := next_escape_char + 1
					end
					Result.extend (l_format_code)
				end
			end
		end

feature {NONE} -- Implementation

	parse_modified_1 (a_char: CHARACTER): I18N_FORMATTING_ELEMENT is
			--
		do
			inspect
				a_char
			when	modified_date_time,
					modified_time then
					create {I18N_FORMAT_STRING} Result.make_as_modified_1 (a_char, locale_info)
			when 	modified_base_year_name,
					modified_date,
					modified_base_year_offset,
					modified_year then
					create {I18N_D_FORMATTING_ELEMENT} Result.make_as_modified_1 (a_char, locale_info)
			else

			end
		end

	parse_modified_2 (a_char: CHARACTER): I18N_FORMATTING_ELEMENT is
			--
		do
			inspect
				a_char
			when	modified_time_24h,
					modified_time_12h,
					modified_minutes,
					modified_seconds
			then
					create {I18N_FORMAT_STRING} Result.make_as_modified_2 (a_char, locale_info)
			when	modified_day_of_month_0_padded,
					modified_day_of_month_space_padded,
					modified_month,
					modified_weekday,
					modified_week_number,
					modified_week_number_monday_as_first_1,
					modified_week_number_sunday_as_first,
					modified_week_number_monday_as_first_2
			then
					create {I18N_D_FORMATTING_ELEMENT} Result.make_as_modified_2 (a_char, locale_info)
			when	modified_era,
					time_separator,
					hour_separator
			then
				-- Not yet
			else

			end
		end

end
