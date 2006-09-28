indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class I18N_CURRENCY_VALUE_FORMATTER

inherit I18N_VALUE_FORMATTER

create make

feature -- Initialization

	make (a_locale_info: I18N_LOCALE_INFO) is
			-- Initialize values according
			-- the currency information in
			-- `a_locale_info'
		do
			decimal_separator := a_locale_info.currency_decimal_separator
					-- decimal separator
			numbers_after_decimal_separator := a_locale_info.currency_numbers_after_decimal_separator
					-- numbers after the decimal separator
			group_separator := a_locale_info.currency_group_separator
					-- separator character for thousands (groups of three digits)
 			grouping := a_locale_info.currency_grouping
					-- how the value are grouped
		end

feature -- Element Change

	set_decimal_separator (a_separator: STRING_32) is
			-- set decimal_separator to a_separator
		require
			a_separator_exists: a_separator /= Void
		do
			decimal_separator := a_separator.twin
		ensure
			correct_result: decimal_separator.is_equal (a_separator)
		end

end -- I18N_CURRENCY_VALUE_FORMATTER

