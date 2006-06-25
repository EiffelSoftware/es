indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_LOCALE_WINDOWS
inherit
	I18N_LOCALE_FACTORY

feature -- locale


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


	set_language_id (a_language_id: STRING) is
		require
			a_language_id_not_void: a_language_id /= Void
		do
			language_id := a_language_id
		ensure
			language_id_is_set: language_id.is_equal(a_language_id)
		end


	get_locale is
		require else
			language_id_code_not_void : language_id_code /= Void
		local
			id: STRING
		do
			id := convert_code(language_id_code)
			set_language_id(id)
		ensure then
		end


end -- class I18N_LOCALE_WINDOWS
