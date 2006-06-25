indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_WINDOWS_LOCALE_FACTORY

inherit
	I18N_LOCALE_FACTORY

feature -- Locale
	get_locale: LOCALE is
		require else
		local
			id: STRING
		do
			create Result
			id := convert_code(language_id_code)
			Result.set_language_id(id)
		ensure then
		end

feature -- Implementation
	language_id_code: NATURAL_32 is
		external
			"C inline use <windows.h>"
		alias
			"return GetUserDefaultLCID();"
		end

	convert_code (a_code: NATURAL_32): STRING is
		require
			a_code_exists: a_code /= Void
		do
			Result := a_code.to_hex_string
		ensure
			result_not_void: Result /= Void
		end

end
