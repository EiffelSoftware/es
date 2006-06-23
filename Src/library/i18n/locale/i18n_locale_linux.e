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

feature -- get locale informations
	
	language_id: STRING
	lang: EXECUTION_ENVIRONMENT
	
	get_locale is
		require else
		do
--			lang.get("LANG")
--				Error code: VKCN(1)
--				Type error: function call used as instruction.
--				What to do: call a procedure rather than a function, or keep the function but use the call as expression rather than instruction.
		ensure then
 	   end
    
invariant
	invariant_clause: True -- Your invariant here

end -- class I18N_LOCALE_LINUX
