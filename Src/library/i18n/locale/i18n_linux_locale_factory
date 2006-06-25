indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_LOCALE_LINUX
inherit
--	SHARED_EXEC_ENVIRONMENT
--		Error code: VTCT
--		Error: type is based on unknown class.
--		What to do: use an identifier that is the name of a class in the universe.
	I18N_LOCALE_FACTORY
	EXECUTION_ENVIRONMENT

feature -- locale

	get_locale: LOCALE is
		require else
		do
			create Result
			Result.set_language_id(get("LANG"))
		ensure then
 	   end

invariant
	invariant_clause: True -- Your invariant here

end -- class I18N_LOCALE_LINUX
