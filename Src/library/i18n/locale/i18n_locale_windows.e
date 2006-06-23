indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_LOCALE_WINDOWS
inherit
--	SHARED_EXEC_ENVIRONMENT
--		Error code: VTCT
--		Error: type is based on unknown class.
--		What to do: use an identifier that is the name of a class in the universe.
	I18N_LOCALE_FACTORY

feature -- get locale informations
	
	language_id: STRING
	
	language_id_code: STRING is
				-- `GetUserDefaultLCID' C encapsulation.
		external
			"C [macro %"windows.h%"] : EIF_STRING"
			-- the macro gives an output of type LCID (is it a string?), ie EIF_STRING needs to be changed accordingly if possible
		alias
			"GetUserDefaultLCID"
		end

	
	convert_code (a_code: STRING): STRING is
		require
			a_code_exists: a_code /= Void
		do
		ensure
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
		do
			set_language_id(convert_code(language_id_code))
		ensure then
		end

invariant
	invariant_clause: True -- Your invariant here

end -- class I18N_LOCALE_WINDOWS
