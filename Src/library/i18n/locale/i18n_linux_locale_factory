indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_LINUX_LOCALE_FACTORY

inherit
	I18N_LOCALE_FACTORY
	EXECUTION_ENVIRONMENT

feature -- Locale

	get_locale: LOCALE is
		require else
		do
			create Result
			Result.set_language_id(get("LANG"))
		ensure then
 	   end

invariant
	invariant_clause: True -- Your invariant here

end
