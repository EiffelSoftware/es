class I18N_T_FORMATTING_ELEMENT

inherit
	I18N_FORMATTING_ELEMENT
	I18N_FORMATTING_UTILITY

create
	make

feature --

	make (a_format_character: CHARACTER; a_locale_info: I18N_LOCALE_INFO) is
			--
		do
			current_format_char:= a_format_character
			locale_info:= a_locale_info
		end


	output (a_time: TIME; a_date: DATE): STRING_32 is
			--
		do
			inspect
				current_format_char
			when hour_12_padded then
				if a_time.hour > 12 then
					Result :=  padd_with_0_left (a_time.hour-12, 2)
				else
					Result :=  padd_with_0_left (a_time.hour, 2)
				end
			when hour_12 then
				if a_time.hour > 12 then
					Result :=  (a_time.hour-12).out
				else
					Result :=  a_time.hour.out
				end
			when hour_24 then
				Result := a_time.hour.out
			when hour_24_padded then
				Result :=  padd_with_0_left (a_time.hour, 2)
			when minutes then
				Result := a_time.minute.out
			when minutes_padded then
				Result :=  padd_with_0_left (a_time.minute, 2)
			when seconds then
				Result := a_time.second.out
			when seconds_padded then
				Result :=  padd_with_0_left (a_time.second, 2)
			when second_fraction_padded then
				Result := a_time.fractional_second.out
			when second_fraction then
				Result := a_time.fractional_second.out
			when am_pm_1 then
			when am_pm_lowercase then
			when am_pm_uppercase then

			else
				Result := "ERROR in tfor, item: '"+current_format_string.out+"' %N"
			end
		end

end
