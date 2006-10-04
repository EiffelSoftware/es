class I18N_U_FORMATTING_ELEMENT
inherit I18N_FORMATTING_ELEMENT

create
	make_with_string

feature --

	make_with_string (a_string: STRING_32) is
			--
		do
			current_format_string:= a_string
		end


	output (a_time: TIME; a_date: DATE): STRING_32 is
			--
		do
			Result := current_format_string
		end

end
