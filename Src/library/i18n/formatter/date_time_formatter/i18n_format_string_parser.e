class I18N_FORMAT_STRING_PARSER

inherit
	I18N_FORMATTING_CHARACTERS
		export
			{NONE} all
		end
	I18N_FORMATTING_ACTIONS
		export
			{NONE} all
		end

create make

feature -- Parser

	make (a_locale_info: I18N_LOCALE_INFO) is
			-- Creation procedure
		do
			locale_info := a_locale_info
		end

	locale_info: I18N_LOCALE_INFO


	parse (a_string: STRING_32): LINKED_LIST[I18N_FORMATTING_ELEMENT] is
			-- parse `a_string', for every format character, create
			-- appropriate formatting_element and put it in the list
			-- returned as result
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
				next_escape_char := a_string.index_of (escape_character,i)
				if next_escape_char = 0 or next_escape_char = a_string.count then
					-- no more escape_character's
					create {I18N_USERSTRING_ELEMENT} l_format_code.make (a_string.substring (i, a_string.count))
					i := a_string.count +1
					Result.extend (l_format_code.twin)
				else
					if (next_escape_char-i) > 0 then
						-- there was a user string inbetween
						create {I18N_USERSTRING_ELEMENT} l_format_code.make (a_string.substring (i,next_escape_char-1))
						Result.extend (l_format_code.twin)
					end
					t_char := a_string.item (next_escape_char+1).to_character_8
					inspect
						t_char
					when day_of_month then
						create {I18N_DATE_ELEMENT} l_format_code.make (agent day_of_month_action)
					when day_of_month_padded then
						create {I18N_DATE_ELEMENT} l_format_code.make (agent day_of_month_padded_action)
					when abbreviated_day_name then
						create {I18N_DATE_ELEMENT} l_format_code.make (agent abbreviated_day_name_action (?, locale_info))
					when day_name then
						create {I18N_DATE_ELEMENT} l_format_code.make (agent day_name_action (?, locale_info))
					when day_of_year then
						create {I18N_DATE_ELEMENT} l_format_code.make (agent day_of_year_action)
					when day_of_week then
						create {I18N_DATE_ELEMENT} l_format_code.make (agent day_of_week_action)
					when day_of_week_0 then
						create {I18N_DATE_ELEMENT} l_format_code.make (agent day_of_week_0_action)
					when month then
						create {I18N_DATE_ELEMENT} l_format_code.make (agent month_action)
					when month_padded then
						create {I18N_DATE_ELEMENT} l_format_code.make (agent month_padded_action)
					when abbreviated_month_name1, abbreviated_month_name2 then
						create {I18N_DATE_ELEMENT} l_format_code.make (agent abbreviated_month_name_action (?, locale_info))
					when month_name then
						create {I18N_DATE_ELEMENT} l_format_code.make (agent month_name_action (?, locale_info))
					when century_number then
						create {I18N_DATE_ELEMENT} l_format_code.make (agent century_number_action)
					when iso_year_with_century then
						create {I18N_DATE_ELEMENT} l_format_code.make (agent iso_year_with_century_action)
					when iso_year_without_century then
						create {I18N_DATE_ELEMENT} l_format_code.make (agent iso_year_without_century_action)
					when week_number_iso then
						create {I18N_DATE_ELEMENT} l_format_code.make (agent week_number_iso_action)
					when week_number_sunday_as_first then
						create {I18N_DATE_ELEMENT} l_format_code.make (agent week_number_sunday_as_first_action)
					when week_number_monday_as_first then
						create {I18N_DATE_ELEMENT} l_format_code.make (agent week_number_monday_as_first_action)
					when year_1 then
						create {I18N_DATE_ELEMENT} l_format_code.make (agent year_1_action)
					when year_2 then
						create {I18N_DATE_ELEMENT} l_format_code.make (agent year_2_action)
					when year_4 then
						create {I18N_DATE_ELEMENT} l_format_code.make (agent year_4_action)
					when hour_12_padded then
						create {I18N_TIME_ELEMENT} l_format_code.make (agent hour_12_padded_action)
					when hour_12 then
						create {I18N_TIME_ELEMENT} l_format_code.make (agent hour_12_action)
					when hour_24 then
						create {I18N_TIME_ELEMENT} l_format_code.make (agent hour_24_action)
					when hour_24_padded then
						create {I18N_TIME_ELEMENT} l_format_code.make (agent hour_24_action)
					when minutes then
						create {I18N_TIME_ELEMENT} l_format_code.make (agent minutes_action)
					when minutes_padded then
						create {I18N_TIME_ELEMENT} l_format_code.make (agent minutes_padded_action)
					when seconds then
						create {I18N_TIME_ELEMENT} l_format_code.make (agent seconds_action)
					when seconds_padded then
						create {I18N_TIME_ELEMENT} l_format_code.make (agent seconds_padded_action)
					when am_pm_1 then
						create {I18N_TIME_ELEMENT} l_format_code.make (agent am_pm_1_action)
					when am_pm_lowercase then
						create {I18N_TIME_ELEMENT} l_format_code.make (agent am_pm_lowercase_action (?, locale_info))
					when am_pm_uppercase then
						create {I18N_TIME_ELEMENT} l_format_code.make (agent am_pm_uppercase_action (?, locale_info))
					when local_date_time then
						create {I18N_FORMAT_STRING} l_format_code.make (locale_info.date_time_format, locale_info)
					when usa_date then
						create {I18N_FORMAT_STRING} l_format_code.make (escape_character.out+month_padded.out+"/"+
																		escape_character.out+day_of_month_padded.out+"/"+
																		escape_character.out+year_2.out, locale_info)
					when iso_date then
						create {I18N_FORMAT_STRING} l_format_code.make (escape_character.out+year_4.out+"-"+
																		escape_character.out+month_padded.out+"-"+
																		escape_character.out+day_of_month_padded.out, locale_info)
					when am_pm_time then
						create {I18N_FORMAT_STRING} l_format_code.make (escape_character.out+hour_12.out+":"+
																		escape_character.out+minutes_padded.out+":"+
																		escape_character.out+seconds.out+" "+
																		escape_character.out+am_pm_lowercase.out, locale_info)
					when short_time_24h then
						create {I18N_FORMAT_STRING} l_format_code.make (escape_character.out+hour_24_padded.out+":"+
																		escape_character.out+minutes_padded.out, locale_info)
					when time_24h then
						create {I18N_FORMAT_STRING} l_format_code.make (escape_character.out+hour_24_padded.out+":"+
																		escape_character.out+minutes_padded.out+":"+
																		escape_character.out+seconds.out, locale_info)
					when local_date then
						create {I18N_FORMAT_STRING} l_format_code.make (locale_info.long_date_format, locale_info)
					when locale_time then
						create {I18N_FORMAT_STRING} l_format_code.make (locale_info.long_time_format, locale_info)
					when escape_character then
						-- `t_char' was not an escape character
						create {I18N_USERSTRING_ELEMENT} l_format_code.make (escape_character.out)
					when modifier_character_1 then
 						l_format_code := parse_modified_1 (t_char)
						i := next_escape_char + 2
					when modifier_character_2 then
 						l_format_code := parse_modified_2 (t_char)
						i := next_escape_char + 2
					else
						-- It isn't a supported character code, may bee one of the following:
						--		. `era'
						--		. `time_zone_offset'
						--		. `time_zone_name'
		 				-- Insert a space
						create {I18N_USERSTRING_ELEMENT} l_format_code.make (" ")
						i := next_escape_char + 1
					end
					i := next_escape_char + 2
					Result.extend (l_format_code)
				end
			end
		end

 feature {NONE} -- Implementation

 	parse_modified_1 (a_char: CHARACTER): I18N_FORMATTING_ELEMENT is
 			-- this function is called when the escape character
 			-- was followed my the `modifier_character_1' = 'E'
 			-- NOTE: the formatting element produced, does not
 			-- correspond to the Value POSIX defined, because they are
 			-- still not implemented
 		do
 			inspect
 				a_char
 			when modified_date_time then
 				create {I18N_FORMAT_STRING} Result.make (locale_info.long_time_format+" "+locale_info.long_date_format, locale_info)
 			when modified_time then
 				create {I18N_FORMAT_STRING} Result.make (locale_info.long_time_format,locale_info)
 			when modified_date then
				create {I18N_FORMAT_STRING} Result.make (locale_info.long_date_format, locale_info)
 			when modified_year then
				create {I18N_DATE_ELEMENT} Result.make (agent year_4_action (?))
 			else
 				-- not supported, it may be one of:
 				--		. `modified_base_year_name'
 				--		. `modified_base_year_offset'
 				-- Insert a space
				create {I18N_USERSTRING_ELEMENT} Result.make (" ")
 			end
 		end

 	parse_modified_2 (a_char: CHARACTER): I18N_FORMATTING_ELEMENT is
 			-- this function is called when the escape character
 			-- was followed my the `modifier_character_1' = 'O'
 			-- NOTE: the formatting element produced, does not
 			-- correspond to the Value POSIX defined, because they are
 			-- still not implemented
 		do
 			inspect
 				a_char
 			when modified_time_24h then
 				create {I18N_FORMAT_STRING} Result.make (escape_character.out+hour_24_padded.out+":"+
																escape_character.out+minutes_padded.out+":"+
																escape_character.out+seconds.out, locale_info)
 			when modified_time_12h then
				create {I18N_FORMAT_STRING} Result.make (escape_character.out+hour_12.out+":"+
																escape_character.out+minutes_padded.out+":"+
																escape_character.out+seconds.out+" "+
																escape_character.out+am_pm_lowercase.out, locale_info)
 			when modified_minutes then
				create {I18N_FORMAT_STRING} Result.make (escape_character.out+minutes.out, locale_info)
 			when modified_seconds then
 				create {I18N_FORMAT_STRING} Result.make (escape_character.out+seconds.out, locale_info)
 			when modified_day_of_month_0_padded then
 				create {I18N_DATE_ELEMENT} Result.make (agent day_of_month_action (?))
 			when modified_day_of_month_space_padded then
 				create {I18N_DATE_ELEMENT} Result.make (agent day_of_month_padded_action (?))
 			when modified_month then
				create {I18N_DATE_ELEMENT} Result.make (agent month_action (?))
			when modified_weekday then
				create {I18N_DATE_ELEMENT} Result.make (agent day_name_action (?, locale_info))
			when modified_week_number, modified_week_number_sunday_as_first then
				create {I18N_DATE_ELEMENT} Result.make (agent week_number_sunday_as_first_action (?))
			when modified_week_number_monday_as_first_2, modified_week_number_monday_as_first_1 then
				create {I18N_DATE_ELEMENT} Result.make (agent week_number_sunday_as_first_action (?))
 			else
 				-- not supported, it may be one of:
 				--		. `modified_era'
 				-- Insert a space
				create {I18N_USERSTRING_ELEMENT} Result.make (" ")
 			end
 		end

end
