deferred class I18N_FORMATTING_ELEMENT

inherit
	I18N_FORMATTING_CHARACTERS
		export
			{NONE} all
		end

feature -- Output




	output (a_time: TIME; a_date: DATE): STRING_32 is
		deferred
		end

feature {NONE} -- Implementation

	locale_info: I18N_LOCALE_INFO
	current_format_string: STRING_32
	current_format_char: CHARACTER

	is_modified_1: BOOLEAN
	is_modified_2: BOOLEAN

invariant
	(is_modified_1 implies not is_modified_2) and (is_modified_2 implies not is_modified_1)
end
