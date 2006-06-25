indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_MACOSX_LOCALE_FACTORY

inherit
	I18N_LOCALE_FACTORY
	EXECUTION_ENVIRONMENT

feature -- Locale
	get_locale is
		require else
		do
			language_id := get("LANG")
		ensure then
 	   end

invariant
	invariant_clause: True -- Your invariant here

end
