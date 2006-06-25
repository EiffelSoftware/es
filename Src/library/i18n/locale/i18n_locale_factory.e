indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	I18N_LOCALE_FACTORY

feature -- locale

	language_id: STRING

	get_locale: LOCALE is
		require
		deferred
		ensure
			Result /= Void
		end

end -- class I18N_LOCALE_FACTORY
