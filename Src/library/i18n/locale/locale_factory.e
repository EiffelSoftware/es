indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	LOCALE_FACTORY

feature

	locale: I18N_LOCALE_FACTORY is
			-- 
		require
		deferred
		ensure
		end
		
	
	
invariant
	invariant_clause: True -- Your invariant here

end -- class FACTORY
