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

	to_iso_format (lcid: STRING): STRING is
			-- feature that converts hex LCID into ISO format
		require
			lcid /= Void
		do
			-- Result := the data that can be found before the ";" in the registry key named "lcid"
			if lcid.is_equal ("0810") then
				Result := "it-ch"
			else
				Result := lcid
			end
		ensure
		end


end
