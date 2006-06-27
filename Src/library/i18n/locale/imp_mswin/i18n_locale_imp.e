indexing
	description: "Locale information retrieval on windows."
	status: "NOTE: This class is not stable yet, don't use it in production environments!"
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_LOCALE_IMP

inherit
	I18N_LOCALE
	redefine
		default_create
	end

creation
	default_create

feature -- Initialization

	default_create is
			-- Retrieve `language_id'.
		local
			id, id2: STRING
		do
			id := locale_getUserDefaultLCID.to_hex_string
			id := language_id_code.to_hex_string
			id.tail (4)
			id := to_iso_format(id)
			language_id := id
			if language_id /= Void then
				language_id := ""
			end
		ensure then
			valid_language_id: language_id /= Void
		end

feature {NONE} -- Implementation

	locale_getUserDefaultLCID: NATURAL_32 is
		external
			"C inline use %"eif_locale.h%""
		end

	language_id_code: NATURAL_32 is
		external
			"C inline use <windows.h>"
		alias
			"return GetUserDefaultLCID();"
		end

	to_iso_format (a_lcid: STRING): STRING is
			-- returns the ISO value of the LCID using windows registry
		require
			valid_lcid: a_lcid /= Void and then not a_lcid.is_empty
		local
			key: STRING
			key_value: STRING
			index_of_semicolon: INTEGER
			registry: AUT_REGISTRY
		do
			create registry
			key := "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\MIME\Database\Rfc1766\" + a_lcid
			key_value := registry.string_value (key)
			if key_value /= Void then
				index_of_semicolon := key_value.index_of (';', 1)
				Result := key_value.substring (1, index_of_semicolon - 1)
			else
				Result := ""
			end
		ensure
			valid_result: Result /= Void
		end

end
