class I18N_FORMAT_STRING
inherit
	I18N_FORMATTING_ELEMENT
		rename
			output as fill_format_string
		end

create
	make,
	make_as_modified_1,
	make_as_modified_2,
	make_from_predefined_format_char

feature -- Initialization

	make (a_format_string: STRING_32; a_locale_info: I18N_LOCALE_INFO) is
		do
			current_format_string := a_format_string
			locale_info := a_locale_info
			create format_string_parser.make (a_locale_info)
			format_elements_list := format_string_parser.parse (a_format_string)
		end

	make_from_predefined_format_char (a_format_character: CHARACTER; a_locale_info: I18N_LOCALE_INFO) is
			--
		local
			l_string: STRING_32
		do
			locale_info := a_locale_info
			inspect
				a_format_character
			when local_date_time then
				l_string := locale_info.long_time_format+" "+locale_info.long_date_format
			when usa_date then
				l_string := "&m/&d/&y"
			when iso_date then
				l_string := "&Y-&m-&d"
			when am_pm_time then
				l_string := "&I:&M:&S &p"
			when short_time_24h then
				l_string := "&H:&M"
			when time_24h then
				l_string := "&H:&M:&S"
			when local_date then
				l_string := locale_info.long_date_format
			when locale_time then
				l_string := locale_info.long_time_format
			else
				l_string := "---"
			end
			create format_string_parser.make (a_locale_info)
			format_elements_list := format_string_parser.parse (l_string)
		end

	make_as_modified_1 (a_modified_format_character: CHARACTER; a_locale_info: I18N_LOCALE_INFO) is
			--
		do
			is_modified_1 := True
		end

	make_as_modified_2 (a_modified_format_character: CHARACTER; a_locale_info: I18N_LOCALE_INFO) is
			--
		do
			is_modified_2 := True
		end



feature -- Fill

	fill_format_string (a_time: TIME; a_date: DATE): STRING_32 is
			--
		do
			from
				create Result.make_empty
				format_elements_list.start
			until
				format_elements_list.after
			loop
				Result.append (format_elements_list.item.output (a_time, a_date))
				format_elements_list.forth
			end
		end

feature {NONE} -- Implementation

	format_elements_list: LINKED_LIST[I18N_FORMATTING_ELEMENT]
	format_string_parser: I18N_FORMAT_STRING_PARSER

end
