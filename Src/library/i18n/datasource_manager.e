indexing
	description: "Abstract description of the interface to a data source for translations"
	author: "ES-i18n team (es-i18n@origo.ethz.ch)"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	I18N_DATASOURCE_MANAGER

feature -- Initialization

	make (a_uri : STRING_GENERAL) is
			-- Creation procedure
			-- Implementations should redefine this
		require
			a_uri_exists: a_uri /= Void
		do
			uri := a_uri.to_string_32
		ensure
			uri_set: uri.is_equal(a_uri.as_string_32)
		end

feature -- Access

	get_dictionary (a_locale: I18N_LOCALE_ID): I18N_DICTIONARY is
			-- get dictionary datastructure for the locale `a_locale'
		require
			a_locale_exists: a_locale /= Void
			a_locale_present: has_locale(a_locale)
		deferred
		ensure
			dictionary_exists: Result /= Void
		end

feature -- Informations

	 available_locales: LINEAR[I18N_LOCALE_ID] is
			-- list of the available locales
		deferred
		ensure
			result_exists: Result /= Void
		end

	has_locale ( a_locale_id: I18N_LOCALE_ID): BOOLEAN is
			-- is `a_locale_id' available?
		require
			a_locale_id_exists: a_locale_id /= Void
		local
			linear: LINEAR[I18N_LOCALE_ID]
		do
			linear := available_locales
			from
				linear.start
			until
				linear.after or Result = True
			loop
				Result := a_locale_id.is_equal(linear.item)
				linear.forth
			end
		ensure
			correct_result: Result = available_locales.has (a_locale_id)
		end

feature {NONE}

	uri: STRING_32

end
