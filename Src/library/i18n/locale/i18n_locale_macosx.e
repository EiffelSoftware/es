indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_LOCALE_MACOSX
inherit
--	SHARED_EXEC_ENVIRONMENT
--		Error code: VTCT
--		Error: type is based on unknown class.
--		What to do: use an identifier that is the name of a class in the universe.
	I18N_LOCALE_FACTORY

feature -- get locale informations
	
	language_id: STRING
	lang: EXECUTION_ENVIRONMENT

	get_locale is
		require else
		do
		ensure then
 	   end

invariant
	invariant_clause: True -- Your invariant here

end -- class I18N_LOCALE_MACOSX
