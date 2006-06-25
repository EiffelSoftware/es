indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	UNX_FACTORY
inherit
	FACTORY


feature

	locale: I18N_LOCALE_FACTORY is
			--
		require else
		do
			create {I18N_LOCALE_LINUX} Result
		ensure then
		end


end -- class UNX_FACTORY
