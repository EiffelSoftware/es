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
			id: STRING
		do
			id := locale_getUserDefaultLCID.to_hex_string
			id.tail (4)
			id := to_iso_format(id)
			language_id := id
		end

feature {NONE} -- Implementation

	locale_getUserDefaultLCID: NATURAL_32 is
		external
			"C inline use %"eif_locale.h%""
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
