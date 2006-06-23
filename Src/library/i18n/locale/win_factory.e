indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WIN_FACTORY
inherit
	LOCALE_FACTORY


feature
	
	locale: I18N_LOCALE_FACTORY is
			-- 
		require else
		do
			create {I18N_LOCALE_WINDOWS} Result
		ensure then
		end
	
	
invariant
	invariant_clause: True -- Your invariant here

end -- class WIN_FACTORY
