indexing
	description: "Class that allows formatting of the numerical part of a monetary quantity"
	author: "ES-i18n team (es-18n@origo.ethz.ch)"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class I18N_CURRENCY_VALUE_FORMATTER

inherit I18N_VALUE_FORMATTER
	redefine
		make
	end

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
			positive_sign := a_locale_info.currency_positive_sign
			negative_sign := a_locale_info.currency_negative_sign
		end

end -- I18N_CURRENCY_VALUE_FORMATTER

