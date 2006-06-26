indexing
	description: "Factory to create a I18N_LOCALE object under windows."
	status: "NOTE: This class is not stable yet, don't use it in production environments!"
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_WINDOWS_LOCALE_FACTORY

inherit
	I18N_LOCALE_FACTORY

feature -- Locale
	get_actual_locale: I18N_LOCALE is
		require else
		local
			id: STRING
		do
			create Result
			id := language_id_code.to_hex_string
			id.tail (4)
			id := to_iso_format(id)
			Result.set_language_id(id)
		ensure then
		end

feature {NONE} -- Implementation
	language_id_code: NATURAL_32 is
		external
			"C inline use <windows.h>"
		alias
			"return GetUserDefaultLCID();"
		end

	registry: AUT_REGISTRY

	to_iso_format (lcid: STRING): STRING is
			-- returns the ISO value of the LCID using windows registry
		local
			key: STRING
			key_value: STRING
			index_of_semicolon: INTEGER
		do
			key := "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\MIME\Database\Rfc1766\" + lcid
			key_value := registry.string_value (key)
			index_of_semicolon := key_value.index_of (';', 1)
			Result := key_value.substring (1, index_of_semicolon - 1)
		ensure
		end

end
