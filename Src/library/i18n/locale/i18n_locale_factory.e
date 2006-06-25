indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	I18N_LOCALE_FACTORY
inherit
--	SHARED_EXEC_ENVIRONMENT
--		Error code: VTCT
--		Error: type is based on unknown class.
--		What to do: use an identifier that is the name of a class in the universe.

feature -- locale

	language_id: STRING

	get_locale is
		require
		deferred
		ensure
			language_id_is_set: language_id /= Void
		end

end -- class I18N_LOCALE_FACTORY
