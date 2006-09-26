indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_LOCALE

create
	make


feature -- Basic Operations

	make (a_dictionary: I18N_DICTIONARY; a_locale_info: I18N_LOCALE_INFO) is
			--
		do

		end


	translate (original: STRING_GENERAL): STRING_32 is
			-- translate `original'
		require
			original_exists: original /= Void
		do
			Result := dictionary.get_singular (original)
		ensure
			result_exists: Result /= Void
		end

	translate_plural (original_singular, original_plural: STRING_GENERAL; plural_form : INTEGER): STRING_32 is
			-- translate...
		require
			original_singular_exists: original_singular /= Void
			original_plural_exists: original_plural /= Void
			valid_plural_form: plural_form >= 0
		do
			Result := dictionary.get_plural (original_singular, original_plural, plural_form)
		ensure
			result_exists: Result /= Void
		end

	format_date (a_date: DATE): STRING_32 is
			-- returns the date formatting
			-- according to the current locale
		require
			a_date_exists: a_date /= Void
		do
		ensure
			result_exists: Result /= Void
		end

	format_value (a_value: NUMERIC): STRING_32 is
			-- returns the value formatting
			-- according to the current locale
		require
			a_value_exists: a_value /= Void
		do
		ensure
			result_exists: Result /= Void
		end

	format_string (original: STRING_GENERAL; token_values: TUPLE[STRING_GENERAL]): STRING_32 is
			-- replace tokens in the result of
			-- translate_plural (original)
		require
			original_exists: original /= Void
		do
		ensure
			result_exists: Result /= Void
		end


feature {NONE} -- Implementation

	info : I18N_LOCALE_INFO
		-- specific information about the locale

	dictionary:		I18N_DICTIONARY
	date_formatter:		I18N_DATE_FORMATTER
	value_formatter:	I18N_VALUE_FORMATTER
	string_formatter:	I18N_STRING_FORMATTER



end
