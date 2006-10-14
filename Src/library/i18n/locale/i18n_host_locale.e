indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	I18N_HOST_LOCALE

feature -- Initialization

	make_from_user_locale: I18N_LOCALE_INFO is
			-- Creation procedure.
			-- create locale form the user locale
		deferred
		end

	make_from_locale (a_locale_id : I18N_LOCALE_ID): I18N_LOCALE_INFO is
			-- Creation procedure
			-- Create locale with a_locale_id
		require
			a_locale_not_void: a_locale_id /= Void
			a_locale_exists: is_available(a_locale_id)
		deferred
		end

feature -- Informations

	is_available (a_locale_id : I18N_LOCALE_ID) : BOOLEAN is
			-- is 'a_locale' avaiable?
		require
			a_locale_id_exists: a_locale_id /= Void
		deferred
		end

	available_locales : LINEAR[I18N_LOCALE_ID] is
			-- list af all available locales
		deferred
		ensure
			result_exists: Result /= Void
		end

	default_locale_id: I18N_LOCALE_ID is
			-- default locale id
		deferred
		end
end
