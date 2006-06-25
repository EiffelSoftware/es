indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LOCALE
inherit
	SHARED_FACTORY

feature

	find_locale is
			-- find infos about locale of the user/os
		do
			fact := factory
			fact.get_locale
		ensure
		end




invariant
	invariant_clause: True -- Your invariant here

end -- class LOCALE
